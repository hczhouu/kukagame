#ifndef HOMEHOTGAMESMODEL_H
#define HOMEHOTGAMESMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class HomeHotGamesModel : public QAbstractListModel
{
    Q_OBJECT

    enum HOTGAMESINFO {
        HOTGAMES_NAME = 1,
        HOTGAMES_ICON_URL,
        HOTGAMES_MAIN_IMAGE,
        HOTGAMES_ID,
        HOTGAMES_PACKAGE_NAME,
        HOTGAMES_GAME_CNAHNNEL,
        HOTGAMES_GOODS_ID,
        HOTGAMES_GOODS_TYPE, // 1应用 2推广 3商品
        HOTGAMES_IS_GOODS //是否支持购买
    };


public slots:
    void updateHotGamesList(const QString& id,  const QJsonArray& arrList);

public:
    HomeHotGamesModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    static HomeHotGamesModel* hotGamesModel;

private:
    QJsonArray m_hotGamesList;
    ///void checkLocalCache(const QString& id, const QJsonArray& arrList);
};

#endif // HOMEHOTGAMESMODEL_H
