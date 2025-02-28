#ifndef GAMEDETAILSIMAGEMODEL_H
#define GAMEDETAILSIMAGEMODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include <QJsonObject>

class GameDetailsImageModel : public QAbstractListModel
{
    Q_OBJECT

    enum DETAILS_IMAGE {
        IMAGE_URL = 1
    };

public slots:
    void updateDetailsImage(const QJsonArray& arrList);

public:
    explicit GameDetailsImageModel(QObject *parent = nullptr);
    static GameDetailsImageModel* detailImage;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int,QByteArray> roleNames() const override;

private:
    QJsonArray m_gameDetailsImage;
};

#endif // GAMEDETAILSIMAGEMODEL_H
