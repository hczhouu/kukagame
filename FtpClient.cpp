#include "FtpClient.h"
#include <QFileInfo>
#include <QDir>
#include <QStandardPaths>
#include <QDesktopServices>
#include "CommonFunc.h"
#include "CommonDefine.h"


#define ValueMax_B    pow(1024,1)
#define ValueMax_KB   pow(1024,2)
#define ValueMax_MB   pow(1024,3)
#define ValueMax_G    pow(1024,4)

FtpClient* FtpClient::ftpClient = nullptr;
const QString FTP_HOST = "111.46.204.40";

FtpClient::FtpClient(QObject *parent)
    : QObject{parent}
{
    ftpClient = this;
    m_currentDir = u8"";
    m_lastDir = u8"";
    m_downSavePath = "";
    m_oDownTimer.setInterval(1000);
    m_oUploadTimer.setInterval(1000);

    m_downloadTaskNum = 0;
    m_uploadTaskNum = 0;
    m_transferCompleteNum = 0;

    m_strDownloadPath = CommonFunc::readRegValueString("downLoadPath");
    if (m_strDownloadPath.isEmpty())
    {
        QString downloadPath = QFileInfo(QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).
                                         first()).absolutePath();
        downloadPath = QDir::toNativeSeparators(downloadPath);
        downloadPath.append("\\kukaDownload");
        m_strDownloadPath = downloadPath;
    }

    CommonFunc::setRegValueString("downLoadPath", m_strDownloadPath);


    m_ftpHost = CommonFunc::readRegValueString("cloudDisk");
    if (m_ftpHost.isEmpty())
    {
        CommonFunc::setRegValueString("cloudDisk", FTP_HOST);
        m_ftpHost = FTP_HOST;
    }

    //connect(&m_ftpClient, &QFtp::stateChanged, this, &FtpClient::slotStateChanged);
    //connect(&m_ftpClient, &QFtp::readyRead, this, &FtpClient::slotReadyRead);
    //connect(&m_ftpClient, &QFtp::dataTransferProgress, this, &FtpClient::slotDataTransferProgress);
    connect(&m_ftpClient, &QFtp::listInfo, this, &FtpClient::slotAddToList);
    connect(&m_ftpClient, &QFtp::commandFinished, this, &FtpClient::slotCommandFinished);
    //connect(&m_ftpClient, &QFtp::done, this, &FtpClient::slotDone);


    connect(&m_downloadClient, &QFtp::dataTransferProgress, this, &FtpClient::slotdownDataTransferProgress);
    connect(&m_downloadClient, &QFtp::commandFinished, this, &FtpClient::slotdownCommandFinished);
    connect(&m_oDownTimer, &QTimer::timeout, this, &FtpClient::slotDownOnTimer);

    connect(&m_uploadClient, &QFtp::dataTransferProgress, this, &FtpClient::slotuploadDataTransferProgress);
    connect(&m_uploadClient, &QFtp::commandFinished, this, &FtpClient::slotuploadCommandFinished);
    connect(&m_oUploadTimer, &QTimer::timeout, this, &FtpClient::slotuploadOnTimer);

    m_totalDownProgress = 0;
    m_currDownProgress = 0;
    m_lastDownSize = 0;
    m_textDownProgress = u8"已完成 0%";
    m_downloadSpeed = "0.0 B/s";

    m_totalUploadProgress = 0;
    m_currUploadProgress = 0;
    m_lastUploadSize = 0;
    m_textUploadProgress = u8"已完成 0%";
    m_uploadSpeed = "0.0 B/s";

    m_isDownloading = false;
    m_isUploading = false;

    m_hashFileTypeIcon.insert("EXE", FilesType{"../res/newVersion/icon_exe_big",u8"应用程序"});
    m_hashFileTypeIcon.insert("ZIP", FilesType{"../res/newVersion/icon_zip_big.png",u8"ZIP 压缩文件"});
    m_hashFileTypeIcon.insert("RAR", FilesType{"../res/newVersion/icon_zip_big.png",u8"RAR 压缩文件"});
    m_hashFileTypeIcon.insert("TXT", FilesType{"../res/newVersion/icon_txt_big.png",u8"文本文件"});
    m_hashFileTypeIcon.insert("XLS", FilesType{"../res/newVersion/icon_xls_big.png",u8"Excel文档"});
    m_hashFileTypeIcon.insert("XLSX",FilesType{"../res/newVersion/icon_xls_big.png",u8"Excel文档"});
    m_hashFileTypeIcon.insert("MP3", FilesType{"../res/newVersion/icon_video_big.png",u8"音频文件"});
    m_hashFileTypeIcon.insert("MP4", FilesType{"../res/newVersion/icon_video_big.png",u8"视频文件"});
    m_hashFileTypeIcon.insert("AVI", FilesType{"../res/newVersion/icon_video_big.png",u8"视频文件"});
    m_hashFileTypeIcon.insert("MKV", FilesType{"../res/newVersion/icon_video_big.png",u8"视频文件"});
    m_hashFileTypeIcon.insert("RMVB",FilesType{"../res/newVersion/icon_video_big.png",u8"视频文件"});
    m_hashFileTypeIcon.insert("PPT", FilesType{"../res/newVersion/icon_ppt_big.png",u8"PPT文档"});
    m_hashFileTypeIcon.insert("DOC", FilesType{"../res/newVersion/icon_word_big.png",u8"DOC文档"});
    m_hashFileTypeIcon.insert("PDF", FilesType{"../res/newVersion/icon_pdf_big.png",u8"PDF文件"});
    m_hashFileTypeIcon.insert("PNG", FilesType{"../res/newVersion/icon_image_big.png",u8"图片文件"});
    m_hashFileTypeIcon.insert("JPG", FilesType{"../res/newVersion/icon_image_big.png",u8"图片文件"});
    m_hashFileTypeIcon.insert("JPEG", FilesType{"../res/newVersion/icon_image_big.png",u8"图片文件"});
    m_hashFileTypeIcon.insert("ISO", FilesType{"../res/newVersion/icon_iso_big.png",u8"镜像文件"});
    m_hashFileTypeIcon.insert("DLL", FilesType{"../res/newVersion/icon_dll_big.png",u8"应用程序扩展"});
}

