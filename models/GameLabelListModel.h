#ifndef GAMELABELLISTMODEL_H
#define GAMELABELLISTMODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include <QJsonObject>

class GameLabelListModel : public QAbstractListModel
{
    Q_OBJECT

    enum GAMEINFO {
        GAME_NAME = 1,
        GAME_ID,
        GAME_MAIN_IMAGE,
    };

signals:
    void getDataSuccess();

public slots:
    void updateGameList(const QString& labelId, const QJsonArray& arrList);

public:
    explicit GameLabelListModel(QObject *parent = nullptr);
    static GameLabelListModel* pGameListModel;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    virtual QHash<int, QByteArray> roleNames() const override;
private:
    QJsonArray m_gameList;
};

#endif // GAMELABELLISTMODEL_H
