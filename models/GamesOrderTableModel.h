#ifndef GAMESORDERTABLEMODEL_H
#define GAMESORDERTABLEMODEL_H

#include <QAbstractTableModel>
#include <QJsonArray>
#include <QJsonObject>

class GamesOrderTableModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit GamesOrderTableModel(QObject *parent = nullptr);
    static GamesOrderTableModel* m_pGameOrderTableModel;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int,QByteArray> roleNames() const override;
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    bool setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role = Qt::EditRole) override;

public:
    void initListData(const QJsonArray& arrList);
    Q_INVOKABLE QString getData(int row, int column);
    Q_INVOKABLE QString getItemData(int row, int column);
private:
    QJsonArray m_rowModelData;
    QVector<QVector<QVariant>>  m_tableModelData;

    // 横项表头
    QList<QString> m_headerList;

};

#endif // GAMESORDERTABLEMODEL_H
