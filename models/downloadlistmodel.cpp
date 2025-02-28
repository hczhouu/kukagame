#include "downloadlistmodel.h"

DownloadListModel* DownloadListModel::pDownloadListModel = nullptr;

DownloadListModel::DownloadListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    pDownloadListModel = this;
}

int DownloadListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_downLoadList.size();
}

QVariant DownloadListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (m_downLoadList.empty())
    {
        return QVariant();
    }

    QJsonObject item = m_downLoadList.at(index.row());

    switch (role) {
    case FILES_NAME:{
        return item.value("fileName").toString();
    }
    case FILES_SIZE:{
        return item.value("fileSize").toString();
    }
    case FILES_TIME:{
        return item.value("modifyTime").toString();
    }
    case FILES_TYPE_ICON:{
        return item.value("fileIcon").toString();
    }
    case FILES_DOWN_SIZE:{

        return item.value("downSize").toInt();
    }
    case FILES_TOTAL_SIZE:{

        return item.value("totalSize").toInt();
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int,QByteArray> DownloadListModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(FILES_NAME, "fileName");
    rolesHash.insert(FILES_SIZE, "fileSize");
    rolesHash.insert(FILES_TIME, "fileTime");
    rolesHash.insert(FILES_TYPE_ICON, "fileIcon");
    rolesHash.insert(FILES_DOWN_SIZE, "downSize");
    rolesHash.insert(FILES_TOTAL_SIZE, "totalSize");

    return rolesHash;
}


void DownloadListModel::addRow(const QJsonObject& item)
{
    emit beginResetModel();
    m_downLoadList.push_back(item);
    emit endResetModel();
}


void DownloadListModel::removeRow(int row)
{
    if (m_downLoadList.empty())
    {
        return;
    }

    emit beginResetModel();
    m_downLoadList.erase(m_downLoadList.begin() + row);
    emit endResetModel();
}


void DownloadListModel::updateProgress(int index, qint64 downSize, qint64 totalSize)
{
    m_downLoadList[index].insert("downSize", downSize);
    m_downLoadList[index].insert("totalSize", totalSize);
    QModelIndex updateIndex=this->index(index);
    emit dataChanged(updateIndex, updateIndex);
}
