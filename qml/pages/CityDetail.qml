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
            text: zoneCity.replace(/_/g, " ") + ", " + zoneCountry.replace(
                      /([a-z])([A-Z])/g, "$1 $2")
            wrapMode: Text.Wrap
            Image {
                height: 55
                width: 95
                source: zoneCountry !== "" ? '../images/' + zoneCountry + '.png' : ""
                anchors.leftMargin: Theme.paddingSmall
            }
        }
        Label {
            x: Theme.paddingLarge
            text: "Timezone"
        }
        Label {
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            text: zoneName
        }
        Label {
            x: Theme.paddingLarge
            text: "Zone time"
        }
        Label {
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            text: zoneDateTime
        }
        Label {
            x: Theme.paddingLarge
            text: "Local time"
        }
        Label {
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            text: localDateTime
        }
        Label {
            x: Theme.paddingLarge
            text: "Time difference"
        }
        Label {
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            text: zoneTimeDiff + " hour"
        }
        Label {
            x: Theme.paddingLarge
            text: "Prev. daylight transition " + abbrevFromPrev
        }
        Label {
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            text: zonePreviousTransition
        }
        Label {
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            text: dstShiftTxtOld
        }
        Label {
            x: Theme.paddingLarge
            text: "Next daylight transition " + abbrevToNext
        }
        Label {
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            text: zoneNextTransition
        }
        Label {
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            text: dstShiftTxt
        }
    }
}
