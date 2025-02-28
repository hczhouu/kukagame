#ifndef SIGNREWARDMODEL_H
#define SIGNREWARDMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class SignRewardModel : public QAbstractListModel
{
    Q_OBJECT

    enum SIGNREWARD {
        SIGN_DAYS = 1,
        REWARD_TIME
    };

    Q_PROPERTY(QString totalDays MEMBER m_totalDays NOTIFY totalDaysChanged FINAL)
    Q_PROPERTY(QString totalTime MEMBER m_totalTime NOTIFY totalTimeChanged FINAL)

signals:
    void totalTimeChanged();
    void totalDaysChanged();

public slots:
    void updateRewardList(const QJsonArray& arrList, int totalDays, int totalTime);

public:
    explicit SignRewardModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;
private:
    QString m_totalDays;
    QString m_totalTime;
    QJsonArray m_signRewardList;
};

#endif // SIGNREWARDMODEL_H
