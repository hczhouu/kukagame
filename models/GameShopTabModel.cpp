#include "GameShopTabModel.h"
#include "models/GameShopItemModel.h"


GameShopTabModel::GameShopTabModel(QObject *parent)
    : QAbstractListModel(parent)
{
    m_iconList.push_back("../res/v2/icon_01.png");
    m_iconList.push_back("../res/v2/icon_02.png");
    m_iconList.push_back("../res/v2/icon_03.png");
    m_iconList.push_back("../res/v2/icon_04.png");
    m_showLoading = true;
}

int GameShopTabModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_tabTitleList.size();
}

QVariant GameShopTabModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_tabTitleList.at(index.row()).toObject();
    switch (role) {
    case TAB_TITLE:{
        return item.value("furnishName").toString();
    }
    case TAB_ICON:{
        if (index.row() > 3)
        {
            return "../res/v2/icon_04.png";
        }

        return m_iconList.at(index.row());
    }
    default:
        break;
    }

    return QVariant();
}


QHash<int, QByteArray> GameShopTabModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(TAB_TITLE, "tabTitle");
    rolesHash.insert(TAB_ICON, "tabIcon");
    return rolesHash;
}

void GameShopTabModel::updateShopTabTitle(const QJsonArray& arrList)
{
    beginResetModel();
    m_tabTitleList  = arrList;
    endResetModel();

    for(int i = 0; i < arrList.size(); ++i)
    {
        m_itemList.push_back(arrList.at(i).toObject());
    }

    if (GameShopItemModel::shopItemModel != nullptr)
    {
        connect(this, &GameShopTabModel::initGameItemsList, GameShopItemModel::shopItemModel,
                &GameShopItemModel::initGameItemsList, Qt::UniqueConnection);
    }

    selectIndex(0);
}


void GameShopTabModel::selectIndex(int index)
{
    m_showLoading = true;
    emit showLoadingChanged();

    if (index < m_itemList.size())
    {
        const QString& id = m_itemList.at(index).value("id").toString();
        const QJsonArray& gameList = m_itemList.at(index).value("gameBaseVoList").toArray();
        emit initGameItemsList(id, gameList);
    }

    m_showLoading = false;
    emit showLoadingChanged();
}
