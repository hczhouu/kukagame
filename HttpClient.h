#ifndef HTTPCLIENT_H
#define HTTPCLIENT_H

#include <QObject>
#include <mutex>
#include <QScreen>
#include <QGuiApplication>


class HttpClient : public QObject
{
    Q_OBJECT

public:
    ~HttpClient();
    static std::shared_ptr<HttpClient> getInstance();

    Q_PROPERTY(QString headLogoUrl MEMBER m_headLogoUrl NOTIFY headLogoUrlChanged FINAL)
    Q_PROPERTY(QString captchaImage MEMBER m_captchaImage NOTIFY captchaImageChanged FINAL)
    Q_PROPERTY(QString userAccount MEMBER m_userAccount NOTIFY userAccountChanged FINAL)
    Q_PROPERTY(bool userLogined MEMBER m_bUserLogined NOTIFY userLoginedChanged FINAL)
    Q_PROPERTY(bool userRealStatus MEMBER m_userRealStatus NOTIFY userRealStatusChanged FINAL)
    Q_PROPERTY(bool userJuniorStatus MEMBER m_userJuniorStatus NOTIFY userJuniorStatusChanged FINAL)
    Q_PROPERTY(QString userCurrentPass MEMBER m_userCurrentPass NOTIFY userCurrentPassChanged FINAL)
    Q_PROPERTY(QString nickName MEMBER m_strNickName NOTIFY nickNameChanged FINAL)

    Q_PROPERTY(QString timecardFree MEMBER m_timecardFree NOTIFY timecardFreeChanged FINAL)
    Q_PROPERTY(QString timecardDuration MEMBER m_timecardDuration NOTIFY timecardDurationChanged FINAL)
    Q_PROPERTY(QString timecardPeriod MEMBER m_timecardPeriod NOTIFY timecardPeriodChanged FINAL)
    Q_PROPERTY(QString freeTimecardFree MEMBER m_freeTimecardFree NOTIFY freeTimecardFreeChanged FINAL)
    Q_PROPERTY(QString freeTimecardDuration MEMBER m_freeTimecardDuration NOTIFY freeTimecardDurationChanged FINAL)
    Q_PROPERTY(QString freeTimecardPeriod MEMBER m_freeTimecardPeriod NOTIFY freeTimecardPeriodChanged FINAL)
    Q_PROPERTY(QString remainPayTime MEMBER m_remainPayTime NOTIFY remainPayTimeChanged FINAL)
    Q_PROPERTY(QString remainFreeTime MEMBER m_remainFreeTime NOTIFY remainFreeTimeChanged FINAL)

    Q_PROPERTY(QString codeUrl MEMBER m_strCodeUrl NOTIFY codeUrlChanged FINAL)
    Q_PROPERTY(bool qrLoading MEMBER m_bQRLoading NOTIFY qrLoadingChanged FINAL)
    Q_PROPERTY(bool findNewVersion MEMBER m_findNewVersion NOTIFY findNewVersionChanged FINAL)
    Q_PROPERTY(QString verMessage MEMBER m_verMessage NOTIFY verMessageChanged FINAL)

    Q_PROPERTY(double dpi MEMBER m_screenDpi NOTIFY dpiChanged FINAL)
    Q_PROPERTY(int screenWidth MEMBER m_screenWidth NOTIFY screenWidthChanged FINAL)
    Q_PROPERTY(int screenHeight MEMBER m_screenHeight NOTIFY screenHeightChanged FINAL)


    Q_PROPERTY(bool noNotify MEMBER m_noNotify NOTIFY noNotifyChanged FINAL)
    Q_PROPERTY(bool closeExit MEMBER m_closeExit NOTIFY closeExitChanged FINAL)
    Q_PROPERTY(bool startGameNoTips MEMBER m_startGameNoTips NOTIFY startGameNoTipsChanged FINAL)

