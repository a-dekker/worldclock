import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.worldclock.TimeZone 1.0
import "../localdb.js" as DB

Page {
    id: cityDetailPage
    allowedOrientations: Orientation.Portrait | Orientation.Landscape
                         | Orientation.LandscapeInverted
    property bool largeScreen: Screen.sizeCategory === Screen.Large ||
                               Screen.sizeCategory === Screen.ExtraLarge
    property string zoneDateTime
    property string zoneName
    property string zoneCountry
    property string zoneCity
    property string zoneOffset
    property string localDateTime
    property string zoneTimeDiff
    property string zoneHasDaylightTime
    property string zoneisDaylightTime
    property string zonePreviousTransition
    property string zoneNextTransition
    property string abbrevToNext
    property string abbrevFromPrev
    property string dstShiftTxtOld
    property string dstShiftTxt
    property string countryTranslated
    property string countryInf
    property string currency3pos
    property string currency
    property string countrcode_tel
    property string iso2pos
    property string iso3pos
    property string wwwExt

    TZ {
        id: timezones
    }

    function get_city_details(cityid) {
        var data = timezones.readCityDetails(cityid, mainapp.timeFormat)
        mainapp.city_id = ""
        data = data.split(';')
        zoneDateTime = data[0]
        zoneName = data[1]
        zoneCountry = data[2]
        zoneCity = data[3]
        for (var i = 0; i < 3; i++) {
            zoneCity = zoneCity.replace(/(.+)\//, "")
        }
        zoneOffset = data[4]
        localDateTime = data[5]
        zoneTimeDiff = data[6]
        zoneHasDaylightTime = data[7] // incorrect?
        zoneisDaylightTime = data[8] // not used now
        zonePreviousTransition = data[9]
        zoneNextTransition = data[10]
        abbrevToNext = data[11]
        abbrevFromPrev = data[12]
        dstShiftTxtOld = data[13]
        dstShiftTxt = data[14]
        countryTranslated = data[15]
        // now some translation stuff, as I can't get it to work in worldclock.cpp
        if (zonePreviousTransition === "None" ) {
            zonePreviousTransition = qsTr("None")
        }
        if (zoneNextTransition === "None" ) {
            zoneNextTransition = qsTr("None")
        }
        switch (dstShiftTxtOld) {
            case "txt_clock_back_old":
                dstShiftTxtOld = "(" + qsTr("the clock jumped one hour backward") + ")"
                break
            case "txt_clock_forw_old":
                dstShiftTxtOld = "(" + qsTr("the clock jumped one hour forward") + ")"
                break
            default:
                dstShiftTxtOld = ""
        }
        switch (dstShiftTxt) {
            case "txt_clock_back":
                dstShiftTxt = "(" + qsTr("the clock jumps one hour backward") + ")"
                break
            case "txt_clock_forw":
                dstShiftTxt = "(" + qsTr("the clock jumps one hour forward") + ")"
                break
            default:
                dstShiftTxt = ""
        }
    }

    function get_country_details() {
        var countryInf = DB.getCountryInfo(zoneCountry)
        // JPY|Yen|81|JP|JPN|.jp
        countryInf = countryInf.split('|')
        currency3pos = countryInf[0]
        currency = countryInf[1]
        countrcode_tel = countryInf[2]
        iso2pos = countryInf[3]
        iso3pos = countryInf[4]
        wwwExt = countryInf[5]
    }

    Component.onCompleted: {
        get_city_details(mainapp.city_id)
        get_country_details()
    }

    // Place our content in a Column.  The PageHeader is always placed at the top
    // of the page, followed by our content.
    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.height

        VerticalScrollDecorator {
        }

        Column {
            id: column
            width: cityDetailPage.width
            spacing: largeScreen ? Theme.paddingMedium : Theme.paddingSmall
            PageHeader {
                title: qsTr("Timezone details")
            }
            SectionHeader {
                wrapMode: Text.Wrap
                Image {
                    height: largeScreen ? 100 : 55
                    width: largeScreen ? 180 : 95
                    source: zoneCountry !== "" ? '../images/' + zoneCountry + '.png' : ""
                    anchors.leftMargin: Theme.paddingSmall
                }
                text: zoneCity.replace(/_/g, " ") + ", " + countryTranslated.replace(
                          /([a-z])([A-Z])/g, "$1 $2")
            }
            Label {
                x: Theme.paddingLarge
                text: qsTr("Timezone")
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - Theme.paddingLarge
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: zoneName
                truncationMode: TruncationMode.Fade
            }
            Label {
                x: Theme.paddingLarge
                text: qsTr("Zone time")
            }
            Label {
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: zoneDateTime
                width: parent.width - Theme.paddingLarge
                truncationMode: TruncationMode.Fade
            }
            Label {
                x: Theme.paddingLarge
                text: qsTr("Local time")
            }
            Label {
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: localDateTime
                width: parent.width - Theme.paddingLarge
                truncationMode: TruncationMode.Fade
            }
            Label {
                x: Theme.paddingLarge
                text: qsTr("Time difference")
            }
            Label {
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: zoneTimeDiff + " " + qsTr("hour")
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - Theme.paddingLarge
                truncationMode: TruncationMode.Fade
                text: qsTr("Prev. daylight transition") + " " + abbrevFromPrev
            }
            Label {
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: zonePreviousTransition
                width: parent.width - Theme.paddingLarge
                truncationMode: TruncationMode.Fade
            }
            Label {
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: dstShiftTxtOld
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - Theme.paddingLarge
                truncationMode: TruncationMode.Fade
                text: qsTr("Next daylight transition") + " " + abbrevToNext
            }
            Label {
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: zoneNextTransition
                width: parent.width - Theme.paddingLarge
                truncationMode: TruncationMode.Fade
            }
            Label {
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: dstShiftTxt
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: iso3pos !== ""
            }
            Row {
                id: isoInfo
                x: Theme.paddingLarge
                width: parent.width - Theme.paddingLarge
                spacing: 10
                visible: iso3pos !== ""
                Image {
                    id: isoIcon
                    source: "../images/iso-icon.png"
                    height: largeScreen ? 80 : 40
                    width: largeScreen ? 80 : 40
                }
                Label {
                    id: isoTxt
                    x: Theme.paddingLarge
                    font.pixelSize: largeScreen ? Theme.fontSizeMedium : Theme.fontSizeSmall
                    text: iso3pos + '/' + iso2pos
                    width: (parent.width / 3) * 0.95
                }
                Image {
                    x: parent.width / 2
                    id: wwwIcon
                    source: "../images/www-icon.png"
                    height: largeScreen ? 80 : 40
                    width: largeScreen ? 80 : 40
                }
                Label {
                    id: wwwTxt
                    x: Theme.paddingLarge
                    font.pixelSize: largeScreen ? Theme.fontSizeMedium : Theme.fontSizeSmall
                    text: wwwExt
                    width: (parent.width / 3) * 0.95
                }
            }
            Row {
                id: phoneCoinInfo
                x: Theme.paddingLarge
                width: parent.width - Theme.paddingLarge
                spacing: 10
                Image {
                    id: countryCode
                    source: "image://theme/icon-l-answer"
                    height: largeScreen ? 80 : 40
                    width: largeScreen ? 80 : 40
                    visible: countrcode_tel !== ""
                }
                Label {
                    id: countryCodeTxt
                    x: Theme.paddingLarge
                    font.pixelSize: largeScreen ? Theme.fontSizeMedium : Theme.fontSizeSmall
                    text: countrcode_tel
                    visible: countrcode_tel !== ""
                    truncationMode: TruncationMode.Fade
                    width: (parent.width / 3) * 0.95
                }
                Image {
                    id: currencyIcon
                    source: "../images/coin-icon.png"
                    height: largeScreen ? 80 : 40
                    width: largeScreen ? 80 : 40
                    visible: currency !== ""
                }
                Label {
                    id: currencyTxt
                    x: Theme.paddingLarge
                    font.pixelSize: largeScreen ? Theme.fontSizeMedium : Theme.fontSizeSmall
                    text: currency + " (" + currency3pos + ")"
                    visible: currency !== ""
                    truncationMode: TruncationMode.Fade
                    width: (parent.width / 2.4)
                }
            }
        }
    }
}
