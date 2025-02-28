#include "GameLabelListModel.h"
#include <QCoreApplication>

GameLabelListModel* GameLabelListModel::pGameListModel = nullptr;
QString cacheDir;

GameLabelListModel::GameLabelListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    pGameListModel = this;
    cacheDir = QCoreApplication::applicationDirPath() + "/cache/home/allgames/";
}

int GameLabelListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_gameList.size();
}

QVariant GameLabelListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_gameList.at(index.row()).toObject();
    switch (role) {
    case GAME_NAME:{
        return item.value("gameName").toString();
    }
    case GAME_ID:{
        return item.value("id").toString();
    }
    case GAME_MAIN_IMAGE:{
        return item.value("pcGameMainImg").toString("../res/v2/no_image.jpg");
    }
    default:
        break;
    }
    return QVariant();
}

QHash<int, QByteArray> GameLabelListModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(GAME_NAME, "gameName");
    rolesHash.insert(GAME_ID, "gameId");
    rolesHash.insert(GAME_MAIN_IMAGE, "gameMainImage");
    return rolesHash;
}


void GameLabelListModel::updateGameList(const QString& labelId, const QJsonArray& arrList)
{
    if (labelId == 0)
    {
        beginResetModel();
        m_gameList = arrList;
        endResetModel();
        emit getDataSuccess();
        return;
    }

    beginResetModel();
    m_gameList = arrList;
    endResetModel();
    emit getDataSuccess();
}