FtpClient::~FtpClient()
{

}


void FtpClient::setConnectionParams(QString user, QString pass)
{
    m_userName = user;
    m_userPass = pass;
}


void FtpClient::loginSrv()
{
    if (m_ftpClient.state() != QFtp::LoggedIn)
    {
        m_ftpClient.connectToHost(m_ftpHost);
        m_ftpClient.login(m_userName, m_userPass);
    }
}

void FtpClient::close()
{
    m_ftpClient.close();
    m_uploadClient.close();
    m_downloadClient.close();
}

void FtpClient::queryDirList()
{
    clearFileList();
    if (m_ftpClient.state() != QFtp::LoggedIn)
    {
        m_ftpClient.connectToHost(m_ftpHost);
        m_ftpClient.login(m_userName, m_userPass);
    }  else {

        m_ftpClient.list(m_currentDir);
    }
}

void FtpClient::slotAddToList(const QUrlInfo& urlInfo)
{
    if (urlInfo.isDir())
    {
        QJsonObject item;
        item.insert("fileChecked", false);
        item.insert("fileName",QString::fromLocal8Bit(urlInfo.name().toLatin1()));
        item.insert("modifyTime", urlInfo.lastModified().toLocalTime().toString("yyyy-MM-dd hh:mm:ss"));
        item.insert("fileType", u8"文件夹");
        item.insert("fileSize", "-");
        item.insert("isFolder", true);
        //item.insert("fileIcon", "res/newVersion/icon_type_folder.png");
        item.insert("fileIcon", "../res/newVersion/icon_folder_big.png");
        item.insert("fileDesc", u8"文件夹");
        m_jsonArrFolder.push_back(item);
    } else {
        QJsonObject item;
        item.insert("fileChecked", false);
        item.insert("fileName",QString::fromLocal8Bit(urlInfo.name().toLatin1()));
        item.insert("modifyTime", urlInfo.lastModified().toLocalTime().toString("yyyy-MM-dd hh:mm:ss"));
        item.insert("fileType", u8"文件");
        item.insert("fileSize", formatSize(urlInfo.size()));
        item.insert("isFolder", false);

        QString fileType = urlInfo.name().mid(urlInfo.name().lastIndexOf(".") + 1).toUpper();
        auto itor = m_hashFileTypeIcon.find(fileType);
        if (itor != m_hashFileTypeIcon.end())
        {
            item.insert("fileIcon", itor.value().typeIcon);
            item.insert("fileDesc", itor.value().typeDesc);
        } else {
            item.insert("fileIcon", "../res/newVersion/icon_unknow_big.png");
            item.insert("fileDesc", u8"未知文件");
        }

        m_jsonArrFiles.push_back(item);
    }
}


