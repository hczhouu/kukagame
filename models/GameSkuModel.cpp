#include "GameSkuModel.h"

GameSkuModel::GameSkuModel(QObject *parent)
    : QAbstractListModel(parent)
{}

int GameSkuModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_gameSkuList.size();
}

QVariant GameSkuModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_gameSkuList.at(index.row()).toObject();
    switch (role) {
    case SKU_NAME:{
        return item.value("skuName").toString();
    }
    case SKU_DESC:{
        return item.value("skuIntroduction").toString();
    }
    case SKU_PRICE:{
        return QString::number(item.value("price").toDouble(0.00));
    }
    case SKU_ORI_PRICE:{
        return item.value("oriPrice").toDouble(0.00);
    }
    case SKU_SAVE_PRICE:{
        return item.value("discountPercent").toString();
    }
    case SKU_STOCK:{
        return item.value("stock").toInt();
    }
    case SKU_ID:{
        return item.value("id").toString();
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int, QByteArray> GameSkuModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles.insert(SKU_NAME, "skuName");
    roles.insert(SKU_DESC, "skuDesc");
    roles.insert(SKU_PRICE, "skuPrice");
    roles.insert(SKU_ORI_PRICE, "skuOriPrice");
    roles.insert(SKU_SAVE_PRICE, "skuSavePrice");
    roles.insert(SKU_STOCK, "skuStock");
    roles.insert(SKU_ID, "skuId");
    return roles;
}

void GameSkuModel::updateGameSkuList(const QJsonArray& arrList)
{
    beginResetModel();
    m_gameSkuList = arrList;
    endResetModel();

    if (m_gameSkuList.size() > 0)
    {
        m_skuName = m_gameSkuList.at(0).toObject().value("skuName").toString();
        m_skuDesc = m_gameSkuList.at(0).toObject().value("skuIntroduction").toString();
        m_skuPrice = m_gameSkuList.at(0).toObject().value("price").toDouble();
        m_skuSavePrice = m_gameSkuList.at(0).toObject().value("discountPercent").toString();
        m_skuStock = m_gameSkuList.at(0).toObject().value("stock").toInt();
        m_skuId = m_gameSkuList.at(0).toObject().value("id").toString();
        m_skuOriPrice = m_gameSkuList.at(0).toObject().value("oriPrice").toDouble(0.00);
    } else {
        m_skuName = "--";
        m_skuDesc = "--";
        m_skuPrice = 0;
        m_skuSavePrice = "--";
        m_skuStock = 0;
        m_skuId = "--";
        m_skuOriPrice = 0;
    }

    emit skuPriceChanged();
    emit skuSavePriceChanged();
    emit skuStockChanged();
    emit skuIdChanged();
    emit skuNameChanged();
    emit skuDescChanged();
    emit skuOriPriceChanged();
}

void GameSkuModel::initSkuInfo()
{
    m_skuName = "--";
    m_skuDesc = "--";
    m_skuPrice = 0;
    m_skuSavePrice = "--";
    m_skuStock = 0;
    m_skuId = "--";
    m_skuOriPrice = 0;

    emit skuPriceChanged();
    emit skuSavePriceChanged();
    emit skuStockChanged();
    emit skuIdChanged();
    emit skuNameChanged();
    emit skuDescChanged();
    emit skuOriPriceChanged();
}


void GameSkuModel::resetModel()
{
    beginResetModel();
    for (int i = 0; i < m_gameSkuList.size(); ++ i)
    {
        m_gameSkuList.removeAt(i);
    }
    endResetModel();
}
