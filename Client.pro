QT += quick core network quickcontrols2 websockets svg widgets multimedia webenginewidgets

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

DEFINES += _CRT_SECURE_NO_WARNINGS
DEFINES += _CRT_NONSTDC_NO_WARNINGS

QMAKE_PROJECT_DEPTH = 0

SOURCES += \
        CommonFunc.cpp \
        GameDetails.cpp \
        HomePage.cpp \
        HttpClient.cpp \
        MsgCenter.cpp \
        NetworkAccessManagerFactory.cpp \
        log/easylogging++.cc \
        main.cpp \
        models/ActivitiesNoticeModel.cpp \
        models/DynamicNoticeModel.cpp \
        models/GameDetailsImageModel.cpp \
        models/GameLabelListModel.cpp \
        models/GameLabelModel.cpp \
        models/GameShopBannerModel.cpp \
        models/GameShopItemModel.cpp \
        models/GameShopTabModel.cpp \
        models/GameSkuModel.cpp \
        models/GamesOrderTableModel.cpp \
        models/HomeActivitiesModel.cpp \
        models/HomeBannerModel.cpp \
        models/HomeGoodsModel.cpp \
        models/HomeGoodsTabModel.cpp \
        models/HomeHotGamesModel.cpp \
        models/HomeHotGamesTabModel.cpp \
        models/OrderListTableModel.cpp \
        models/SearchResultModel.cpp \
        models/SignRewardModel.cpp \
        models/SigninModel.cpp \
        models/SystemNoticeModel.cpp \
        models/durationtablemodel.cpp \
        models/periodlistmodel.cpp \
        models/redeemtablemodel.cpp \
        models/timecardlistmodel.cpp \
        qaesencryption.cpp \
        qrencode/bitstream.c \
        qrencode/mask.c \
        qrencode/mmask.c \
        qrencode/mqrspec.c \
        qrencode/qrenc.c \
        qrencode/qrencode.c \
        qrencode/qrinput.c \
        qrencode/qrspec.c \
        qrencode/rsecc.c \
        qrencode/split.c

RESOURCES += qml.qrc \
    images.qrc


HEADERS += \
    CommonDefine.h \
    CommonFunc.h \
    GameDetails.h \
    HomePage.h \
    HttpClient.h \
    MsgCenter.h \
    NetworkAccessManagerFactory.h \
    aesni/aesni-enc-cbc.h \
    aesni/aesni-enc-ecb.h \
    aesni/aesni-key-exp.h \
    aesni/aesni-key-init.h \
    log/easylogging++.h \
    models/ActivitiesNoticeModel.h \
    models/DynamicNoticeModel.h \
    models/GameDetailsImageModel.h \
    models/GameLabelListModel.h \
    models/GameLabelModel.h \
    models/GameShopBannerModel.h \
    models/GameShopItemModel.h \
    models/GameShopTabModel.h \
    models/GameSkuModel.h \
    models/GamesOrderTableModel.h \
    models/HomeActivitiesModel.h \
    models/HomeBannerModel.h \
    models/HomeGoodsModel.h \
    models/HomeGoodsTabModel.h \
    models/HomeHotGamesModel.h \
    models/HomeHotGamesTabModel.h \
    models/OrderListTableModel.h \
    models/SearchResultModel.h \
    models/SignRewardModel.h \
    models/SigninModel.h \
    models/SystemNoticeModel.h \
    models/durationtablemodel.h \
    models/periodlistmodel.h \
    models/redeemtablemodel.h \
    models/timecardlistmodel.h \
    qaesencryption.h \
    qrencode/bitstream.h \
    qrencode/config.h \
    qrencode/mask.h \
    qrencode/mmask.h \
    qrencode/mqrspec.h \
    qrencode/qrencode.h \
    qrencode/qrencode_inner.h \
    qrencode/qrinput.h \
    qrencode/qrspec.h \
    qrencode/rsecc.h \
    qrencode/split.h

TARGET = kukaGame

win32:CONFIG(release, debug|release):{
    DESTDIR =$$PWD/Bin64/kukaGame
    UI_DIR = $$PWD/tmp/release/ui
    MOC_DIR = $$PWD/tmp/release/moc
    OBJECTS_DIR = $$PWD/tmp/release/obj
    RCC_DIR = $$PWD/tmp/release/rcc
}
else:win32:CONFIG(debug, debug|release):{
    DESTDIR =$$PWD/Bin64/debug
    UI_DIR = $$PWD/tmp/debug/ui
    MOC_DIR = $$PWD/tmp/debug/moc
    OBJECTS_DIR = $$PWD/tmp/debug/obj
    RCC_DIR = $$PWD/tmp/debug/rcc
}

INCLUDEPATH += $$PWD/third/libcurl
INCLUDEPATH += $$PWD/third/zlib/include
LIBS += -L$$PWD/third/libcurl/libs/x64 -llibcurl_imp
LIBS += -L$$PWD/third/openssl/lib/x64 -llibcrypto -llibssl
LIBS += -L$$PWD/third/zlib/lib/x64 -lzlib
LIBS += Shlwapi.lib


RC_FILE += main.rc
DEFINES += HAVE_CONFIG_H
#QMAKE_CFLAGS_RELEASE = -O2 -MD -Zi
CONFIG(release, debug|release){
QMAKE_LFLAGS += /MANIFESTUAC:\"level=\'requireAdministrator\' uiAccess=\'false\'\"
}
