#include "transfercompletelistmodel.h"

TransferCompleteListModel* TransferCompleteListModel::pTransferCompleteListModel = nullptr;

TransferCompleteListModel::TransferCompleteListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    pTransferCompleteListModel = this;
}

int TransferCompleteListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_transferCompleteList.size();
}

QVariant TransferCompleteListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (m_transferCompleteList.empty())
    {
        return QVariant();
    }

    QJsonObject item = m_transferCompleteList.at(index.row());

    switch (role) {
    case FILES_NAME:{
        return item.value("fileName").toString();
    }
    case FILES_SIZE:{
        return item.value("fileSize").toString();
    }
    case FILES_TYPE_ICON:{
        return item.value("fileIcon").toString();
    }
    case FILES_STATUS:{
        return item.value("status").toString();
    }
    case FILES_PATH:{
        return item.value("filePath").toString();
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int,QByteArray> TransferCompleteListModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(FILES_NAME, "fileName");
    rolesHash.insert(FILES_SIZE, "fileSize");
    rolesHash.insert(FILES_TYPE_ICON, "fileIcon");
    rolesHash.insert(FILES_STATUS, "status");
    rolesHash.insert(FILES_PATH, "filePath");
    return rolesHash;
}

void TransferCompleteListModel::addRow(const QJsonObject& item)
{
    emit beginResetModel();
    m_transferCompleteList.push_back(item);
    emit endResetModel();
}


void TransferCompleteListModel::removeRow(int row)
{
    if (m_transferCompleteList.empty())
    {
        return;
    }

    emit beginResetModel();
    m_transferCompleteList.erase(m_transferCompleteList.begin() + row);
    emit endResetModel();
}
