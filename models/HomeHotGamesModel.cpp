#include "HomeHotGamesModel.h"
#include <QCoreApplication>
#include <QFile>
#include <QDir>

HomeHotGamesModel* HomeHotGamesModel::hotGamesModel = nullptr;

HomeHotGamesModel::HomeHotGamesModel(QObject *parent)
    : QAbstractListModel(parent)
{
    hotGamesModel = this;
}

int HomeHotGamesModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_hotGamesList.size();
}

QVariant HomeHotGamesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_hotGamesList.at(index.row()).toObject();
    switch (role) {
    case HOTGAMES_NAME:{
        return item.value("gameName").toString(u8"NULL");
    }
    case HOTGAMES_ICON_URL:{
        return item.value("gameIcon").toString("../res/v2/no_image.jpg");
    }
    case HOTGAMES_MAIN_IMAGE:{
        return item.value("gameMainImg").toString("../res/v2/no_image.jpg");
    }
    case HOTGAMES_ID:{
        return item.value("id").toString("NULL");
    }
    case HOTGAMES_PACKAGE_NAME:{
        return item.value("packageName").toString("NULL");
    }
    case HOTGAMES_GAME_CNAHNNEL:{
        return item.value("gameChannel").toString("NULL");
    }
    case HOTGAMES_GOODS_ID:{
        return item.value("gameGoods").toObject().value("id").toString("NULL");
    }
    case HOTGAMES_GOODS_TYPE:{
        // 1应用 2推广 3商品
        return item.value("appType").toString("NULL");
    }
    case HOTGAMES_IS_GOODS:{
        if (item.value("gameGoods").isNull() ||
            item.value("gameGoods").isUndefined() ||
            item.value("gameGoods").toObject().isEmpty())
        {
            return false;
        }

        return true;
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int, QByteArray> HomeHotGamesModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(HOTGAMES_NAME, "hotGameName");
    rolesHash.insert(HOTGAMES_ICON_URL, "hotGameIconUrl");
    rolesHash.insert(HOTGAMES_MAIN_IMAGE, "hotGameMainImage");
    rolesHash.insert(HOTGAMES_ID, "hotGameId");
    rolesHash.insert(HOTGAMES_PACKAGE_NAME, "hotGamePackageName");
    rolesHash.insert(HOTGAMES_GAME_CNAHNNEL, "hotGameChannel");
    rolesHash.insert(HOTGAMES_GOODS_ID, "hotGameGoodsId");
    rolesHash.insert(HOTGAMES_GOODS_TYPE, "hotGameGoodsType");
    rolesHash.insert(HOTGAMES_IS_GOODS, "hotGameIsGoods");
    return rolesHash;
}



void HomeHotGamesModel::updateHotGamesList(const QString& id,  const QJsonArray& arrList)
{
    beginResetModel();
    m_hotGamesList = arrList;
    endResetModel();
}



