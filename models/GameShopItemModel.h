#ifndef GAMESHOPITEMMODEL_H
#define GAMESHOPITEMMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class GameShopItemModel : public QAbstractListModel
{
    Q_OBJECT
    enum GAMESHOPITEMINFO {
        ITEM_NAME = 1,
        ITEM_LABEL,
        ITEM_ICONURL,
        ITEM_MAIN_IMAGE,
        ITEM_PRICE,
        ITEM_ORIGINAL_PRICE,
        ITEM_PRICE_SAVE,
        ITEM_GAME_ID,
        ITEM_GOODS_ID,
        ITEM_PACKAGE_NAME,
        ITEM_GAME_CHANNEL,
        ITEM_GOODS_TYPE, //1应用 2推广 3商品
        ITEM_IS_GOODS //是否支持购买
    };

public slots:
    void initGameItemsList(const QString& id, const QJsonArray& arrList);

public:
    explicit GameShopItemModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    static GameShopItemModel* shopItemModel;
private:
    QJsonArray m_gameItemsList;
};

#endif // GAMESHOPITEMMODEL_H
