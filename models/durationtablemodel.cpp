#include "DurationTableModel.h"

DurationTableModel* DurationTableModel::m_pdurationTableModel = nullptr;

DurationTableModel::DurationTableModel(QObject *parent)
    : QAbstractTableModel(parent)
{
    m_pdurationTableModel = this;
    _horHeaderList.push_back(u8"游戏名称");
    _horHeaderList.push_back(u8"登录端");
    _horHeaderList.push_back(u8"开始时间");
    _horHeaderList.push_back(u8"结束时间");
    _horHeaderList.push_back(u8"使用时长");
}

QStringList DurationTableModel::getHorHeader() const
{
    return _horHeaderList;
}

void DurationTableModel::setHorHeader(const QStringList &header)
{
    _horHeaderList=header;
    emit horHeaderChanged();
}

QJsonArray DurationTableModel::getInitData() const
{
    return _initData;
}

void DurationTableModel::setInitData(const QJsonArray &jsonArr)
{
    _initData=jsonArr;
    if(_completed){
        loadData(_initData);
    }
    emit initDataChanged();
}

void DurationTableModel::classBegin()
{

}

void DurationTableModel::componentComplete()
{
    _completed = true;
    if(!_initData.isEmpty()){
        loadData(_initData);
    }
}

QHash<int, QByteArray> DurationTableModel::roleNames() const
{
    //value表示取值，edit表示编辑
    return QHash<int,QByteArray>{
        { Qt::DisplayRole,"value" },
        { Qt::EditRole,"edit" }
    };
}

QVariant DurationTableModel::headerData(int section, Qt::Orientation orientation, int role) const
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

bool DurationTableModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role)
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


int DurationTableModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return _modelData.count();
}

int DurationTableModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return _horHeaderList.count();
}

QVariant DurationTableModel::data(const QModelIndex &index, int role) const
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

bool DurationTableModel::setData(const QModelIndex &index, const QVariant &value, int role)
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

Qt::ItemFlags DurationTableModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;
    return Qt::ItemIsEnabled|Qt::ItemIsSelectable|Qt::ItemIsEditable;
}

void DurationTableModel::loadData(const QJsonArray &data)
{
    QVector<QVector<QVariant>> newData;
    QJsonArray::const_iterator iter;
    for(iter=data.begin();iter!=data.end();++iter){
        QVector<QVariant> newRow;
        const QJsonObject itemRow=(*iter).toObject();
        newRow.append(itemRow.value("gameName").toString("NULL"));
        newRow.append(itemRow.value("loginTerminal").toString("NULL"));
        newRow.append(itemRow.value("loginTime").toString("NULL"));
        newRow.append(itemRow.value("logoutTime").toString("NULL"));
        newRow.append(itemRow.value("duration").toString("NULL"));
        newData.append(newRow);
    }

    emit beginResetModel();
    _modelData=newData;
    emit endResetModel();
}
