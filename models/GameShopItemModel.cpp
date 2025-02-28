#include "GameShopItemModel.h"
#include <QCoreApplication>

GameShopItemModel* GameShopItemModel::shopItemModel = nullptr;

GameShopItemModel::GameShopItemModel(QObject *parent)
    : QAbstractListModel(parent)
{
    shopItemModel = this;
}

int GameShopItemModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_gameItemsList.size();
}

QVariant GameShopItemModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();


    QJsonObject item = m_gameItemsList.at(index.row()).toObject();
    switch (role) {
    case ITEM_NAME:{
        return item.value("gameName").toString(u8"NULL");
    }
    case ITEM_LABEL:{
        return item.value("gameLabel").toString("NULL");
    }
    case ITEM_ICONURL:{
        return item.value("gameIcon").toString(u8"../res/v2/no_image.jpg");
    }
    case ITEM_MAIN_IMAGE:{
        return item.value("gameMainImg").toString(u8"../res/v2/no_image.jpg");
    }
    case ITEM_PACKAGE_NAME:{
        return item.value("packageName").toString("NULL");
    }
    case ITEM_GAME_CHANNEL:{
        return item.value("gameChannel").toString("NULL");
    }
    case ITEM_PRICE:{
        return QString::number(item.value("gameGoods").toObject().value("startPrice").toDouble(0.00));
    }
    case ITEM_ORIGINAL_PRICE:{
        return QString::number(item.value("gameGoods").toObject().value("oriPrice").toDouble(0.00));
    }
    case ITEM_PRICE_SAVE:{
        return item.value("gameGoods").toObject().value("discountPercent").toString("NULL");
    }
    case ITEM_GAME_ID:{
        return item.value("id").toString("NULL");
    }
    case ITEM_GOODS_ID:{
        return item.value("gameGoods").toObject().value("id").toString();
    }
    case ITEM_GOODS_TYPE:{
        return item.value("appType").toString("NULL");
    }
    case ITEM_IS_GOODS:{
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


QHash<int, QByteArray> GameShopItemModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(ITEM_NAME, "itemName");
    rolesHash.insert(ITEM_LABEL, "itemLabel");
    rolesHash.insert(ITEM_ICONURL, "itemIconUrl");
    rolesHash.insert(ITEM_MAIN_IMAGE, "itemMainImage");
    rolesHash.insert(ITEM_PRICE, "itemPrice");
    rolesHash.insert(ITEM_ORIGINAL_PRICE, "itemOriginalPrice");
    rolesHash.insert(ITEM_PRICE_SAVE, "itemPriceSave");
    rolesHash.insert(ITEM_GAME_ID, "itemGameId");
    rolesHash.insert(ITEM_GOODS_ID, "itemGoodsId");
    rolesHash.insert(ITEM_GOODS_TYPE, "itemGoodsType");
    rolesHash.insert(ITEM_PACKAGE_NAME, "itemPackageName");
    rolesHash.insert(ITEM_GAME_CHANNEL, "itemGameChannel");
    rolesHash.insert(ITEM_IS_GOODS, "itemIsGoods");
    return rolesHash;
}


void GameShopItemModel::initGameItemsList(const QString& id, const QJsonArray& arrList)
{
    beginResetModel();
    m_gameItemsList = arrList;
    endResetModel();
}
