#include "CommonFunc.h"
#include <mutex>
#include <comdef.h>
#include <string.h>
#include <QByteArray>
#include <QTextCodec>
#include "qaesencryption.h"
#include <QCryptographicHash>
#include "curl/curl.h"


namespace CommonFunc {

std::mutex oMutex;
std::mutex downloadMutex;

// 读配置文件键值
QString readIniConfigStringVal(const QString& strKey)
{
    QString strBinPath = QCoreApplication::applicationDirPath();
    strBinPath.append("/config.ini");
    QFileInfo fileInfo(strBinPath);
    if (!fileInfo.isFile())
    {
        return "";
    }

    QSettings settings(strBinPath, QSettings::IniFormat);
    return settings.value(strKey).toString();
}


void setRegValueString(const QString& key, const QString& value)
{
    QSettings settings(REG_CONFIGPATH, QSettings::NativeFormat);
    settings.setValue(key, value);
}

void setRegValueBool(const QString& key, bool value)
{
    QSettings settings(REG_CONFIGPATH, QSettings::NativeFormat);
    settings.setValue(key, value);
}

QString readRegValueString(const QString& key)
{
    QSettings settings(REG_CONFIGPATH, QSettings::NativeFormat);
    return settings.value(key, "").toString();
}


bool readRegValueBool(const QString& key)
{
    QSettings settings(REG_CONFIGPATH, QSettings::NativeFormat);
    return settings.value(key, "").toBool();
}

QString encryptoData(const QString& rawData)
{
    QAESEncryption encryption(QAESEncryption::AES_128, QAESEncryption::ECB, QAESEncryption::PKCS7);
    QByteArray enBA = encryption.encode(rawData.toUtf8(), CRYPTO_KEY.toUtf8());
    return QString::fromLatin1(enBA.toBase64());
}

QString decryptoData(const QString& rawData)
{
    QAESEncryption encryption(QAESEncryption::AES_128, QAESEncryption::ECB, QAESEncryption::PKCS7);
    QByteArray  enBA = QByteArray::fromBase64(rawData.toUtf8());
    QByteArray deBA = encryption.decode(enBA, CRYPTO_KEY.toUtf8());
    return QString::fromLatin1(QAESEncryption::RemovePadding(deBA, QAESEncryption::PKCS7));
}


size_t WriteCallback(char* buffer, size_t size,
                     size_t nitems, void* outstream)
{
    if (nullptr == buffer || size == 0 ||
        nullptr == outstream)
        return size * nitems;

    std::string* pstrMsg = reinterpret_cast<std::string*>(outstream);
    pstrMsg->append(buffer, size * nitems);
    return size * nitems;
}

//发起HTTP请求
bool SendHttpRequest(std::string& resp, bool bPostMethod, const std::string& strUrl,
                            const std::string& postData, const std::string& strToken)
{
    std::unique_lock<std::mutex> lock(oMutex);
    std::string strBuf = "";
    CURL* pCurl = curl_easy_init();
    curl_easy_setopt(pCurl, CURLOPT_URL, strUrl.c_str());
    curl_easy_setopt(pCurl, CURLOPT_SSL_VERIFYPEER, 0L);
    curl_easy_setopt(pCurl, CURLOPT_SSL_VERIFYHOST, 0L);
    curl_easy_setopt(pCurl, CURLOPT_TRANSFER_ENCODING, 1L);
    curl_easy_setopt(pCurl, CURLOPT_WRITEFUNCTION, WriteCallback);
    curl_easy_setopt(pCurl, CURLOPT_WRITEDATA, &strBuf);
    curl_easy_setopt(pCurl, CURLOPT_CONNECTTIMEOUT, 20L);
    curl_easy_setopt(pCurl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(pCurl, CURLOPT_NOPROXY, "*");
    struct curl_slist* headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");
    if (!strToken.empty())
    {
        headers = curl_slist_append(headers, strToken.data());
    }

    curl_easy_setopt(pCurl, CURLOPT_HTTPHEADER, headers);
    if (bPostMethod && !postData.empty())
    {
        curl_easy_setopt(pCurl, CURLOPT_POST, 1L);
        curl_easy_setopt(pCurl, CURLOPT_POSTFIELDS, postData.data());
        curl_easy_setopt(pCurl, CURLOPT_POSTFIELDSIZE, postData.size());
    }

    CURLcode eCode = curl_easy_perform(pCurl);
    curl_slist_free_all(headers);
    curl_easy_cleanup(pCurl);
    if (eCode != CURLE_OK)
    {
        resp.clear();
        resp.append(curl_easy_strerror(eCode));
        return false;
    }

    resp.clear();
    resp.append(strBuf);
    return true;
}


//写文件回调
size_t WriteFileCallback(char* buffer, size_t size,
                         size_t nitems, void* outstream)
{
    if (nullptr == buffer || nullptr == outstream)
        return size * nitems;

    FILE* pFile = reinterpret_cast<FILE*>(outstream);
    return fwrite(buffer, size, nitems, pFile);
}


QString GetBaseUrl()
{
    QSettings settings("HKEY_CURRENT_USER\\SOFTWARE\\kukaGame",
                       QSettings::NativeFormat);
    return settings.value("apiUrl").toString();
}

//AES/CBC加密
QString AES_EncryptData(const QString& key, const QByteArray& rawData)
{
    //QByteArray iv;
    //iv.append(16, char(0));
    QString iv = "0000000000000000";
    QAESEncryption encryption(QAESEncryption::AES_128,
                              QAESEncryption::CBC, QAESEncryption::PKCS7);
    QByteArray enBA = encryption.encode(rawData, key.toLocal8Bit(), iv.toLocal8Bit());
    return enBA.toBase64();
}


QJsonObject parseJsonToObject(const std::string& resp,
                              int& statusCode, QString& strMsg)
{
    QByteArray strBuf = QByteArray::fromStdString(resp);
    QJsonParseError jsonError;
    QJsonDocument docJson = QJsonDocument::fromJson(strBuf, &jsonError);
    if (docJson.isNull()  || (jsonError.error != QJsonParseError::NoError)) {
        strMsg = "parse data error[6001]";
        return QJsonObject();
    }

    QJsonObject object = docJson.object();
    if(!object.contains("status")) {
        strMsg = "parse data error[6002]";
        return QJsonObject();
    }

    strMsg = object.value("message").toString();
    statusCode = object.value("status").toInt();
    return object.value("data").toObject();
}

QJsonArray parseJsonToArray(const std::string& resp,
                            int& statusCode, QString& strMsg)
{
    QByteArray strBuf = QByteArray::fromStdString(resp);
    QJsonParseError jsonError;
    QJsonDocument docJson = QJsonDocument::fromJson(strBuf, &jsonError);
    if (docJson.isNull()  || (jsonError.error != QJsonParseError::NoError)) {
        strMsg = "parse data error[6003]";
        return QJsonArray();
    }

    QJsonObject object = docJson.object();
    if(!object.contains("status")) {
        strMsg = "parse data error[6004]";
        return QJsonArray();
    }

    strMsg = object.value("message").toString();
    statusCode = object.value("status").toInt();
    return object.value("data").toArray();
}

}
