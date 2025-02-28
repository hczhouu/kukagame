#ifndef GAMELABELMODEL_H
#define GAMELABELMODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include <QJsonObject>

class GameLabelModel : public QAbstractListModel
{
    Q_OBJECT

    enum LABELINFO {
        LABEL_TEXT = 1,
        LABEL_ID
    };

signals:
    void getDataSuccess();

public slots:
    void updateGameLabel(const QJsonArray& jsonArr);

public:
    explicit GameLabelModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

private:
    QJsonArray m_listLabel;
};

#endif // GAMELABELMODEL_H
