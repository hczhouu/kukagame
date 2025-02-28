#include "SigninModel.h"


SigninModel::SigninModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int SigninModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_signinList.size();
}

QVariant SigninModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_signinList.at(index.row()).toObject();
    switch (role) {
    case IS_SIGNIN:{
        return item.value("isSignIn").toBool();
    }
    case SIGNIN_DAYS:{
        return QString::number(index.row() + 1);
    }
    case SIGNIN_PRIZE:{
        return item.value("signPrize").toInt();
    }
    case SIGNIN_REMARK:{
        return item.value("remark").toString();
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int, QByteArray> SigninModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(IS_SIGNIN, "isSignin");
    rolesHash.insert(SIGNIN_DAYS, "signinDays");
    rolesHash.insert(SIGNIN_PRIZE, "signinPrize");
    return rolesHash;
}


void SigninModel::updateSignList(const QJsonArray& arrList)
{
    beginResetModel();
    m_signinList = arrList;
    endResetModel();

    if (m_signinList.empty())
    {
        return;
    }

    QJsonObject itemTemp = m_signinList.at(m_signinList.size() - 1).toObject();
    m_remarkData = itemTemp.value("remark").toString();
    emit remarkDataChanged();
}