    Q_PROPERTY(QString userName MEMBER m_strUserName NOTIFY userNameChanged FINAL)
    Q_PROPERTY(QString userPass MEMBER m_strUserPass NOTIFY userPassChanged FINAL)
    Q_PROPERTY(bool rememberPass MEMBER m_rememberPass NOTIFY rememberPassChanged FINAL)
    Q_PROPERTY(bool agreePolicy MEMBER m_agreePolicy NOTIFY agreePolicyChanged FINAL)
    Q_PROPERTY(QString vipFlags MEMBER m_vipFlags NOTIFY vipFlagsChanged FINAL)
    Q_PROPERTY(double payPercent MEMBER m_payPercent NOTIFY payPercentChanged FINAL)

private:
    HttpClient();

signals:
    void loginSuccess();
    void showLoginView();
    //用户头像
    void headLogoUrlChanged();
    //验证码图片
    void captchaImageChanged();
    //账户名
    void userAccountChanged();
    //用户登录成功
    void userLoginedChanged();


    void showLoginErrorMsg(const QVariant& msg);
    void showRegErrorMsg(const QVariant& msg);
    void showModifyPassErrorMsg(const QVariant& msg);

    //刷新套餐信息
    void updateRemainTimes(QString days, QString hours, QString mins);

    // 弹出消息框
    void showMsgPopup(const QVariant& msgType, const QVariant& msgData);

    void userRealStatusChanged();
    void userJuniorStatusChanged();
    void userCurrentPassChanged();

    void timecardFreeChanged();
    void timecardDurationChanged();
    void timecardPeriodChanged();
    void freeTimecardFreeChanged();
    void freeTimecardDurationChanged();
    void freeTimecardPeriodChanged();
    void remainPayTimeChanged();
    void remainFreeTimeChanged();

    void codeUrlChanged();
    void qrLoadingChanged();

    void nickNameChanged();

    //关闭支付页面弹窗
    void closePayPopup();
    //发现新版本
    void findNewVersionChanged();
    void verMessageChanged();
    void modifySuccess();

    //强制更新弹窗
    void showForceUpdate();
    //公告消息弹窗
    void showNoticeMessage(QString noticeId);

    //缩放改变
    void dpiChanged();
    void screenWidthChanged();
    void screenHeightChanged();

    void noNotifyChanged();
    void closeExitChanged();
    void startGameNoTipsChanged();
    void userNameChanged();
    void userPassChanged();
    void rememberPassChanged();
    void agreePolicyChanged();
    void updateTimeCard(int type, const QJsonObject& jsonData);
    void showLoginErrorTips(const QString& errStr);

    void vipFlagsChanged();
    void payPercentChanged();

public slots:
    void OnTimeOut();
    //缩放切换
    void logicalDotsPerInchChanged(qreal dpi);
    //分辨率切换
    void geometryChanged(const QRect &geometry);

    void loadUserInfo();

    void OnUpdateTimeCard(int type, const QJsonObject& jsonData);

private:
    static std::shared_ptr<HttpClient> m_pClient;
    static std::mutex m_mutex;
    static QString m_strApiUrl;
    static QString m_bandHost;

    QString m_strUuid;
    QString m_strToken;
    QString m_strUserId;
    int m_isCopartner;

    int m_actionType;
    bool m_bIsRefresh;
    //记住密码
    bool m_rememberPass;
    bool m_agreePolicy;
    //是否切换账号登录
    bool m_switchAccount;
    //用户已登录
    bool m_bUserLogined;

    QString m_strUserName;
    QString m_strUserPass;

    QString m_headLogoUrl;
    QString m_captchaImage;
    QString m_userAccount;
    QString m_strNickName;
    QString m_userCurrentPass;

    //付费和体验剩余总时长
    QString m_remainPayTime;
    QString m_remainFreeTime;

    //付费时长
    QString m_timecardFree;
    QString m_timecardDuration;
    QString m_timecardPeriod;

    //体验时长
    QString m_freeTimecardFree;
    QString m_freeTimecardDuration;
    QString m_freeTimecardPeriod;

    //订单编码
    QString m_strOrderSn;
    //二维码地址
    QString m_strCodeUrl;
    //支付金额
    QVariant m_payAmount;
    bool m_bQRLoading;
    //手动检查更新
    bool m_bManual;
    bool m_noNotify;
    bool m_closeExit;
    bool m_startGameNoTips;

    //实名认证状态
    bool m_userRealStatus;
    bool m_userJuniorStatus;
    bool m_findNewVersion;
    QString m_strFilePackUrl;
    QString m_verMessage;
    QString m_vipFlags;
    QString m_vipLabel;
    double m_payPercent;


