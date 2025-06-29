﻿#include "GameDetails.h"
#include "CommonFunc.h"
#include "HttpClient.h"
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QBuffer>
#include <QImage>
#include <QPixmap>
#include <QApplication>
#include <QClipboard>
#include <QPainter>
#include <QProcess>
#include <QDebug>
#include "CommonDefine.h"

extern "C"{
#include "qrencode/qrencode.h"
}

static std::mutex oMutex;
static HANDLE handEvent = NULL;


GameDetails::GameDetails(QObject *parent)
    : QObject{parent}
{
    m_bQRLoading = true;
}


//获取游戏详情
void GameDetails::getGameDetailsInfo(const QString& gameId, const QString& goodsId)
{
    m_strGameIcon.clear();
    m_strGameDesc.clear();
    emit gameIconChanged();
    emit gameDescChanged();

    if (GameDetailsImageModel::detailImage != nullptr)
    {
        connect(this, &GameDetails::updateDetailsImage, GameDetailsImageModel::detailImage,
                &GameDetailsImageModel::updateDetailsImage, Qt::UniqueConnection);
    }

    std::thread([=](){
        std::string resp;
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("pc/home/getGameById/");
        url.append(gameId.toStdString());
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, false, url, "", token.toStdString()))
        {
            LOG(ERROR) << "get game details error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        QJsonObject itemData = CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode != 200)
        {
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, strMsg);
            }
            return;
        }

        //是否可玩 1可玩  3需要预约
        int isPlay = itemData.value("isPlay").toInt(1);
        m_enablePlay = (isPlay == 1);
        emit enablePlayChanged();

        QString appointmentStatus = itemData.value("appointmentStatus").toString("N");
        m_appointmentStatus = u8"立即预约";
        if (appointmentStatus.compare("Y") == 0)
        {
            m_appointmentStatus = u8"取消预约";
        }

        emit appointmentStatusChanged();
        m_strGameName = itemData.value("gameName").toString();
        m_strGameIcon = itemData.value("gameIcon").toString();
        m_strGameDesc = itemData.value("gameDesc").toString();
        m_strGameMainImage = itemData.value("gameMainImg").toString();
        m_haimaGameType = itemData.value("haiMaGameType").toInt(1);
        m_selectGameId = gameId;
        m_selectGoodsId = goodsId;

        m_packageName = itemData.value("packageName").toString();
        m_gameChannel = itemData.value("gameChannel").toString();
        m_enableStart = false;
        if (!m_packageName.isEmpty() && !m_gameChannel.isEmpty())
        {
            m_enableStart = true;
        }

        emit enableStartChanged();

        //是否含有商品规格
        m_itemIsGoods = true;
        if (itemData.value("gameGoods").isNull() ||
            itemData.value("gameGoods").isUndefined() ||
            itemData.value("gameGoods").toObject().isEmpty())
        {
            m_itemIsGoods = false;
        } else {
            m_selectGoodsId = itemData.value("gameGoods").toObject().value("id").toString();
        }

        emit itemIsGoodsChanged();
        emit gameNameChanged();
        emit gameIconChanged();
        emit gameDescChanged();
        emit gameMainImgChanged();
        emit getGameDetailsSuccess();

        QString noImage = "../res/v2/no_image_750.jpg";
        QJsonArray arrFileList = itemData.value("fileList").toArray();
        if (arrFileList.empty())
        {
            m_imageLeft = noImage;
            m_imageRight = noImage;
            emit imageLeftChanged();
            emit imageRightChanged();
            return;
        }

        m_imageLeft = arrFileList.at(0).toObject().value("fileUrl").toString(noImage);
        if (arrFileList.size() == 1)
        {
            m_imageRight = noImage;
        } else {
            m_imageRight = arrFileList.at(1).toObject().value("fileUrl").toString(noImage);
        }

        emit imageLeftChanged();
        emit imageRightChanged();

    }).detach();
}



//刷新当前游戏详情页面
void GameDetails::refreshGameDetails()
{
    getGameDetailsInfo(m_selectGameId, m_selectGoodsId);
}


