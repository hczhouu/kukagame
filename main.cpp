#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QFont>
#include <QQmlContext>
#include <QTextCodec>
#include <QNetworkProxyFactory>
#include <QNetworkProxy>
#include <QThreadPool>
#include <QSharedMemory>
#include <QSettings>
#include "HttpClient.h"
#include "HomePage.h"
#include "GameDetails.h"
#include "MsgCenter.h"
#include "CommonDefine.h"
#include <QDir>
#include <QIcon>
#include <QUuid>
#include <QStandardPaths>
#include <QSslSocket>
#include <string>
#include "FtpClient.h"
#include <DbgHelp.h>
#include <Shlwapi.h>
#include <QProcess>
#include "CommonFunc.h"
#include "sa_sdk/sensors_analytics_sdk.h"
#include "NetworkAccessManagerFactory.h"

#define ELPP_QT_LOGGING 1
#include "log/easylogging++.h"
INITIALIZE_EASYLOGGINGPP



int GenerateMiniDump(PEXCEPTION_POINTERS pExceptionPointers)
{
    // 定义函数指针
    typedef BOOL(WINAPI* MiniDumpWriteDumpT)(
        HANDLE,
        DWORD,
        HANDLE,
        MINIDUMP_TYPE,
        PMINIDUMP_EXCEPTION_INFORMATION,
        PMINIDUMP_USER_STREAM_INFORMATION,
        PMINIDUMP_CALLBACK_INFORMATION
        );

    MiniDumpWriteDumpT pfnMiniDumpWriteDump = NULL;
    HMODULE hDbgHelp = LoadLibrary(L"DbgHelp.dll");
    if (NULL == hDbgHelp)
    {
        return EXCEPTION_CONTINUE_EXECUTION;
    }
    pfnMiniDumpWriteDump = (MiniDumpWriteDumpT)GetProcAddress(hDbgHelp, "MiniDumpWriteDump");

    if (NULL == pfnMiniDumpWriteDump)
    {
        FreeLibrary(hDbgHelp);
        return EXCEPTION_CONTINUE_EXECUTION;
    }
    // 创建 dmp 文件件
    TCHAR szFileName[MAX_PATH] = { 0 };
    SYSTEMTIME stLocalTime;
    GetLocalTime(&stLocalTime);
    TCHAR szBuf[MAX_PATH] = { 0 };
    GetModuleFileNameW(NULL, szBuf, sizeof(szBuf));
    PathRemoveFileSpecW(szBuf);
    wsprintf(szFileName, L"%s\\%04d%02d%02d-%02d%02d%02d.dmp", szBuf, stLocalTime.wYear,
             stLocalTime.wMonth, stLocalTime.wDay,
             stLocalTime.wHour, stLocalTime.wMinute, stLocalTime.wSecond);
    HANDLE hDumpFile = CreateFile(szFileName, GENERIC_READ | GENERIC_WRITE,
                                  FILE_SHARE_WRITE | FILE_SHARE_READ, 0, CREATE_ALWAYS, 0, 0);
    if (INVALID_HANDLE_VALUE == hDumpFile)
    {
        FreeLibrary(hDbgHelp);
        return EXCEPTION_CONTINUE_EXECUTION;
    }
    // 写入 dmp 文件
    MINIDUMP_EXCEPTION_INFORMATION expParam;
    expParam.ThreadId = GetCurrentThreadId();
    expParam.ExceptionPointers = pExceptionPointers;
    expParam.ClientPointers = FALSE;
    pfnMiniDumpWriteDump(GetCurrentProcess(), GetCurrentProcessId(),
                         hDumpFile, MiniDumpWithDataSegs, (pExceptionPointers ? &expParam : NULL), NULL, NULL);
    // 释放文件
    CloseHandle(hDumpFile);
    FreeLibrary(hDbgHelp);
    return EXCEPTION_EXECUTE_HANDLER;
}

LONG WINAPI ExceptionFilter(LPEXCEPTION_POINTERS lpExceptionInfo)
{
    // 这里做一些异常的过滤或提示
    if (IsDebuggerPresent())
    {
        return EXCEPTION_CONTINUE_SEARCH;
    }
    return GenerateMiniDump(lpExceptionInfo);
}


