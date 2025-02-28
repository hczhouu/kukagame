#ifndef HOMEACTIVITIESMODEL_H
#define HOMEACTIVITIESMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class HomeActivitiesModel : public QAbstractListModel
{
    Q_OBJECT

    enum ACTIVITIESINFO
    {
        ACTIVITIES_BANNER_NAME = 1,
        ACTIVITIES_BANNER_DESC,
        ACTIVITIES_BANNER_URL,
        ACTIVITIES_BANNER_TYPE,
        ACTIVITIES_BANNER_APP_ID,
        ACTIVITIES_BANNER_APP_TYPE,
        ACTIVITIES_BANNER_MSG_ID,
        ACTIVITIES_BANNER_MSG_TYPE,
        ACTIVITIES_BANNER_MSG_TITLE,
        ACTIVITIES_BANNER_INTERNAL_LINK,
        ACTIVITIES_BANNER_EXTERNAL_LINK
    };

public slots:
    void updateActivitiesList(const QJsonArray& arrList);

public:
    explicit HomeActivitiesModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

private:
    QJsonArray m_activitiesList;
};

#endif // HOMEACTIVITIESMODEL_H
