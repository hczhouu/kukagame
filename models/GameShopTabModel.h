#ifndef GAMESHOPTABMODEL_H
#define GAMESHOPTABMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class GameShopTabModel : public QAbstractListModel
{
    Q_OBJECT

    enum GAMESHOPTABTITLE {
        TAB_TITLE = 1,
        TAB_ICON
    };

    Q_PROPERTY(bool showLoading MEMBER m_showLoading NOTIFY showLoadingChanged FINAL)

signals:
    void initGameItemsList(const QString& id, const QJsonArray& arrList);
    void showLoadingChanged();

public slots:
    void updateShopTabTitle(const QJsonArray& arrList);

public:
    explicit GameShopTabModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void selectIndex(int index);

private:
    bool m_showLoading;
    QJsonArray m_tabTitleList;
    QList<QString> m_iconList;
    QVector<QJsonObject> m_itemList;
};

#endif // GAMESHOPTABMODEL_H