int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("kukaGame");
    QCoreApplication::setApplicationName("kukaStream");
    //初始化日志模块
    QString logDirPath = QFileInfo(QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).
                                    first()).absolutePath();
    QString strLogsPath = logDirPath;
    strLogsPath.append("\\log\\kukaGame.log");
    el::Configurations conf;
    conf.setToDefault();
    conf.setGlobally(el::ConfigurationType::Format, "[%datetime{%Y-%M-%d %H:%m:%s} | %level] %msg");
    conf.setGlobally(el::ConfigurationType::Filename, strLogsPath.toStdString());
    conf.setGlobally(el::ConfigurationType::Enabled, "true");
    conf.setGlobally(el::ConfigurationType::ToFile, "true");
    el::Loggers::reconfigureAllLoggers(conf);
    el::Loggers::reconfigureAllLoggers(el::ConfigurationType::ToStandardOutput, "false");

    //不使用代理
    QNetworkProxyFactory::setUseSystemConfiguration(false);
    QNetworkProxy noProxy(QNetworkProxy::NoProxy);
    QNetworkProxy::setApplicationProxy(noProxy);

    QApplication app(argc, argv);
    //只允许启动一个进程
    static QSharedMemory *shareMem = new QSharedMemory("kukaGame");
    if (!shareMem->create(1))
    {
        app.quit();
        return -1;
    }

    QSettings setting("HKEY_CURRENT_USER\\SOFTWARE\\kukaGame", QSettings::NativeFormat);
    if (setting.value("closeExit").isNull())
    {
        setting.setValue("closeExit", false);
    }

    if (setting.value("noNotify").isNull())
    {
        setting.setValue("noNotify", false);
    }

    if (setting.value("apiUrl").isNull())
    {
        setting.setValue("apiUrl", "https://ovirtapi.singlecloud.cc/");
    }

    if (setting.value("bandHost").isNull())
    {
        setting.setValue("bandHost", "111.46.204.34");
    }

    if (setting.value("startGameNoTips").isNull())
    {
        setting.setValue("startGameNoTips", false);
    }

    QString instanceId = QUuid::createUuid().toString(QUuid::Id128).toUpper();
    if(setting.value("instanceId").isNull() ||
        setting.value("instanceId").toString().isEmpty())
    {
        setting.setValue("instanceId", instanceId);
    } else {
        instanceId = setting.value("instanceId").toString().toUpper();
    }

    //初始化数据埋点SDK
    QString binPath = QDir::toNativeSeparators(QGuiApplication::applicationDirPath());
    const std::string staging_file_path = binPath.toStdString() + "\\staging_file";
    const std::string server_url = "https://higateway.haishuu.com/ha?project=kukayun&token=ykJ4d1fR";
    sensors_analytics::Sdk::Init(staging_file_path, server_url, instanceId.toStdString(),
                                 false, 200);

    sensors_analytics::PropertiesNode event_properties;
    event_properties.SetString("H_lib", "API");
    event_properties.SetString("client", "Windows");
    sensors_analytics::Sdk::Track("H_AppStart", event_properties);
    std::thread([](){
         bool flush_result = sensors_analytics::Sdk::Flush();
         LOG(INFO) << "app start " << flush_result;
    }).detach();

    //设置捕获dump文件
    SetUnhandledExceptionFilter(ExceptionFilter);

    //设置全局字体
    QFont font;
    font.setFamily(QString::fromLocal8Bit("微软雅黑"));
    app.setFont(font);
    app.setWindowIcon(QIcon(":res/newVersion/main.ico"));


    QQmlApplicationEngine engine;
    std::shared_ptr<HttpClient> pClient = HttpClient::getInstance();
    engine.rootContext()->setContextProperty("HttpClient", pClient.get());
    engine.setNetworkAccessManagerFactory(new NetworkAccessManagerFactory());

