#include "RedeemTableModel.h"

RedeemTableModel* RedeemTableModel::m_predeemTableModel = nullptr;

RedeemTableModel::RedeemTableModel(QObject *parent)
    : QAbstractTableModel(parent)
{
    m_predeemTableModel = this;
    _horHeaderList.push_back(u8"兑换码");
    _horHeaderList.push_back(u8"兑换类型");
    _horHeaderList.push_back(u8"生成套餐");
    _horHeaderList.push_back(u8"兑换时间");
    _horHeaderList.push_back(u8"到期时间");
    _horHeaderList.push_back(u8"使用期限");
    _horHeaderList.push_back(u8"状态");

}

QStringList RedeemTableModel::getHorHeader() const
{
    return _horHeaderList;
}

void RedeemTableModel::setHorHeader(const QStringList &header)
{
    _horHeaderList=header;
    emit horHeaderChanged();
}

QJsonArray RedeemTableModel::getInitData() const
{
    return _initData;
}

void RedeemTableModel::setInitData(const QJsonArray &jsonArr)
{
    _initData=jsonArr;
    if(_completed){
        loadData(_initData);
    }
    emit initDataChanged();
}

void RedeemTableModel::classBegin()
{

}

void RedeemTableModel::componentComplete()
{
    _completed = true;
    if(!_initData.isEmpty()){
        loadData(_initData);
    }
}

QHash<int, QByteArray> RedeemTableModel::roleNames() const
{
    //value表示取值，edit表示编辑
    return QHash<int,QByteArray>{
        { Qt::DisplayRole,"value" },
        { Qt::EditRole,"edit" }
    };
}

QVariant RedeemTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    //返回表头数据，无效的返回None
    if(role==Qt::DisplayRole){
        if(orientation==Qt::Horizontal){
            return _horHeaderList.value(section,QString::number(section));
        }else if(orientation==Qt::Vertical){
            return QString::number(section);
        }
    }
    return QVariant();
}

bool RedeemTableModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role)
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


int RedeemTableModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return _modelData.count();
}

int RedeemTableModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return _horHeaderList.count();
}

QVariant RedeemTableModel::data(const QModelIndex &index, int role) const
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

bool RedeemTableModel::setData(const QModelIndex &index, const QVariant &value, int role)
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

Qt::ItemFlags RedeemTableModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEnabled|Qt::ItemIsSelectable|Qt::ItemIsEditable;
}

void RedeemTableModel::loadData(const QJsonArray &data)
{
    QVector<QVector<QVariant>> newData;
    QJsonArray::const_iterator iter;
    QString strUnit;
    QString strStatus;
    for(iter=data.begin();iter!=data.end();++iter){
        QVector<QVariant> newRow;
        const QJsonObject itemRow=(*iter).toObject();
        newRow.append(itemRow.value("code"));

        QString strLimit = QString::number(itemRow.value("timeLimit").toInt());
        switch (itemRow.value("useUnit").toInt()) {
        case 1:
        {
            strUnit = u8"时长卡";
            strLimit.append(u8"小时");
            break;
        }
        case 2:
        {
            strUnit = u8"周期卡";
            strLimit.append(u8"天");
            break;
        }
        default:
            break;
        }
        newRow.append(strUnit);
        newRow.append(itemRow.value("goodsName"));
        newRow.append(itemRow.value("createTime"));
        newRow.append(itemRow.value("codeEndTime"));
        newRow.append(strLimit);

        switch (itemRow.value("status").toInt()) {
        case 0:
        {
            strStatus = u8"未使用";
            break;
        }
        case 1:
        {
            strStatus = u8"已使用";
            break;
        }
        case 2:
        {
            strStatus = u8"已过期";
            break;
        }
        default:
            break;
        }
        newRow.append(strStatus);
        newData.append(newRow);
    }

    emit beginResetModel();
    _modelData=newData;
    emit endResetModel();
}

/*
bool EasyTableModel::insertRows(int row, int count, const QModelIndex &parent)
{
    beginInsertRows(parent, row, row + count - 1);
    // FIXME: Implement me!
    endInsertRows();
}

bool EasyTableModel::insertColumns(int column, int count, const QModelIndex &parent)
{
    beginInsertColumns(parent, column, column + count - 1);
    // FIXME: Implement me!
    endInsertColumns();
}

bool EasyTableModel::removeRows(int row, int count, const QModelIndex &parent)
{
    beginRemoveRows(parent, row, row + count - 1);
    // FIXME: Implement me!
    endRemoveRows();
}

bool EasyTableModel::removeColumns(int column, int count, const QModelIndex &parent)
{
    beginRemoveColumns(parent, column, column + count - 1);
    // FIXME: Implement me!
    endRemoveColumns();
}*/
