#ifndef TIMECARDLISTMODEL_H
#define TIMECARDLISTMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class TimeCardListModel : public QAbstractListModel
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
    explicit TimeCardListModel(QObject *parent = nullptr);
    static TimeCardListModel* pTimecardListModel;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int,QByteArray> roleNames() const override;

    void updateTimecardList(const QJsonArray& arrItem);

private:
    bool m_isDataReady;
    QJsonArray m_timeCardList;
};

#endif // TIMECARDLISTMODEL_H
