#include "HttpClient.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonParseError>
#include <QApplication>
#include <QString>
#include <QSettings>
#include <QProcess>
#include <QBuffer>
#include <QImage>
#include <QDebug>
#include <QPixmap>
#include <QPainter>
#include "CommonFunc.h"
#include "CommonDefine.h"
#include "FtpClient.h"
#include "curl/curl.h"

extern "C"{
#include "qrencode/qrencode.h"
}

std::shared_ptr<HttpClient> HttpClient::m_pClient = nullptr;
std::mutex HttpClient::m_mutex;
QString HttpClient::m_strApiUrl = "";
QString HttpClient::m_bandHost = "";

static std::atomic<int64_t> downFileSize(0);
static std::atomic<int64_t> totalFileSize(0);


HttpClient::HttpClient()
{
    m_bUserLogined = false;
    m_userRealStatus = false;
    m_userJuniorStatus = false;
    m_userCurrentPass = "*********";
    m_timecardFree = u8"0天0时0分";
    m_timecardDuration = u8"0天0时0分";
    m_timecardPeriod = u8"0天0时0分";
    m_findNewVersion = false;
    m_headLogoUrl = "../res/no-head-logo.png";
    m_vipFlags = "";
    m_vipLabel = "";
    m_payPercent = 1.0;

    QSettings settings("HKEY_CURRENT_USER\\SOFTWARE\\kukaGame", QSettings::NativeFormat);
    m_strApiUrl = settings.value("apiUrl").toString();
    m_bandHost = settings.value("bandHost").toString();
    m_noNotify = settings.value("noNotify", false).toBool();
    m_closeExit = settings.value("closeExit", false).toBool();
    m_startGameNoTips = settings.value("startGameNoTips", false).toBool();

    loadUserInfo();

    QTimer::singleShot(3000,this,&HttpClient::OnTimeOut);

    m_desktop = QGuiApplication::primaryScreen();
    QRect rect = m_desktop->geometry();
    m_screenWidth = rect.width();
    m_screenHeight = rect.height();

    m_screenDpi = m_desktop->logicalDotsPerInch() / 96;
    connect(m_desktop, &QScreen::logicalDotsPerInchChanged,
            this, &HttpClient::logicalDotsPerInchChanged);
    connect(m_desktop, &QScreen::geometryChanged,
            this, &HttpClient::geometryChanged);

}

HttpClient::~HttpClient()
{

}

std::shared_ptr<HttpClient> HttpClient::getInstance()
{
    if (m_pClient != nullptr) {
        return m_pClient;
    }

    std::lock_guard<std::mutex> lock(m_mutex);
    m_pClient = std::shared_ptr<HttpClient>(new HttpClient());
    return m_pClient;
}


void HttpClient::loadUserInfo()
{
    m_strUserName = "";
    m_strUserPass = "";
    m_rememberPass = CommonFunc::readRegValueBool("rememberPass");
    m_agreePolicy = CommonFunc::readRegValueBool("agreePolicy");
    if (m_rememberPass) {
        m_strUserName = CommonFunc::decryptoData(CommonFunc::readRegValueString("userName"));
        m_strUserPass = CommonFunc::decryptoData(CommonFunc::readRegValueString("userData"));
    }

    emit userNameChanged();
    emit userPassChanged();
    emit rememberPassChanged();
    emit agreePolicyChanged();
}

// 用户登录
void HttpClient::userLogin(const QVariant& userName, const QVariant& userPass,
                           const QVariant& verifyCode, bool rememberPass)
{
    m_rememberPass = rememberPass;
    m_strUserName = userName.toString();
    m_strUserPass = userPass.toString();

//    QDateTime dateTime = QDateTime::currentDateTime();
//    QDateTime dateTimeExpire = QDateTime(QDate(2025,5,15), QTime(12,0,0));
//    if (dateTime > dateTimeExpire)
//    {
//        emit showMsgPopup(true, QString::fromLocal8Bit("系统错误"));
//        return;
//    }

    std::thread([=](){

        QString strUrl = m_strApiUrl;
        strUrl.append("login");

        QJsonObject oJson;
        oJson.insert("captcha", verifyCode.toString());
        oJson.insert("channelCode", 0);
        oJson.insert("userName", m_strUserName);
        oJson.insert("password", m_strUserPass);
        oJson.insert("uuid", m_strUuid);
        QJsonDocument docJson;
        docJson.setObject(oJson);

        std::string resp;
        if (!CommonFunc::SendHttpRequest(resp, true,
                                         strUrl.toStdString(), docJson.toJson().toStdString(), ""))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "login error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode != 200)
        {
            emit showLoginErrorTips(strMsg);
            return;
        }

        //登录成功
//        if (FtpClient::ftpClient != nullptr)
//        {
//            FtpClient::ftpClient->setConnectionParams(m_strUserName, m_strUserPass);
//        }

        m_strToken = "token:" + strMsg;
        m_bUserLogined = true;
        emit showMsgPopup(false, QString::fromLocal8Bit("登录成功"));
        emit userLoginedChanged();
        emit loginSuccess();
        //获取用户信息
        getUserInfo();

    }).detach();
}


//用户注册
void HttpClient::userRegister(const QVariant& userName, const QVariant& userPass,
                               const QVariant& verifyCode, const QVariant& invitationCode)
{
    std::thread([=](){
        QString strUrl = m_strApiUrl;
        strUrl.append("register");

        QJsonObject oJson;
        oJson.insert("code", verifyCode.toString());
        oJson.insert("company", "");
        oJson.insert("dept", "");
        oJson.insert("mobile", userName.toString());
        oJson.insert("password", userPass.toString());
        oJson.insert("position", "");
        oJson.insert("promoCode", "");
        oJson.insert("source", "gameClient");
        oJson.insert("promoCode", invitationCode.toString());
        QJsonDocument docJosn;
        docJosn.setObject(oJson);

        std::string resp;
        if (!CommonFunc::SendHttpRequest(resp, true,
                                        strUrl.toStdString(),docJosn.toJson().toStdString(), ""))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "register user error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode == 200)
        {
            //注册成功
            emit showLoginView();
            emit showMsgPopup(false, strMsg);
        } else {
            //注册失败
            emit showMsgPopup(true, strMsg);
        }
    }).detach();
}


