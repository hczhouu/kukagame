#include "GameShopBannerModel.h"
#include <QTextCodec>
#include <QCoreApplication>

GameShopBannerModel::GameShopBannerModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

int GameShopBannerModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_bannerList.size();
}

QVariant GameShopBannerModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();


    QJsonObject item = m_bannerList.at(index.row()).toObject();
    switch (role) {
    case BANNER_NAME:{
        int type = item.value("relatedType").toInt(0);
        if (type == 3 ||  type == 4)
        {
            return item.value("bannerName").toString("NULL");
        }
        return item.value("relatedApplicationName").toString("NULL");
    }
    case BANNER_DESC:{
        return item.value("relatedAppIntroduction").toString("NULL");
    }
    case BANNER_URL:{
        return item.value("bannerUrl").toString();
    }
    case BANNER_TYPE:{
        return item.value("relatedType").toInt(0);
    }
    case BANNER_APP_ID:{
        return item.value("relatedAppId").toString("NULL");
    }
    case BANNER_APP_TYPE:{
        return item.value("relatedAppType").toString("NULL");
    }
    case BANNER_MSG_ID:{
        return item.value("relatedMessageId").toString("NULL");
    }
    case BANNER_MSG_TYPE:{
        return item.value("relatedMessageType").toString("NULL");
    }
    case BANNER_MSG_TITLE:{
        return item.value("relatedMessageTitle").toString("NULL");
    }
    case BANNER_INTERNAL_LINK:{
        return item.value("internalLink").toString("NULL");
    }
    case BANNER_EXTERNAL_LINK:{
        return item.value("externalLink").toString("NULL");
    }
    default:
        break;
    }


    return QVariant();
}


QHash<int, QByteArray> GameShopBannerModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(BANNER_NAME, "bannerName");
    rolesHash.insert(BANNER_DESC, "bannerDesc");
    rolesHash.insert(BANNER_URL, "bannerUrl");
    rolesHash.insert(BANNER_TYPE, "bannerType");

    rolesHash.insert(BANNER_APP_ID, "bannerAppId");
    rolesHash.insert(BANNER_APP_TYPE, "bannerAppType");
    rolesHash.insert(BANNER_MSG_ID, "bannerMsgId");
    rolesHash.insert(BANNER_MSG_TYPE, "bannerMsgType");
    rolesHash.insert(BANNER_MSG_TITLE, "bannerMsgTitle");
    rolesHash.insert(BANNER_INTERNAL_LINK, "bannerInternalLink");
    rolesHash.insert(BANNER_EXTERNAL_LINK, "bannerExternalLink");
    return rolesHash;
}


void GameShopBannerModel::updateGameShopBannerList(const QJsonArray& arrList)
{
    beginResetModel();
    m_bannerList = arrList;
    endResetModel();
}

