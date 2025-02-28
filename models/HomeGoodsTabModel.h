#ifndef HOMEGOODSTABMODEL_H
#define HOMEGOODSTABMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>


class HomeGoodsTabModel : public QAbstractListModel
{
    Q_OBJECT

    enum GOODSTABINFO {
        GOODSTAB_TITLE = 1
    };


signals:
    void initGoodsList(const QString& id, const QJsonArray& arrList);

public slots:
    void updateGoodsTabTitle(const QJsonArray& arrList);

public:
    explicit HomeGoodsTabModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void selectIndex(int index);

private:
    QJsonArray m_goodsTabList;
    QVector<QJsonObject> m_hotGoodsList;
};

#endif // HOMEGOODSTABMODEL_H
