#ifndef HOMEPAGE_H
#define HOMEPAGE_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include "models/SigninModel.h"
#include "models/SignRewardModel.h"
#include "models/HomeBannerModel.h"
#include "models/HomeActivitiesModel.h"
#include "models/HomeHotGamesTabModel.h"
#include "models/HomeGoodsTabModel.h"
#include "models/GameShopBannerModel.h"
#include "models/GameShopTabModel.h"
#include "models/SearchResultModel.h"
#include "models/GameLabelModel.h"
#include "models/GameLabelListModel.h"
#include <qwebengineview.h>

class HomePage : public QObject
{
    Q_OBJECT
public:
    explicit HomePage(QObject *parent = nullptr);
    Q_PROPERTY(QString promoCodeImage MEMBER m_promoCodeImage NOTIFY promoCodeImageChanged FINAL)
    Q_PROPERTY(QString promoCodeText MEMBER m_promoCodeText NOTIFY promoCodeTextChanged FINAL)

    //签到数据已就绪
    Q_PROPERTY(bool signDataIsReady MEMBER m_signDataIsReady NOTIFY signDataIsReadyChanged FINAL)
    //签到奖励数据已就绪
    Q_PROPERTY(bool signRewardIsReady MEMBER m_signRewardIsReady NOTIFY signRewardIsReadyChanged FINAL)
    //当日是否已签到
    Q_PROPERTY(QString enableSign MEMBER m_enableSign NOTIFY enableSignChanged FINAL)

    Q_PROPERTY(bool bannerModelIsReady MEMBER m_bannerModelIsReady NOTIFY bannerModelIsReadyChanged FINAL)
    Q_PROPERTY(bool homeGoodsModelIsReady MEMBER m_homeGoodsModelIsReady NOTIFY homeGoodsModelIsReadyChanged FINAL)

    //商城banner和商品列表
    Q_PROPERTY(bool shopBannerIsReady MEMBER m_shopBannerIsReady NOTIFY shopBannerIsReadyChanged FINAL)
    Q_PROPERTY(bool shopGoodModelIsReady MEMBER m_shopGoodModelIsReady NOTIFY shopGoodModelIsReadyChanged FINAL)

public slots:
    void bridgeWebToClient(const QString& args);

signals:
    void promoCodeImageChanged();
    void promoCodeTextChanged();
    // 弹出消息框
    void showMsgPopup(const QVariant& msgType, const QVariant& msgData);
    void updateList(const QJsonArray& arrList);
    void updateRewardList(const QJsonArray& arrList, int totalDays, int totalTime);

    void updateHomeBannerList(const QJsonArray& arrList);
    void updateHomeActivitiesList(const QJsonArray& arrList);
    void updateHotGameTab(const QJsonArray& arrList);
    void updateGoodsTabTitle(const QJsonArray& arrList);
    void updateGameShopBannerList(const QJsonArray& arrList);

    void updateShopTab(const QJsonArray& arrList);

    void updateSearchList(const QJsonArray& arrList);

    void showRechargeView();
    void showContactView();

    void lableListChanged();
    void updateGameLableData(const QJsonArray& arrList);
    void signDataIsReadyChanged();
    void signRewardIsReadyChanged();
    void enableSignChanged();
    void bannerModelIsReadyChanged();
    void homeGoodsModelIsReadyChanged();
    void updateGameLabelList(const QString& labelId, const QJsonArray& arrList);
    void shopBannerIsReadyChanged();
    void shopGoodModelIsReadyChanged();
public:
    //获取首页轮播图数据
    Q_INVOKABLE void getBannerData(HomeBannerModel* homeBanner, HomeActivitiesModel* activitiesModel,
                                   HomeHotGamesTabModel* tabModel, HomeGoodsTabModel* goodsTabModel);

    //获取商城页面轮播图
    Q_INVOKABLE void getGameShopBanner(GameShopBannerModel* shopBannerModel, GameShopTabModel* shopTabModel);

    //获取商城页面标签页
    Q_INVOKABLE void getShopGameItems();

    //获取热门推荐和特惠游戏列表
    Q_INVOKABLE void getHotGamesList();


    //获取签到列表
    Q_INVOKABLE void getSigninList(SigninModel* signModel);

    //提交签到
    Q_INVOKABLE void postSignin();

    //获取签到奖励数据
    Q_INVOKABLE void getSignReward(SignRewardModel* signReward);

    //获取推广二维码
    Q_INVOKABLE void getPromoCode();

    //复制推广码
    Q_INVOKABLE void copyPromocode();

    Q_INVOKABLE void homeSearch(const QString& keyWords, SearchResultModel* searchModel);

    Q_INVOKABLE void showInternalLink(const QString& link);

    Q_INVOKABLE void getAllGameLabel(GameLabelModel* labelModel);
    Q_INVOKABLE void getGameListByLabel(GameLabelListModel* gameLabelListModel, const QString& labelId);
    Q_INVOKABLE void gameSearch(const QString& keyWords);
private:
    QString m_promoCodeImage;
    QString m_promoCodeText;
    SigninModel* m_psignModel;
    SignRewardModel* m_psignReward;

    QWebEngineView* m_pWebView;
    QList<QString>  m_lableList;
    bool m_signDataIsReady;
    bool m_signRewardIsReady;
    QString m_enableSign;
    bool m_bannerModelIsReady;
    bool m_homeGoodsModelIsReady;
    bool m_shopBannerIsReady;
    bool m_shopGoodModelIsReady;
};

#endif // HOMEPAGE_H