void FtpClient::slotCommandFinished(int index, bool bError)
{
    Q_UNUSED(index)
    switch (m_ftpClient.currentCommand())
    {
    case  QFtp::Login:
    {
        if (!bError)
        {
            queryDirList();
        }
        break;
    }
    case  QFtp::ConnectToHost:
    {
        if (bError)
        {
            m_ftpClient.abort();
            LOG(INFO)<< m_ftpClient.errorString().data();
        }
        break;
    }
    case  QFtp::List:
    {
        if(!bError)
        {
            QJsonArray jsonArr;
            for (int i = 0; i < m_jsonArrFolder.size(); ++i)
            {
                jsonArr.push_back(m_jsonArrFolder.at(i));
            }

            for (int i = 0; i < m_jsonArrFiles.size(); ++i)
            {
                jsonArr.push_back(m_jsonArrFiles.at(i));
            }

            AllFilesListModel::pAllFileListModel->updateFileInfoList(jsonArr);
        } else {
            LOG(INFO)<< m_ftpClient.errorString().data();
        }

        break;
    }
    default:
        break;
    }
}



void FtpClient::slotdownCommandFinished(int index, bool bError)
{
    Q_UNUSED(index)
    switch (m_downloadClient.currentCommand())
    {
    case  QFtp::Login:
    {
        if (!bError)
        {
            startDownload();
        }

        break;
    }
    case  QFtp::ConnectToHost:
    {
        if (bError)
        {
            LOG(INFO)<< m_downloadClient.errorString().data();
            m_downloadClient.abort();
        }
        break;
    }
    case  QFtp::Get:
    {
        if (m_oDownFile.isOpen())
        {
            m_oDownFile.close();
        }
        break;
    }
    default:
        break;
    }
}

void FtpClient::slotdownDataTransferProgress(qint64 currsize, qint64 totalsize)
{
    m_currDownSize = currsize;
    m_totalDownSize = totalsize;
}


void FtpClient::slotDownOnTimer()
{
    if (m_currDownSize == 0 || m_totalDownSize == 0)
    {
        return;
    }


    m_downloadSpeed = formatSize(m_currDownSize - m_lastDownSize) + "/s";
    emit downloadSpeedChanged();
    m_lastDownSize = m_currDownSize;


    QString strPercent = "";
    double percent = ((double)m_currDownSize / m_totalDownSize) * 100;
    strPercent.append("");
    strPercent.append(QString::number(qRound(percent)));
    strPercent.append("%");

    DownloadListModel::pDownloadListModel->updateProgress(0, m_currDownSize, m_totalDownSize);
    m_downloadTaskNum = DownloadListModel::pDownloadListModel->rowCount();

    //刷新下载任务数
    emit downloadTaskNumChanged();

    if (m_currDownSize != m_totalDownSize)
    {
        return;
    }

    //文件下载完毕
    m_oDownTimer.stop();
    m_currDownProgress += 1;
    emit currDownProgressChanged();

    QString strTotalPercent = "";
    double totalPercent = ((double)m_currDownProgress / m_totalDownProgress) * 100;
    strTotalPercent.append("");
    strTotalPercent.append(QString::number(qRound(totalPercent)));
    strTotalPercent.append("%");
    m_textDownProgress = u8"已完成 ";
    m_textDownProgress.append(strTotalPercent);
    emit textDownProgressChanged();

    DownloadListModel::pDownloadListModel->removeRow(0);
    m_downloadTaskNum = DownloadListModel::pDownloadListModel->rowCount();
    emit downloadTaskNumChanged();


    //添加完成列表
    if (TransferCompleteListModel::pTransferCompleteListModel != nullptr)
    {
        QJsonObject jsonItem;
        jsonItem.insert("fileName", m_currDownFileName);
        jsonItem.insert("fileSize", m_currDownFileSize);
        jsonItem.insert("filePath", m_strDownloadPath);
        QString fileType = m_currDownFileName.mid(m_currDownFileName.lastIndexOf(".") + 1).toUpper();
        auto itor = m_hashFileTypeIcon.find(fileType);
        if (itor != m_hashFileTypeIcon.end())
        {
            jsonItem.insert("fileIcon", itor.value().typeIcon);
        } else {
            jsonItem.insert("fileIcon", "res/newVersion/icon_type_unknow.png");
        }

        jsonItem.insert("status", u8"下载完成");
        TransferCompleteListModel::pTransferCompleteListModel->addRow(jsonItem);
        m_transferCompleteNum = TransferCompleteListModel::pTransferCompleteListModel->rowCount();
        emit transferCompleteNumChanged();
    }

    if (!m_queTransferFileList.empty())
    {
        startDownload();
    } else {

        //所有文件下载完成
        m_downloadSpeed = "0.0 B/s";
        emit downloadSpeedChanged();
        m_lastDownSize = 0;
        m_isDownloading = false;

        m_totalDownProgress = 0;
        m_currDownProgress = 0;
        m_textDownProgress = u8"已完成 0%";
        emit totalDownProgressChanged();
        emit currDownProgressChanged();
        emit textDownProgressChanged();

        queryDirList();
    }
}



