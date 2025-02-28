#ifndef COMMONDEFINE_H
#define COMMONDEFINE_H
#include <QString>

#include "models/orderlisttablemodel.h"
#include "models/GamesOrderTableModel.h"
#include "models/redeemtablemodel.h"
#include "models/durationtablemodel.h"
#include "models/allfileslistmodel.h"
#include "models/downloadlistmodel.h"
#include "models/uploadlistmodel.h"
#include "models/transfercompletelistmodel.h"
#include "models/goodslistmodel.h"
#include "models/periodlistmodel.h"
#include "models/timecardlistmodel.h"
#include "models/SigninModel.h"
#include "models/SignRewardModel.h"
#include "models/HomeBannerModel.h"
#include "models/HomeActivitiesModel.h"
#include "models/HomeHotGamesTabModel.h"
#include "models/HomeHotGamesModel.h"
#include "models/HomeGoodsTabModel.h"
#include "models/HomeGoodsModel.h"
#include "models/GameShopBannerModel.h"
#include "models/GameShopTabModel.h"
#include "models/GameShopItemModel.h"
#include "models/GameSkuModel.h"
#include "models/ActivitiesNoticeModel.h"
#include "models/DynamicNoticeModel.h"
#include "models/SystemNoticeModel.h"
#include "models/SearchResultModel.h"
#include "models/CDKeyListModel.h"
#include "models/GameDetailsImageModel.h"
#include "models/GameLabelModel.h"
#include "models/GameLabelListModel.h"
#include "log/easylogging++.h"

const std::string  LOGNAME = "KUKAGAMELOG";


struct CACHEIMAGE
{
    QString id;
    QString rawUrl;
    QString localUrl;

    CACHEIMAGE() {
        id = "";
        rawUrl = "";
        localUrl = "";
    }
};



#endif // COMMONDEFINE_H


