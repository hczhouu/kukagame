#ifndef CDKEYLISTMODEL_H
#define CDKEYLISTMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class CDKeyListModel : public QAbstractListModel
{
    Q_OBJECT
    enum CDKEY_INFO {
        CD_KEY = 1
    };

public slots:
    void updateCdKeyList(const QJsonArray& arrList);

public:
    explicit CDKeyListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int,QByteArray> roleNames() const override;

private:
    QJsonArray m_cdKeyList;
};

#endif // CDKEYLISTMODEL_H
