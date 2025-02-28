#include "allfileslistmodel.h"

AllFilesListModel* AllFilesListModel::pAllFileListModel = nullptr;

AllFilesListModel::AllFilesListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    pAllFileListModel = this;
}

int AllFilesListModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_filesInfoList.size();
}

QVariant AllFilesListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (m_filesInfoList.empty())
    {
        return QVariant();
    }

    QJsonObject item = m_filesInfoList.at(index.row());

    switch (role) {
    case FILES_CHECKED:{
        return item.value("fileChecked").toBool();
    }
    case FILES_NAME:{
        return item.value("fileName").toString();
    }
    case FILES_SIZE:{
        return item.value("fileSize").toString();
    }
    case FILES_TIME:{
        return item.value("modifyTime").toString();
    }
    case FILES_TYPE:{
        return item.value("fileType").toString();
    }
    case FILES_TYPE_ICON:{
        return item.value("fileIcon").toString();
    }
    case FILES_IS_FOLDER:{
        return item.value("isFolder").toBool();
    }
    case FILES_DESC:{
        return item.value("fileDesc").toString();
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int,QByteArray> AllFilesListModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(FILES_CHECKED, "fileChecked");
    rolesHash.insert(FILES_NAME, "fileName");
    rolesHash.insert(FILES_SIZE, "fileSize");
    rolesHash.insert(FILES_TYPE, "fileType");
    rolesHash.insert(FILES_TIME, "fileTime");
    rolesHash.insert(FILES_TYPE_ICON, "fileIcon");
    rolesHash.insert(FILES_DESC, "fileDesc");
    rolesHash.insert(FILES_IS_FOLDER, "isFolder");
    return rolesHash;
}

void AllFilesListModel::updateFileInfoList(const QJsonArray& fileInfoList)
{
    emit beginResetModel();
    m_filesInfoList.clear();
    for (int i = 0 ; i < fileInfoList.size(); ++i)
    {
        m_filesInfoList.push_back(fileInfoList.at(i).toObject());
    }
    emit endResetModel();
}

void AllFilesListModel::getSeclectFileList(QQueue<QJsonValue>& vecFileList)
{
    vecFileList.clear();
    QSet<QJsonValue>::iterator itor = m_setItem.begin();
    for (; itor != m_setItem.end(); ++itor)
    {
        vecFileList.enqueue(*itor);
    }
}


void AllFilesListModel::addToSelectedList(bool bChecked, int index)
{
    if (bChecked)
    {
        m_setItem.insert(m_filesInfoList.at(index));
    } else {
        auto itFind = m_setItem.find(m_filesInfoList.at(index));
        if (itFind != m_setItem.end())
        {
            m_setItem.erase(itFind);
        }
    }
}


void AllFilesListModel::clearSelectList()
{
    m_setItem.clear();
    selectAll(false);
}


void AllFilesListModel::selectAll(bool bCheckAll)
{
    for (QList<QJsonObject>::iterator itor = m_filesInfoList.begin();
         itor != m_filesInfoList.end(); ++itor)
    {
        QJsonObject& item = *itor;
        if (item.value("isFolder").toBool())
        {
            continue;
        }

        if (bCheckAll) {
            m_setItem.insert(item);
        }
    }

    if (!bCheckAll)
    {
        // emit beginResetModel();
        // for (int i = 0; i < m_filesInfoList.size(); ++i)
        // {
        //     QJsonObject item = m_filesInfoList.at(i);
        //     item.value("fileChecked") = false;
        //     m_filesInfoList.replace(i, item);
        // }
        // emit endResetModel();
        m_setItem.clear();
    }
}
