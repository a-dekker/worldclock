#ifndef TIMEZONE_H
#define TIMEZONE_H

#include <QObject>
#include <QTimeZone>

class TimeZone : public QObject {
    Q_OBJECT

   public:
    explicit TimeZone(QObject *parent = 0);
    ~TimeZone();
    Q_INVOKABLE QString readAllCities();
    Q_INVOKABLE QString readCityInfo(const QByteArray &cityid,
                                     const QByteArray &time_format);
    Q_INVOKABLE QVariantMap readCityTime(const QByteArray &cityid,
                                     const QByteArray &time_format);
    Q_INVOKABLE QVariantMap readCityDetails(const QByteArray &cityid,
                                        const QByteArray &time_format);
    Q_INVOKABLE QVariantMap readLocalTime(const QByteArray &time_format);
};

#endif  // TIMEZONE_H
