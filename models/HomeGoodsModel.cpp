#include "HomeGoodsModel.h"
#include <QCoreApplication>


HomeGoodsModel* HomeGoodsModel::homeGoodsModel = nullptr;

HomeGoodsModel::HomeGoodsModel(QObject *parent)
    : QAbstractListModel(parent)
{
    homeGoodsModel = this;
    m_showLoading = true;
    emit showLoadingChanged();
}

int HomeGoodsModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_goodsList.size();
}

QVariant HomeGoodsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_goodsList.at(index.row()).toObject();
    switch (role) {
    case GOODS_NAME:{
        return item.value("gameName").toString(u8"NULL");
    }
    case GOODS_ICON_URL:{
        return item.value("gameIcon").toString("../res/v2/no_image.jpg");
    }
    case GOODS_MAIN_IMAGE:{
        return item.value("gameMainImg").toString("../res/v2/no_image.jpg");
    }
    case GOODS_ID:{
        return item.value("id").toString("NULL");
    }
    case ITEM_PACKAGE_NAME:{
        return item.value("packageName").toString("NULL");
    }
    case ITEM_GAME_CHANNEL:{
        return item.value("gameChannel").toString("NULL");
    }
    case ITEM_GOODS_ID:{
        return item.value("gameGoods").toObject().value("id").toString();
    }
    case GOODS_PRICE:{
        return QString::number(item.value("gameGoods").toObject().value("startPrice").toDouble(0.00));
    }
    case ITEM_GOODS_TYPE:{
        return item.value("appType").toString("NULL");
    }
    case ITEM_IS_GOOGS:{
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


QHash<int, QByteArray> HomeGoodsModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(GOODS_NAME, "goodsName");
    rolesHash.insert(GOODS_ICON_URL, "goodsIconUrl");
    rolesHash.insert(GOODS_ID, "goodsId");
    rolesHash.insert(GOODS_PRICE, "goodsPrice");
    rolesHash.insert(ITEM_GOODS_ID, "itemGoodsId");
    rolesHash.insert(ITEM_GOODS_TYPE, "itemGoodsType");
    rolesHash.insert(ITEM_PACKAGE_NAME, "itemGoodsPackageName");
    rolesHash.insert(ITEM_GAME_CHANNEL, "itemGoodsGameChannel");
    rolesHash.insert(GOODS_MAIN_IMAGE, "goodsMainImage");
    rolesHash.insert(ITEM_IS_GOOGS, "itemIsGoods");
    return rolesHash;
}


void HomeGoodsModel::initGoodsList(const QString& id, const QJsonArray& arrList)
{
    m_showLoading = true;
    emit showLoadingChanged();

    beginResetModel();
    m_goodsList = arrList;
    endResetModel();

    m_showLoading = false;
    emit showLoadingChanged();
}
