#include "GamesOrderTableModel.h"

GamesOrderTableModel* GamesOrderTableModel::m_pGameOrderTableModel = nullptr;

GamesOrderTableModel::GamesOrderTableModel(QObject *parent)
    : QAbstractTableModel(parent)
{
    m_headerList.push_back(u8"订单编号");
    m_headerList.push_back(u8"下单时间");
    m_headerList.push_back(u8"商品");
    m_headerList.push_back(u8"数量");
    m_headerList.push_back(u8"合计消费");
    m_headerList.push_back(u8"支付方式");
    m_headerList.push_back(u8"订单状态");
    m_headerList.push_back(u8"操作");
    m_pGameOrderTableModel = this;
}

int GamesOrderTableModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_tableModelData.size();
}

int GamesOrderTableModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_headerList.size();
}

QVariant GamesOrderTableModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    switch (role) {
    case Qt::DisplayRole:
    case Qt::EditRole:
        return m_tableModelData.at(index.row()).at(index.column());
    default:
        break;
    }

    return QVariant();
}


QHash<int,QByteArray> GamesOrderTableModel::roleNames() const
{

    QHash<int, QByteArray> roles;
    roles.insert(Qt::DisplayRole, "value");
    roles.insert(Qt::EditRole, "edit");
    return roles;
}


QVariant GamesOrderTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if(role==Qt::DisplayRole){
        if(orientation==Qt::Horizontal){
            return m_headerList.value(section,QString::number(section));
        }else if(orientation==Qt::Vertical){
            return QString::number(section);
        }
    }
    return QVariant();
}


bool GamesOrderTableModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role)
{
    if (value != headerData(section, orientation, role)) {
        if(orientation==Qt::Horizontal&&role==Qt::EditRole){
            m_headerList[section]=value.toString();
            emit headerDataChanged(orientation, section, section);
            return true;
        }
    }
    return false;
}


void GamesOrderTableModel::initListData(const QJsonArray& arrList)
{
    beginResetModel();
    m_tableModelData.clear();
    for (auto iter : arrList)
    {
        QJsonObject item = iter.toObject();
        QVector<QVariant> vecRows;
        vecRows.push_back(item.value("orderSn").toString());
        vecRows.push_back(item.value("createTime").toString());
        vecRows.push_back(item.value("gameGoodsName").toString());
        vecRows.push_back(QString::number(item.value("payNum").toInt()));
        vecRows.push_back(item.value("orderAmount").toString());

        switch (item.value("payType").toInt()) {
        case 1:
        {
            vecRows.push_back(u8"支付宝");
            break;
        }
        case 2:
        {
            vecRows.push_back(u8"微信");
            break;
        }
        default:
            vecRows.push_back(u8"--");
            break;
        }

        QString payStatus = item.value("status").toInt() == 1 ? u8"支付成功" : u8"等待付款";
        vecRows.push_back(payStatus);
        vecRows.push_back(u8"查看详情");
        m_tableModelData.push_back(vecRows);
    }

    endResetModel();
}


QString GamesOrderTableModel::getData(int row, int column)
{
    if (m_tableModelData.size() < row)
    {
        return "";
    }

    return m_tableModelData.at(row).at(0).toString();
}


QString GamesOrderTableModel::getItemData(int row, int column)
{
    return m_tableModelData.at(row).at(column).toString();
}
