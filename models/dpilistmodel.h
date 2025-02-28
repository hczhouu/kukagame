#ifndef DPILISTMODEL_H
#define DPILISTMODEL_H

#include <QAbstractListModel>

class DpiListModel : public QAbstractListModel
{
    Q_OBJECT

    enum DPILIST{
        DPI_WIDTH = 1,
        DPI_HEIGHT,
        DPI_INDEX
    };

    struct DPIINFO
    {
        QString width;
        QString height;
        int index;
    };

public:
    explicit DpiListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int,QByteArray> roleNames() const override;

private:
    QList<DPIINFO> m_dpiList;
};

#endif // DPILISTMODEL_H
