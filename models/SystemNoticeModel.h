#ifndef SYSTEMNOTICEMODEL_H
#define SYSTEMNOTICEMODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include <QJsonObject>

class SystemNoticeModel : public QAbstractListModel
{
    Q_OBJECT

    enum ACTIVITIES_NOTICE {
        NOTICE_TITLE = 1,
        NOTICE_ID,
        NOTICE_TYPE,
        NOTICE_CAPTION,
        NOTICE_ICON,
        NOTICE_READ_FLAG,
        NOTICE_CREATE_TIME
    };

public slots:
   void updateSystemList(const QJsonArray& arrList);

public:
    explicit SystemNoticeModel(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int,QByteArray> roleNames() const override;

private:
    QJsonArray m_noticeList;
};

#endif // SYSTEMNOTICEMODEL_H