//    qmlRegisterSingletonType<FtpClient>("FtpClient", 1, 0,
//                                            "FtpClient",
//                                            [](QQmlEngine*, QJSEngine*) -> QObject* {
//                                                return new FtpClient();
//                                            });

    qmlRegisterSingletonType<HomePage>("HomePage", 1, 0,
                                        "HomePage",
                                        [](QQmlEngine*, QJSEngine*) -> QObject* {
                                            return new HomePage();
                                        });

    qmlRegisterSingletonType<GameDetails>("GameDetails", 1, 0,
                                       "GameDetails",
                                       [](QQmlEngine*, QJSEngine*) -> QObject* {
                                           return new GameDetails();
                                       });

    qmlRegisterSingletonType<MsgCenter>("MsgCenter", 1, 0,
                                          "MsgCenter",
                                          [](QQmlEngine*, QJSEngine*) -> QObject* {
                                              return new MsgCenter();
                                          });


    qmlRegisterSingletonType<GoodsListModel>("GoodsListModel", 1, 0,
                                             "GoodsListModel",
                                             [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                 return new GoodsListModel();
                                             });

    qmlRegisterSingletonType<PeriodListModel>("PeriodListModel", 1, 0,
                                             "PeriodListModel",
                                             [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                 return new PeriodListModel();
                                             });

    qmlRegisterSingletonType<TimeCardListModel>("TimeCardListModel", 1, 0,
                                              "TimeCardListModel",
                                              [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                  return new TimeCardListModel();
                                              });

    qmlRegisterSingletonType<SigninModel>("SigninModel", 1, 0,
                                                "SigninModel",
                                                [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                    return new SigninModel();
                                                });

    qmlRegisterSingletonType<SignRewardModel>("SignRewardModel", 1, 0,
                                          "SignRewardModel",
                                          [](QQmlEngine*, QJSEngine*) -> QObject* {
                                              return new SignRewardModel();
                                          });


    qmlRegisterSingletonType<HomeBannerModel>("HomeBannerModel", 1, 0,
                                              "HomeBannerModel",
                                              [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                  return new HomeBannerModel();
                                              });

    qmlRegisterSingletonType<HomeActivitiesModel>("HomeActivitiesModel", 1, 0,
                                              "HomeActivitiesModel",
                                              [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                  return new HomeActivitiesModel();
                                              });

    qmlRegisterSingletonType<HomeHotGamesTabModel>("HomeHotGamesTabModel", 1, 0,
                                                  "HomeHotGamesTabModel",
                                                  [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                      return new HomeHotGamesTabModel();
                                                  });

    qmlRegisterSingletonType<HomeHotGamesModel>("HomeHotGamesModel", 1, 0,
                                                   "HomeHotGamesModel",
                                                   [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                       return new HomeHotGamesModel();
                                                   });

    qmlRegisterSingletonType<HomeGoodsTabModel>("HomeGoodsTabModel", 1, 0,
                                                   "HomeGoodsTabModel",
                                                   [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                       return new HomeGoodsTabModel();
                                                   });

    qmlRegisterSingletonType<HomeGoodsModel>("HomeGoodsModel", 1, 0,
                                                "HomeGoodsModel",
                                                [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                    return new HomeGoodsModel();
                                                });

    qmlRegisterSingletonType<GameShopBannerModel>("GameShopBannerModel", 1, 0,
                                                "GameShopBannerModel",
                                                [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                    return new GameShopBannerModel();
                                                });

    qmlRegisterSingletonType<GameShopTabModel>("GameShopTabModel", 1, 0,
                                                "GameShopTabModel",
                                                [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                    return new GameShopTabModel();
                                                });

    qmlRegisterSingletonType<GameShopItemModel>("GameShopItemModel", 1, 0,
                                               "GameShopItemModel",
                                               [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                   return new GameShopItemModel();
                                               });

    qmlRegisterSingletonType<GameSkuModel>("GameSkuModel", 1, 0,
                                               "GameSkuModel",
                                               [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                   return new GameSkuModel();
                                               });

    qmlRegisterSingletonType<ActivitiesNoticeModel>("ActivitiesNoticeModel", 1, 0,
                                           "ActivitiesNoticeModel",
                                           [](QQmlEngine*, QJSEngine*) -> QObject* {
                                               return new ActivitiesNoticeModel();
                                           });

    qmlRegisterSingletonType<DynamicNoticeModel>("DynamicNoticeModel", 1, 0,
                                           "DynamicNoticeModel",
                                           [](QQmlEngine*, QJSEngine*) -> QObject* {
                                               return new DynamicNoticeModel();
                                           });

    qmlRegisterSingletonType<SystemNoticeModel>("SystemNoticeModel", 1, 0,
                                           "SystemNoticeModel",
                                           [](QQmlEngine*, QJSEngine*) -> QObject* {
                                               return new SystemNoticeModel();
                                           });

    qmlRegisterSingletonType<SearchResultModel>("SearchResultModel", 1, 0,
                                                "SearchResultModel",
                                                [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                    return new SearchResultModel();
                                                });

    qmlRegisterSingletonType<CDKeyListModel>("CDKeyListModel", 1, 0,
                                                "CDKeyListModel",
                                                [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                    return new CDKeyListModel();
                                                });

    qmlRegisterSingletonType<GameDetailsImageModel>("GameDetailsImageModel", 1, 0,
                                             "GameDetailsImageModel",
                                             [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                 return new GameDetailsImageModel();
                                             });

    qmlRegisterSingletonType<GameLabelModel>("GameLabelModel", 1, 0,
                                                    "GameLabelModel",
                                                    [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                        return new GameLabelModel();
                                                    });


    qmlRegisterSingletonType<GameLabelListModel>("GameLabelListModel", 1, 0,
                                             "GameLabelListModel",
                                             [](QQmlEngine*, QJSEngine*) -> QObject* {
                                                 return new GameLabelListModel();
                                             });

    qmlRegisterType<OrderListTableModel>("OrderListTableModel",1,0,"OrderListTableModel");
    qmlRegisterType<RedeemTableModel>("RedeemTableModel",1,0,"RedeemTableModel");
    qmlRegisterType<DurationTableModel>("DurationTableModel",1,0,"DurationTableModel");
    qmlRegisterType<GamesOrderTableModel>("GamesOrderTableModel",1,0,"GamesOrderTableModel");

    qmlRegisterType<AllFilesListModel>("AllFilesListModel",1,0,"AllFilesListModel");
    qmlRegisterType<DownloadListModel>("DownloadListModel",1,0,"DownloadListModel");
    qmlRegisterType<UploadListModel>("UploadListModel",1,0,"UploadListModel");
    qmlRegisterType<TransferCompleteListModel>("TransferCompleteListModel",1,0,"TransferCompleteListModel");

    const QUrl url(QStringLiteral("qrc:/qmls/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    int retCode = app.exec();
    QThreadPool::globalInstance()->waitForDone(5000);
    return retCode;
}