//预约游戏
void GameDetails::appointmentGame()
{
    std::thread([=](){

        emit initSkuInfo();
        std::string resp;
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        QString userId;
        if (HttpClient::getInstance() != nullptr)
        {
            userId = HttpClient::getInstance()->getUserId();
        }

        url.append("api/game/appointmentGame");

        bool isAppointment = false;
        if (m_appointmentStatus.compare(u8"立即预约") == 0)
        {
            isAppointment = true;
        }

        QJsonObject jsonData;
        jsonData.insert("id", m_selectGameId);
        jsonData.insert("isAppointment", isAppointment);
        jsonData.insert("userId", userId);
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, true, url,
                                         docJson.toJson().toStdString(), token.toStdString()))
        {
            LOG(ERROR) << "appointmentGame error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        QJsonObject itemData = CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode != 200)
        {
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, strMsg);
            }

            return;
        }

        isAppointment ? m_appointmentStatus = u8"取消预约" :
                        m_appointmentStatus = u8"立即预约";

        emit appointmentStatusChanged();

    }).detach();
}


//生成支付二维码
void GameDetails::generateCodeImage(const QString& strUrl)
{
    if (strUrl.isEmpty())
    {
        LOG(INFO)<< "QR url is empty";
        return;
    }

    QRcode *qrcode;
    qrcode = QRcode_encodeString(strUrl.toStdString().data(), 2, QR_ECLEVEL_Q, QR_MODE_8, 1);
    qint32 qrcode_width = qrcode->width > 0 ? qrcode->width : 1;
    double scale_x = (double)150 / (double)qrcode_width; //二维码图片的缩放比例
    double scale_y =(double)150 /(double) qrcode_width;
    QImage mainimg = QImage(150, 150, QImage::Format_ARGB32);
    QPainter painter(&mainimg);
    QColor background(Qt::white);
    painter.setBrush(background);
    painter.setPen(Qt::NoPen);
    painter.drawRect(0, 0, 150, 150);
    QColor foreground(Qt::black);
    painter.setBrush(foreground);
    for( qint32 y = 0; y < qrcode_width; y ++)
    {
        for(qint32 x = 0; x < qrcode_width; x++)
        {
            unsigned char b = qrcode->data[y * qrcode_width + x];
            if(b & 0x01)
            {
                QRectF r(x * scale_x, y * scale_y, scale_x, scale_y);
                painter.drawRects(&r, 1);
            }
        }
    }

    QByteArray ba;
    QBuffer bufTemp(&ba);
    mainimg.save(&bufTemp, "png");
    m_imageQR.clear();
    m_imageQR.append("data:image/png;base64,");
    m_imageQR.append(ba.toBase64());
    emit imageQRChanged();

    m_bQRLoading = false;
    emit qrLoadingChanged();
    bufTemp.close();
}


//查询用户剩余时长
void GameDetails::queryUserRemainTime()
{
    if (m_packageName.isEmpty() || m_gameChannel.isEmpty())
    {

        if (HttpClient::getInstance() != nullptr)
        {
            emit HttpClient::getInstance()->showMsgPopup(true, u8"启动失败, 游戏包名不能为空");
        }
        return;
    }

    std::thread([=](){
        std::string resp;
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("app/haima/used");
        QJsonObject jsonData;
        jsonData.insert("client", "Windows");
        jsonData.insert("gameName", m_strGameName);
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, true, url,
                                         docJson.toJson().toStdString(), token.toStdString()))
        {
            LOG(ERROR) << "query user remain time error " << resp;
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, u8"游戏启动失败[25002]");
            }
            return;
        }

        QByteArray strBuf = QByteArray::fromStdString(resp);
        QJsonParseError jsonError;
        QJsonDocument docParseJson = QJsonDocument::fromJson(strBuf, &jsonError);
        if (docParseJson.isNull()  || (jsonError.error != QJsonParseError::NoError)) {
            return;
        }

        QJsonObject object = docParseJson.object();
        if(!object.contains("status")) {
            return ;
        }

        QString strMsg = object.value("message").toString();
        qint64 remainTime = QString::number(object.value("data").
        toObject().value("remainingDuration").toDouble(), 'f', 0).toLongLong();
        int statusCode = object.value("status").toInt();
        if (statusCode != 200 || remainTime <= 0)
        {
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, strMsg);
            }
            return;
        }

        //获取token
        std::string urlToken = CommonFunc::GetBaseUrl().toStdString();
        urlToken.append("app/haima/getCtoken");
        resp.clear();
        QJsonObject postData;
        postData.insert("pkgName", m_packageName);
        postData.insert("userId", HttpClient::getInstance()->getUserId());
        QJsonDocument postJson;
        postJson.setObject(postData);
        if (!CommonFunc::SendHttpRequest(resp, true, urlToken,
                                         postJson.toJson().toStdString(), token.toStdString()))
        {
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, u8"获取游戏Token失败[25002]");
            }

            return;
        }

        QByteArray strBufToken = QByteArray::fromStdString(resp);
        QJsonParseError jsonErrorToken;
        QJsonDocument docParseJsonToken = QJsonDocument::fromJson(strBufToken, &jsonErrorToken);
        if (docParseJsonToken.isNull()  || (jsonErrorToken.error != QJsonParseError::NoError)) {
            return;
        }

        QJsonObject objectTemp = docParseJsonToken.object();
        if(!objectTemp.contains("data")) {
            return ;
        }


        QJsonObject objToken = objectTemp.value("data").toObject();
        QString strToken = objToken.value("ctoken").toString();
        qint64 playTime = QString::number(objToken.value("playTime").toDouble(), 'f', 0).toLongLong();
        QString bid = objToken.value("bid").toString();
        startStream(remainTime, m_packageName, m_gameChannel, strToken, playTime, bid);

    }).detach();
}


