#include "HomePage.h"
#include "HttpClient.h"
#include <thread>
#include <QApplication>
#include <QClipboard>
#include <QDesktopWidget>
#include <QWebChannel>
#include <QWebEngineSettings>
#include "CommonFunc.h"
#include "log/easylogging++.h"

QString baseUrl = "";

HomePage::HomePage(QObject *parent)
    : QObject{parent}
{
    m_pWebView = nullptr;
    QSettings settings("HKEY_CURRENT_USER\\SOFTWARE\\kukaGame", QSettings::NativeFormat);
    baseUrl = settings.value("apiUrl").toString();
    m_bannerModelIsReady = false;
}

//获取首页轮播图数据
void HomePage::getBannerData(HomeBannerModel* homeBanner, HomeActivitiesModel* activitiesModel,
                             HomeHotGamesTabModel* tabModel, HomeGoodsTabModel* goodsTabModel)
{
    if (homeBanner != nullptr)
    {
        connect(this, &HomePage::updateHomeBannerList, homeBanner,
                &HomeBannerModel::updateBannerList, Qt::UniqueConnection);
    }

    if (activitiesModel != nullptr)
    {
        connect(this, &HomePage::updateHomeActivitiesList, activitiesModel,
                &HomeActivitiesModel::updateActivitiesList, Qt::UniqueConnection);
    }


    if (tabModel != nullptr)
    {
        connect(this, &HomePage::updateHotGameTab, tabModel,
                &HomeHotGamesTabModel::updateHotGamesTitle, Qt::UniqueConnection);
    }

    if(goodsTabModel != nullptr)
    {
        connect(this, &HomePage::updateGoodsTabTitle, goodsTabModel,
                &HomeGoodsTabModel::updateGoodsTabTitle, Qt::UniqueConnection);
    }

    std::thread([=](){

        m_bannerModelIsReady = false;
        emit bannerModelIsReadyChanged();

        std::string resp;
        QJsonObject jsonData;
        jsonData.insert("clientType", 100); //1:PC首页 5:PC商城
        jsonData.insert("pageNo", 1);
        jsonData.insert("pageSize", 10);
        QJsonDocument docJson;
        docJson.setObject(jsonData);
        std::string postData = docJson.toJson().toStdString();
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("pc/home/getBannerList");
        if (!CommonFunc::SendHttpRequest(resp, true, url, postData, ""))
        {
            LOG(ERROR) << "get banner data error " << resp;
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, QByteArray::fromStdString(resp));
            }

            getBannerData(homeBanner, activitiesModel, tabModel, goodsTabModel);
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        QJsonArray itemData = CommonFunc::parseJsonToArray(resp, statusCode, strMsg);
        if (statusCode != 200)
        {
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, strMsg);
            }

            //获取热门推荐列表
            getHotGamesList();
            m_bannerModelIsReady = false;
            emit bannerModelIsReadyChanged();
            return;
        }


        //顶部轮播图
        if (itemData.at(0).isArray())
        {
            emit updateHomeBannerList(itemData.at(0).toArray());
        } else {
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, u8"parse top banner data error");
            }
        }

        //活动动态轮播图
        if (itemData.at(1).isArray())
        {
            emit updateHomeActivitiesList(itemData.at(1).toArray());
        } else {
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, u8"parse activities banner data error");
            }
        }

        m_bannerModelIsReady = true;
        emit bannerModelIsReadyChanged();
        //获取热门推荐列表
        getHotGamesList();

    }).detach();
}



//获取推荐热门 和 超值特惠
void HomePage::getHotGamesList()
{
    std::thread([=](){

        m_homeGoodsModelIsReady = false;
        emit homeGoodsModelIsReadyChanged();

        std::string resp;
        QJsonObject jsonData;
        jsonData.insert("displayLocation", 10);
        QJsonDocument docJson;
        docJson.setObject(jsonData);
        std::string postData = docJson.toJson().toStdString();
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("pc/home/homePageList");
        if (!CommonFunc::SendHttpRequest(resp, true, url, postData, ""))
        {
            LOG(ERROR) << "get hot gamel list error " << resp;
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, QByteArray::fromStdString(resp));
            }
            return;
        }

        int statusCode = 0;
        QString strMsg = "";
        QJsonArray arrItem = CommonFunc::parseJsonToArray(resp, statusCode, strMsg);
        for (auto item : arrItem)
        {
            QString strName = item.toObject().value("scope").toString();
            if (strName.compare("app") == 0)
            {
                emit updateHotGameTab(item.toObject().value("gameFurnishVoList").toArray());
            } else if(strName.compare("mall") == 0)
            {
                emit updateGoodsTabTitle(item.toObject().value("gameFurnishVoList").toArray());
            }
        }

        m_homeGoodsModelIsReady = true;
        emit homeGoodsModelIsReadyChanged();
    }).detach();
}


