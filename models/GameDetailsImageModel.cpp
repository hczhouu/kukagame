#include "GameDetailsImageModel.h"

GameDetailsImageModel* GameDetailsImageModel::detailImage = nullptr;

GameDetailsImageModel::GameDetailsImageModel(QObject *parent)
    : QAbstractListModel(parent)
{
    detailImage = this;
}

int GameDetailsImageModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_gameDetailsImage.size();
}

QVariant GameDetailsImageModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_gameDetailsImage.at(index.row()).toObject();
    switch (role) {
    case IMAGE_URL:{
        return item.value("fileUrl").toString("../res/v2/no_image_01.jpg");
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int,QByteArray> GameDetailsImageModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(IMAGE_URL, "imageUrl");
    return rolesHash;
}


void GameDetailsImageModel::updateDetailsImage(const QJsonArray& arrList)
{
    beginResetModel();
    if (arrList.empty())
    {
        QJsonObject item;
        item.insert("fileUrl", "../res/v2/no_image_01.jpg");
        QJsonArray arrItem;
        arrItem.push_back(item);
        m_gameDetailsImage = arrItem;
    } else {
        m_gameDetailsImage = arrList;
    }

    endResetModel();
}
