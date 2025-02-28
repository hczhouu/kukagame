#include "SystemNoticeModel.h"

SystemNoticeModel::SystemNoticeModel(QObject *parent)
    : QAbstractListModel(parent)
{}


int SystemNoticeModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_noticeList.size();
}

QVariant SystemNoticeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_noticeList.at(index.row()).toObject();
    switch (role) {
    case NOTICE_ID:{
        return item.value("id").toString("NULL");
    }
    case NOTICE_TYPE:{
        return item.value("type").toInt(0);
    }
    case NOTICE_TITLE:{
        return item.value("title").toString("NULL");
    }
    case NOTICE_CREATE_TIME:{
        return item.value("sendTime").toString("NULL");
    }
    case NOTICE_READ_FLAG:{
        int status = item.value("readFlag").toInt(0);
        return status == 0;
    }
    case NOTICE_CAPTION:{
        return u8"公告消息";
    }
    case NOTICE_ICON:{
        return "../res/v2/msg_06.png";
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int,QByteArray> SystemNoticeModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(NOTICE_ID, "noticeId");
    rolesHash.insert(NOTICE_TYPE, "noticeType");
    rolesHash.insert(NOTICE_TITLE, "noticeTitle");
    rolesHash.insert(NOTICE_CAPTION, "noticeCaption");
    rolesHash.insert(NOTICE_ICON, "noticeIcon");
    rolesHash.insert(NOTICE_READ_FLAG, "noticeReadFlag");
    rolesHash.insert(NOTICE_CREATE_TIME, "noticeCreateTime");
    return rolesHash;
}


void SystemNoticeModel::updateSystemList(const QJsonArray& arrList)
{
    beginResetModel();
    m_noticeList = arrList;
    endResetModel();
}