    QScreen* m_desktop;
    double m_screenDpi;

    void parseRefreshClientInfo(const std::string& resp);
    void parseUserInfoReply(const std::string& resp);
    void parseCheckUpdateVersion(const std::string& resp);
    void generateCodeImage(const QString& strUrl);
    bool compareVersion(const QStringList& newVersion,
                        const QStringList& currVersion);

    static size_t writeFileCallBack(char* buffer, size_t size,
                               size_t nitems, void* outstream);
    static int progressCallBack(void* clientp,double dltotal, double dlnow,
                                double ultotal, double ulnow);

public:
    int m_screenWidth;
    int m_screenHeight;
    QString getToken();
    QString getUserId();
    int userIsCopartner();
    //发起登录请求
    Q_INVOKABLE void userLogin(const QVariant& userName, const QVariant& userPass,
                          const QVariant& verifyCode, bool rememberPass);
    //发起注册账号请求
    Q_INVOKABLE void userRegister(const QVariant& userName, const QVariant& userPass,
                                  const QVariant& verifyCode, const QVariant& invitationCode);
    // 发起修改密码请求
    Q_INVOKABLE void modifyPassword(const QVariant& userPhone,
                                    const QVariant& userPass, const QVariant& verifyCode);
    //获取图片验证码
    Q_INVOKABLE void fetchImageVerifyCode();
    //获取注册短信验证码
    Q_INVOKABLE void fetchRegSmsVerifyCode(const QVariant& mobile);
    //获取修改密码短信验证码
    Q_INVOKABLE void fetchModifySmsVerifyCode(const QVariant& mobile);

    //获取卡套餐列表
    Q_INVOKABLE void getGoodsList(int type);

    //获取订单记录
    Q_INVOKABLE void getOrderList();
    //获取游戏商品订单列表
    Q_INVOKABLE void getGameOrderList();
    //获取兑换记录
    Q_INVOKABLE void getRedeemList();
    //获取时长记录
    Q_INVOKABLE void getDurationList();

    // 获取用户信息
    Q_INVOKABLE void getUserInfo();
    // 刷新套餐信息
    Q_INVOKABLE void refreshClientInfo(bool isRefreshClick);

    //兑换激活码
    Q_INVOKABLE void exchangeActivateCode(const QVariant& activeCode);

    //实名认证
    Q_INVOKABLE void realNameAuth(const QVariant& realName, const QVariant& idCard);

    //查看密码
    Q_INVOKABLE void viewLoginPass(const QVariant& phoneNum, const QVariant& verifyCode);

    //修改密码
    Q_INVOKABLE void modifyUserPass(const QVariant& userPass, const QVariant& currentPass);

    //提交订单
    Q_INVOKABLE void createOrder(const QVariant& goodsId, const QVariant& payAmount);

    //获取微信支付二维码
    Q_INVOKABLE void generateWechatQR(const QVariant& payAmount);

    //获取支付宝二维码
    Q_INVOKABLE void generateAlipayQR(const QVariant& payAmount,
                                      const QVariant& orderAmount);

    //查询微信支付状态
    Q_INVOKABLE void queryWechatOrderStatus();
    //关闭微信订单
    Q_INVOKABLE void closeWechatOrder();
    //查询支付宝支付状态
    Q_INVOKABLE void queryAlipayOrderStatus();
    //关闭微信订单
    Q_INVOKABLE void closeAlipayOrder();

    //检查更新
    Q_INVOKABLE void checkUpdateVersion(bool bManual);
    //下载更新文件
    Q_INVOKABLE void downloadUpdatePackage();

    //开启青少年模式
    Q_INVOKABLE void enableTeenageMode(bool turnOn, const QVariant& oldPass,
                                       const QVariant& newPass);

    //获取下载进度
    Q_INVOKABLE QVariant getDownPercent();

    Q_INVOKABLE bool verifyCanBuyVip(const QVariant& goodsName);

    Q_INVOKABLE void updateCloseSettings(bool closeExit);
    Q_INVOKABLE void updateNoNotifySettings(bool noNotify);
    Q_INVOKABLE void updateStartGameNoTipsSettings(bool noNotify);
    //退出登录
    Q_INVOKABLE void userLogout();
};

#endif // HTTPCLIENT_H
