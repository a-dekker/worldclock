/*
   Copyright (C) 2013 Jolla Ltd.
Contact: Thomas Perl <thomas.perl@jollamobile.com>
All rights reserved.

You may use this file under the terms of BSD license as follows:

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the Jolla Ltd nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <QtQml>
#include <QProcess>
#include <qqml.h>
#include <QtGui>
#include <QQuickView>
#include <QTimeZone>
#include <sailfishapp.h>
#include "settings.h"
#include "osread.h"
#include "worldclock.h"


int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    QProcess appinfo;
    QString appversion;
    // read app version from rpm database on startup
    appinfo.start("/bin/rpm", QStringList() << "-qa" << "--queryformat" << "%{version}-%{RELEASE}" << "harbour-worldclock");
    appinfo.waitForFinished(-1);
    if (appinfo.bytesAvailable() > 0) {
        appversion = appinfo.readAll();
    }
    // To display the view, call "show()" (will show fullscreen on device).
    qmlRegisterType<TimeZone>("harbour.worldclock.TimeZone", 1 , 0 , "TZ");
    qmlRegisterType<Launcher>("harbour.worldclock.Launcher", 1 , 0 , "App");
    qmlRegisterType<Settings>("harbour.worldclock.Settings", 1 , 0 , "MySettings");

    QGuiApplication* app = SailfishApp::application(argc, argv);

    QQuickView* view = SailfishApp::createView();
    view->rootContext()->setContextProperty("version", appversion);
    view->setSource(SailfishApp::pathTo("qml/worldclock.qml"));
    view->show();
    return app->exec();

}

TimeZone::TimeZone(QObject *parent) :
    QObject(parent)
{

}

QString TimeZone::TimeZone::readAllCities()
{
    QSettings settings;
    int sortOrder = settings.value("sortorder_completeList", "").toInt();
    QList<QByteArray> ids =  QTimeZone::availableTimeZoneIds();
    QString output;
    QString sign;
    QString timeoffset;
    QMultiMap<int, QString> map;
    QMultiMap<QString, QString> sorted_map;
    // QMultiMap is sorted by key by default
    // We use QMultiMap (not QMap) so we can have duplicates
    int dummy_counter_for_sort = 0; // to inverse reverted sorting
    foreach (QByteArray id, ids) {
        QTimeZone zone = QTimeZone(id);
        QDateTime zoneTime = QDateTime(QDate::currentDate(), QTime::currentTime(), zone).toLocalTime();
        int offset = zone.offsetFromUtc(QDateTime::currentDateTime());
        QString countryName = QLocale::countryToString(zone.country());
        // insert space where appropriate. Can't be done in one regex replace?
        QRegularExpression rx("([a-z])([A-Z]).+([a-z])([A-Z])");
        QRegularExpressionMatch match = rx.match(countryName);
        if (match.hasMatch()) {
            QString lowerChar1 = match.captured(1);
            QString upperChar1 = match.captured(2);
            QString lowerChar2 = match.captured(3);
            QString upperChar2 = match.captured(4);
            countryName.replace(lowerChar1+upperChar1,lowerChar1 + " " + upperChar1);
            countryName.replace(lowerChar2+upperChar2,lowerChar2 + " " + upperChar2);
        }
        QRegularExpression rx2("([a-z])([A-Z])");
        match = rx2.match(countryName);
        if (match.hasMatch()) {
            QString lowerChar1 = match.captured(1);
            QString upperChar1 = match.captured(2);
            countryName.replace(lowerChar1+upperChar1,lowerChar1 + " " + upperChar1);
        }
        if ( countryName == "Default") {
            // UTC name
            countryName = "";
        } else {
            countryName = " [" + countryName + "]";
        }
        if (offset < 0)
            sign = "-";
        else
            sign = "+";
        if((offset % 3600)==0)
            // offset equals to whole hour
            timeoffset = QString("UTC %3").arg(sign+QString::number(abs(offset)/3600));
        else
        {
            int minutes = offset/60 %60;
            timeoffset = QString("UTC %3:%4").arg(sign+QString::number(abs(offset)/3600)).arg(abs(minutes));
        }

        if (sortOrder == 1) {
            dummy_counter_for_sort ++;
            map.insert(offset + dummy_counter_for_sort,timeoffset + " (" + id + ")" + countryName);
        } else if (sortOrder == 2) {
            const int separator = id.lastIndexOf('/');
            const QString cityName = id.mid(separator + 1);
            // QString continentName = id.left(separator);
            sorted_map.insert(cityName, timeoffset + " (" + id + ")" + countryName);
        } else if (sortOrder == 3) {
            sorted_map.insert(countryName, timeoffset + " (" + id + ")" + countryName);
        } else {
            output += timeoffset + " (" + id + ")" + countryName + "\n";
        }

    }
    if (sortOrder == 1) {
        QMultiMap<int, QString>::const_iterator i = map.constBegin();
        output = "";
        while (i != map.constEnd()) {
            output += i.value() + "\n";
            ++i;
        }
    }
    if (sortOrder == 2 || sortOrder == 3) {
        QMultiMap<QString, QString>::const_iterator i = sorted_map.constBegin();
        output = "";
        while (i != sorted_map.constEnd()) {
            output += i.value() + "\n";
            ++i;
        }
    }
    return output;
}

QString TimeZone::TimeZone::readCityInfo(const QByteArray &cityid, const QByteArray &time_format)
{
    QLocale english("en_US");
    QString output;
    QString sign;
    QString timeoffset;
    QTimeZone zone = QTimeZone(cityid);
    QDateTime zoneTime = QDateTime(QDate::currentDate(), QTime::currentTime(), zone).toLocalTime();
    QString abbreviation = zone.abbreviation(zoneTime);
    int offset = zone.offsetFromUtc(QDateTime::currentDateTime());
    if (offset < 0)
        sign = "-";
    else
        sign = "+";
    if((offset % 3600)==0)
        // offset equals to whole hour
        timeoffset = QString("UTC %3").arg(sign+QString::number(abs(offset)/3600));
    else
    {
        int minutes = offset/60 %60;
        timeoffset = QString("UTC %3:%4").arg(sign+QString::number(abs(offset)/3600)).arg(abs(minutes));
    }
    QDateTime mytime = QDateTime::currentDateTime();
    mytime = mytime.toUTC();
    mytime = mytime.addSecs( offset );
    if (time_format == "24" ) {
        output += mytime.time().toString("hh:mm")+";"+cityid+";"+ QLocale::countryToString(zone.country()) \
                  +";"+english.toString(mytime.date(), "ddd MMM d yyyy")+";"+abbreviation \
                  +" ("+timeoffset+");"+QString::number(offset/60);
    } else {
        output += english.toString(mytime.time(), "hh:mm ap")+";"+cityid+";"+ QLocale::countryToString(zone.country()) \
                  +";"+english.toString(mytime.date(), "ddd MMM d yyyy")+";"+abbreviation+" ("+timeoffset+");" \
                  +QString::number(offset/60);
    }
    return output;
}

QString TimeZone::TimeZone::readCityTime(const QByteArray &cityid, const QByteArray &time_format)
{
    QLocale english("en_US");
    QString output;
    QTimeZone zone = QTimeZone(cityid);
    QDateTime mytime = QDateTime::currentDateTime();
    int offset = zone.offsetFromUtc(QDateTime::currentDateTime());
    mytime = mytime.toUTC();
    mytime = mytime.addSecs( offset );
    if (time_format == "24") {
        output += mytime.time().toString("hh:mm")+';'+english.toString(mytime.date(), "ddd MMM d yyyy");
    } else {
        output += english.toString(mytime.time(), "hh:mm ap")+';'+english.toString(mytime.date(), "ddd MMM d yyyy");
    }
    return output;
}

QString TimeZone::TimeZone::readLocalTime(const QByteArray &time_format)
{
    QLocale english("en_US");
    QString output;
    QDateTime mytime = QDateTime::currentDateTime();
    if (time_format == "24") {
        output += mytime.time().toString("hh:mm")+';'+english.toString(mytime.date(), "ddd MMM d yyyy");
    } else {
        output += english.toString(mytime.time(), "hh:mm ap")+';'+english.toString(mytime.date(), "ddd MMM d yyyy");
    }
    return output;
}

QString TimeZone::TimeZone::readCityDetails(const QByteArray &cityid, const QByteArray &time_format)
{
    QLocale english("en_US");
    QString output;
    QTimeZone zone = QTimeZone(cityid);
    QDateTime mytime = QDateTime::currentDateTime();
    int offset = zone.offsetFromUtc(QDateTime::currentDateTime());
    mytime = mytime.toUTC();
    mytime = mytime.addSecs( offset );
    QDateTime zoneTime = QDateTime(QDate::currentDate(), QTime::currentTime(), zone).toLocalTime();
    QString longname = zone.displayName(zoneTime, QTimeZone::LongName, english );
    QString abbreviation = zone.abbreviation(zoneTime);
    QString offsetname = zone.displayName(zoneTime, QTimeZone::OffsetName);

    const QDateTime dateTime1 = QDateTime::currentDateTime();
    const QDateTime dateTime2 = QDateTime(dateTime1.date(), dateTime1.time(), Qt::UTC);
    int sec_diff = offset - dateTime1.secsTo(dateTime2);
    int hours = (abs(sec_diff) / 60 / 60) % 24;
    int minutes = (abs(sec_diff) / 60) % 60;
    QString timeDiff = QString::number(hours) + ":";;
    if (minutes < 10) {
        timeDiff = timeDiff + "0" + QString::number(minutes);
    } else
    {
        timeDiff = timeDiff + QString::number(minutes);
    }
    if (sec_diff < -60) {
        timeDiff = "-"+timeDiff;
    } else
    {
        timeDiff = "+"+timeDiff;
    }
    QString hasDaylighttime;
    if (zone.hasDaylightTime())
        hasDaylighttime = "true";
    else
        hasDaylighttime = "false";

    QString isDaylighttime;
    if (zone.isDaylightTime(QDateTime::currentDateTime()))
        isDaylighttime = "true";
    else
        isDaylighttime = "false";

    QString hasTransitions;
    if (zone.hasTransitions())
        hasTransitions = "true";
    else
        hasTransitions = "false";

    QString nextTransition = "none";
    QString previousTransition = "none";

    QTimeZone::OffsetData offset2 = zone.previousTransition(QDateTime::currentDateTime());
    QTimeZone::OffsetData offset3 = zone.nextTransition(QDateTime::currentDateTime());
    // lets find the upcoming/previous abbreviation
    QString abbrevToNext = zone.abbreviation(offset2.atUtc.addDays(-1));
    QString abbrevFromPrev = zone.abbreviation(offset3.atUtc.addDays(1));
    QString DST_shift_txt = "";
    QString DST_shift_txt_old = "";
    bool isDayLightTime = zone.isDaylightTime(QDateTime::currentDateTime());

    if (offset3.atUtc != QDateTime()) {
        abbrevToNext = "(" + abbreviation + "→" + abbrevToNext + ")";
        if (time_format == "24") {
            if ( isDayLightTime ) {
                if ( offset > 0) {
                    previousTransition = english.toString(offset2.atUtc.addSecs(offset-3600), "hh:mm dddd MMMM d yyyy") + " ("+abbrevFromPrev+")";
                } else {
                    previousTransition = english.toString(offset2.atUtc.addSecs(offset+3600), "hh:mm dddd MMMM d yyyy") + " ("+abbrevFromPrev+")";
                }
            } else {
                if ( offset > 0) {
                    previousTransition = english.toString(offset2.atUtc.addSecs(offset+3600), "hh:mm dddd MMMM d yyyy") + " ("+abbrevFromPrev+")";
                } else {
                    previousTransition = english.toString(offset2.atUtc.addSecs(offset+3600), "hh:mm dddd MMMM d yyyy") + " ("+abbrevFromPrev+")";
                }
            }
            nextTransition = english.toString(offset3.atUtc.addSecs(offset), "hh:mm dddd MMMM d yyyy") + " ("+abbreviation+")";
        } else {
            previousTransition = english.toString(offset2.atUtc, "hh:mm ap dddd MMMM d yyyy") + " (UTC)";
            nextTransition = english.toString(offset3.atUtc, "hh:mm ap dddd MMMM d yyyy") + " (UTC)";
        }
        if ( isDayLightTime ) {
            // we now are in DaylightTime, so we go one hour back
            DST_shift_txt = "(the clock jumps one hour backward)";
            DST_shift_txt_old = "(the clock jumped one hour forward)";
        } else {
            DST_shift_txt = "(the clock jumps one hour forward)";
            DST_shift_txt_old = "(the clock jumped one hour backward)";
        }
        abbrevFromPrev = "(" + abbrevFromPrev + "→" + abbreviation + ")";
    } else {
        abbrevToNext = "";
        abbrevFromPrev = "";
    }

    if (time_format == "24") {
        output += mytime.time().toString("hh:mm")+" "+english.toString(mytime.date(), "dddd MMMM d yyyy") \
                  +";"+longname+" ("+abbreviation+")"+";"+QLocale::countryToString(zone.country())+";"+cityid \
                  +";"+offsetname+";"+QTime::currentTime().toString("hh:mm")+" " \
                  +english.toString(QDate::currentDate(), "dddd MMMM d yyyy")+";"+timeDiff+";" \
                  +hasDaylighttime+";"+isDaylighttime+";"+previousTransition+";"+nextTransition+";" \
                  +abbrevToNext+";"+abbrevFromPrev+';'+DST_shift_txt_old+';'+DST_shift_txt;
    } else {
        output += english.toString(mytime.time(), "hh:mm ap")+" "+english.toString(mytime.date(), "dddd MMMM d yyyy") \
                  +";"+longname+" ("+abbreviation+")"+";"+QLocale::countryToString(zone.country())+";"+cityid \
                  +";"+offsetname+";"+english.toString(QTime::currentTime(), "hh:mm ap")+" " \
                  +english.toString(QDate::currentDate(), "dddd MMMM d yyyy")+";"+timeDiff+";" \
                  +hasDaylighttime+";"+isDaylighttime+";"+previousTransition+";"+nextTransition+";" \
                  +abbrevToNext+";"+abbrevFromPrev+";"+DST_shift_txt_old+';'+DST_shift_txt;
    }
    return output;
}

TimeZone::~TimeZone() {

}
