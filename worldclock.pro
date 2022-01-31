# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-worldclock

CONFIG += sailfishapp \
    c++11

SOURCES += src/worldclock.cpp \
    src/settings.cpp

DEPLOYMENT_PATH = /usr/share/$${TARGET}

OTHER_FILES += qml/worldclock.qml \
    qml/cover/CoverPage.qml \
    rpm/worldclock.changes.in \
    rpm/worldclock.spec \
    translations/*.ts \
    harbour-worldclock.desktop \
    qml/pages/About.qml \
    qml/pages/MainPage.qml \
    qml/pages/Timezone.qml \
    qml/components/CountryItem.qml \
    qml/components/SilicaLabel.qml \
    qml/pages/CityDetail.qml \
    qml/pages/SettingPage.qml \
    qml/images/earth.png \
    qml/pages/Aliases.qml \
    qml/pages/Vars.js \
    qml/localdb.js \
    translations/CityTranslations-sv_SE.txt \
    translations/CityTranslations-de_DE.txt \
    translations/CityTranslations-ru_RU.txt \
    translations/CityTranslations-pl_PL.txt \
    translations/CityTranslations-fr_FR.txt \
    translations/CityTranslations-hu_HU.txt \
    translations/CityTranslations-it_IT.txt \
    translations/CityTranslations-el_GR.txt \
    translations/CityTranslations-ar_EG.txt \
    translations/CityTranslations-sl_SI.txt \
    translations/CityTranslations-es_ES.txt \
    translations/CityTranslations-nl_NL.txt

isEmpty(VERSION) {
    VERSION = $$system( egrep "^Version:\|^Release:" rpm/worldclock.spec |tr -d "[A-Z][a-z]: " | tr "\\\n" "-" | sed "s/\.$//g"| tr -d "[:space:]")
    message("VERSION is unset, assuming $$VERSION")
}
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

icon86.files += icons/86x86/harbour-worldclock.png
icon86.path = /usr/share/icons/hicolor/86x86/apps

icon108.files += icons/108x108/harbour-worldclock.png
icon108.path = /usr/share/icons/hicolor/108x108/apps

icon128.files += icons/128x128/harbour-worldclock.png
icon128.path = /usr/share/icons/hicolor/128x128/apps

icon172.files += icons/172x172/harbour-worldclock.png
icon172.path = /usr/share/icons/hicolor/172x172/apps

icon256.files += icons/256x256/harbour-worldclock.png
icon256.path = /usr/share/icons/hicolor/256x256/apps

translations.files = translations
translations.path = $${DEPLOYMENT_PATH}

INSTALLS += icon86 icon108 icon128 icon172 icon256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

INSTALLS += translations

TRANSLATIONS = translations/harbour-worldclock-sv.ts \
               translations/harbour-worldclock-ru.ts \
               translations/harbour-worldclock-pl_PL.ts \
               translations/harbour-worldclock-de.ts \
               translations/harbour-worldclock-fr_FR.ts \
               translations/harbour-worldclock-hu_HU.ts \
               translations/harbour-worldclock-it.ts \
               translations/harbour-worldclock-el.ts \
               translations/harbour-worldclock-ar.ts \
               translations/harbour-worldclock-sl_SI.ts \
               translations/harbour-worldclock-es.ts \
               translations/harbour-worldclock-nl_BE.ts \
               translations/harbour-worldclock-zh_CN.ts \
               translations/harbour-worldclock-et.ts \
               translations/harbour-worldclock-nl.ts


HEADERS += \
    src/worldclock.h \
    src/settings.h

# only include these files for translation:
lupdate_only {
    SOURCES = qml/*.qml \
              qml/pages/*.qml
}
include(SortFilterProxyModel/SortFilterProxyModel.pri)
