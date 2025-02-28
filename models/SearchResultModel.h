#ifndef SEARCHRESULTMODEL_H
#define SEARCHRESULTMODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include <QJsonObject>

class SearchResultModel : public QAbstractListModel
{
    Q_OBJECT

    enum RESULTINFO {
        ITEM_GAME_ID,
        ITEM_GOODS_ID,
        ITEM_GAME_ICON,
        ITEM_GAME_NAME
    };

    Q_PROPERTY(bool noResult MEMBER m_noResult NOTIFY noResultChanged FINAL)

signals:
    void showSearchResult();
    void noResultChanged();

public slots:
    void updateSearchList(const QJsonArray& arrList);

public:
    explicit SearchResultModel(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int,QByteArray> roleNames() const override;


private:
    bool m_noResult;
    QJsonArray m_resultList;
};

#endif // SEARCHRESULTMODEL_H
