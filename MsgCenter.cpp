#include "MsgCenter.h"
#include "CommonFunc.h"
#include "CommonDefine.h"
#include "HttpClient.h"


MsgCenter::MsgCenter(QObject *parent)
    : QObject{parent}
{
    m_unReadFlag = false;
    m_msgReady = false;
    m_imageWidth = 0;
    m_imageHeight = 0;
    m_totalUnreadNum = 0;
    emit totalUnreadNumChanged();

    m_announcementTotal = 0;
    m_activityTotal = 0;
    m_dynamicTotal = 0;
    m_transactionTotal = 0;
    emit announcementTotalChanged();
    emit activityTotalChanged();
    emit dynamicTotalChanged();
    emit transactionTotalChanged();
}


//获取未读消息数量
void MsgCenter::getUnReadNum(ActivitiesNoticeModel* atcivitiesModel,
                             DynamicNoticeModel* dynamicModel, SystemNoticeModel* systemModel)
{
    if (atcivitiesModel != nullptr)
    {
        connect(this, &MsgCenter::updateActivitiesList, atcivitiesModel,
                &ActivitiesNoticeModel::updateActivitiesList, Qt::UniqueConnection);
    }

    if (dynamicModel != nullptr)
    {
        connect(this, &MsgCenter::updateDynamicList, dynamicModel,
                &DynamicNoticeModel::updateDynamicList, Qt::UniqueConnection);
    }

    if (systemModel != nullptr)
    {
        connect(this, &MsgCenter::updateSystemList, systemModel,
                &SystemNoticeModel::updateSystemList, Qt::UniqueConnection);
    }

    std::thread([=](){
        std::string resp;
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("admin/message/getMsgUnReadStaticPc");
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, false, url, "", token.toStdString()))
        {
            LOG(ERROR) << "get unread num error " << resp;
            //刷新弹窗公告
            getForceNotice();
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

            //刷新弹窗公告
            getForceNotice();
            return;
        }

        m_announcementTotal = itemData.value("announcementTotal").toInt(0);
        m_activityTotal = itemData.value("activityTotal").toInt(0);
        m_dynamicTotal = itemData.value("dynamicTotal").toInt(0);
        m_transactionTotal = itemData.value("transactionTotal").toInt(0);
        if (m_announcementTotal == 0 && m_activityTotal == 0
            && m_dynamicTotal == 0 && m_transactionTotal == 0)
        {
            m_unReadFlag = false;
        } else {
            //标记小红点
            m_unReadFlag = true;
        }

        emit unReadFlagChanged();
        m_totalUnreadNum = m_announcementTotal + m_activityTotal + m_dynamicTotal + m_transactionTotal;
        emit totalUnreadNumChanged();

        emit announcementTotalChanged();
        emit activityTotalChanged();
        emit dynamicTotalChanged();
        emit transactionTotalChanged();

        //刷新弹窗公告
        getForceNotice();

    }).detach();
}

//根据消息分类获取消息列表
void MsgCenter::getMsgListByType(int type)
{
    std::thread([=](){

        m_msgDataIsReady = false;
        emit msgDataIsReadyChanged();
        m_msgDataIsEmpty = false;
        emit msgDataIsEmptyChanged();

        std::string resp;
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("app/messageCenter/getMyAnnouncementSendPc?pageNo=1&pageSize=10&type=");
        url.append(QString::number(type).toStdString());
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, false, url, "", token.toStdString()))
        {
            LOG(ERROR) << "get msg list error " << resp;
            m_msgDataIsReady = true;
            emit msgDataIsReadyChanged();
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

            m_msgDataIsReady = true;
            emit msgDataIsReadyChanged();
            return;
        }

        QJsonArray arrList = itemData.value("records").toArray();
        if (type == 0)
        {
            emit updateSystemList(arrList);
        } else if (type == 1) {
            emit updateActivitiesList(arrList);
        } else if (type == 2) {
            emit updateDynamicList(arrList);
        }

        if (arrList.isEmpty())
        {
            m_msgDataIsEmpty = true;
            emit msgDataIsEmptyChanged();
        }

        m_msgDataIsReady = true;
        emit msgDataIsReadyChanged();
        getUnReadNum(nullptr, nullptr, nullptr);

    }).detach();
}


//根据消息ID获取消息详情
void MsgCenter::getMsgDetailsById(const QString& strId)
{
    m_msgReady = false;
    emit msgReadyChanged();

    std::thread([=](){
        std::string resp;
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("app/messageCenter/getDetailById?sendId=");
        url.append(strId.toStdString());
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, false, url, "", token.toStdString()))
        {
            LOG(ERROR) << "get msg detail error " << resp;
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

        m_imageWidth =  itemData.value("imgWidth").toInt(0);
        m_imageHeight = itemData.value("imgHeight").toInt(0);
        LOG(INFO) << "rawsize : " << m_imageWidth  << m_imageHeight;
        if (m_imageWidth == 0 || m_imageHeight == 0) {
            m_imageHeight = 200;
            m_imageWidth = 780;
        } else if (m_imageWidth >= 780) {
            double scale = static_cast<double>(m_imageWidth) / 780;
            double imageHeight = static_cast<double>(m_imageHeight) / scale;
            m_imageHeight = static_cast<int>(imageHeight);
            m_imageWidth = 780;
            LOG(INFO) << "realsize : " << m_imageWidth << m_imageHeight;
        }

        emit imageWidthChanged();
        emit imageHeightChanged();

        int pushLink = itemData.value("pushLink").toInt(2);
        m_msgTitle = itemData.value("title").toString();
        m_msgContent = itemData.value("msgContent").toString();
        m_msgImage = itemData.value("msgContentUrl").toString();
        m_bPushLink = (pushLink == 0);
        m_activitiesLink = itemData.value("activityLink").toString("");

        emit msgTitleChanged();
        emit msgContentChanged();
        emit msgImageChanged();
        emit msgActivitiesLinkChanged();
        emit pushLinkChanged();

        m_textWithImage = false;
        m_onlyImage = false;
        m_onlyText = false;

        int msgTempType = itemData.value("messageTemplate").toInt(0);
        if (msgTempType == 1)
        {
            //图+文
            m_textWithImage = true;
        } else if(msgTempType == 2)
        {
            //纯图片
            m_onlyImage = true;
        } else if(msgTempType == 3)
        {
            //纯文字
            m_onlyText = true;
        }

        emit textWithImageChanged();
        emit onlyImageChanged();
        emit onlyTextChanged();
        emit pushLinkChanged();

        m_msgReady = true;
        emit msgReadyChanged();

        getUnReadNum(nullptr, nullptr, nullptr);

    }).detach();
}

//获取强制弹窗公告
void MsgCenter::getForceNotice()
{
    std::thread([=](){
        std::string resp;
        std::string url = CommonFunc::GetBaseUrl().toStdString();
        url.append("app/messageCenter/getPopUpMessagePc");
        QString token = HttpClient::getInstance()->getToken();
        if (!CommonFunc::SendHttpRequest(resp, false, url, "", token.toStdString()))
        {
            LOG(ERROR) << "get popup msg error " << resp;
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

        if (itemData.isEmpty())
        {
            return;
        }

        QString msgId = itemData.value("id").toString();
        int type = itemData.value("type").toInt();
        QString strCaption;
        if (type == 0)
        {
            strCaption = u8"公告消息";
        } else if(type == 1)
        {
            strCaption = u8"活动消息";
        } else if(type == 2)
        {
            strCaption = u8"动态消息";
        }

        emit forcePopupMsg(msgId, strCaption);

        getUnReadNum(nullptr, nullptr, nullptr);

    }).detach();
}
