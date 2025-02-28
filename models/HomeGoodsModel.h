#ifndef HOMEGOODSMODEL_H
#define HOMEGOODSMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class HomeGoodsModel : public QAbstractListModel
{
    Q_OBJECT

    enum GOODSINFO {
        GOODS_NAME = 1,
        GOODS_ICON_URL,
        GOODS_MAIN_IMAGE,
        GOODS_ID,
        GOODS_PRICE,
        ITEM_PACKAGE_NAME,
        ITEM_GAME_CHANNEL,
        ITEM_GOODS_ID,
        ITEM_GOODS_TYPE, //0应用 1推广 2商品
        ITEM_IS_GOOGS //是否支持购买
    };

    Q_PROPERTY(bool showLoading MEMBER m_showLoading NOTIFY showLoadingChanged FINAL)

signals:
    void showLoadingChanged();

public slots:
    void initGoodsList(const QString& id, const QJsonArray& arrList);

public:
    explicit HomeGoodsModel(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    static HomeGoodsModel* homeGoodsModel;

private:
    bool m_showLoading;
    QJsonArray m_goodsList;
};

#endif // HOMEGOODSMODEL_H
