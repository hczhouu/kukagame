#ifndef GAMESKUMODEL_H
#define GAMESKUMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class GameSkuModel : public QAbstractListModel
{
    Q_OBJECT

    enum GAMESKUINFO {
        SKU_NAME = 1,
        SKU_DESC,
        SKU_PRICE,
        SKU_ORI_PRICE,
        SKU_SAVE_PRICE,
        SKU_STOCK,
        SKU_ID
    };

    //规格名称
    Q_PROPERTY(QString skuName MEMBER m_skuName NOTIFY skuNameChanged FINAL)
    //规格描述
    Q_PROPERTY(QString skuDesc MEMBER m_skuDesc NOTIFY skuDescChanged FINAL)
    //价格
    Q_PROPERTY(double skuPrice MEMBER m_skuPrice NOTIFY skuPriceChanged FINAL)
    //原价
    Q_PROPERTY(double skuOriPrice MEMBER m_skuOriPrice NOTIFY skuOriPriceChanged FINAL)
    //优惠
    Q_PROPERTY(QString skuSavePrice MEMBER m_skuSavePrice NOTIFY skuSavePriceChanged FINAL)
    //库存
    Q_PROPERTY(int skuStock MEMBER m_skuStock NOTIFY skuStockChanged FINAL)
    //规格ID
    Q_PROPERTY(QString skuId MEMBER m_skuId NOTIFY skuIdChanged FINAL)

signals:
    void skuNameChanged();
    void skuPriceChanged();
    void skuSavePriceChanged();
    void skuStockChanged();
    void skuIdChanged();
    void skuDescChanged();
    void skuOriPriceChanged();

public slots :
    void updateGameSkuList(const QJsonArray& arrList);
    void initSkuInfo();

public:
    explicit GameSkuModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void resetModel();

private:
    QJsonArray m_gameSkuList;
    double m_skuPrice;
    double m_skuOriPrice;
    QString m_skuSavePrice;
    int m_skuStock;
    QString m_skuId;
    QString m_skuName;
    QString m_skuDesc;
};

#endif // GAMESKUMODEL_H
