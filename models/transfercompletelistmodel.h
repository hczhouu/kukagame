#ifndef TRANSFERCOMPLETELISTMODEL_H
#define TRANSFERCOMPLETELISTMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonValue>

class TransferCompleteListModel : public QAbstractListModel
{
    Q_OBJECT

    enum DownloadListInfo{
        FILES_NAME,
        FILES_SIZE,
        FILES_STATUS,
        FILES_TYPE_ICON,
        FILES_PATH
    };

public:
    explicit TransferCompleteListModel(QObject *parent = nullptr);
    static TransferCompleteListModel* pTransferCompleteListModel;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int,QByteArray> roleNames() const override;

    void addRow(const QJsonObject& item);
    Q_INVOKABLE void removeRow(int row);
private:
    QList<QJsonObject> m_transferCompleteList;

};

#endif // TRANSFERCOMPLETELISTMODEL_H
