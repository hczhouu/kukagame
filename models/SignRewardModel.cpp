#include "SignRewardModel.h"


SignRewardModel::SignRewardModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int SignRewardModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_signRewardList.size();
}

QVariant SignRewardModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_signRewardList.at(index.row()).toObject();
    switch (role) {
    case SIGN_DAYS:{
        return item.value("signDate").toString();
    }
    case REWARD_TIME:{
        return QString::number(item.value("nowTotalPrize").toInt()) + "min";
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int, QByteArray> SignRewardModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(SIGN_DAYS, "signDays");
    rolesHash.insert(REWARD_TIME, "rewardTime");
    return rolesHash;
}


void SignRewardModel::updateRewardList(const QJsonArray& arrList,
                                       int totalDays, int totalTime)
{
    m_totalDays = QString::number(totalDays);
    m_totalTime = QString::number(totalTime) + "min";
    emit totalDaysChanged();
    emit totalTimeChanged();

    beginResetModel();
    m_signRewardList = arrList;
    endResetModel();
}
