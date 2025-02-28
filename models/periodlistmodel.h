#ifndef PERIODLISTMODEL_H
#define PERIODLISTMODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>

//周期卡列表
class PeriodListModel : public QAbstractListModel
{
    Q_OBJECT

    enum GoodsInfo{
        GOODS_ID = 1,
        GOODS_NAME,
        GOODS_DESC,
        GOODS_MEAL_TYPE,
        GOODS_TIME_LIMIT,
        GOODS_TOTAL_TIME,
        GOODS_ORIGINAL_PRICE,
        GOODS_PAY_AMOUNT,
        GOODS_ORDER_AMOUNT,
        GOODS_SORT,
        GOODS_LABEL,
        GOODS_TYPE,
        GOODS_REMARK
    };

    Q_PROPERTY(bool isDataReady MEMBER m_isDataReady NOTIFY isDataReadyChanged FINAL)

signals:
    void isDataReadyChanged();

public:
    explicit PeriodListModel(QObject *parent = nullptr);
    static PeriodListModel* pPeriodGoodsList;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int,QByteArray> roleNames() const override;

    void updateGoodsList(const QJsonArray& goodsList);

private:
    bool m_isDataReady;
    QList<QJsonObject> m_goodsList;
};

#endif // PERIODLISTMODEL_H
