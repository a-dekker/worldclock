import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.worldclock.TimeZone 1.0

Page {
    id: cityDetailPage

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
        zoneNextTransition = data[10]
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

    Component.onCompleted: {
        get_city_details(mainapp.city_id)
    }

    // Place our content in a Column.  The PageHeader is always placed at the top
    // of the page, followed by our content.
    Column {
        id: column
        width: cityDetailPage.width
        // set spacing considering the width/height ratio
        spacing: cityDetailPage.height / cityDetailPage.width
                 > 1.6 ? Theme.paddingMedium : Theme.paddingSmall
        PageHeader {
            title: qsTr("Timezone details")
        }
        SectionHeader {
            wrapMode: Text.Wrap
            Image {
                height: 55
                width: 95
                source: zoneCountry !== "" ? '../images/' + zoneCountry + '.png' : ""
                anchors.leftMargin: Theme.paddingSmall
            }
            text: zoneCity.replace(/_/g, " ") + ", " + zoneCountry.replace(
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
    }
}
