#ifndef HOMEBANNERMODEL_H
#define HOMEBANNERMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class HomeBannerModel : public QAbstractListModel
{
    Q_OBJECT

    enum BANNERINFO
    {
        BANNER_NAME = 1,
        BANNER_DESC,
        BANNER_URL,
        BANNER_APP_ID,
        BANNER_APP_TYPE,
        BANNER_MSG_ID,
        BANNER_MSG_TYPE,
        BANNER_MSG_TITLE,
        BANNER_INTERNAL_LINK,
        BANNER_EXTERNAL_LINK,
        BANNER_TYPE //1-应用 2-消息 3-内部链接 4-外部链接
    };

public slots:
    void updateBannerList(const QJsonArray& arrList);

public:
    explicit HomeBannerModel(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

private:
    QJsonArray m_bannerlist;
};

#endif // HOMEBANNERMODEL_H