void FtpClient::slotuploadCommandFinished(int index, bool bError)
{
    Q_UNUSED(index)
    switch (m_uploadClient.currentCommand())
    {
    case  QFtp::Login:
    {
        if (!bError)
        {
            m_totalUploadProgress = m_queUploadFileItem.size();
            emit totalUploadProgressChanged();
            startUpload();
        }

        break;
    }
    case  QFtp::ConnectToHost:
    {
        if (bError)
        {
            m_uploadClient.abort();
        }
        break;
    }
    case  QFtp::Put:
    {
        if (m_oUploadFile.isOpen())
        {
            m_oUploadFile.close();
        }
        break;
    }
    default:
        break;
    }

}

void FtpClient::slotuploadDataTransferProgress(qint64 currsize, qint64 totalsize)
{
    m_currUploadSize = currsize;
    m_totalUploadSize = totalsize;
}



void FtpClient::slotuploadOnTimer()
{
    if (m_currUploadSize == 0 || m_totalUploadSize == 0)
    {
        return;
    }


    m_uploadSpeed = formatSize(m_currUploadSize - m_lastUploadSize) + "/s";
    emit uploadSpeedChanged();
    m_lastUploadSize = m_currUploadSize;

    QString strPercent = "";
    double percent = ((double)m_currUploadSize / m_totalUploadSize) * 100;
    strPercent.append("");
    strPercent.append(QString::number(qRound(percent)));
    strPercent.append("%");

    UploadListModel::pUploadListModel->updateProgress(0, m_currUploadSize, m_totalUploadSize);
    m_uploadTaskNum = UploadListModel::pUploadListModel->rowCount();

    emit uploadTaskNumChanged();

    if (m_currUploadSize != m_totalUploadSize)
    {
        return;
    }

    //文件上传完毕
    m_oUploadTimer.stop();
    m_queUploadFilePath.dequeue();
    m_currUploadProgress += 1;
    emit currUploadProgressChanged();

    QString strTotalPercent = "";
    double totalPercent = ((double)m_currUploadProgress / m_totalUploadProgress) * 100;
    strTotalPercent.append("");
    strTotalPercent.append(QString::number(qRound(totalPercent)));
    strTotalPercent.append("%");
    m_textUploadProgress = u8"已完成 ";
    m_textUploadProgress.append(strTotalPercent);
    emit textUploadProgressChanged();

    UploadListModel::pUploadListModel->removeRow(0);
    m_uploadTaskNum = UploadListModel::pUploadListModel->rowCount();
    emit uploadTaskNumChanged();


    //添加到完成列表
    if (TransferCompleteListModel::pTransferCompleteListModel != nullptr)
    {
        QJsonObject jsonItem;
        jsonItem.insert("fileName", m_currUploadFileName);
        jsonItem.insert("fileSize", m_currUploadFileSize);
        jsonItem.insert("filePath", m_currUploadItem.value("filePath").toString());
        QString fileType = m_currUploadFileName.mid(m_currUploadFileName.lastIndexOf(".") + 1).toUpper();
        auto itor = m_hashFileTypeIcon.find(fileType);
        if (itor != m_hashFileTypeIcon.end())
        {
            jsonItem.insert("fileIcon", itor.value().typeIcon);
        } else {
            jsonItem.insert("fileIcon", "res/newVersion/icon_type_unknow.png");
        }

        jsonItem.insert("status", u8"上传完成");
        TransferCompleteListModel::pTransferCompleteListModel->addRow(jsonItem);
        m_transferCompleteNum = TransferCompleteListModel::pTransferCompleteListModel->rowCount();
        emit transferCompleteNumChanged();
    }

    if (!m_queUploadFileItem.empty())
    {
        startUpload();
    } else {

        m_uploadSpeed = "0.0 B/s";
        emit uploadSpeedChanged();
        m_lastUploadSize = 0;
        m_isUploading = false;

        m_totalUploadProgress = 0;
        m_currUploadProgress = 0;
        m_textUploadProgress = u8"已完成 0%";
        emit totalUploadProgressChanged();
        emit currUploadProgressChanged();
        emit textUploadProgressChanged();

        queryDirList();
    }
}


