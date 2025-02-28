#include "OrderListTableModel.h"


OrderListTableModel* OrderListTableModel::m_porderTableModel = nullptr;

OrderListTableModel::OrderListTableModel(QObject *parent)
    : QAbstractTableModel(parent)
{
    m_porderTableModel = this;
    _horHeaderList.push_back(u8"订单编号");
    _horHeaderList.push_back(u8"下单时间");
    _horHeaderList.push_back(u8"商品");
    _horHeaderList.push_back(u8"数量");
    _horHeaderList.push_back(u8"支付金额");
    _horHeaderList.push_back(u8"支付方式");
    _horHeaderList.push_back(u8"订单状态");

}


QHash<int, QByteArray> OrderListTableModel::roleNames() const
{
    //value表示取值，edit表示编辑
    return QHash<int,QByteArray>{
        { Qt::DisplayRole,"value" },
        { Qt::EditRole,"edit" }
    };
}

QVariant OrderListTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if(role==Qt::DisplayRole){
        if(orientation==Qt::Horizontal){
            return _horHeaderList.value(section,QString::number(section));
        }else if(orientation==Qt::Vertical){
            return QString::number(section);
        }
    }
    return QVariant();
}

bool OrderListTableModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role)
{
    if (value != headerData(section, orientation, role)) {
        if(orientation==Qt::Horizontal&&role==Qt::EditRole){
            _horHeaderList[section]=value.toString();
            emit headerDataChanged(orientation, section, section);
            return true;
        }
    }
    return false;
}


int OrderListTableModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return _modelData.count();
}

int OrderListTableModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return _horHeaderList.count();
}

QVariant OrderListTableModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    switch (role) {
    case Qt::DisplayRole:
    case Qt::EditRole:
        return _modelData.at(index.row()).at(index.column());
    default:
        break;
    }
    return QVariant();
}

bool OrderListTableModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (value.isValid()&&index.isValid()&&(data(index, role) != value)) {
        if(Qt::EditRole==role){
            _modelData[index.row()][index.column()]=value;
            emit dataChanged(index, index, QVector<int>() << role);
            return true;
        }
    }
    return false;
}

Qt::ItemFlags OrderListTableModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEnabled|Qt::ItemIsSelectable|Qt::ItemIsEditable;
}

void OrderListTableModel::loadData(const QJsonArray &data)
{
    QVector<QVector<QVariant>> newData;
    QString strStatus;
    QString strPaytype;
    for(auto iter = data.begin();iter != data.end();++iter){
        QVector<QVariant> newRow;
        const QJsonObject itemRow=(*iter).toObject();
        newRow.append(itemRow.value("orderSn"));
        newRow.append(itemRow.value("payTime"));
        newRow.append(itemRow.value("productName"));
        newRow.append(itemRow.value("payNum"));
        newRow.append(itemRow.value("payAmount"));

        switch (itemRow.value("payType").toInt()) {
        case 1:
        {
            strPaytype = u8"支付宝";
            break;
        }
        case 2:
        {
            strPaytype = u8"微信";
            break;
        }
        default:
            strPaytype = u8"--";
            break;
        }

        newRow.append(strPaytype);

        switch (itemRow.value("status").toInt())
        {
        case 0:
        {
            strStatus = u8"等待付款";
            break;
        }
        case 1:
        {
            strStatus = u8"已完成";
            break;
        }
        case -1:
        {
            strStatus = u8"已取消";
            break;
        }
        default:
            strStatus = u8"--";
            break;
        }

        newRow.append(strStatus);
        newData.append(newRow);
    }

    emit beginResetModel();
    _modelData = newData;
    emit endResetModel();
}
