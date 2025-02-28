#ifndef DOWNLOADLISTMODEL_H
#define DOWNLOADLISTMODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>

class DownloadListModel : public QAbstractListModel
{
    Q_OBJECT

    enum DownloadListInfo{
        FILES_NAME,
        FILES_SIZE,
        FILES_DOWN_SIZE,
        FILES_TOTAL_SIZE,
        FILES_TIME,
        FILES_TYPE_ICON
    };

public:
    explicit DownloadListModel(QObject *parent = nullptr);
    static DownloadListModel* pDownloadListModel;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int,QByteArray> roleNames() const override;

    void addRow(const QJsonObject& item);
    void removeRow(int row);
    void updateProgress(int index, qint64 downSize, qint64 totalSize);

private:
    QList<QJsonObject> m_downLoadList;

};

#endif // DOWNLOADLISTMODEL_H
