#include "HomeGoodsTabModel.h"
#include "models/HomeGoodsModel.h"

HomeGoodsTabModel::HomeGoodsTabModel(QObject *parent)
    : QAbstractListModel(parent)
{}

int HomeGoodsTabModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_goodsTabList.size();
}

QVariant HomeGoodsTabModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QJsonObject item = m_goodsTabList.at(index.row()).toObject();
    switch (role) {
    case GOODSTAB_TITLE:{
        return item.value("furnishName").toString();
    }
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> HomeGoodsTabModel::roleNames() const
{
    QHash<int,QByteArray> rolesHash;
    rolesHash.insert(GOODSTAB_TITLE, "goodsTabTitle");
    return rolesHash;
}



void HomeGoodsTabModel::updateGoodsTabTitle(const QJsonArray& arrList)
{
    beginResetModel();
    m_goodsTabList = arrList;
    endResetModel();

    for(int i = 0; i < arrList.size(); ++i)
    {
        m_hotGoodsList.push_back(arrList.at(i).toObject());
    }

    if (HomeGoodsModel::homeGoodsModel != nullptr)
    {
        connect(this, &HomeGoodsTabModel::initGoodsList, HomeGoodsModel::homeGoodsModel,
                &HomeGoodsModel::initGoodsList, Qt::UniqueConnection);
    }

    selectIndex(0);
}


void HomeGoodsTabModel::selectIndex(int index)
{
    if (index >= m_hotGoodsList.size())
    {
        return;
    }

    const QString& id = m_hotGoodsList.at(index).value("id").toString();
    const QJsonArray& gameList = m_hotGoodsList.at(index).value("gameBaseVoList").toArray();
    emit initGoodsList(id, gameList);
}

