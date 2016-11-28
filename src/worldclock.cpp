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
#include <fstream>
#include <iostream>


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

    // QString locale_appname = "harbour-worldclock-" + QLocale::system().name();
    // qDebug() << "Translations:" << SailfishApp::pathTo("translations").toLocalFile() + "/" + locale_appname + ".qm";
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
        // German
        case settingsPublic::Languages::DE:
            translator.load("harbour-worldclock-de.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Russian
        case settingsPublic::Languages::RU:
            translator.load("harbour-worldclock-ru.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Hungarian
        case settingsPublic::Languages::HU_HU:
            translator.load("harbour-worldclock-hu_HU.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Polish
        case settingsPublic::Languages::PL_PL:
            translator.load("harbour-worldclock-pl_PL.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // French
        case settingsPublic::Languages::FR_FR:
            translator.load("harbour-worldclock-fr_FR.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Italian
        case settingsPublic::Languages::IT:
            translator.load("harbour-worldclock-it.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Greek
        case settingsPublic::Languages::EL:
            translator.load("harbour-worldclock-el.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Arabic
        case settingsPublic::Languages::AR:
            translator.load("harbour-worldclock-ar.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
            break;
        // Slovenian
        case settingsPublic::Languages::SL_SI:
            translator.load("harbour-worldclock-sl_SI.qm", SailfishApp::pathTo(QString("translations")).toLocalFile());
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
    // Swedish
    case settingsPublic::Languages::SV:
        myLang = QLocale( QLocale::Swedish, QLocale::Sweden );
        break;
    // Dutch
    case settingsPublic::Languages::NL:
        myLang = QLocale( QLocale::Dutch, QLocale::Netherlands );
        break;
    // German
    case settingsPublic::Languages::DE:
        myLang = QLocale( QLocale::German, QLocale::Germany );
        break;
    // Russian
    case settingsPublic::Languages::RU:
        myLang = QLocale( QLocale::Russian, QLocale::Russia );
        break;
    // Polish
    case settingsPublic::Languages::HU_HU:
        myLang = QLocale( QLocale::Hungarian, QLocale::Hungary );
        break;
    case settingsPublic::Languages::PL_PL:
        myLang = QLocale( QLocale::Polish, QLocale::Poland );
        break;
    // Italian
    case settingsPublic::Languages::IT:
        myLang = QLocale( QLocale::Italian, QLocale::Italy );
        break;
    // Greek
    case settingsPublic::Languages::EL:
        myLang = QLocale( QLocale::Greek, QLocale::Greece );
        break;
    // Arabic
    case settingsPublic::Languages::AR:
        myLang = QLocale( QLocale::Arabic, QLocale::Egypt );
        break;
    // Slovenian
    case settingsPublic::Languages::SL_SI:
        myLang = QLocale( QLocale::Slovenian, QLocale::Slovenia );
        break;
    // English
    default:
        myLang = QLocale( QLocale::English, QLocale::UnitedStates );
        break;
    }
    return myLang;
}

QString cityTranslations(void)
{
    QLocale locale = myLanguage();
    QString cityFile = SailfishApp::pathTo("translations/CityTranslations-"+locale.name()+".txt").toLocalFile();
    QString lines;
    QFile inFile(cityFile);
    if (inFile.open(QIODevice::ReadOnly))
    {
        QTextStream in(&inFile);
        while (!in.atEnd())
        {
            // Read file into memory
            QString line = in.readLine();
            lines += line + '\n';
        }
        inFile.close();
    }
    return lines;
}

TimeZone::TimeZone(QObject *parent) :
    QObject(parent)
{

}

QString TimeZone::TimeZone::readAllCities()
{
    // get translation list
    QString lines = cityTranslations();

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
        QString countryNameOrg = countryName;
        // insert space where appropriate. Can't be done in one regex replace?
        QRegularExpression rx("([a-z])([A-Z])");
        QRegularExpressionMatch match = rx.match(countryName);
        for (int i = 1; i <= 6; i++) {
            match = rx.match(countryName);
            if (match.hasMatch()) {
                QString lowerChar1 = match.captured(1);
                QString upperChar1 = match.captured(2);
                countryName.replace(lowerChar1+upperChar1,lowerChar1 + " " + upperChar1);
            }
        }
        int index = lines.indexOf('\n'+countryName+';', 0, Qt::CaseInsensitive);
        if (index != -1) {
            index++;
            // Replace countryName with translation
            countryName = lines.mid(index+countryName.length()+1, lines.indexOf('\n',index) - lines.indexOf(';',index)-1);
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

        const int delimiter = id.lastIndexOf('/');
        int nbrSlashes = id.count("/");
        QString cityNameTr = id.mid(delimiter + 1).replace("_"," ");
        QString continentTr = id.mid(0, delimiter);
        QString stateTr = "";
        if ( nbrSlashes == 2) {
            // eg (America/North Dakota/Beulah)
            continentTr = id.mid(0, id.indexOf('/')); //first part
            stateTr = id.mid(id.indexOf('/')+1, delimiter - continentTr.length() - 1 ); //second part
        }
        if (!lines.isEmpty()) {
            int index = lines.indexOf(cityNameTr+';', 0, Qt::CaseInsensitive);
            if (index != -1) {
                cityNameTr = lines.mid(index+cityNameTr.length()+1, lines.indexOf('\n',index) - lines.indexOf(';',index)-1);
            }
            index = lines.indexOf(continentTr+';', 0, Qt::CaseInsensitive);
            if (index != -1) {
                continentTr = lines.mid(index+continentTr.length()+1, lines.indexOf('\n',index) - lines.indexOf(';',index)-1);
            }
            if (!stateTr.isEmpty()) {
                index = lines.indexOf(stateTr+';', 0, Qt::CaseInsensitive);
                if (index != -1) {
                    stateTr =  lines.mid(index+stateTr.length()+1, lines.indexOf('\n',index) - lines.indexOf(';',index)-1);
                }
                continentTr = continentTr + "/" + stateTr;
            }
        }
        if (sortOrder == 1) {
            dummy_counter_for_sort ++;
            map.insert(offset + dummy_counter_for_sort,timeoffset + " (" + continentTr + "/" + cityNameTr + ")" + countryName + ";" + id + ";" + countryNameOrg);
        } else if (sortOrder == 2) {
            sorted_map.insert(cityNameTr, timeoffset + " (" + continentTr + "/" + cityNameTr + ")" + countryName + ";" + id + ";" + countryNameOrg);
        } else if (sortOrder == 3) {
            sorted_map.insert(countryName, timeoffset + " (" + continentTr + "/" + cityNameTr + ")" + countryName + ";" + id + ";" + countryNameOrg);
        } else {
            output += timeoffset + " (" + continentTr + "/" + cityNameTr + ")" + countryName + ";" + id +  + ";" + countryNameOrg + "\n";
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
    // get translation list
    QString lines = cityTranslations();

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

    QString myCountry = QLocale::countryToString(zone.country());
    QString myCountryOrg = myCountry;
    // insert space where appropriate. Can't be done in one regex replace?
    QRegularExpression regx("([a-z])([A-Z])");
    QRegularExpressionMatch match = regx.match(myCountry);
    for (int i = 1; i <= 6; i++) {
        match = regx.match(myCountry);
        if (match.hasMatch()) {
            QString lowerChar1 = match.captured(1);
            QString upperChar1 = match.captured(2);
            myCountry.replace(lowerChar1+upperChar1,lowerChar1 + " " + upperChar1);
        }
    }
    int index = lines.indexOf('\n'+myCountry+';', 0, Qt::CaseInsensitive);
    if (index != -1) {
        index++;
        // Replace countryName with translation
        myCountry = lines.mid(index+myCountry.length()+1, lines.indexOf('\n',index) - lines.indexOf(';',index)-1);
    }
    const int separator = cityid.lastIndexOf('/');
    const QString cityName = cityid.mid(separator + 1).replace("_"," ");
    index = lines.indexOf("\n"+cityName+';', 0, Qt::CaseInsensitive);
    QString cityTr = cityName;
    if (index != -1) {
        index++;
        cityTr = lines.mid(index+cityName.length()+1, lines.indexOf('\n',index) - lines.indexOf(';',index)-1);
    }
    if (time_format == "24" ) {
        output += mytime.time().toString("hh:mm")+";"+cityid+";"+ myCountry \
                  +";"+QLocale().toString(mytime.date(),dateFormat)+";"+abbreviation \
                  +" ("+timeoffset+");"+QString::number(offset/60)+";"+cityTr+";"+myCountryOrg;
    } else {
        output += mytime.time().toString("hh:mm ap")+";"+cityid+";"+ myCountry \
                  +";"+QLocale().toString(mytime.date(),dateFormat)+";"+abbreviation \
                  +" ("+timeoffset+");"+QString::number(offset/60)+";"+cityTr+";"+myCountryOrg;
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
    dateFormat.replace("/", " ").replace("-", " ").replace(".", " ");
    QRegExp rx("\\b(M){1,2}\\b");
    dateFormat.replace(rx, "MMM");
    QRegExp rx2("\\b(y){2}\\b");
    dateFormat.replace(rx2, "yyyy");
    // qDebug() <<  dateFormat;
    if (time_format == "24") {
        output += QLocale().toString(mytime.time(), "hh:mm")+';'+QLocale().toString(mytime.date(),dateFormat);
    } else {
        output += QLocale().toString(mytime.time(), "hh:mm ap")+';'+QLocale().toString(mytime.date(),dateFormat);
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
    // get translation list
    QString lines = cityTranslations();

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
        dateFormat.replace("/", " ").replace("-", " ").replace("."," ");
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
                    previousTransition = QLocale().toString(offset2.atUtc.addSecs(offset-3600), dateFormat) + " ("+abbrevFromPrev+")";
                } else {
                    previousTransition = QLocale().toString(offset2.atUtc.addSecs(offset+3600), dateFormat) + " ("+abbrevFromPrev+")";
                }
            } else {
                if ( offset > 0) {
                    previousTransition = QLocale().toString(offset2.atUtc.addSecs(offset+3600), dateFormat) + " ("+abbrevFromPrev+")";
                } else {
                    previousTransition = QLocale().toString(offset2.atUtc.addSecs(offset+3600), dateFormat) + " ("+abbrevFromPrev+")";
                }
            }
            nextTransition = QLocale().toString(offset3.atUtc.addSecs(offset), dateFormat) + " ("+abbreviation+")";
        } else {
            dateFormat.replace("hh:mm","hh:mm ap");
            previousTransition = QLocale().toString(offset2.atUtc, dateFormat) + " (UTC)";
            nextTransition = QLocale().toString(offset3.atUtc, dateFormat) + " (UTC)";
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

    // Replace countryName with translation
    QString myCountry = QLocale::countryToString(zone.country());
    // insert space where appropriate. Can't be done in one regex replace?
    QRegularExpression regx("([a-z])([A-Z])");
    QRegularExpressionMatch match = regx.match(myCountry);
    for (int i = 1; i <= 6; i++) {
        match = regx.match(myCountry);
        if (match.hasMatch()) {
            QString lowerChar1 = match.captured(1);
            QString upperChar1 = match.captured(2);
            myCountry.replace(lowerChar1+upperChar1,lowerChar1 + " " + upperChar1);
        }
    }
    int index = lines.indexOf('\n'+myCountry+';', 0, Qt::CaseInsensitive);
    if (index != -1) {
        index++;
        myCountry = lines.mid(index+myCountry.length()+1, lines.indexOf('\n',index) - lines.indexOf(';',index)-1);
    }
    const int separator = cityid.lastIndexOf('/');
    const QString cityName = cityid.mid(separator + 1).replace("_", " ");
    QByteArray cityidTr = cityid;
    index = lines.indexOf('\n'+cityName+';', 0, Qt::CaseInsensitive);
    if (index != -1) {
        index++;
        QString myCity = lines.mid(index+cityName.length()+1, lines.indexOf('\n',index) - lines.indexOf(';',index)-1);
        cityidTr.replace(cityName.toUtf8().replace(" ","_"),myCity.toUtf8());
    }

    if (time_format == "24") {
        output += mytime.time().toString("hh:mm")+" - "+QLocale().toString(mytime.date(), QLocale::LongFormat) \
                  +";"+longname+" ("+abbreviation+")"+";"+QLocale::countryToString(zone.country())+";"+cityidTr \
                  +";"+offsetname+";"+QTime::currentTime().toString("hh:mm")+" - " \
                  +QLocale().toString(QDate::currentDate(), QLocale::LongFormat)+";"+timeDiff+";" \
                  +hasDaylighttime+";"+isDaylighttime+";"+previousTransition+";"+nextTransition+";" \
                  +abbrevToNext+";"+abbrevFromPrev+';'+DST_shift_txt_old+';'+DST_shift_txt+';'+myCountry;
    } else {
        output += QLocale().toString(mytime.time(), "hh:mm ap")+" - "+QLocale().toString(mytime.date(), QLocale::LongFormat) \
                  +";"+longname+" ("+abbreviation+")"+";"+QLocale::countryToString(zone.country())+";"+cityidTr \
                  +";"+offsetname+";"+QLocale().toString(QTime::currentTime(), "hh:mm ap")+" - " \
                  +QLocale().toString(QDate::currentDate(), QLocale::LongFormat)+";"+timeDiff+";" \
                  +hasDaylighttime+";"+isDaylighttime+";"+previousTransition+";"+nextTransition+";" \
                  +abbrevToNext+";"+abbrevFromPrev+";"+DST_shift_txt_old+';'+DST_shift_txt+';'+myCountry;
    }
    return output;
}

TimeZone::~TimeZone() {

}
