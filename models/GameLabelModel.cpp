#include "GameLabelModel.h"

GameLabelModel::GameLabelModel(QObject *parent)
    : QAbstractListModel(parent)
{}

int GameLabelModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_listLabel.size();
}

QVariant GameLabelModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_listLabel.at(index.row()).toObject();
    switch (role) {
    case LABEL_ID:{
        return item.value("id").toString();
    }
    case LABEL_TEXT:{
        return item.value("categoryName").toString();
    }
    default:
        break;
    }
    return QVariant();
}


QHash<int, QByteArray> GameLabelModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(LABEL_ID, "labelId");
    rolesHash.insert(LABEL_TEXT, "labelText");
    return rolesHash;
}


void GameLabelModel::updateGameLabel(const QJsonArray& jsonArr)
{
    beginResetModel();
    m_listLabel = jsonArr;
    endResetModel();
    emit getDataSuccess();
}