// 忘记密码
void HttpClient::modifyPassword(const QVariant& userPhone,
                                const QVariant& userPass, const QVariant& verifyCode)
{
    std::thread([=](){
        std::string resp;
        QString strUrl = m_strApiUrl;
        strUrl.append("forgetPassword");
        QJsonObject oJson;
        oJson.insert("code", verifyCode.toString());
        oJson.insert("mobile", userPhone.toString());
        oJson.insert("password", userPass.toString());
        QJsonDocument docJson;
        docJson.setObject(oJson);
        if (!CommonFunc::SendHttpRequest(resp, true, strUrl.toStdString(),
                                        docJson.toJson().toStdString(), ""))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "modify error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode == 200)
        {
            //修改成功
            emit showMsgPopup(false, strMsg);
            emit modifySuccess();
        } else {
            //修改失败
            emit showMsgPopup(true, strMsg);
        }

    }).detach();
}

// 获取图片验证码
void HttpClient::fetchImageVerifyCode()
{
    QDateTime time= QDateTime::currentDateTime(); //获取系统当前的时间
    uint nTime = time.toTime_t();
    m_strUuid = QString::number(nTime);
    m_captchaImage = m_strApiUrl + "captcha?uuid=" + m_strUuid;
    emit captchaImageChanged();
}


//获取注册短信验证码
void HttpClient::fetchRegSmsVerifyCode(const QVariant& mobile)
{
    std::thread([=](){
        std::string resp;
        QString strUrl = m_strApiUrl;
        strUrl.append("sms/sendRegisterCode/");
        strUrl.append(mobile.toString());
        if(!CommonFunc::SendHttpRequest(resp, false, strUrl.toStdString(), "", ""))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "fetch sms code failed";
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode == 200)
        {
            emit showMsgPopup(false, strMsg);
        } else {
            emit showMsgPopup(true, strMsg);
        }

    }).detach();
}

//获取修改密码短信验证码
void HttpClient::fetchModifySmsVerifyCode(const QVariant& mobile)
{
    std::thread([=](){
        std::string resp;
        QString strUrl = m_strApiUrl;
        strUrl.append("sms/sendForgetPasswordCode/");
        strUrl.append(mobile.toString());
        if(!CommonFunc::SendHttpRequest(resp, false, strUrl.toStdString(), "", ""))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "fetch modify sms code failed";
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode == 200)
        {
            emit showMsgPopup(false, strMsg);
        } else {
            emit showMsgPopup(true, strMsg);
        }

    }).detach();
}


