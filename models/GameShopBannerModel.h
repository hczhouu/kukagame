#ifndef GAMESHOPBANNERMODEL_H
#define GAMESHOPBANNERMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class GameShopBannerModel : public QAbstractListModel
{
    Q_OBJECT

    enum GAMESHOPBANNERINFO {
        BANNER_NAME = 1,
        BANNER_DESC,
        BANNER_URL,
        BANNER_TYPE,
        BANNER_APP_ID,
        BANNER_APP_TYPE,
        BANNER_MSG_ID,
        BANNER_MSG_TYPE,
        BANNER_MSG_TITLE,
        BANNER_INTERNAL_LINK,
        BANNER_EXTERNAL_LINK
    };

public slots:
    void updateGameShopBannerList(const QJsonArray& arrList);


public:
    explicit GameShopBannerModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

private:
    QJsonArray m_bannerList;
};

#endif // GAMESHOPBANNERMODEL_H
