#ifndef GAMEDETAILS_H
#define GAMEDETAILS_H

#include <QObject>
#include "models/GameSkuModel.h"

class GameDetails : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString gameName MEMBER m_strGameName NOTIFY gameNameChanged FINAL)
    Q_PROPERTY(QString gameIcon MEMBER m_strGameIcon NOTIFY gameIconChanged FINAL)
    Q_PROPERTY(QString gameDesc MEMBER m_strGameDesc NOTIFY gameDescChanged FINAL)
    Q_PROPERTY(QString gameMainImg MEMBER m_strGameMainImage NOTIFY gameMainImgChanged FINAL)
    Q_PROPERTY(QString imageQR MEMBER m_imageQR NOTIFY imageQRChanged FINAL)
    Q_PROPERTY(bool qrLoading MEMBER m_bQRLoading NOTIFY qrLoadingChanged FINAL)
    //当前元素是否包含商品信息 有商品才能购买 否则直接启动
    Q_PROPERTY(bool itemIsGoods MEMBER m_itemIsGoods NOTIFY itemIsGoodsChanged FINAL)

    Q_PROPERTY(QString orderSn MEMBER m_orderSn NOTIFY orderSnChanged FINAL)
    Q_PROPERTY(QString goodsName MEMBER m_goodsName NOTIFY goodsNameChanged FINAL)
    Q_PROPERTY(QString skuName MEMBER m_skuName NOTIFY skuNameChanged FINAL)
    Q_PROPERTY(QString createTime MEMBER m_createTime NOTIFY createTimeChanged FINAL)
    Q_PROPERTY(QString payAmount MEMBER m_payAmount NOTIFY payAmountChanged FINAL)
    Q_PROPERTY(int payNum MEMBER m_payNum NOTIFY payNumChanged FINAL)
    Q_PROPERTY(QString postStatus MEMBER m_postStatus NOTIFY postStatusChanged FINAL)
    Q_PROPERTY(int payType MEMBER m_payType NOTIFY payTypeChanged FINAL)
    Q_PROPERTY(QString payStatus MEMBER m_payStatus NOTIFY payStatusChanged FINAL)
    Q_PROPERTY(QString goodsMainImage MEMBER m_goodsMainImage NOTIFY goodsMainImageChanged FINAL)

    Q_PROPERTY(QString imageLeft MEMBER m_imageLeft NOTIFY imageLeftChanged FINAL)
    Q_PROPERTY(QString imageRight MEMBER m_imageRight NOTIFY imageRightChanged FINAL)
    Q_PROPERTY(bool enableStart MEMBER m_enableStart NOTIFY enableStartChanged FINAL)
    Q_PROPERTY(bool enablePlay MEMBER m_enablePlay NOTIFY enablePlayChanged FINAL)
    Q_PROPERTY(QString appointmentStatus MEMBER m_appointmentStatus NOTIFY appointmentStatusChanged FINAL)

public:
    explicit GameDetails(QObject *parent = nullptr);

signals:
    void gameNameChanged();
    void gameIconChanged();
    void gameDescChanged();
    void gameMainImgChanged();
    void imageQRChanged();
    void qrLoadingChanged();
    void itemIsGoodsChanged();
    void goodsMainImageChanged();

    void getGameDetailsSuccess();
    //创建订单失败
    void createOrderStatus(bool status);
    void getGameSkuSuccess(bool success);

    void initSkuInfo();
    void updateGameSkuList(const QJsonArray& arrList);

    void closePayPopup(const QString& orderSn);
    void getOrderDetailSuccess();

    void orderSnChanged();
    void goodsNameChanged();
    void skuNameChanged();
    void createTimeChanged();
    void payAmountChanged();
    void payNumChanged();
    void postStatusChanged();
    void payTypeChanged();
    void payStatusChanged();

    void updateCdKeyList(const QJsonArray& arrList);
    void updateDetailsImage(const QJsonArray& arrList);

    void imageLeftChanged();
    void imageRightChanged();
    void enableStartChanged();
    void enablePlayChanged();
    void appointmentStatusChanged();

public:
    Q_INVOKABLE void getGameDetailsInfo(const QString& gameId, const QString& goodsId);
    Q_INVOKABLE void refreshGameDetails();
    Q_INVOKABLE void getGameSkuInfo(GameSkuModel* pGameSku);
    Q_INVOKABLE void createGameOrder(int num, double payAmount,
                                     const QString& goodsSkuId, int payType);
    Q_INVOKABLE void queryPayStatus();
    Q_INVOKABLE void closeOrder();
    Q_INVOKABLE void startStream(qint64 remainTime, const QString& packageName,
                                 const QString& gameChannel, const QString& ctoken, qint64 playtime, const QString& bid);
    Q_INVOKABLE void queryUserRemainTime();
    Q_INVOKABLE void appointmentGame();
private:
    QString m_strGameName;
    QString m_strGameIcon;
    QString m_strGameDesc;
    int m_haimaGameType;
    QString m_strGameMainImage;
    QString m_selectGameId;
    QString m_selectGoodsId;
    QString m_imageQR;
    bool m_bQRLoading;
    bool m_itemIsGoods;//是否支持购买
    bool m_enablePlay; //是否可玩
    QString m_appointmentStatus;//预约状态

    //订单详细信息
    QString m_orderSn; //订单编号
    QString m_postStatus; //发货状态
    QString m_payStatus; //支付状态
    int m_payNum; //购买数量
    int m_payType; //支付方式
    QString m_goodsName; //商品名称
    QString m_skuName; //规格名称
    QString m_createTime;//支付时间
    QString m_payAmount;//支付金额
    QString m_goodsMainImage;

    QString m_packageName;
    QString m_gameChannel;
    bool m_enableStart;
    QString m_imageLeft;
    QString m_imageRight;
    std::atomic_int m_payOrderType;

    void generateCodeImage(const QString& strUrl);
};

#endif // GAMEDETAILS_H
