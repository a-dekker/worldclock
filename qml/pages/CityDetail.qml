import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.worldclock.TimeZone 1.0
import "../localdb.js" as DB
import "../components"

Page {
    id: cityDetailPage

    property bool largeScreen: screen.width >= 1080
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
    property string cityId
    property bool pageactive: false
    property var applicationActive: mainapp.applicationActive

    TZ {
        id: timezones
    }

    function get_city_details(cityid) {
        var data = timezones.readCityDetails(cityid, mainapp.timeFormat)
        mainapp.city_id = ""
        zoneDateTime = data["zoneDateTime"]
        zoneName = data["zoneName"]
        zoneCountry = data["zoneCountry"]
        zoneCity = data["zoneCity"]
        for (var i = 0; i < 3; i++) {
            zoneCity = zoneCity.replace(/(.+)\//, "")
        }
        zoneOffset = data["zoneOffset"]
        localDateTime = data["localDateTime"]
        zoneTimeDiff = data["zoneTimeDiff"]
        zoneHasDaylightTime = data["zoneHasDaylightTime"] // incorrect?
        zoneisDaylightTime = data["zoneisDaylightTime"] // not used now
        zonePreviousTransition = data["zonePreviousTransition"]
        zoneNextTransition = data["zoneNextTransition"]
        abbrevToNext = data["abbrevToNext"]
        abbrevFromPrev = data["abbrevFromPrev"]
        dstShiftTxtOld = data["dstShiftTxtOld"]
        dstShiftTxt = data["dstShiftTxt"]
        countryTranslated = data["countryTranslated"]
        // now some translation stuff, as I can't get it to work in worldclock.cpp
        if (zonePreviousTransition === "None") {
            zonePreviousTransition = qsTr("None")
        }
        if (zoneNextTransition === "None") {
            zoneNextTransition = qsTr("None")
        }
        switch (dstShiftTxtOld) {
        case "txt_clock_back_old":
            dstShiftTxtOld = "(" + qsTr(
                        "the clock jumped one hour backward") + ")"
            break
        case "txt_clock_forw_old":
            dstShiftTxtOld = "(" + qsTr(
                        "the clock jumped one hour forward") + ")"
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

    onApplicationActiveChanged: {
        if (applicationActive) {
            pageactive = true
        } else {
            pageactive = false
        }
    }

    onStatusChanged: {
        if ((status === PageStatus.Activating)
                || (status === PageStatus.Active)) {
            pageactive = true
        }
    }

    Timer {
        id: timerclock

        interval: 15000 // every 15 secs update for now
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            updateTime()
        }
        running: pageactive
    }

    function updateTime() {
        var data = timezones.readCityDetails(cityId, mainapp.timeFormat)
        zoneDateTime = data["zoneDateTime"]
        localDateTime = data["localDateTime"]
    }

    Component.onCompleted: {
        cityId = mainapp.city_id
        get_city_details(mainapp.city_id)
        if (zoneCountry !== "Default") {
            get_country_details()
        }
        timerclock.start()
    }

    // Place our content in a Column.  The PageHeader is always placed at the top
    // of the page, followed by our content.
    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.height

        VerticalScrollDecorator {}

        Column {
            id: column
            width: cityDetailPage.width
            spacing: largeScreen ? Theme.paddingMedium : Theme.paddingSmall
            PageHeader {
                title: qsTr("Timezone details")
            }
            FancySectionHeader {
                text: zoneCity.replace(/_/g,
                                       " ") + ", " + countryTranslated.replace(
                          /([a-z])([A-Z])/g, "$1 $2")
                iconSource: zoneCountry === "" ? "" : zoneCountry === "Default"
                                                 && isLightTheme ? '../images/Default_lighttheme.png' : '../images/' + zoneCountry + '.png'
            }
            Row {
                x: Theme.paddingLarge
                Label {
                    text: qsTr("Timezone")
                    width: isPortrait ? column.width - Theme.paddingLarge : (column.width / 2 - Theme.paddingLarge)
                }
                Label {
                    text: qsTr("Zone time")
                    width: column.width / 2
                    visible: isLandscape
                }
            }
            Row {
                x: Theme.paddingLarge
                Label {
                    width: isPortrait ? column.width - Theme.paddingLarge : (column.width / 2 - Theme.paddingLarge)
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                    text: zoneName
                    truncationMode: TruncationMode.Fade
                }
                Label {
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                    text: zoneDateTime
                    width: column.width / 2
                    truncationMode: TruncationMode.Fade
                    visible: isLandscape
                }
            }
            Label {
                width: isPortrait ? column.width - Theme.paddingLarge : (column.width / 2)
                x: Theme.paddingLarge
                text: qsTr("Zone time")
                visible: isPortrait
            }
            Label {
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: zoneDateTime
                width: parent.width - Theme.paddingLarge
                truncationMode: TruncationMode.Fade
                visible: isPortrait
            }
            Row {
                x: Theme.paddingLarge
                Label {
                    width: isPortrait ? column.width - Theme.paddingLarge : (column.width / 2 - Theme.paddingLarge)
                    text: qsTr("Local time")
                }
                Label {
                    text: qsTr("Time difference")
                    width: column.width / 2
                    visible: isLandscape
                }
            }
            Row {
                x: Theme.paddingLarge
                Label {
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                    text: localDateTime
                    width: isPortrait ? column.width - Theme.paddingLarge : (column.width / 2 - Theme.paddingLarge)
                    truncationMode: TruncationMode.Fade
                }
                Label {
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                    text: zoneTimeDiff + " " + qsTr("hour")
                    width: column.width / 2
                    visible: isLandscape
                }
            }
            Label {
                x: Theme.paddingLarge
                text: qsTr("Time difference")
                visible: isPortrait
            }
            Label {
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: zoneTimeDiff + " " + qsTr("hour")
                visible: isPortrait
            }
            Row {
                x: Theme.paddingLarge
                Label {
                    truncationMode: TruncationMode.Fade
                    width: isPortrait ? column.width - Theme.paddingLarge : (column.width / 2 - Theme.paddingLarge)
                    text: qsTr("Prev. daylight transition") + " " + abbrevFromPrev
                }
                Label {
                    truncationMode: TruncationMode.Fade
                    text: qsTr("Next daylight transition") + " " + abbrevToNext
                    width: column.width / 2
                    visible: isLandscape
                }
            }
            Row {
                x: Theme.paddingLarge
                Label {
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                    text: zonePreviousTransition
                    width: isPortrait ? column.width - Theme.paddingLarge : (column.width / 2 - Theme.paddingLarge)
                    truncationMode: TruncationMode.Fade
                }
                Label {
                    font.pixelSize: Theme.fontSizeSmall
                    color: Theme.secondaryColor
                    text: zoneNextTransition
                    width: column.width / 2
                    truncationMode: TruncationMode.Fade
                    visible: isLandscape
                }
            }
            Row {
                x: Theme.paddingLarge
                Label {
                    width: isPortrait ? column.width - Theme.paddingLarge : (column.width / 2 - Theme.paddingLarge)
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryColor
                    text: dstShiftTxtOld
                    visible: dstShiftTxtOld !== ""
                }
                Label {
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.secondaryColor
                    text: dstShiftTxt
                    width: column.width / 2
                    visible: isLandscape && dstShiftTxt !== ""
                }
            }
            Label {
                x: Theme.paddingLarge
                width: parent.width - Theme.paddingLarge
                truncationMode: TruncationMode.Fade
                text: qsTr("Next daylight transition") + " " + abbrevToNext
                visible: isPortrait
            }
            Label {
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                text: zoneNextTransition
                width: parent.width - Theme.paddingLarge
                truncationMode: TruncationMode.Fade
                visible: isPortrait
            }
            Label {
                x: Theme.paddingLarge
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: dstShiftTxt
                visible: isPortrait && dstShiftTxt !== ""
            }
            Separator {
                x: Theme.paddingLarge
                color: Theme.primaryColor
                width: parent.width
                visible: iso3pos !== ""
            }
            Row {
                id: isoInfo
                x: Theme.paddingLarge
                width: parent.width - Theme.paddingLarge
                spacing: 10
                visible: iso3pos !== ""
                HighlightImage {
                    id: isoIcon
                    color: Theme.primaryColor
                    source: "../images/iso-icon.png"
                    height: largeScreen ? 80 : 40
                    width: largeScreen ? 80 : 40
                }
                Label {
                    id: isoTxt
                    x: Theme.paddingLarge
                    font.pixelSize: largeScreen ? Theme.fontSizeMedium : Theme.fontSizeSmall
                    text: iso3pos + '/' + iso2pos
                    width: isPortrait ? (parent.width / 3) * 0.95 : (parent.width / 6) * 0.95
                }
                HighlightImage {
                    x: parent.width / 2
                    color: Theme.primaryColor
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
                    width: isPortrait ? (parent.width / 3) * 0.95 : (parent.width / 6) * 0.95
                }
                Image {
                    source: "image://theme/icon-l-answer"
                    height: largeScreen ? 80 : 40
                    width: largeScreen ? 80 : 40
                    visible: countrcode_tel !== "" && isLandscape
                }
                Label {
                    x: Theme.paddingLarge
                    font.pixelSize: largeScreen ? Theme.fontSizeMedium : Theme.fontSizeSmall
                    text: countrcode_tel
                    visible: countrcode_tel !== "" && isLandscape
                    truncationMode: TruncationMode.Fade
                    width: isPortrait ? (parent.width / 3) * 0.95 : (parent.width / 6) * 0.95
                }
                HighlightImage {
                    source: "../images/coin-icon.png"
                    color: Theme.primaryColor
                    height: largeScreen ? 80 : 40
                    width: largeScreen ? 80 : 40
                    visible: currency !== "" && isLandscape
                }
                Label {
                    x: Theme.paddingLarge
                    font.pixelSize: largeScreen ? Theme.fontSizeMedium : Theme.fontSizeSmall
                    text: currency + " (" + currency3pos + ")"
                    visible: currency !== "" && isLandscape
                    width: isPortrait ? (parent.width / 3) * 0.95 : (parent.width / 6) * 0.95
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
                    visible: countrcode_tel !== "" && isPortrait
                }
                Label {
                    id: countryCodeTxt
                    x: Theme.paddingLarge
                    font.pixelSize: largeScreen ? Theme.fontSizeMedium : Theme.fontSizeSmall
                    text: countrcode_tel
                    visible: countrcode_tel !== "" && isPortrait
                    truncationMode: TruncationMode.Fade
                    width: (parent.width / 3) * 0.95
                }
                HighlightImage {
                    id: currencyIcon
                    color: Theme.primaryColor
                    source: "../images/coin-icon.png"
                    height: largeScreen ? 80 : 40
                    width: largeScreen ? 80 : 40
                    visible: currency !== "" && isPortrait
                }
                Label {
                    id: currencyTxt
                    x: Theme.paddingLarge
                    font.pixelSize: largeScreen ? Theme.fontSizeMedium : Theme.fontSizeSmall
                    text: currency + " (" + currency3pos + ")"
                    visible: currency !== "" && isPortrait
                    truncationMode: TruncationMode.Fade
                    width: (parent.width / 2.4)
                }
            }
        }
    }
}