QString FtpClient::formatSize(qint64 size)
{
    QString result = "0";
    double value = 0.00;
    if(size > 0 && size < ValueMax_B)
    {
        result = QString("%1").arg(size)+QString(" B");
    }
    else if((size >= ValueMax_B) && (size < ValueMax_KB))
    {
        value = size/ValueMax_B;
        result = QString::number(value,'f',1)+QString(" KB");
    }
    else if((size >= ValueMax_KB) && (size < ValueMax_MB))
    {
        value = size/ValueMax_KB;
        result = QString::number(value,'f',1)+QString(" MB");
    }
    else if((size >= ValueMax_MB) && (size < ValueMax_G))
    {
        value = size/ValueMax_MB;
        result = QString::number(value,'f',1)+QString(" G");
    }
    return result;
}


void FtpClient::clearFileList()
{
    while(m_jsonArrFiles.count())
    {
        m_jsonArrFiles.pop_back();
    }

    while(m_jsonArrFolder.count())
    {
        m_jsonArrFolder.pop_back();
    }
}

//后退
void FtpClient::backFolder()
{
    m_currentDir = m_currentDir.mid(0, m_currentDir.lastIndexOf("/"));
    m_currentDir = m_currentDir.mid(0, m_currentDir.lastIndexOf("/") + 1);
    queryDirList();
}


//前进
void FtpClient::forwardFolder()
{
}


//双击文件夹
void FtpClient::browseFolder(const QVariant& dirPath)
{
    QString dirName = QString::fromLatin1(dirPath.toString().toLocal8Bit());
    dirName.append("/");
    m_currentDir += dirName;
    queryDirList();
}



//刷新
void FtpClient::refreshFolder()
{
    queryDirList();
}


//新建文件夹
void FtpClient::addNewFolder(const QVariant& dirName)
{
    QString strDirName = dirName.toString().trimmed();
    if (strDirName.lastIndexOf(".") > -1 || strDirName.indexOf("/") > -1
        || strDirName.indexOf("\\") > -1 || strDirName.indexOf(":") > -1
        || strDirName.indexOf("*") > -1 || strDirName.indexOf("?") > -1
        || strDirName.indexOf("\"") > -1 || strDirName.indexOf("<") > -1
        || strDirName.indexOf(">") > -1 || strDirName.indexOf("|") > -1)
    {
        emit showMsgPopup(true, u8"文件夹名称不支持特殊字符");
        return;
    }

    QString strDirPath = m_currentDir +
                         QString::fromLatin1(dirName.toString().trimmed().toLocal8Bit());

    m_ftpClient.mkdir(strDirPath);
    queryDirList();
}


//删除文件夹
void FtpClient::deleteDirs(const QVariant& dirName)
{
    QString strDirPath = QString::fromLatin1(dirName.toString().toLocal8Bit());
    m_ftpClient.rmdir(strDirPath);
    queryDirList();
}


//删除文件
void FtpClient::deleteFiles()
{
    if (AllFilesListModel::pAllFileListModel == nullptr)
    {
        return;
    }

    AllFilesListModel::pAllFileListModel->getSeclectFileList(m_queDelFiles);
    if (m_queDelFiles.empty())
    {
        return;
    }

    QQueue<QJsonValue>::iterator itor = m_queDelFiles.begin();
    for (; itor != m_queDelFiles.end(); ++itor)
    {

        QString strTemp = itor->toObject().value("fileName").toString();
        QString fullPath = m_currentDir + QString::fromLatin1(strTemp.toLocal8Bit());
        m_ftpClient.remove(fullPath);
    }

    m_queDelFiles.clear();
    AllFilesListModel::pAllFileListModel->clearSelectList();

    queryDirList();
}

