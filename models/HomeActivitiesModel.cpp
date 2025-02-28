#include "HomeActivitiesModel.h"
#include <QTextCodec>
#include <QCoreApplication>

HomeActivitiesModel::HomeActivitiesModel(QObject *parent)
    : QAbstractListModel(parent)
{}

int HomeActivitiesModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_activitiesList.size();
}

QVariant HomeActivitiesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_activitiesList.at(index.row()).toObject();
    switch (role) {
    case ACTIVITIES_BANNER_NAME:{
        int type = item.value("relatedType").toInt(0);
        if (type == 3 || type == 4)
        {
            return item.value("bannerName").toString("NULL");
        }

        return item.value("relatedApplicationName").toString("NULL");
    }
    case ACTIVITIES_BANNER_DESC:{
        return item.value("relatedAppIntroduction").toString("NULL");
    }
    case ACTIVITIES_BANNER_URL:{
        return item.value("bannerUrl").toString("NULL");
    }
    case ACTIVITIES_BANNER_TYPE:{
        return item.value("relatedType").toInt(0);
    }
    case ACTIVITIES_BANNER_APP_ID:{
        return item.value("relatedAppId").toString("NULL");
    }
    case ACTIVITIES_BANNER_APP_TYPE:{
        return item.value("relatedAppType").toString("NULL");
    }
    case ACTIVITIES_BANNER_MSG_ID:{
        return item.value("relatedMessageId").toString("NULL");
    }
    case ACTIVITIES_BANNER_MSG_TYPE:{
        return item.value("relatedMessageType").toString("NULL");
    }
    case ACTIVITIES_BANNER_MSG_TITLE:{
        return item.value("relatedMessageTitle").toString("NULL");
    }
    case ACTIVITIES_BANNER_INTERNAL_LINK:{
        return item.value("internalLink").toString("NULL");
    }
    case ACTIVITIES_BANNER_EXTERNAL_LINK:{
        return item.value("externalLink").toString("NULL");
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int, QByteArray> HomeActivitiesModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(ACTIVITIES_BANNER_NAME, "activitiesBannerName");
    rolesHash.insert(ACTIVITIES_BANNER_DESC, "activitiesBannerDesc");
    rolesHash.insert(ACTIVITIES_BANNER_URL, "activitiesBannerUrl");
    rolesHash.insert(ACTIVITIES_BANNER_TYPE, "activitiesBannerType");
    rolesHash.insert(ACTIVITIES_BANNER_APP_ID, "activitiesBannerAppId");
    rolesHash.insert(ACTIVITIES_BANNER_APP_TYPE, "activitiesBannerAppType");
    rolesHash.insert(ACTIVITIES_BANNER_MSG_ID, "activitiesBannerMsgId");
    rolesHash.insert(ACTIVITIES_BANNER_MSG_TYPE, "activitiesBannerMsgType");
    rolesHash.insert(ACTIVITIES_BANNER_MSG_TITLE, "activitiesBannerMsgTitle");
    rolesHash.insert(ACTIVITIES_BANNER_INTERNAL_LINK, "activitiesBannerInternalLink");
    rolesHash.insert(ACTIVITIES_BANNER_EXTERNAL_LINK, "activitiesBannerExternalLink");
    return rolesHash;
}


void HomeActivitiesModel::updateActivitiesList(const QJsonArray& arrList)
{

    beginResetModel();
    m_activitiesList = arrList;
    endResetModel();
}

