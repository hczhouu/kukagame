#ifndef HOMEHOTGAMESTABMODEL_H
#define HOMEHOTGAMESTABMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class HomeHotGamesTabModel : public QAbstractListModel
{
    Q_OBJECT

    enum HOTGAMESTABINFO {
        HOTGAMES_TITLE = 1,
        FIRSTITEM_URL,
        FIRSTITEM_NAME,
        FIRSTITEM_GAME_ID,
        FIRSTITEM_GOODS_ID,
        FIRSTITEM_PACKAGE_NAME,
        FIRSTITEM_GAME_CHANNEL,
        FIRSTITEM_GAME_TYPE //1应用 2推广 3商品
    };

    Q_PROPERTY(bool showLoading MEMBER m_showLoading NOTIFY showLoadingChanged FINAL)

signals:
    void updateHotGamesList(const QString& id,  const QJsonArray& arrList);
    void showLoadingChanged();

public slots:
    void updateHotGamesTitle(const QJsonArray& arrList);

public:
    explicit HomeHotGamesTabModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void selectIndex(int index);
private:
    bool m_showLoading;
    QJsonArray m_tabTitleList;
    QVector<QJsonObject> m_hotGamesList;
};

#endif // HOMEHOTGAMESTABMODEL_H
