#include "CDKeyListModel.h"

CDKeyListModel::CDKeyListModel(QObject *parent)
    : QAbstractListModel(parent)
{}

int CDKeyListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_cdKeyList.size();
}

QVariant CDKeyListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    switch (role) {
    case CD_KEY:{
        return m_cdKeyList.at(index.row()).toString();
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int,QByteArray> CDKeyListModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(CD_KEY, "cdKey");
    return rolesHash;
}


void CDKeyListModel::updateCdKeyList(const QJsonArray& arrList)
{
    beginResetModel();
    m_cdKeyList = arrList;
    endResetModel();
}
