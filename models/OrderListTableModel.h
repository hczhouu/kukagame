#ifndef ORDERLISTTABLEMODEL_H
#define ORDERLISTTABLEMODEL_H

#include <QAbstractTableModel>
#include <QQmlParserStatus>
#include <QHash>
#include <QList>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>

//订单记录列表
class OrderListTableModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit OrderListTableModel(QObject *parent = nullptr);
    static OrderListTableModel* m_porderTableModel;

    //void setInitData(const QJsonArray &jsonArr);

    QHash<int,QByteArray> roleNames() const override;

    // 表头
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    bool setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role = Qt::EditRole) override;

    // 数据，这三个必须实现
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // 编辑
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;

    void loadData(const QJsonArray &data);

private:
    // 组件是否初始化完成
    bool _completed = false;
    // 加载的数据
    //QJsonArray _initData;
    QVector<QVector<QVariant>> _modelData;
    // 横项表头
    QList<QString> _horHeaderList;


};

#endif // ORDERLISTTABLEMODEL_H
