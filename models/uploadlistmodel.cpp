#include "uploadlistmodel.h"

UploadListModel* UploadListModel::pUploadListModel = nullptr;

UploadListModel::UploadListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    pUploadListModel = this;
}

int UploadListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_downLoadList.size();
}

QVariant UploadListModel::data(const QModelIndex &index, int role) const
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
    case FILES_UPLOAD_SIZE:{

        return item.value("uploadSize").toInt();
    }
    case FILES_TOTAL_SIZE:{

        return item.value("totalSize").toInt();
    }
    case FILES_PATH:{

        return item.value("filePath").toString();
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int,QByteArray> UploadListModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(FILES_NAME, "fileName");
    rolesHash.insert(FILES_SIZE, "fileSize");
    rolesHash.insert(FILES_TIME, "fileTime");
    rolesHash.insert(FILES_TYPE_ICON, "fileIcon");
    rolesHash.insert(FILES_UPLOAD_SIZE, "uploadSize");
    rolesHash.insert(FILES_TOTAL_SIZE, "totalSize");
    rolesHash.insert(FILES_PATH, "filePath");
    return rolesHash;
}


void UploadListModel::addRow(const QJsonObject& item)
{
    emit beginResetModel();
    m_downLoadList.push_back(item);
    emit endResetModel();
}


void UploadListModel::removeRow(int row)
{
    if (m_downLoadList.empty())
    {
        return;
    }

    emit beginResetModel();
    m_downLoadList.erase(m_downLoadList.begin() + row);
    emit endResetModel();
}


void UploadListModel::updateProgress(int index, qint64 uploadSize, qint64 totalSize)
{
    m_downLoadList[index].insert("uploadSize", uploadSize);
    m_downLoadList[index].insert("totalSize", totalSize);
    QModelIndex updateIndex=this->index(index);
    emit dataChanged(updateIndex, updateIndex);
}
