#ifndef UPLOADLISTMODEL_H
#define UPLOADLISTMODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>

class UploadListModel : public QAbstractListModel
{
    Q_OBJECT

    enum DownloadListInfo{
        FILES_NAME,
        FILES_SIZE,
        FILES_UPLOAD_SIZE,
        FILES_TOTAL_SIZE,
        FILES_TIME,
        FILES_TYPE_ICON,
        FILES_PATH
    };

public:
    explicit UploadListModel(QObject *parent = nullptr);
    static UploadListModel* pUploadListModel;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int,QByteArray> roleNames() const override;

    void addRow(const QJsonObject& item);
    void removeRow(int row);
    void updateProgress(int index, qint64 uploadSize, qint64 totalSize);

private:
    QList<QJsonObject> m_downLoadList;

};

#endif // UPLOADLISTMODEL_H
