﻿#include "DynamicNoticeModel.h"

DynamicNoticeModel::DynamicNoticeModel(QObject *parent)
    : QAbstractListModel(parent)
{}


int DynamicNoticeModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_noticeList.size();
}

QVariant DynamicNoticeModel::data(const QModelIndex &index, int role) const
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
    case NOTICE_CAPTION:{
        return u8"动态消息";
    }
    case NOTICE_ICON:{
        return "../res/v2/msg_04.png";
    }
    case NOTICE_READ_FLAG:{
        int status = item.value("readFlag").toInt(0);
        return status == 0;
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int,QByteArray> DynamicNoticeModel::roleNames() const
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


void DynamicNoticeModel::updateDynamicList(const QJsonArray& arrList)
{
    beginResetModel();
    m_noticeList = arrList;
    endResetModel();
}
