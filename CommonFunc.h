#ifndef COMMONFUNC_H
#define COMMONFUNC_H

#include <QSettings>
#include <QString>
#include <QCoreApplication>
#include <QFileInfo>
#include <QDir>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

namespace CommonFunc {

// AES加解密秘钥
const QString CRYPTO_KEY = "!@#678TgaE10~%^*";
const QString REG_CONFIGPATH = "HKEY_CURRENT_USER\\Software\\kukaGame";

// 读配置文件键值
QString readIniConfigStringVal(const QString& strKey);

void setRegValueString(const QString& key, const QString& value);

void setRegValueBool(const QString& key, bool value);

QString readRegValueString(const QString& key);

bool readRegValueBool(const QString& key);


QString encryptoData(const QString& rawData);

QString decryptoData(const QString& rawData);


size_t WriteCallback(char* buffer, size_t size,
                     size_t nitems, void* outstream);

bool SendHttpRequest(std::string& resp, bool bPostMethod, const std::string& strUrl,
                            const std::string& postData = "", const std::string& strToken = "");


//写文件回调
size_t WriteFileCallback(char* buffer, size_t size,
                     size_t nitems, void* outstream);

//下载图片文件
bool downloadImageFile(const std::string& imgUrl, const std::string& savePath);


QString GetBaseUrl();

//AES/CBC加密
QString AES_EncryptData(const QString& key, const QByteArray& rawData);

//解析json数据
QJsonObject parseJsonToObject(const std::string& resp,
                              int& statusCode, QString& strMsg);

QJsonArray parseJsonToArray(const std::string& resp,
                            int& statusCode, QString& strMsg);

}


#endif // COMMONFUNC_H
