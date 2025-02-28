#include "periodlistmodel.h"

PeriodListModel* PeriodListModel::pPeriodGoodsList = nullptr;

PeriodListModel::PeriodListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    pPeriodGoodsList = this;
    m_isDataReady = false;
}

int PeriodListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_goodsList.size();
}

QVariant PeriodListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (m_goodsList.empty())
    {
        return QVariant();
    }

    QJsonObject item = m_goodsList.at(index.row());
    switch (role) {
    case GOODS_ID:{

        return item.value("id").toString();
    }
    case GOODS_NAME:{
        return item.value("goodsName").toString();
    }
    case GOODS_DESC:{
        return item.value("goodsDescribe").toString();
    }
    case GOODS_MEAL_TYPE:{
        return QString::number(item.value("mealType").toInt());
    }
    case GOODS_TIME_LIMIT:{
        return QString::number(item.value("timeLimit").toInt());
    }
    case GOODS_TOTAL_TIME:{
        return QString::number(item.value("totalTime").toInt());
    }
    case GOODS_ORIGINAL_PRICE:{
        return item.value("originalPrice").toString();
    }
    case GOODS_PAY_AMOUNT:{
        return item.value("payAmount").toString();
    }
    case GOODS_ORDER_AMOUNT:{
        return item.value("orderAmount").toString();
    }
    case GOODS_SORT:{
        return QString::number(item.value("sort").toInt());
    }
    case GOODS_TYPE:{
        return item.value("type").toString();
    }
    case GOODS_LABEL:{
        return item.value("label").toString();
    }
    case GOODS_REMARK:{
        return item.value("goodsRemark").toString();
    }
    default:
        break;
    }


    return QVariant();
}

QHash<int,QByteArray> PeriodListModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(GOODS_ID, "goodsId");
    rolesHash.insert(GOODS_NAME, "goodsName");
    rolesHash.insert(GOODS_DESC, "goodsDesc");
    rolesHash.insert(GOODS_MEAL_TYPE, "mealType");
    rolesHash.insert(GOODS_TIME_LIMIT, "timeLimit");
    rolesHash.insert(GOODS_TOTAL_TIME, "totalTime");
    rolesHash.insert(GOODS_ORIGINAL_PRICE, "originalPrice");
    rolesHash.insert(GOODS_PAY_AMOUNT, "payAmount");
    rolesHash.insert(GOODS_ORDER_AMOUNT, "orderAmount");
    rolesHash.insert(GOODS_SORT, "sort");
    rolesHash.insert(GOODS_LABEL, "goodsLabel");
    rolesHash.insert(GOODS_TYPE, "type");
    rolesHash.insert(GOODS_REMARK, "goodsRemark");
    return rolesHash;
}


void PeriodListModel::updateGoodsList(const QJsonArray& goodsList)
{
    m_isDataReady = false;
    emit isDataReadyChanged();

    beginResetModel();
    m_goodsList.clear();
    for (int i = 0 ; i < goodsList.size(); ++i)
    {
        m_goodsList.push_back(goodsList.at(i).toObject());
    }
    endResetModel();

    m_isDataReady = true;
    emit isDataReadyChanged();
}