//传输文件
void FtpClient::transferFiles(bool bDownload, const QVariantList& filPath)
{
    if (AllFilesListModel::pAllFileListModel == nullptr)
    {
        return;
    }

    if (DownloadListModel::pDownloadListModel == nullptr)
    {
        return;
    }

    if(UploadListModel::pUploadListModel == nullptr)
    {
        return;
    }

    if (bDownload)
    {
        AllFilesListModel::pAllFileListModel->getSeclectFileList(m_queTransferFileList);
        if (m_queTransferFileList.empty())
        {
            return;
        }

        for (int i = 0; i < m_queTransferFileList.size(); ++i)
        {
            QJsonObject jsonNewItem;
            QJsonValue jsonItem = m_queTransferFileList.at(i);
            jsonNewItem.insert("checked", false);
            jsonNewItem.insert("fileName", jsonItem.toObject().value("fileName").toString());
            jsonNewItem.insert("fileSize", jsonItem.toObject().value("fileSize").toString());
            jsonNewItem.insert("fileIcon", jsonItem.toObject().value("fileIcon").toString());
            jsonNewItem.insert("downSize", 0);
            jsonNewItem.insert("totalSize", 0);
            jsonNewItem.insert("progress", "0%");
            jsonNewItem.insert("operation", "");

            QString strtemp = jsonItem.toObject().value("fileName").toString();
            DownloadListModel::pDownloadListModel->addRow(jsonNewItem);
        }

        AllFilesListModel::pAllFileListModel->clearSelectList();

        m_totalDownProgress += m_queTransferFileList.size();
        emit totalDownProgressChanged();

        if (m_downloadClient.state() != QFtp::LoggedIn)
        {
            m_downloadClient.connectToHost(m_ftpHost);
            m_downloadClient.login(m_userName, m_userPass);
        } else {
            if (!m_isDownloading)
            {
                startDownload();
            }
        }

        emit showMsgPopup(false, u8"添加到下载任务成功");

    } else {

        for(int i = 0; i < filPath.size(); ++i)
        {
            QString tempPath = filPath.at(i).toString().mid(8);
            QString fileName =  tempPath.mid(tempPath.lastIndexOf("/") + 1);
            QFileInfo fileInfo(tempPath);
            if (!fileInfo.exists())
            {
                continue;
            }


            QString fileSize = formatSize(fileInfo.size());
            QJsonObject jsonItem;
            jsonItem.insert("checked", false);
            jsonItem.insert("fileName", fileName);
            jsonItem.insert("fileSize", fileSize);
            jsonItem.insert("filePath", tempPath);

            QString fileType = fileName.mid(fileName.lastIndexOf(".") + 1).toUpper();
            auto itor = m_hashFileTypeIcon.find(fileType);
            if (itor != m_hashFileTypeIcon.end())
            {
                jsonItem.insert("fileIcon", itor.value().typeIcon);
            } else {
                jsonItem.insert("fileIcon", "res/newVersion/icon_type_unknow.png");
            }

            jsonItem.insert("uploadSize", 0);
            jsonItem.insert("totalSize", 0);
            UploadListModel::pUploadListModel->addRow(jsonItem);
            m_queUploadFileItem.enqueue(jsonItem);
            m_queUploadFilePath.enqueue(tempPath);
        }

        m_totalUploadProgress += m_queUploadFileItem.size();
        emit totalUploadProgressChanged();

        if (m_uploadClient.state() != QFtp::LoggedIn)
        {
            m_uploadClient.connectToHost(m_ftpHost);
            m_uploadClient.login(m_userName, m_userPass);
        } else {
            if (!m_isUploading)
            {
                startUpload();
            }
        }

        emit showMsgPopup(false, u8"添加到上传任务成功");
    }

}


//开始下载
void FtpClient::startDownload()
{
    if (m_downloadClient.state() != QFtp::LoggedIn)
    {
        m_downloadClient.connectToHost(m_ftpHost);
        m_downloadClient.login(m_userName, m_userPass);
    }

    m_currDownItem = m_queTransferFileList.dequeue().toObject();
    m_currDownFileName = m_currDownItem.value("fileName").toString();
    m_currDownFileSize = m_currDownItem.value("fileSize").toString();

    QString downloadPath = m_strDownloadPath;
    QDir dir(downloadPath);
    if (!dir.exists())
    {
        dir.mkpath(downloadPath);
    }

    downloadPath.append("\\");
    downloadPath.append(m_currDownFileName);
    m_oDownFile.setFileName(downloadPath);
    QString strFilepath = m_currentDir + QString::fromLatin1(m_currDownFileName.toLocal8Bit());
    if (m_oDownFile.open(QIODevice::WriteOnly))
    {
        m_currDownSize = 0;
        m_totalDownSize = 0;
        m_oDownTimer.start();
        m_isDownloading = true;
        m_downloadClient.get(strFilepath, &m_oDownFile);
    } else {
        LOG(INFO)<< "download open file failed";
    }
}