//获取签到列表
void HomePage::getSigninList(SigninModel* signModel)
{
    m_psignModel = signModel;
    connect(this, &HomePage::updateList, signModel,
            &SigninModel::updateSignList, Qt::UniqueConnection);

    std::thread([=](){
        m_signDataIsReady = false;
        emit signDataIsReadyChanged();

        m_enableSign = "";
        emit enableSignChanged();

        std::string resp;
        std::string postData = "sign";
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("app/signIn/getCycleList");
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, true, url, postData, token.toStdString()))
        {
            LOG(ERROR) << "get sign list error " << resp;
            m_signDataIsReady = true;
            emit signDataIsReadyChanged();

            m_enableSign = "";
            emit enableSignChanged();
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

            m_signDataIsReady = true;
            emit signDataIsReadyChanged();

            m_enableSign = "";
            emit enableSignChanged();
            return;
        }

        QJsonArray arrList = itemData.value("signInCycleList").toArray();
        emit updateList(arrList);

        QDateTime dateTime= QDateTime::currentDateTime();
        QString dateStr = dateTime.toString("yyyy-MM-dd");

        for (auto iter : arrList)
        {
            QJsonObject item = iter.toObject();
            QString signDate = item.value("signDate").toString();
            bool isSignIn = item.value("isSignIn").toBool();
            if (signDate.compare(dateStr) == 0)
            {
                if (isSignIn)
                {
                    m_enableSign = u8"今日已签到";

                } else {
                    m_enableSign = u8"立即签到";
                }
                emit enableSignChanged();
                break;
            }
        }

        m_signDataIsReady = true;
        emit signDataIsReadyChanged();

    }).detach();
}


//提交签到
void HomePage::postSignin()
{
    std::thread([=](){
        std::string resp;

        QJsonObject jsonData;
        jsonData.insert("signDate",
                        QDate::currentDate().toString("yyyy-MM-dd"));
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        std::string postData = docJson.toJson().toStdString();
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("app/signIn/add");
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, true, url, postData, token.toStdString()))
        {
            LOG(ERROR) << "signin error " << resp;
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

        //刷新签到数据
        getSigninList(m_psignModel);

    }).detach();
}


//获取签到奖励数据
void HomePage::getSignReward(SignRewardModel* signReward)
{
    m_psignReward = signReward;
    connect(this, &HomePage::updateRewardList, signReward,
            &SignRewardModel::updateRewardList, Qt::UniqueConnection);

    std::thread([=](){

        m_signRewardIsReady = false;
        emit signRewardIsReadyChanged();

        std::string resp;
        QJsonObject jsonData;
        jsonData.insert("pageNo", 1);
        jsonData.insert("pageSize", 10);
        jsonData.insert("type", 0);
        jsonData.insert("value", "");
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        std::string postData = docJson.toJson().toStdString();
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("app/signIn/page");
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, true, url, postData, token.toStdString()))
        {
            LOG(ERROR) << "get sign reward error " << resp;
            m_signRewardIsReady = true;
            emit signRewardIsReadyChanged();
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
            m_signRewardIsReady = true;
            emit signRewardIsReadyChanged();
            return;
        }

        int totalTime = itemData.value("totalPrize").toInt();
        QJsonObject data = itemData.value("data").toObject();
        int totalDays =  data.value("total").toInt();

        QJsonArray arrList = data.value("list").toArray();
        emit updateRewardList(arrList, totalDays, totalTime);

        //刷新套餐信息
        if (HttpClient::getInstance() != nullptr)
        {
            HttpClient::getInstance()->refreshClientInfo(false);
        }

        m_signRewardIsReady = true;
        emit signRewardIsReadyChanged();

    }).detach();
}


//获取推广码
void HomePage::getPromoCode()
{
    std::thread([=](){
        std::string resp;

        QJsonObject jsonData;
        jsonData.insert("pid", HttpClient::getInstance()->getUserId());
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        std::string postData = docJson.toJson().toStdString();
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("qrcode/getNormalQrCode");
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, true, url, postData, token.toStdString()))
        {
            LOG(ERROR) << "get promo code error " << resp;
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

        m_promoCodeImage = itemData.value("code").toString();
        m_promoCodeText = itemData.value("promoCode").toString();
        emit promoCodeImageChanged();
        emit promoCodeTextChanged();

    }).detach();
}

//首页搜索
void HomePage::homeSearch(const QString& keyWords, SearchResultModel* searchModel)
{
    connect(this, &HomePage::updateSearchList, searchModel,
            &SearchResultModel::updateSearchList, Qt::UniqueConnection);

    std::thread([=](){
        std::string resp;

        QJsonObject jsonData;
        jsonData.insert("pageNo", 1);
        jsonData.insert("pageSize", 10);
        jsonData.insert("gameName", keyWords);
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        std::string postData = docJson.toJson().toStdString();
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("pc/home/homeSearch");
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, true, url, postData, token.toStdString()))
        {
            LOG(ERROR) << "get search result error " << resp;
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        QJsonArray itemData = CommonFunc::parseJsonToArray(resp, statusCode, strMsg);
        if (statusCode != 200)
        {
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, strMsg);
            }
            return;
        }

        emit updateSearchList(itemData);

    }).detach();
}


