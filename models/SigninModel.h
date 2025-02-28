#ifndef SIGNINMODEL_H
#define SIGNINMODEL_H

#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class SigninModel : public QAbstractListModel
{
    Q_OBJECT

    enum SIGNINLIST{
        IS_SIGNIN = 1,
        SIGNIN_DAYS,
        SIGNIN_PRIZE,
        SIGNIN_REMARK
    };

    Q_PROPERTY(QString remarkData MEMBER m_remarkData NOTIFY remarkDataChanged FINAL)

signals:
    void remarkDataChanged();

public slots:
    void updateSignList(const QJsonArray& arrList);

public:
    explicit SigninModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;
private:
    QString m_remarkData;
    QJsonArray m_signinList;
};

#endif // SIGNINMODEL_H