//开始上传
void FtpClient::startUpload()
{
    if (m_uploadClient.state() != QFtp::LoggedIn)
    {
        m_uploadClient.connectToHost(m_ftpHost);
        m_uploadClient.login(m_userName, m_userPass);
    }

    m_currUploadItem = m_queUploadFileItem.dequeue().toObject();
    m_currUploadFileName = m_currUploadItem.value("fileName").toString();
    m_currUploadFileSize = m_currUploadItem.value("fileSize").toString();
    QString realFilePath = m_currUploadItem.value("filePath").toString();
    QFileInfo fileInfo(realFilePath);
    m_oUploadFile.setFileName(realFilePath);
    if (m_oUploadFile.open(QIODevice::ReadOnly))
    {
        m_currUploadSize = 0;
        m_totalUploadSize = 0;
        m_oUploadTimer.start();
        QString strFilepath = m_currentDir + QString::fromLatin1(fileInfo.fileName().toLocal8Bit());
        m_isUploading = true;
        m_uploadClient.put(&m_oUploadFile, strFilepath);
    }
}


//打开下载目录
void FtpClient::openDir()
{
    QString strUrl = "file:///";
    strUrl.append(QDir::fromNativeSeparators(m_strDownloadPath));
    QDesktopServices::openUrl(QUrl(strUrl));
}


//打开上传目录
void FtpClient::openUploadDir(const QVariant& filePath)
{
    QString strFilePath =  filePath.toString();
    strFilePath = strFilePath.mid(0, strFilePath.lastIndexOf("/"));
    QString strUrl = "file:///";
    strUrl.append(QDir::fromNativeSeparators(strFilePath));
    QDesktopServices::openUrl(QUrl(strUrl));
}


//取消下载
void FtpClient::cancelAllDownload()
{
    m_isDownloading = false;
    m_oDownTimer.stop();
    //m_downloadClient.rawCommand("QUIT");
    //m_downloadClient.close();
    if (m_oDownFile.isOpen())
    {
        m_oDownFile.close();
    }

    m_queTransferFileList.clear();
    m_totalDownProgress = 0;
    m_currDownProgress = 0;
    m_lastDownSize = 0;
    m_textDownProgress = u8"已完成 0%";
    m_downloadSpeed = "0.0B/s";

    emit totalDownProgressChanged();
    emit currDownProgressChanged();
    emit textDownProgressChanged();
    emit downloadSpeedChanged();
}


//取消上传
void FtpClient::cancelAllUpload()
{
    m_isUploading = false;
    m_oUploadTimer.stop();
    m_uploadClient.abort();
    m_uploadClient.disconnect();
    if (m_oUploadFile.isOpen())
    {
        m_oUploadFile.close();
    }

    m_queUploadFileItem.clear();
    m_totalUploadProgress = 0;
    m_currUploadProgress = 0;
    m_lastUploadSize = 0;
    m_textUploadProgress = u8"已完成 0%";
    m_uploadSpeed = "0.0B/s";

    emit totalUploadProgressChanged();
    emit currUploadProgressChanged();
    emit textUploadProgressChanged();
    emit uploadSpeedChanged();
}


void FtpClient::updateDownloadPath(const QVariant& savePath)
{
    m_strDownloadPath = QDir::toNativeSeparators(savePath.toString().mid(8));
    CommonFunc::setRegValueString("downLoadPath", m_strDownloadPath);
    emit downloadPathChanged();
}

void FtpClient::removeTransferCompleteItem(int index)
{
    if (TransferCompleteListModel::pTransferCompleteListModel == nullptr)
    {
        return;
    }

    TransferCompleteListModel::pTransferCompleteListModel->removeRow(index);
    m_transferCompleteNum = TransferCompleteListModel::pTransferCompleteListModel->rowCount();
    emit transferCompleteNumChanged();
}
