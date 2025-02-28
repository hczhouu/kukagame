#ifndef MSGCENTER_H
#define MSGCENTER_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include "models/ActivitiesNoticeModel.h"
#include "models/DynamicNoticeModel.h"
#include "models/SystemNoticeModel.h"



class MsgCenter : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool unReadFlag MEMBER m_unReadFlag NOTIFY unReadFlagChanged FINAL)
    Q_PROPERTY(bool msgReady MEMBER m_msgReady NOTIFY msgReadyChanged FINAL)

    Q_PROPERTY(QString msgTitle MEMBER m_msgTitle NOTIFY msgTitleChanged FINAL)
    Q_PROPERTY(QString msgContent MEMBER m_msgContent NOTIFY msgContentChanged FINAL)
    Q_PROPERTY(QString msgImage MEMBER m_msgImage NOTIFY msgImageChanged FINAL)
    Q_PROPERTY(QString msgActivitiesLink MEMBER m_activitiesLink NOTIFY msgActivitiesLinkChanged FINAL)
    Q_PROPERTY(bool pushLink MEMBER m_bPushLink NOTIFY pushLinkChanged FINAL)

    Q_PROPERTY(bool onlyText MEMBER m_onlyText NOTIFY onlyTextChanged FINAL)
    Q_PROPERTY(bool onlyImage MEMBER m_onlyImage NOTIFY onlyImageChanged FINAL)
    Q_PROPERTY(bool textWithImage MEMBER m_textWithImage NOTIFY textWithImageChanged FINAL)

    Q_PROPERTY(bool msgDataIsReady MEMBER m_msgDataIsReady NOTIFY msgDataIsReadyChanged FINAL)
    Q_PROPERTY(bool msgDataIsEmpty MEMBER m_msgDataIsEmpty NOTIFY msgDataIsEmptyChanged FINAL)

    Q_PROPERTY(int imageWidth MEMBER m_imageWidth NOTIFY imageWidthChanged FINAL)
    Q_PROPERTY(int imageHeight MEMBER m_imageHeight NOTIFY imageHeightChanged FINAL)
    Q_PROPERTY(int totalUnreadNum MEMBER m_totalUnreadNum NOTIFY totalUnreadNumChanged FINAL)

    Q_PROPERTY(int announcementTotal MEMBER m_announcementTotal NOTIFY announcementTotalChanged FINAL)
    Q_PROPERTY(int activityTotal MEMBER m_activityTotal NOTIFY activityTotalChanged FINAL)
    Q_PROPERTY(int dynamicTotal MEMBER m_dynamicTotal NOTIFY dynamicTotalChanged FINAL)
    Q_PROPERTY(int transactionTotal MEMBER m_transactionTotal NOTIFY transactionTotalChanged FINAL)


public:
    explicit MsgCenter(QObject *parent = nullptr);

signals:
    void unReadFlagChanged();
    void totalUnreadNumChanged();
    void announcementTotalChanged();
    void activityTotalChanged();
    void dynamicTotalChanged();
    void transactionTotalChanged();

    void updateActivitiesList(const QJsonArray& arrList);
    void updateDynamicList(const QJsonArray& arrList);
    void updateSystemList(const QJsonArray& arrList);


    void showTextMsg();
    void showTextWithImageMsg();
    void msgReadyChanged();

    void msgTitleChanged();
    void msgContentChanged();
    void msgImageChanged();
    void msgActivitiesLinkChanged();
    void pushLinkChanged();

    void onlyTextChanged();
    void onlyImageChanged();
    void textWithImageChanged();

    void forcePopupMsg(const QVariant& msgId, const QVariant& msgCaption);
    void msgDataIsReadyChanged();
    void msgDataIsEmptyChanged();
    void imageWidthChanged();
    void imageHeightChanged();

private:
    bool m_unReadFlag;
    bool m_msgReady;

    QString m_msgTitle;
    QString m_msgContent;
    QString m_msgImage;
    bool    m_bPushLink;
    QString m_activitiesLink;
    bool m_onlyText;
    bool m_onlyImage;
    bool m_textWithImage;
    bool m_msgDataIsReady;
    bool m_msgDataIsEmpty;
    int m_imageWidth;
    int m_imageHeight;
    int m_totalUnreadNum;
    int m_announcementTotal;
    int m_activityTotal;
    int m_dynamicTotal;
    int m_transactionTotal;
    QJsonObject parseJsonToObject(const std::string& resp,
                                  int& statusCode, QString& strMsg);
public:
    Q_INVOKABLE void getUnReadNum(ActivitiesNoticeModel* atcivitiesModel,
                                  DynamicNoticeModel* dynamicModel, SystemNoticeModel* systemModel);
    Q_INVOKABLE void getMsgDetailsById(const QString& strId);
    Q_INVOKABLE void getMsgListByType(int type);
    Q_INVOKABLE void getForceNotice();
};

#endif // MSGCENTER_H
