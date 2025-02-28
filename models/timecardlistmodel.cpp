#include "timecardlistmodel.h"

TimeCardListModel* TimeCardListModel::pTimecardListModel = nullptr;

TimeCardListModel::TimeCardListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    pTimecardListModel = this;
}

int TimeCardListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_timeCardList.size();
}

QVariant TimeCardListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_timeCardList.at(index.row()).toObject();
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


QHash<int,QByteArray> TimeCardListModel::roleNames() const
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


void TimeCardListModel::updateTimecardList(const QJsonArray& arrItem)
{
    m_isDataReady = false;
    emit isDataReadyChanged();

    beginResetModel();
    m_timeCardList = arrItem;
    endResetModel();

    m_isDataReady = true;
    emit isDataReadyChanged();
}

