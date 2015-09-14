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

CONFIG += sailfishapp

SOURCES += src/worldclock.cpp \
    src/settings.cpp \
    src/osread.cpp

OTHER_FILES += qml/worldclock.qml \
    qml/cover/CoverPage.qml \
    rpm/worldclock.changes.in \
    rpm/worldclock.spec \
    translations/*.ts \
    harbour-worldclock.desktop \
    harbour-worldclock.png \
    qml/pages/About.qml \
    qml/pages/MainPage.qml \
    qml/pages/Timezone.qml \
    qml/components/CountryItem.qml \
    qml/components/SilicaLabel.qml \
    qml/pages/CityDetail.qml \
    qml/pages/SettingPage.qml \
    qml/pages/Popup.qml \
    qml/images/earth.png \
    qml/pages/Aliases.qml \
    qml/pages/Vars.js \
    qml/localdb.js

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

INSTALLS += translations

TRANSLATIONS = translations/harbour-worldclock-sv.ts \
               translations/harbour-worldclock-ru.ts \
               translations/harbour-worldclock-de.ts \
               translations/harbour-worldclock-nl.ts


HEADERS += \
    src/worldclock.h \
    src/settings.h \
    src/osread.h

# only include these files for translation:
lupdate_only {
    SOURCES = qml/*.qml \
              qml/pages/*.qml
}
