#include "NetworkAccessManagerFactory.h"
#include "QCoreApplication"

NetworkAccessManagerFactory::NetworkAccessManagerFactory() {}


QNetworkAccessManager *NetworkAccessManagerFactory::create(QObject *parent)
{
    QNetworkAccessManager *nam = new QNetworkAccessManager(parent);
    QNetworkDiskCache* diskCache = new QNetworkDiskCache(nam);
    QString cachePath = QStandardPaths::displayName(QStandardPaths::CacheLocation);
    diskCache->setCacheDirectory(QCoreApplication::applicationDirPath() + "/cache");
    diskCache->setMaximumCacheSize(500 * 1024 * 1024);
    nam->setCache(diskCache);
    return nam;
}
