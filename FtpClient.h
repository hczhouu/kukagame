#ifndef FTPCLIENT_H
#define FTPCLIENT_H

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include <QQueue>
#include <QVector>
#include <QFile>
#include <QTimer>
#include "qftp.h"


class FtpClient : public QObject
{
    Q_OBJECT

    struct FilesType
    {
        QString typeIcon;
        QString typeDesc;
    };

public:
    explicit FtpClient(QObject *parent = nullptr);
    ~FtpClient();

    Q_PROPERTY(QString downSavePath MEMBER m_downSavePath NOTIFY downSavePathChanged FINAL)

    Q_PROPERTY(int totalDownProgress MEMBER m_totalDownProgress NOTIFY totalDownProgressChanged)
    Q_PROPERTY(int currDownProgress MEMBER m_currDownProgress NOTIFY currDownProgressChanged)
    Q_PROPERTY(QString textDownProgress MEMBER m_textDownProgress NOTIFY textDownProgressChanged)
    Q_PROPERTY(QString downloadSpeed MEMBER m_downloadSpeed NOTIFY downloadSpeedChanged)

    Q_PROPERTY(int totalUploadProgress MEMBER m_totalUploadProgress NOTIFY totalUploadProgressChanged)
    Q_PROPERTY(int currUploadProgress MEMBER m_currUploadProgress NOTIFY currUploadProgressChanged)
    Q_PROPERTY(QString textUploadProgress MEMBER m_textUploadProgress NOTIFY textUploadProgressChanged)
    Q_PROPERTY(QString uploadSpeed MEMBER m_uploadSpeed NOTIFY uploadSpeedChanged)

    Q_PROPERTY(QString downloadPath MEMBER m_strDownloadPath NOTIFY downloadPathChanged)

    Q_PROPERTY(int downloadTaskNum MEMBER m_downloadTaskNum NOTIFY downloadTaskNumChanged)
    Q_PROPERTY(int uploadTaskNum MEMBER m_uploadTaskNum NOTIFY uploadTaskNumChanged)
    Q_PROPERTY(int transferCompleteNum MEMBER m_transferCompleteNum NOTIFY transferCompleteNumChanged)
    
signals:
    void downSavePathChanged();
    void totalDownProgressChanged();
    void currDownProgressChanged();
    void textDownProgressChanged();
    void downloadSpeedChanged();

    void totalUploadProgressChanged();
    void currUploadProgressChanged();
    void textUploadProgressChanged();
    void uploadSpeedChanged();

    void downloadPathChanged();

    void showMsgPopup(const QVariant& msgType, const QVariant& msgData);
    void downloadTaskNumChanged();
    void uploadTaskNumChanged();
    void transferCompleteNumChanged();
public slots:
    void slotAddToList(const QUrlInfo& urlInfo);
    void slotCommandFinished(int index, bool bError);

    void slotdownCommandFinished(int index, bool bError);
    void slotdownDataTransferProgress(qint64 currsize, qint64 totalsize);
    void slotDownOnTimer();

    void slotuploadCommandFinished(int index, bool bError);
    void slotuploadDataTransferProgress(qint64 currsize, qint64 totalsize);
    void slotuploadOnTimer();

public:

    static FtpClient* ftpClient;
    void setConnectionParams(QString user, QString pass);

    //获取文件列表
    void queryDirList();

    //登录FTP服务器
    Q_INVOKABLE void loginSrv();
    //后退
    Q_INVOKABLE void backFolder();
    //前进
    Q_INVOKABLE void forwardFolder();
    //浏览文件夹
    Q_INVOKABLE void browseFolder(const QVariant& dirPath);
    //刷新
    Q_INVOKABLE void refreshFolder();
    //新建文件夹
    Q_INVOKABLE void addNewFolder(const QVariant& dirName);

    Q_INVOKABLE void deleteDirs(const QVariant& dirName);

    //删除文件
    Q_INVOKABLE void deleteFiles();

    //上传下载文件
    Q_INVOKABLE void transferFiles(bool bDownload, const QVariantList& filPath);

    //打开文件所在目录
    Q_INVOKABLE void openDir();

    Q_INVOKABLE void openUploadDir(const QVariant& filePath);

    //取消下载
    Q_INVOKABLE void cancelAllDownload();

    //取消上传
    Q_INVOKABLE void cancelAllUpload();

    Q_INVOKABLE void updateDownloadPath(const QVariant& savePath);

    Q_INVOKABLE void close();

    Q_INVOKABLE void removeTransferCompleteItem(int index);

private:
    QJsonArray m_jsonArr;
    QJsonArray m_jsonArrFolder;
    QJsonArray m_jsonArrFiles;
    QString m_currentDir;
    QString m_lastDir;
    QString formatSize(qint64 size);
    QString m_downSavePath;
    QTimer m_oDownTimer;
    QTimer m_oUploadTimer;

    qint64 m_currDownSize;
    qint64 m_lastDownSize;
    qint64 m_totalDownSize;

    qint64 m_currUploadSize;
    qint64 m_lastUploadSize;
    qint64 m_totalUploadSize;

    int m_downloadTaskNum;
    int m_uploadTaskNum;
    int m_transferCompleteNum;

    //上传操作
    bool m_bDownload;
    //是否正在上传下载
    bool m_isDownloading;
    bool m_isUploading;

    QQueue<QJsonValue> m_queDelFiles;
    QQueue<QJsonValue> m_queTransferFileList;
    QQueue<QJsonValue> m_queUploadFileItem;

    QQueue<QString> m_queUploadFilePath;

    QFile m_oDownFile;
    QFile m_oUploadFile;
    void clearFileList();
    void startDownload();
    void startUpload();

private:
    QHash<QString, FilesType> m_hashFileTypeIcon;

    QFtp m_ftpClient;
    QFtp m_downloadClient;
    QFtp m_uploadClient;

    int m_totalDownProgress;
    int m_currDownProgress;
    QString m_textDownProgress;
    QString m_downloadSpeed;

    int m_totalUploadProgress;
    int m_currUploadProgress;
    QString m_textUploadProgress;
    QString m_uploadSpeed;

    QString m_currDownFileName;
    QString m_currDownFileSize;

    QString m_currUploadFileName;
    QString m_currUploadFileSize;

    QString m_strDownloadPath;
    QString m_userName;
    QString m_userPass;
    QString m_ftpHost;

    QJsonObject m_currDownItem;
    QJsonObject m_currUploadItem;
};

#endif // FTPCLIENT_H