void HomePage::copyPromocode()
{
    QApplication::clipboard()->setText(m_promoCodeText);
    if (HttpClient::getInstance() != nullptr)
    {
        emit HttpClient::getInstance()->showMsgPopup(false, u8"复制成功");
    }
}


void HomePage::bridgeWebToClient(const QString& args)
{
    m_pWebView->close();
    delete m_pWebView;
    m_pWebView = nullptr;

    if (args.compare("1001") == 0)
    {
        emit showRechargeView();
    } else if (args.compare("1002") == 0)
    {
        emit showContactView();
    }

}

void HomePage::showInternalLink(const QString& link)
{
    if (m_pWebView != nullptr)
    {
        m_pWebView->close();
        delete m_pWebView;
        m_pWebView = nullptr;
    }

    m_pWebView = new QWebEngineView(NULL);
    QWebChannel* pChannel = new QWebChannel(m_pWebView->page());
    pChannel->registerObject("MainWindow", this);
    m_pWebView->page()->setWebChannel(pChannel);

    QRect screenGeometry = QApplication::desktop()->screenGeometry();
    int screenWidth = screenGeometry.width();
    int screenHeight = screenGeometry.height();
    m_pWebView->setWindowTitle(u8"酷卡云游戏");
    m_pWebView->setGeometry((screenWidth - 1200) /2, (screenHeight - 700)/2, 1280, 800);
    m_pWebView->load(QUrl(link));
    m_pWebView->show();
}


//获取所有游戏标签
void HomePage::getAllGameLabel(GameLabelModel* labelModel)
{
    connect(this, &HomePage::updateGameLableData, labelModel,
            &GameLabelModel::updateGameLabel, Qt::UniqueConnection);

    std::thread([=](){
        std::string resp;
        QJsonObject jsonData;
        jsonData.insert("pageNo", 1);
        jsonData.insert("pageSize", 100);
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        std::string postData = docJson.toJson().toStdString();
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("app/home/getCategoryList");
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, true, url, postData, token.toStdString()))
        {
            LOG(ERROR) << "get game label error " << resp;
            return;
        }


        QString strMsg = "";
        int statusCode = 0;
        QJsonArray itemData = CommonFunc::parseJsonToArray(resp, statusCode, strMsg);
        if (statusCode != 200)
        {
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, strMsg);
            }
            return;
        }

        emit updateGameLableData(itemData);

        if (itemData.empty())
        {
            return;
        }

        QString id = itemData.at(0).toObject().value("id").toString();
        getGameListByLabel(GameLabelListModel::pGameListModel, id);

    }).detach();
}


//根据标签获取游戏列表
void HomePage::getGameListByLabel(GameLabelListModel* gameLabelListModel, const QString& labelId)
{
    if (gameLabelListModel != nullptr)
    {
        connect(this, &HomePage::updateGameLabelList,
                gameLabelListModel, &GameLabelListModel::updateGameList, Qt::UniqueConnection);
    }

    std::thread([=](){
        std::string resp;

        QJsonObject jsonData;
        jsonData.insert("pageNo", 1);
        jsonData.insert("pageSize", 1000);
        jsonData.insert("id", labelId);
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        std::string postData = docJson.toJson().toStdString();
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("pc/home/getGameListById");
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, true, url, postData, token.toStdString()))
        {
            LOG(ERROR) << "get game list by label error : " << resp;
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, QString::fromStdString(resp));
            }
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        QJsonArray itemData = CommonFunc::parseJsonToArray(resp, statusCode, strMsg);
        if (statusCode != 200)
        {
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, strMsg);
            }
            return;
        }

        emit updateGameLabelList(labelId, itemData);

    }).detach();
}


//全部游戏搜索
void HomePage::gameSearch(const QString& keyWords)
{
    std::thread([=](){
        std::string resp;
        QJsonObject jsonData;
        jsonData.insert("pageNo", 1);
        jsonData.insert("pageSize", 10);
        jsonData.insert("gameName", keyWords);
        QJsonDocument docJson;
        docJson.setObject(jsonData);

        std::string postData = docJson.toJson().toStdString();
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("pc/home/homeSearch");
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, true, url, postData, token.toStdString()))
        {
            LOG(ERROR) << "get search result error " << resp;
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, QString::fromStdString(resp));
            }
            return;
        }

        QString strMsg = "";
        int statusCode = 0;
        QJsonArray itemData = CommonFunc::parseJsonToArray(resp, statusCode, strMsg);
        if (statusCode != 200)
        {
            if (HttpClient::getInstance() != nullptr)
            {
                emit HttpClient::getInstance()->showMsgPopup(true, strMsg);
            }
            return;
        }

        emit updateGameLabelList(0, itemData);

    }).detach();
}
