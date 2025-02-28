#ifndef ALLFILESLISTMODEL_H
#define ALLFILESLISTMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QQueue>
#include <QSet>

class AllFilesListModel : public QAbstractListModel
{
    Q_OBJECT

    enum FilesListInfo{
        FILES_CHECKED = 1,
        FILES_NAME,
        FILES_SIZE,
        FILES_TYPE,
        FILES_TIME,
        FILES_TYPE_ICON,
        FILES_DESC,
        FILES_IS_FOLDER
    };

public:
    explicit AllFilesListModel(QObject *parent = nullptr);
    static AllFilesListModel* pAllFileListModel;

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int,QByteArray> roleNames() const override;
    void updateFileInfoList(const QJsonArray& goodsList);

    Q_INVOKABLE void addToSelectedList(bool bChecked, int index);
    Q_INVOKABLE void getSeclectFileList(QQueue<QJsonValue>& vecFileList);
    Q_INVOKABLE void clearSelectList();
    Q_INVOKABLE void selectAll(bool bCheckAll);

private:
    QSet<QJsonValue> m_setItem;
    QList<QJsonObject> m_filesInfoList;
};

#endif // ALLFILESLISTMODEL_H