// 获取用户信息
void HttpClient::getUserInfo()
{   
    std::thread([=](){
        std::string resp;
        QString strUrl = m_strApiUrl;
        strUrl.append("user/userInfo");
        if (!CommonFunc::SendHttpRequest(resp, false,
                                         strUrl.toStdString(), "", m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "get userinfo error " << resp;
            return;
        }

        //解析用户信息
        parseUserInfoReply(resp);
    }).detach();
}


// 刷新套餐信息
void HttpClient::refreshClientInfo(bool isRefreshClick)
{
    m_bIsRefresh = isRefreshClick;
    std::thread([=](){
        std::string resp;
        QString strUrl = m_strApiUrl;
        strUrl.append("user/gameClientInfo");
        if (!CommonFunc::SendHttpRequest(resp, false,
                                         strUrl.toStdString(), "", m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "refresh client info error " << resp;
            return;
        }

        //解析套餐信息
        parseRefreshClientInfo(resp);

    }).detach();
}


//兑换激活码
void HttpClient::exchangeActivateCode(const QVariant& activeCode)
{
    std::thread([=](){
        std::string resp;
        QString strUrl = m_strApiUrl;
        strUrl.append("cloudClient/exchangeCode/");
        strUrl.append(activeCode.toString());

        if (!CommonFunc::SendHttpRequest(resp, false,
                                         strUrl.toStdString(), "", m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "exchange active code error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode == 200) {
            emit showMsgPopup(false, QString::fromLocal8Bit("兑换成功"));
            refreshClientInfo(false);
        } else {
            emit showMsgPopup(true, strMsg);
        }
    }).detach();
}


//实名认证
void HttpClient::realNameAuth(const QVariant& realName, const QVariant& idCard)
{
    std::thread([=](){
        std::string resp;
        QString strUrl = m_strApiUrl;
        strUrl.append("app/realName");

        QJsonObject jsonData;
        jsonData.insert("idCard", idCard.toString());
        jsonData.insert("realName", realName.toString());
        jsonData.insert("userId", m_strUserId);
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        if (!CommonFunc::SendHttpRequest(resp, true,
            strUrl.toStdString(), docJson.toJson().toStdString(), m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "realNameAuth error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
            return;
        }

        getUserInfo();

    }).detach();

}

//查看用户密码
void HttpClient::viewLoginPass(const QVariant& phoneNum, const QVariant& verifyCode)
{ 
    std::thread([=](){
        std::string resp;

        QString strUrl = m_strApiUrl;
        strUrl.append("findPassword");

        QJsonObject jsonData;
        jsonData.insert("code", verifyCode.toString());
        jsonData.insert("mobile", phoneNum.toString());
        jsonData.insert("userId", m_strUserId);
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        if (!CommonFunc::SendHttpRequest(resp, true,
            strUrl.toStdString(), docJson.toJson().toStdString(), m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "realNameAuth error " << resp;
            return;
        }

        QByteArray strBuf = QByteArray::fromStdString(resp);
        QJsonParseError jsonError;
        QJsonDocument docJsonParse = QJsonDocument::fromJson(strBuf, &jsonError);
        if (docJsonParse.isNull()  || (jsonError.error != QJsonParseError::NoError)) {
            return;
        }

        QJsonObject object = docJsonParse.object();
        if(!object.contains("status")) {
            return;
        }

        int statusCode = object.value("status").toInt();
        QString strMsg = object.value("message").toString();

        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
            return ;
        }

        m_userCurrentPass = object.value("data").toString();
        emit userCurrentPassChanged();

    }).detach();

}


//修改密码
void HttpClient::modifyUserPass(const QVariant& userPass, const QVariant& currentPass)
{
    if (currentPass.toString() != m_strUserPass)
    {
        //验证当前登录密码错误
        emit showMsgPopup(true, u8"当前登录密码错误");
        return;
    }

    std::thread([=](){
        std::string resp;

        QString strUrl = m_strApiUrl;
        strUrl.append("updatePassword");

        QJsonObject jsonData;
        jsonData.insert("password", userPass.toString());
        jsonData.insert("sysUserName", "");
        QJsonDocument docJson;
        docJson.setObject(jsonData);
        if (!CommonFunc::SendHttpRequest(resp, true,
            strUrl.toStdString(), docJson.toJson().toStdString(), m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "modify user pass error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
        } else {
            emit showMsgPopup(false, strMsg);
        }

    }).detach();
}


//获取订单记录
void HttpClient::getOrderList()
{
    std::thread([=](){
        QString strUrl = m_strApiUrl;
        strUrl.append("order/orderNewPage");
        QJsonObject jsonData;
        jsonData.insert("orderSn", "");
        jsonData.insert("pageNo", 1);
        jsonData.insert("pageSize", 18);
        jsonData.insert("userId", m_strUserId);
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        std::string resp;
        if (!CommonFunc::SendHttpRequest(resp, true,
                                         strUrl.toStdString(), docJson.toJson().toStdString(), m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "get orderlist error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        QJsonObject itemData = CommonFunc::parseJsonToObject(resp, statusCode, strMsg);

        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
            return ;
        }

        QJsonArray jsonArr = itemData.value("list").toArray();
        OrderListTableModel::m_porderTableModel->loadData(jsonArr);

        //获取兑换记录
        getRedeemList();
    }).detach();
}

//获取游戏商品列表
void  HttpClient::getGameOrderList()
{
    QString strUrl = m_strApiUrl;
    strUrl.append("pc/game-order/getMyOrderList");

    QJsonObject jsonData;
    jsonData.insert("pageNo", 1);
    jsonData.insert("pageSize", 17);
    jsonData.insert("gameName", "");
    QJsonDocument docJson;
    docJson.setObject(jsonData);

    std::string resp;
    if (!CommonFunc::SendHttpRequest(resp, true,
                                     strUrl.toStdString(), docJson.toJson().toStdString(), m_strToken.toStdString()))
    {
        emit showMsgPopup(true, QString::fromStdString(resp));
        LOG(ERROR) << "get game orderlist error " << resp;
        return;
    }

    QString strMsg = "";
    int statusCode = 0;
    QJsonObject itemData = CommonFunc::parseJsonToObject(resp, statusCode, strMsg);

    if (statusCode != 200) {
        emit showMsgPopup(true, strMsg);
        return ;
    }

    if (GamesOrderTableModel::m_pGameOrderTableModel != nullptr)
    {
        GamesOrderTableModel::m_pGameOrderTableModel->initListData(itemData.value("list").toArray());
    }

}


//获取兑换记录
void HttpClient::getRedeemList()
{
    QString strUrl = m_strApiUrl;
    strUrl.append("activationFront/page");

    QJsonObject jsonData;
    jsonData.insert("pageNo", 1);
    jsonData.insert("pageSize", 18);
    QJsonDocument docJson;
    docJson.setObject(jsonData);

    std::string resp;
    if (!CommonFunc::SendHttpRequest(resp, true,
        strUrl.toStdString(), docJson.toJson().toStdString(), m_strToken.toStdString()))
    {
        emit showMsgPopup(true, QString::fromStdString(resp));
        LOG(ERROR) << "get redeem list error " << resp;
        return;
    }

    QString strMsg = "";
    int statusCode = 0;
    QJsonObject itemData = CommonFunc::parseJsonToObject(resp, statusCode, strMsg);

    if (statusCode != 200) {
        emit showMsgPopup(true, strMsg);
        return ;
    }

    QJsonArray jsonArr = itemData.value("list").toArray();
    RedeemTableModel::m_predeemTableModel->setInitData(jsonArr);

    //获取时长记录
    getDurationList();
}


//获取时长记录
void HttpClient::getDurationList()
{
    QString strUrl = m_strApiUrl;
    strUrl.append("durationRecordV2");

    QJsonObject jsonData;
    jsonData.insert("pageNo", 1);
    jsonData.insert("pageSize", 18);
    jsonData.insert("userId", m_strUserId);
    QJsonDocument docJson;
    docJson.setObject(jsonData);
    std::string resp;
    if (!CommonFunc::SendHttpRequest(resp, true,
        strUrl.toStdString(), docJson.toJson().toStdString(), m_strToken.toStdString()))
    {
        emit showMsgPopup(true, QString::fromStdString(resp));
        LOG(ERROR) << "get duration list error " << resp;
        return;
    }

    QString strMsg = "";
    int statusCode = 0;
    QJsonObject itemData = CommonFunc::parseJsonToObject(resp, statusCode, strMsg);

    if (statusCode != 200) {
        emit showMsgPopup(true, strMsg);
        return ;
    }

    QJsonArray jsonArr = itemData.value("list").toArray();
    DurationTableModel::m_pdurationTableModel->setInitData(jsonArr);

    //获取游戏商品订单记录
    getGameOrderList();
}


//提交订单
void HttpClient::createOrder(const QVariant& goodsId, const QVariant& payAmount)
{
    m_payAmount = payAmount;
    std::thread([=](){
        std::string resp;
        QString strUrl = m_strApiUrl;
        strUrl.append("order/createKukaOrder");

        QJsonObject jsonData;
        jsonData.insert("goodsId", goodsId.toString());
        jsonData.insert("payType", 2);
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        if (!CommonFunc::SendHttpRequest(resp, true,
            strUrl.toStdString(), docJson.toJson().toStdString(), m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "createOrder error " << resp;
            return;
        }

        QByteArray strBuf = QByteArray::fromStdString(resp);
        QJsonParseError jsonError;
        QJsonDocument docJsonParse = QJsonDocument::fromJson(strBuf, &jsonError);
        if (docJsonParse.isNull()  || (jsonError.error != QJsonParseError::NoError)) {
            return;
        }

        QJsonObject object = docJsonParse.object();
        if(!object.contains("status")) {
            return;
        }

        int statusCode = object.value("status").toInt();
        QString strMsg = object.value("message").toString();

        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
            emit closePayPopup();
            return ;
        }

        QJsonObject data = object.value("data").toObject();
        m_strOrderSn = data.value("orderSn").toString();

        generateWechatQR(m_payAmount);

    }).detach();
}


//获取微信支付二维码
void HttpClient::generateWechatQR(const QVariant& payAmount)
{
    std::thread([=](){
        QString strUrl = m_strApiUrl;
        strUrl.append("wx/recharge/nativePay");

        QJsonObject jsonData;
        jsonData.insert("orderSn", m_strOrderSn);
        jsonData.insert("payAmount", payAmount.toString());
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        std::string resp;
        if (!CommonFunc::SendHttpRequest(resp, true,
            strUrl.toStdString(), docJson.toJson().toStdString(), m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "generateWechatQR error " << resp;
            return;
        }

        QByteArray strBuf = QByteArray::fromStdString(resp);
        QJsonParseError jsonError;
        QJsonDocument docJsonParse = QJsonDocument::fromJson(strBuf, &jsonError);
        if (docJsonParse.isNull()  || (jsonError.error != QJsonParseError::NoError)) {
            return;
        }

        QJsonObject object = docJsonParse.object();
        if(!object.contains("status")) {
            return;
        }

        int statusCode = object.value("status").toInt();
        QString strMsg = object.value("message").toString();

        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
            return ;
        }

        QJsonObject data = object.value("data").toObject();
        QString codeUrl = data.value("codeUrl").toString();
        generateCodeImage(codeUrl);
    }).detach();
}


//获取支付宝二维码
void HttpClient::generateAlipayQR(const QVariant& payAmount, const QVariant& orderAmount)
{
    std::thread([=](){
        QString strUrl = m_strApiUrl;
        strUrl.append("aliPay/nativePay");

        QJsonObject jsonData;
        jsonData.insert("orderSn", m_strOrderSn);
        jsonData.insert("orderAmount", orderAmount.toString());
        jsonData.insert("payAmount", payAmount.toString());
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        std::string resp;
        if (!CommonFunc::SendHttpRequest(resp, true,
            strUrl.toStdString(), docJson.toJson().toStdString(), m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "generateAlipayQR error " << resp;
            return;
        }

        QByteArray strBuf = QByteArray::fromStdString(resp);
        QJsonParseError jsonError;
        QJsonDocument docJsonParse = QJsonDocument::fromJson(strBuf, &jsonError);
        if (docJsonParse.isNull()  || (jsonError.error != QJsonParseError::NoError)) {
            return;
        }

        QJsonObject object = docJsonParse.object();
        if(!object.contains("status")) {
            return;
        }

        int statusCode = object.value("status").toInt();
        QString strMsg = object.value("message").toString();

        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
            return ;
        }

        QJsonObject data = object.value("data").toObject();
        QJsonObject jsonUrl = data.value("codeUrl").toObject();
        QJsonObject jsonResp = jsonUrl.value("alipay_trade_precreate_response").toObject();
        QString qr_code = jsonResp.value("qr_code").toString();
        generateCodeImage(qr_code);
    }).detach();
}

//查询微信支付状态
void HttpClient::queryWechatOrderStatus()
{
    std::thread([=](){
        QString strUrl = m_strApiUrl;
        strUrl.append("wx/wxpay/queryOrders");
        strUrl.append("?orderSn=");
        strUrl.append(m_strOrderSn);

        std::string resp;
        if (!CommonFunc::SendHttpRequest(resp, false,
            strUrl.toStdString(), "", m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "query Status error " << resp;
            return;
        }

        QByteArray strBuf = QByteArray::fromStdString(resp);
        QJsonParseError jsonError;
        QJsonDocument docJsonParse = QJsonDocument::fromJson(strBuf, &jsonError);
        if (docJsonParse.isNull()  || (jsonError.error != QJsonParseError::NoError)) {
            return;
        }

        QJsonObject object = docJsonParse.object();
        if(!object.contains("status")) {
            return;
        }

        int statusCode = object.value("status").toInt();
        QString strMsg = object.value("message").toString();

        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
            return ;
        }

        QJsonObject jsonData = object.value("data").toObject();
        QString strStatus = jsonData.value("trade_state").toString();
        if (strStatus == u8"SUCCESS")
        {
            emit closePayPopup();
            emit showMsgPopup(false, u8"支付成功!");
            refreshClientInfo(false);
        }

    }).detach();
}

//关闭微信支付订单
void HttpClient::closeWechatOrder()
{
    std::thread([=](){
        QString strUrl = m_strApiUrl;
        strUrl.append("wx/wxpay/closeOrders");
        strUrl.append("?orderSn=");
        strUrl.append(m_strOrderSn);

        std::string resp;
        if (!CommonFunc::SendHttpRequest(resp, false,
                                         strUrl.toStdString(), "", m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "query Status error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
        }

    }).detach();
}


//查询支付宝支付状态
void HttpClient::queryAlipayOrderStatus()
{
    std::thread([=](){
        QString strUrl = m_strApiUrl;
        strUrl.append("aliPay/queryOrders/");
        strUrl.append(m_strOrderSn);

        std::string resp;
        if (!CommonFunc::SendHttpRequest(resp, false,
            strUrl.toStdString(), "", m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "query alipay order error " << resp;
            return;
        }

        QByteArray strBuf = QByteArray::fromStdString(resp);
        QJsonParseError jsonError;
        QJsonDocument docJson = QJsonDocument::fromJson(strBuf, &jsonError);
        if (docJson.isNull()  || (jsonError.error != QJsonParseError::NoError)) {
            return;
        }

        QJsonObject object = docJson.object();
        if(!object.contains("status")) {
            return;
        }

        int statusCode = object.value("status").toInt();
        QString strMsg = object.value("message").toString();

        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
            return ;
        }

        QJsonObject jsonData = object.value("data").toObject();
        QString strStatus = jsonData.value("tradeStatus").toString();
        if (strStatus == u8"TRADE_SUCCESS")
        {
            emit closePayPopup();
            emit showMsgPopup(false, u8"支付成功!");
            refreshClientInfo(false);
        }

    }).detach();
}


//关闭支付宝订单
void HttpClient::closeAlipayOrder()
{
    std::thread([=](){
        QString strUrl = m_strApiUrl;
        strUrl.append("aliPay/closeOrders");
        strUrl.append("?orderSn=");
        strUrl.append(m_strOrderSn);

        std::string resp;
        if (!CommonFunc::SendHttpRequest(resp, false,
                                         strUrl.toStdString(), "", m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "closeAlipayOrder error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
        }

    }).detach();
}


//检查新版本
void HttpClient::checkUpdateVersion(bool bManual)
{
    m_bManual = bManual;
    m_verMessage = u8"正在检查新版本，请稍后...";
    emit verMessageChanged();
    std::thread([=](){
        QString strUrl = m_strApiUrl;
        strUrl.append("client/getClientVersionByType/4");

        std::string resp;
        if (!CommonFunc::SendHttpRequest(resp, false,
                                         strUrl.toStdString(), "", m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "check update error " << resp;
            return;
        }

        parseCheckUpdateVersion(resp);

    }).detach();
}


//开启青少年模式
void HttpClient::enableTeenageMode(bool turnOn, const QVariant& oldPass,
                                   const QVariant& newPass)
{
    std::thread([=](){

        QString strUrl = m_strApiUrl;
        strUrl.append("user/teenageMode");

        QJsonObject jsonData;
        jsonData.insert("oldword", oldPass.toString());
        jsonData.insert("password", newPass.toString());
        int status = turnOn ? 1 : 0;
        jsonData.insert("status", status);
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        std::string resp;
        if (!CommonFunc::SendHttpRequest(resp, true,
            strUrl.toStdString(), docJson.toJson().toStdString(), m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "enableTeenageMode error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
            return;
        }

        getUserInfo();

    }).detach();
}


//下载更新包
void HttpClient::downloadUpdatePackage()
{
    std::thread([=]{

        //update拷贝到临时目录
        QString tempPath = QDir::toNativeSeparators(QDir::tempPath());
        QString currPath = QDir::toNativeSeparators(QCoreApplication::applicationDirPath());
        QString updateTempPath = tempPath + "\\update.exe";
        QString update7zPath = tempPath + "\\7z.dll";

        //update当前的目录
        QString currUpdateExe = currPath + "\\update.exe";
        QString curr7zDll = currPath + "\\7z.dll";

        //主程序路径
        QString mainExePath = QDir::toNativeSeparators(QCoreApplication::applicationFilePath());

        if (QFile::exists(updateTempPath))
        {
            QFile::remove(updateTempPath);
        }

        bool copyOk =  QFile::copy(currUpdateExe, updateTempPath);
        if (!copyOk)
        {
            emit showMsgPopup(true, u8"更新失败[25002]");
            LOG(INFO) << "copy update failed error code " << GetLastError();
            return;
        }

        if (QFile::exists(update7zPath))
        {
            QFile::remove(update7zPath);
        }

        copyOk =  QFile::copy(curr7zDll, update7zPath);
        if (!copyOk)
        {
            emit showMsgPopup(true, u8"更新失败[25003]");
            LOG(INFO) << "copy 7z.dll failed error code " << GetLastError();
            return;
        }

        //m_strFilePackUrl = "https://down.kuwo.cn/mbox/kwMusic9.3.7.0_BCS10_20240805.exe";
        QString zipPath = QDir::tempPath();
        zipPath.append("/kuka_update.zip");
        FILE* pFile = fopen(zipPath.toStdString().c_str(), "wb+");
        CURL* pCurl = curl_easy_init();
        curl_easy_setopt(pCurl, CURLOPT_URL, m_strFilePackUrl.toStdString().data());
        curl_easy_setopt(pCurl, CURLOPT_SSL_VERIFYPEER, 0L);
        curl_easy_setopt(pCurl, CURLOPT_SSL_VERIFYHOST, 0L);
        curl_easy_setopt(pCurl, CURLOPT_WRITEFUNCTION, writeFileCallBack);
        curl_easy_setopt(pCurl, CURLOPT_WRITEDATA, pFile);
        curl_easy_setopt(pCurl, CURLOPT_CONNECTTIMEOUT, 10L);
        //当请求在 10 秒内每一秒的传输速率都不足 10 字节时，则判定为超时
        curl_easy_setopt(pCurl, CURLOPT_LOW_SPEED_LIMIT, 10);
        curl_easy_setopt(pCurl, CURLOPT_LOW_SPEED_TIME, 10);
        curl_easy_setopt(pCurl, CURLOPT_NOPROXY, "*");
        curl_easy_setopt(pCurl, CURLOPT_NOPROGRESS, 0L);
        curl_easy_setopt(pCurl, CURLOPT_PROGRESSFUNCTION, progressCallBack);

        struct curl_slist* headers = NULL;
        headers = curl_slist_append(headers, "Accept: application/octet-stream");
        curl_easy_setopt(pCurl, CURLOPT_HTTPHEADER, headers);
        CURLcode code = curl_easy_perform(pCurl);
        curl_slist_free_all(headers);
        curl_easy_cleanup(pCurl);
        fclose(pFile);
        if (code != CURLE_OK)
        {
            emit showMsgPopup(true, u8"下载更新文件失败[25001]");
            return;
        }

        QStringList paramsList;
        paramsList.push_back(currPath);
        paramsList.push_back(mainExePath);
        QProcess::startDetached(updateTempPath, paramsList);
        QCoreApplication::quit();

    }).detach();
}


size_t HttpClient::writeFileCallBack(char* buffer, size_t size,
                                       size_t nitems, void* outstream)
{
    if (nullptr == buffer || nullptr == outstream)
        return size * nitems;

    FILE* pFile = reinterpret_cast<FILE*>(outstream);
    return fwrite(buffer, size, nitems, pFile);
}


int HttpClient::progressCallBack(void* clientp,double dltotal, double dlnow,
                                   double ultotal, double ulnow)
{
    Q_UNUSED(clientp)
    Q_UNUSED(ultotal)
    Q_UNUSED(ulnow)

    if (dlnow == 0)
    {
        return 0;
    }

    downFileSize.store((int64_t)dlnow);
    totalFileSize.store((int64_t)dltotal);
    return 0;
}


//获取小时卡商品列表
void HttpClient::getGoodsList(int type)
{
    std::thread([=](){
        QString strUrl = m_strApiUrl;
        strUrl.append("goodsFront/appProductList/");
        if (type == 1001)
        {
            //strUrl.append(u8"时长卡");
        } else if(type == 1002)
        {
            strUrl.append(u8"VIP");
        }

        std::string resp;
        if (!CommonFunc::SendHttpRequest(resp, false,
                                         strUrl.toStdString(), "", m_strToken.toStdString()))
        {
            emit showMsgPopup(true, QString::fromStdString(resp));
            LOG(ERROR) << "get goods list error " << resp;
            return;
        }

        connect(this, &HttpClient::updateTimeCard, this, &HttpClient::OnUpdateTimeCard, Qt::UniqueConnection);
        QByteArray strBuf = QByteArray::fromStdString(resp);
        QJsonParseError jsonError;
        QJsonDocument docJson = QJsonDocument::fromJson(strBuf, &jsonError);
        if (docJson.isNull()  || (jsonError.error != QJsonParseError::NoError)) {
            return;
        }

        QJsonObject object = docJson.object();
        if(!object.contains("status")) {
            return;
        }

        int statusCode = object.value("status").toInt();
        QString strMsg = object.value("message").toString();

        if (statusCode != 200) {
            emit showMsgPopup(true, strMsg);
            return ;
        }

        emit updateTimeCard(type, object);
    }).detach();
}


void HttpClient::OnUpdateTimeCard(int type, const QJsonObject& jsonData)
{
    if (type == 1001)
    {
        if (GoodsListModel::pGoodsList != nullptr)
        {
            GoodsListModel::pGoodsList->updateGoodsList(jsonData.value("data").toArray());
        }
    } else if(type == 1002)
    {
        if (PeriodListModel::pPeriodGoodsList != nullptr)
        {
            PeriodListModel::pPeriodGoodsList->updateGoodsList(jsonData.value("data").toArray());
        }
    } else if(type == 1003)
    {
        if (TimeCardListModel::pTimecardListModel != nullptr)
        {
            TimeCardListModel::pTimecardListModel->updateTimecardList(jsonData.value("data").toArray());
        }
    }
}


void HttpClient::parseRefreshClientInfo(const std::string& resp)
{
    int respCode = 0;
    QString strMsg = "";
    QJsonObject itemData = CommonFunc::parseJsonToObject(resp, respCode, strMsg);

    if (respCode != 200) {
        emit showMsgPopup(true, strMsg);
        return;
    }

    // 点击刷新按钮才弹窗
    if (m_bIsRefresh)
    {
        emit showMsgPopup(false, QString::fromLocal8Bit("刷新成功"));
    }

    //解析用户信息
    QString strsurplusTotal = itemData.value("surplusTotal").toString();
    //QString userId = itemData.value("id").toString();
    QString vipInfo = itemData.value("member").toString();
    m_vipLabel = vipInfo;

    if (vipInfo.compare("SVIP") == 0)
    {
        m_vipFlags = "../res/newVersion/svip.png";
        m_payPercent = 0.80;
    } else if (vipInfo.compare("VIP") == 0) {
        m_vipFlags = "../res/newVersion/vip.png";
        m_payPercent = 0.90;
    } else {
        m_vipFlags = "";
        m_payPercent = 1.00;
    }

    emit vipFlagsChanged();
    emit payPercentChanged();

    //剩余时长
    QString remainDays = "0";
    QString remainHours = "0";
    QString remainMins = "0";
    int dayPos = strsurplusTotal.indexOf(QString::fromLocal8Bit("天"));
    int hoursPos = strsurplusTotal.indexOf(QString::fromLocal8Bit("时"));
    int minPos = strsurplusTotal.indexOf(QString::fromLocal8Bit("分"));
    if (dayPos > 0)
    {
        remainDays = strsurplusTotal.mid(0, dayPos);
    }

    if (hoursPos > 0)
    {
        remainHours = strsurplusTotal.mid(dayPos + 1, hoursPos - dayPos - 1);
    }

    if (minPos > 0)
    {
        remainMins = strsurplusTotal.mid(hoursPos + 1, minPos - hoursPos - 1);
    }

    emit updateRemainTimes(remainDays, remainHours, remainMins);


    QString timeStr = u8"0天0时0分";
    //解析时长卡
    m_timecardDuration = timeStr;
    m_timecardPeriod = timeStr;
    m_timecardFree = timeStr;

    m_freeTimecardDuration = timeStr;
    m_freeTimecardPeriod = timeStr;
    m_freeTimecardFree = timeStr;
    m_remainPayTime = timeStr;
    m_remainFreeTime = timeStr;

    //解析付费和免费总时长数据
    QJsonArray timeCardInfo = itemData.value("totalTimeCardVos").toArray();
    for (int i = 0; i < timeCardInfo.size(); ++i)
    {
        QJsonValue val = timeCardInfo.at(i);
        QJsonObject objTemp = val.toObject();
        QString strName = objTemp.value("name").toString();
        if (strName == u8"付费时长")
        {
            m_remainPayTime = objTemp.value("remainingDuration").toString();
        } else if(strName == u8"免费时长") {
            m_remainFreeTime = objTemp.value("remainingDuration").toString();
        }
    }

    emit remainPayTimeChanged();
    emit remainFreeTimeChanged();

    //解析付费时长数据
    QJsonArray payTimeCardInfo = itemData.value("payVipVos").toArray();
    for (int i = 0; i < payTimeCardInfo.size(); ++i)
    {
        QJsonValue val = payTimeCardInfo.at(i);
        QJsonObject objTemp = val.toObject();
        QString strName = objTemp.value("name").toString();
        if (strName == u8"时长")
        {
            m_timecardDuration = objTemp.value("remainingDuration").toString();
        } else if(strName == u8"会员时长") {
            m_timecardPeriod = objTemp.value("remainingDuration").toString();
        }else if(strName == u8"时段卡") {
            m_timecardFree = objTemp.value("remainingDuration").toString();
        }
    }

    emit timecardDurationChanged();
    emit timecardPeriodChanged();
    emit timecardFreeChanged();


    //解析体验时长数据
    QJsonArray freeTimeCardInfo = itemData.value("freeVipVos").toArray();
    for (int i = 0; i < freeTimeCardInfo.size(); ++i)
    {
        QJsonValue val = freeTimeCardInfo.at(i);
        QJsonObject objTemp = val.toObject();
        QString strName = objTemp.value("name").toString();
        if (strName == u8"时长")
        {
            m_freeTimecardDuration = objTemp.value("remainingDuration").toString();
        } else if(strName == u8"会员时长") {
            m_freeTimecardPeriod = objTemp.value("remainingDuration").toString();
        }else if(strName == u8"时段卡") {
            m_freeTimecardFree = objTemp.value("remainingDuration").toString();
        }
    }

    emit freeTimecardDurationChanged();
    emit freeTimecardPeriodChanged();
    emit freeTimecardFreeChanged();
}


//获取用户信息
void HttpClient::parseUserInfoReply(const std::string& resp)
{
    int statusCode = 0;
    QString strMsg = "";
    QJsonObject itemData = CommonFunc::parseJsonToObject(resp, statusCode, strMsg);
    if (statusCode != 200) {
        emit showMsgPopup(true, strMsg);
        return ;
    }

    m_strUserId = itemData.value("id").toString();
    //实名认证状态
    m_userRealStatus = itemData.value("realStatus").toInt();
    //青少年模式
    m_userJuniorStatus = itemData.value("juniorStatus").toInt();
    //头像
    m_headLogoUrl = itemData.value("avatar").toString();
    //是否合伙人
    m_isCopartner = itemData.value("isCopartner").toInt(0);

    if (m_headLogoUrl.indexOf("http") < 0 ||
        m_headLogoUrl.indexOf("https") < 0)
    {
        m_headLogoUrl = "../res/no-head-logo.png";
    }
    //用户名
    m_strUserName = itemData.value("userName").toString();
    //用户昵称
    m_strNickName = itemData.value("nickName").toString();

    m_userAccount = m_strUserName;
    m_userAccount = m_userAccount.replace(m_userAccount.mid(3, 4),"****");
    emit userAccountChanged();

    QString lastUserName = CommonFunc::readRegValueString("userName");
    // 切换了账号登录
    m_switchAccount = false;
    if (!lastUserName.isEmpty() &&
        CommonFunc::decryptoData(lastUserName).compare(m_strUserName) != 0)
    {
        m_switchAccount = true;
    }

    CommonFunc::setRegValueBool("rememberPass", m_rememberPass);
    CommonFunc::setRegValueBool("agreePolicy", m_agreePolicy);
    CommonFunc::setRegValueString("userName", CommonFunc::encryptoData(m_strUserName));
    CommonFunc::setRegValueString("userData", CommonFunc::encryptoData(m_strUserPass));

    emit headLogoUrlChanged();
    emit userRealStatusChanged();
    emit userJuniorStatusChanged();
    emit nickNameChanged();

    //刷新套餐信息
    refreshClientInfo(false);
}


//检查更新
void HttpClient::parseCheckUpdateVersion(const std::string& resp)
{
    int statusCode = 0;
    QString strMsg = "";
    QJsonObject itemData =  CommonFunc::parseJsonToObject(resp, statusCode, strMsg);

    if (statusCode != 200) {
        emit showMsgPopup(true, strMsg);
        return ;
    }

    QString strVersion = itemData.value("version").toString();
    int forceUpdate = itemData.value("forceUpdate").toInt();
    QString strDesc = itemData.value("updateDescription").toString();
    m_strFilePackUrl = itemData.value("updatePackageFileAddress").toString();;

    QStringList newVerList = strVersion.split(".");
    QString cfgPath = QGuiApplication::applicationDirPath() + "/version.ini";
    QSettings settings(cfgPath, QSettings::IniFormat);
    QString strCurrentVersion = settings.value("main/version").toString();
    QStringList currVerList = strCurrentVersion.split(".");

    m_verMessage = u8"当前已经是最新版本";
    m_verMessage.append("(V");
    m_verMessage.append(strCurrentVersion);
    m_verMessage.append(")");

    if (newVerList.empty() || currVerList.empty())
    {
        emit verMessageChanged();
        return;
    }

    if (newVerList.size() != currVerList.size() )
    {
        emit verMessageChanged();
        return;
    }

    //比较版本号
    bool bNewVersion = compareVersion(newVerList, currVerList);
    if (!bNewVersion)
    {
        emit verMessageChanged();
        return;
    }

    //发现新版本
    m_verMessage = strDesc;
    emit verMessageChanged();
    m_findNewVersion = true;
    emit findNewVersionChanged();

    //非手动点击检查更新 强制更新
    if (forceUpdate == 1 && bNewVersion && !m_bManual)
    {
        emit showForceUpdate();
    }
}

//比较版本号
bool HttpClient::compareVersion(const QStringList& newVersion,
                                const QStringList& currVersion)
{
    int vNewMaxMajor = newVersion.at(0).toInt();
    int vNewMidMajor = newVersion.at(1).toInt();
    int vNewMinMajor = newVersion.at(2).toInt();
    int vNewLastMajor = newVersion.at(3).toInt();

    int vcurrMaxMajor = currVersion.at(0).toInt();
    int vcurrMidMajor = currVersion.at(1).toInt();
    int vcurrMinMajor = currVersion.at(2).toInt();
    int vcurrLastMajor = currVersion.at(3).toInt();

    if (vNewMaxMajor < vcurrMaxMajor)
    {
        return false;
    } else if (vNewMaxMajor > vcurrMaxMajor) {
        return true;
    }

    if (vNewMidMajor < vcurrMidMajor)
    {
        return false;
    } else if (vNewMidMajor > vcurrMidMajor) {
         return true;
    }

    if (vNewMinMajor < vcurrMinMajor)
    {
        return false;
    } else if (vNewMinMajor > vcurrMinMajor) {
         return true;
    }

    if (vNewLastMajor < vcurrLastMajor)
    {
        return false;
    } else if (vNewLastMajor > vcurrLastMajor) {
        return true;
    }

    return false;
}

QVariant HttpClient::getDownPercent()
{
    QString strPercent;
    strPercent.append(u8"正在更新");
    if (downFileSize.load() == 0 || totalFileSize.load() == 0)
    {
        strPercent.append("(0%)");
        return strPercent;
    }

    if (downFileSize.load() == totalFileSize.load()
        && totalFileSize.load() != 0)
    {
        strPercent.append("(100%)");
        return strPercent;
    }

    double percent = ((double)downFileSize.load() / totalFileSize.load()) * 100;
    strPercent.append("(");
    strPercent.append(QString::number(qRound(percent)));
    strPercent.append("%)");
    return strPercent;
}


void HttpClient::generateCodeImage(const QString& strUrl)
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
    m_strCodeUrl.clear();
    m_strCodeUrl.append("data:image/png;base64,");
    m_strCodeUrl.append(ba.toBase64());
    m_bQRLoading = false;
    emit qrLoadingChanged();
    emit codeUrlChanged();
    bufTemp.close();
}


void HttpClient::OnTimeOut()
{
    checkUpdateVersion(false);
}


void HttpClient::geometryChanged(const QRect &geometry)
{
    LOG(INFO)<< "change geometry "<< geometry.width()
              << "*" << geometry.height();
    m_screenWidth = geometry.width();
    m_screenHeight = geometry.height();
}


void HttpClient::logicalDotsPerInchChanged(qreal dpi)
{
    Q_UNUSED(dpi)
    m_screenDpi = m_desktop->logicalDotsPerInch() / 96;
    emit dpiChanged();

    QRect rect = m_desktop->geometry();
    m_screenWidth = rect.width();
    m_screenHeight = rect.height();
    emit screenWidthChanged();
    emit screenHeightChanged();
}


void HttpClient::updateCloseSettings(bool closeExit)
{
    QSettings settings("HKEY_CURRENT_USER\\SOFTWARE\\kukaGame", QSettings::NativeFormat);
    settings.setValue("closeExit", closeExit);
}


void HttpClient::updateNoNotifySettings(bool noNotify)
{
    QSettings settings("HKEY_CURRENT_USER\\SOFTWARE\\kukaGame", QSettings::NativeFormat);
    settings.setValue("noNotify", noNotify);
}

void HttpClient::updateStartGameNoTipsSettings(bool noNotify)
{
    m_startGameNoTips = noNotify;
    QSettings settings("HKEY_CURRENT_USER\\SOFTWARE\\kukaGame", QSettings::NativeFormat);
    settings.setValue("startGameNoTips", noNotify);
}


QString HttpClient::getToken()
{
    return m_strToken;
}


QString HttpClient::getUserId()
{
    return m_strUserId;
}


int HttpClient::userIsCopartner()
{
    return m_isCopartner;
}


void HttpClient::userLogout()
{
    m_strToken.clear();
    m_vipFlags = "";
    emit vipFlagsChanged();
}

bool HttpClient::verifyCanBuyVip(const QVariant& goodsName)
{
    if (m_vipLabel.compare("VIP") == 0)
    {
        if (goodsName.compare("VIP") == 0)
        {
            QString strMsg = u8"您已经是VIP用户,请勿重复购买!";
            emit showMsgPopup(true, strMsg);
            return false;
        }
    }

    if (m_vipLabel.compare("SVIP") == 0)
    {
        if (goodsName.compare("VIP") == 0 || goodsName.compare("SVIP") == 0)
        {
            QString strMsg = u8"您已经是SVIP用户,请勿重复购买!";
            emit showMsgPopup(true, strMsg);
            return false;
        }
    }

    return true;
}

