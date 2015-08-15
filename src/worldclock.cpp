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
#include <QLocale>
#include <QTranslator>
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
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QQuickView* view = SailfishApp::createView();
    qmlRegisterType<TimeZone>("harbour.worldclock.TimeZone", 1 , 0 , "TZ");
    qmlRegisterType<Launcher>("harbour.worldclock.Launcher", 1 , 0 , "App");
    qmlRegisterType<Settings>("harbour.worldclock.Settings", 1 , 0 , "MySettings");
    qmlRegisterType<settingsPublic::Languages>("harbour.worldclock.Settings", 1, 0, "Languages");

    QString locale_appname = "harbour-worldclock-" + QLocale::system().name();
    qDebug() << "Translations:" << SailfishApp::pathTo("translations").toLocalFile() + "/" + locale_appname + ".qm";
    // Check if user has set language explicitly to be used in the app
    QString locale = QLocale::system().name();

    QSettings mySets;
    int languageNbr = mySets.value("language","0").toInt();

    QTranslator translator;
    if (settingsPublic::Languages::SYSTEM_DEFAULT != languageNbr) {
        switch (languageNbr) {
        // Swedish
        case settingsPublic::Languages::SV:
            translator.load("harbour-worldclock-sv.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Dutch
        case settingsPublic::Languages::NL:
            translator.load("harbour-worldclock-nl.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // English
        default:
            translator.load("harbour-worldclock.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        }
        // install translator for specific language
        // otherwise the system language will be set by SailfishApp
        app->installTranslator(&translator);
    }

    view->rootContext()->setContextProperty("DebugLocale",QVariant(locale));
    view->rootContext()->setContextProperty("version", appversion);
    view->setSource(SailfishApp::pathTo("qml/worldclock.qml"));
    view->showFullScreen();
    return app->exec();

}


QLocale myLanguage(void)
{
    QSettings mySets;
    int languageNbr = mySets.value("language","0").toInt();
    QLocale myLang;
    switch (languageNbr) {
    // Dutch
    case settingsPublic::Languages::NL:
        myLang = QLocale( QLocale::Dutch, QLocale::Netherlands );
        break;
    // Swedish
    case settingsPublic::Languages::SV:
        myLang = QLocale( QLocale::Swedish, QLocale::Sweden );
        break;
    // English
    default:
        myLang = QLocale( QLocale::English, QLocale::UnitedStates );
        break;
    }
    return myLang;
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
    QLocale::setDefault(myLanguage());
    QString output;
    QString sign;
    QString timeoffset;
    QTimeZone zone = QTimeZone(cityid);
    QDateTime zoneTime = QDateTime(QDate::currentDate(), QTime::currentTime(), zone).toLocalTime();
    QString abbreviation = zone.abbreviation(zoneTime);
    int offset = zone.offsetFromUtc(QDateTime::currentDateTime());
    // try to make the date format look like ddd MMM d yyyy, but in localized order
    QString dateFormat = "ddd " + QLocale().dateFormat(QLocale::ShortFormat);
    dateFormat.replace("/", " ").replace("-", " ");
    QRegExp rx("\\b(M){1,2}\\b");
    dateFormat.replace(rx, "MMM");
    QRegExp rx2("\\b(y){2}\\b");
    dateFormat.replace(rx2, "yyyy");
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
                  +";"+QLocale().toString(mytime.date(),dateFormat)+";"+abbreviation \
                  +" ("+timeoffset+");"+QString::number(offset/60);
    } else {
        output += mytime.time().toString("hh:mm ap")+";"+cityid+";"+ QLocale::countryToString(zone.country()) \
                  +";"+QLocale().toString(mytime.date(),dateFormat)+";"+abbreviation \
                  +" ("+timeoffset+");"+QString::number(offset/60);
    }
    return output;
}

QString TimeZone::TimeZone::readCityTime(const QByteArray &cityid, const QByteArray &time_format)
{
    QLocale::setDefault(myLanguage());
    QString output;
    QTimeZone zone = QTimeZone(cityid);
    QDateTime mytime = QDateTime::currentDateTime();
    int offset = zone.offsetFromUtc(QDateTime::currentDateTime());
    mytime = mytime.toUTC();
    mytime = mytime.addSecs( offset );
    // try to make the date format look like ddd MMM d yyyy, but in localized order
    QString dateFormat = "ddd " + QLocale().dateFormat(QLocale::ShortFormat);
    dateFormat.replace("/", " ").replace("-", " ");
    QRegExp rx("\\b(M){1,2}\\b");
    dateFormat.replace(rx, "MMM");
    QRegExp rx2("\\b(y){2}\\b");
    dateFormat.replace(rx2, "yyyy");
    // qDebug() <<  dateFormat;
    if (time_format == "24") {
        output += QLocale().toString(mytime.time(), "hh:mm")+';'+QLocale().toString(mytime.date(),dateFormat).remove(".");
    } else {
        output += QLocale().toString(mytime.time(), "hh:mm ap")+';'+QLocale().toString(mytime.date(),dateFormat).remove(".");
    }
    return output;
}

QString TimeZone::TimeZone::readLocalTime(const QByteArray &time_format)
{
    QLocale::setDefault(myLanguage());
    QString output;
    QDateTime mytime = QDateTime::currentDateTime();
    // try to make the date format look like ddd MMM d yyyy, but in localized order
    QString dateFormat = "ddd " + QLocale().dateFormat(QLocale::ShortFormat);
    dateFormat.replace("/", " ").replace("-", " ");
    QRegExp rx("\\b(M){1,2}\\b");
    dateFormat.replace(rx, "MMM");
    QRegExp rx2("\\b(y){2}\\b");
    dateFormat.replace(rx2, "yyyy");
    if (time_format == "24") {
        output += mytime.time().toString("hh:mm")+';'+QLocale().toString(mytime.date(), dateFormat);
    } else {
        output += mytime.time().toString("hh:mm ap")+';'+QLocale().toString(mytime.date(), dateFormat);
    }
    return output;
}

QString TimeZone::TimeZone::readCityDetails(const QByteArray &cityid, const QByteArray &time_format)
{
    QLocale::setDefault(myLanguage());
    QString output;
    QTimeZone zone = QTimeZone(cityid);
    QDateTime mytime = QDateTime::currentDateTime();
    int offset = zone.offsetFromUtc(QDateTime::currentDateTime());
    mytime = mytime.toUTC();
    mytime = mytime.addSecs( offset );
    QDateTime zoneTime = QDateTime(QDate::currentDate(), QTime::currentTime(), zone).toLocalTime();
    QString longname = zone.displayName(zoneTime, QTimeZone::LongName, QLocale() );
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
        // try to make the date format look like dddd MMM d yyyy hh:mm, but in localized order
        QString dateFormat = "dddd " + QLocale().dateFormat(QLocale::ShortFormat) + " hh:mm";
        dateFormat.replace("/", " ").replace("-", " ");
        QRegExp rx("\\b(M){1,2}\\b");
        dateFormat.replace(rx, "MMM");
        QRegExp rx2("\\b(y){2}\\b");
        dateFormat.replace(rx2, "yyyy");
        QRegExp rx3("\\b(d){2}\\b");
        dateFormat.replace(rx3, "d");
        // qDebug() <<  dateFormat;
        if (time_format == "24") {
            if ( isDayLightTime ) {
                if ( offset > 0) {
                    previousTransition = QLocale().toString(offset2.atUtc.addSecs(offset-3600), dateFormat).remove(".") + " ("+abbrevFromPrev+")";
                } else {
                    previousTransition = QLocale().toString(offset2.atUtc.addSecs(offset+3600), dateFormat).remove(".") + " ("+abbrevFromPrev+")";
                }
            } else {
                if ( offset > 0) {
                    previousTransition = QLocale().toString(offset2.atUtc.addSecs(offset+3600), dateFormat).remove(".") + " ("+abbrevFromPrev+")";
                } else {
                    previousTransition = QLocale().toString(offset2.atUtc.addSecs(offset+3600), dateFormat).remove(".") + " ("+abbrevFromPrev+")";
                }
            }
            nextTransition = QLocale().toString(offset3.atUtc.addSecs(offset), dateFormat).remove(".") + " ("+abbreviation+")";
        } else {
            dateFormat.replace("hh:mm","hh:mm ap");
            previousTransition = QLocale().toString(offset2.atUtc, dateFormat).remove(".") + " (UTC)";
            nextTransition = QLocale().toString(offset3.atUtc, dateFormat).remove(".") + " (UTC)";
        }
        if ( isDayLightTime ) {
            // we now are in DaylightTime, so we go one hour back
            DST_shift_txt = "txt_clock_back";
            DST_shift_txt_old = "txt_clock_forw_old";
        } else {
            DST_shift_txt = "txt_clock_forw";
            DST_shift_txt_old = "txt_clock_back_old";
        }
        abbrevFromPrev = "(" + abbrevFromPrev + "→" + abbreviation + ")";
    } else {
        abbrevToNext = "";
        abbrevFromPrev = "";
    }
    // Make first character capital
    previousTransition[0] = previousTransition[0].toUpper();
    nextTransition[0] = nextTransition[0].toUpper();

    if (time_format == "24") {
        output += mytime.time().toString("hh:mm")+" - "+QLocale().toString(mytime.date(), QLocale::LongFormat) \
                  +";"+longname+" ("+abbreviation+")"+";"+QLocale::countryToString(zone.country())+";"+cityid \
                  +";"+offsetname+";"+QTime::currentTime().toString("hh:mm")+" - " \
                  +QLocale().toString(QDate::currentDate(), QLocale::LongFormat)+";"+timeDiff+";" \
                  +hasDaylighttime+";"+isDaylighttime+";"+previousTransition+";"+nextTransition+";" \
                  +abbrevToNext+";"+abbrevFromPrev+';'+DST_shift_txt_old+';'+DST_shift_txt;
    } else {
        output += QLocale().toString(mytime.time(), "hh:mm ap")+" - "+QLocale().toString(mytime.date(), QLocale::LongFormat) \
                  +";"+longname+" ("+abbreviation+")"+";"+QLocale::countryToString(zone.country())+";"+cityid \
                  +";"+offsetname+";"+QLocale().toString(QTime::currentTime(), "hh:mm ap")+" - " \
                  +QLocale().toString(QDate::currentDate(), QLocale::LongFormat)+";"+timeDiff+";" \
                  +hasDaylighttime+";"+isDaylighttime+";"+previousTransition+";"+nextTransition+";" \
                  +abbrevToNext+";"+abbrevFromPrev+";"+DST_shift_txt_old+';'+DST_shift_txt;
    }
    return output;
}

TimeZone::~TimeZone() {

}