//启动游戏
void GameDetails::startStream(qint64 remainTime, const QString& packageName,
                                 const QString& gameChannel, const QString& ctoken, qint64 playtime, const QString& bid)
{

    QJsonObject jsonParams;
    QJsonObject jsonProtoData;
    QString userId = HttpClient::getInstance()->getUserId();
    jsonProtoData.insert("userId", userId);
    jsonProtoData.insert("channelCode", "Windows");
    jsonProtoData.insert("remainTime", remainTime); //单位秒
    jsonParams.insert("packageName",packageName);
    jsonParams.insert("appChannel",gameChannel);

       //x86
    if (m_haimaGameType == 1)
    {
        //正式环境
        jsonParams.insert("accessKeyId","4c0a9472500");
        jsonParams.insert("accessKey","d43fd118dce0eb1267e20dc1d2a35ff6");

        //测试环境
        //jsonParams.insert("accessKeyId","ff04fa3b1c6");
        //jsonParams.insert("accessKey","c19c122084ca5a7f2df7877c517dc66f");
    } else if(m_haimaGameType == 0) {
        //arm
        //正式环境
        jsonParams.insert("accessKeyId","5baad31b542");
        jsonParams.insert("accessKey","fe2147dfa66fe9743a55ecabd1b6018d");

        //测试环境
        //jsonParams.insert("accessKeyId","8c6dd7ba1e5");
        //jsonParams.insert("accessKey","b5ce892c22be49e6275a04efd117b15e");
    }

    jsonParams.insert("accessChannel","9170CD78");
    jsonParams.insert("userId", userId);
    jsonParams.insert("userToken", "token_test");
    jsonParams.insert("remainTime", remainTime * 1000); //单位秒转到毫秒
    jsonParams.insert("rotate",false);
    jsonParams.insert("isArchive",true);
    jsonParams.insert("protoData", jsonProtoData);

    jsonParams.insert("cToken", ctoken);
    jsonParams.insert("playTime", playtime);
    jsonParams.insert("bid", bid);

    //是合伙人
    if (HttpClient::getInstance()->userIsCopartner() == 1)
    {
        jsonParams.insert("priority", 102);
    } else {
        jsonParams.insert("priority", 0);
    }


    QJsonDocument docJson;
    docJson.setObject(jsonParams);
    QByteArray rawData = docJson.toJson(QJsonDocument::Compact);
    // "730o458@#5A>!2.="
    QString binPath =  QCoreApplication::applicationDirPath() + "/stream/kukastream.exe";
    QString encData = CommonFunc::AES_EncryptData(QByteArray::fromBase64("NzMwbzQ1OEAjNUE+ITIuPQ=="), rawData);
    QStringList paramsList;
    paramsList.push_back(encData);
    QProcess::startDetached(binPath, paramsList);
    LOG(INFO) << "start stream error code " << GetLastError();
}

