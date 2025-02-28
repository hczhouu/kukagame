#include "HomeHotGamesTabModel.h"
#include "models/HomeHotGamesModel.h"

HomeHotGamesTabModel::HomeHotGamesTabModel(QObject *parent)
    : QAbstractListModel(parent)
{
    m_showLoading = true;
}

int HomeHotGamesTabModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_tabTitleList.size();
}

QVariant HomeHotGamesTabModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_tabTitleList.at(index.row()).toObject();
    if (item.isEmpty())
    {
        return QVariant();
    }

    QJsonArray arrItem = item.value("gameBaseVoList").toArray();
    if (arrItem.isEmpty())
    {
        return QVariant();
    }

    QJsonObject firstItem = arrItem.at(0).toObject();

    switch (role) {
    case HOTGAMES_TITLE:{
        return item.value("furnishName").toString();
    }
    case FIRSTITEM_URL:{
        return firstItem.value("gameIcon").toString();
    }
    case FIRSTITEM_NAME:{
        return firstItem.value("gameName").toString("NULL");
    }
    case FIRSTITEM_GAME_ID:{
        return firstItem.value("id").toString("NULL");
    }
    case FIRSTITEM_PACKAGE_NAME:{
        return firstItem.value("packageName").toString("NULL");
    }
    case FIRSTITEM_GOODS_ID:{
        return firstItem.value("gameGoods").
                toObject().value("id").toString("NULL");
    }
    case FIRSTITEM_GAME_CHANNEL:{
        return firstItem.value("gameChannel").toString("NULL");
    }
    case FIRSTITEM_GAME_TYPE:{
        return firstItem.value("appType").toString("NULL");
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int, QByteArray> HomeHotGamesTabModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(HOTGAMES_TITLE, "hotGamesTitle");
    rolesHash.insert(FIRSTITEM_URL, "firstItemUrl");
    rolesHash.insert(FIRSTITEM_NAME, "firstItemName");
    rolesHash.insert(FIRSTITEM_GAME_ID, "firstItemGameId");
    rolesHash.insert(FIRSTITEM_PACKAGE_NAME, "firstItemPackageName");
    rolesHash.insert(FIRSTITEM_GOODS_ID, "firstItemGoodsId");
    rolesHash.insert(FIRSTITEM_GAME_CHANNEL, "firstItemGameChannel");
    rolesHash.insert(FIRSTITEM_GAME_TYPE, "firstItemGameType");
    return rolesHash;
}


void HomeHotGamesTabModel::updateHotGamesTitle(const QJsonArray& arrList)
{
    beginResetModel();
    m_tabTitleList = arrList;
    endResetModel();

    for(int i = 0; i < arrList.size(); ++i)
    {
        m_hotGamesList.push_back(arrList.at(i).toObject());
    }

    if (HomeHotGamesModel::hotGamesModel != nullptr)
    {
        connect(this, &HomeHotGamesTabModel::updateHotGamesList, HomeHotGamesModel::hotGamesModel,
                &HomeHotGamesModel::updateHotGamesList, Qt::UniqueConnection);
    }

    selectIndex(0);
}


void HomeHotGamesTabModel::selectIndex(int index)
{
    if (index >= m_hotGamesList.size())
    {
        return;
    }

    m_showLoading = true;
    emit showLoadingChanged();

    const QString& id = m_hotGamesList.at(index).value("id").toString();
    const QJsonArray& gameList = m_hotGamesList.at(index).value("gameBaseVoList").toArray();
    emit updateHotGamesList(id, gameList);

    m_showLoading = false;
    emit showLoadingChanged();
}


