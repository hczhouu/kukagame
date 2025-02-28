#include "SearchResultModel.h"

SearchResultModel::SearchResultModel(QObject *parent)
    : QAbstractListModel(parent)
{}

int SearchResultModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_resultList.size();
}

QVariant SearchResultModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_resultList.at(index.row()).toObject();
    switch (role) {
    case ITEM_GAME_ID:{
        return item.value("id").toString("NULL");
    }
    case ITEM_GOODS_ID:{
        return item.value("gameGoodsId").toString("");
    }
    case ITEM_GAME_ICON:{
        return item.value("pcGameMainImg").toString("../res/v2/no_image.jpg");
    }
    case ITEM_GAME_NAME:{
        return item.value("gameName").toString("NULL");
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int,QByteArray> SearchResultModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(ITEM_GAME_ID, "itemGameId");
    rolesHash.insert(ITEM_GAME_ICON, "itemGameIcon");
    rolesHash.insert(ITEM_GAME_NAME, "itemGameName");
    rolesHash.insert(ITEM_GOODS_ID, "itemGoodsId");
    return rolesHash;
}


void SearchResultModel::updateSearchList(const QJsonArray& arrList)
{
    m_noResult = false;
    if (arrList.empty())
    {
        m_noResult = true;
    }
    beginResetModel();
    m_resultList = arrList;
    endResetModel();

    emit noResultChanged();
    emit showSearchResult();
}
