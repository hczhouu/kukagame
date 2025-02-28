#include "dpilistmodel.h"

#include <QScreen>
#include <QGuiApplication>

DpiListModel::DpiListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    // QRect rect = QGuiApplication::primaryScreen()->geometry();
    // int tempWidth = rect.width();
    // int tempHeight = rect.height();
    m_dpiList.push_back(DPIINFO{1920,1080,0});
    m_dpiList.push_back(DPIINFO{2560,1440,1});
    m_dpiList.push_back(DPIINFO{3840,2160,2});
}

int DpiListModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_dpiList.size();
}

QVariant DpiListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    switch (role) {
    case DPI_WIDTH:
    {
        return m_dpiList.at(index.row()).width;
    }
        break;
    case DPI_HEIGHT:
    {
        return m_dpiList.at(index.row()).height;
    }
    break;
    case DPI_INDEX:
    {
        return m_dpiList.at(index.row()).index;
    }
    break;
    default:
        break;
    }
    return QVariant();
}


QHash<int,QByteArray> DpiListModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(DPI_WIDTH, "dpiWidth");
    rolesHash.insert(DPI_HEIGHT, "dpiHeight");
    rolesHash.insert(DPI_INDEX, "dpiIndex");
    return rolesHash;
}
