import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.worldclock.Settings 1.0
import harbour.worldclock.TimeZone 1.0

CoverBackground {
    BackgroundItem {
        anchors.fill: parent

        Image {
            id: coverBgImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "../images/earth.png"
            // opacity: 0.2
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
        }
    }

    MySettings {
        id: myset
    }

    TZ {
        id: timezones
    }

    // helper function to add cities to the list
    function appendCity(zoneTime, zoneCity, zoneSecs, zoneCityFull) {
        cityListModel.append({
                                 zoneTime: zoneTime,
                                 zoneCity: zoneCity,
                                 zoneSecs: zoneSecs,
                                 zoneCityFull: zoneCityFull
                             })
    }

    // helper function to wipe the city element
    function wipeCityList() {
        cityListModel.clear()
    }

    function loadCityList() {
        wipeCityList()
        if (myset.contains("Cities")) {
            var myCities = myset.value("Cities").toString()
            if (myCities != "") {
                var data
                myCities = myCities.split(",")
                for (var myCity in myCities) {
                    data = timezones.readCityInfo(myCities[myCity],mainapp.timeFormat)
                    data = data.split(';')
                    var zoneTime = data[0]
                    var zoneCity = data[1]
                    var zoneCityFull = zoneCity
                    for (var i = 0; i < 3; i++) {
                        zoneCity = zoneCity.replace(/(.+)\//, "")
                    }
                    var zoneCountry = data[2]
                    var zoneDate = data[3]
                    var zoneUTC = data[4]
                    var zoneSecs = data[5]

                    appendCity(zoneTime, zoneCity, zoneSecs, zoneCityFull)
                }
            }
        }
    }

    function updateTime() {
        var data
        for (var i = 0; i < cityListModel.count; ++i) {
            data = timezones.readCityTime(cityListModel.get(i).zoneCityFull,mainapp.timeFormat)
            data = data.split(';')
            var zoneTime = data[0]
            cityListModel.setProperty(i, "zoneTime", zoneTime)
        }
    }

    function sortModel() {
        var sortorder = myset.value("sortorder")
        // 0 = non;1 = time;2 = city
        var n
        var i
        if (sortorder == 1) {
            // date/time based
            for (n = 0; n < cityListModel.count; n++)
                for (i = n + 1; i < cityListModel.count; i++) {
                    if (+cityListModel.get(n).zoneSecs > +cityListModel.get(
                                i).zoneSecs) {
                        cityListModel.move(i, n, 1)
                        n = 0
                    }
                }
        }
        if (sortorder == 2) {
            // cityname based
            for (n = 0; n < cityListModel.count; n++)
                for (i = n + 1; i < cityListModel.count; i++) {
                    if (cityListModel.get(n).zoneCity > cityListModel.get(
                                i).zoneCity) {
                        cityListModel.move(i, n, 1)
                        n = 0
                    }
                }
        }
    }

    // read cities after start
    Component.onCompleted: {
        loadCityList()
        sortModel()
    }

    onStatusChanged: {
        switch (status) {
        case PageStatus.Activating:
            // reload citylist if navigateBack
            loadCityList()
            sortModel()

            break
        }
    }

    ListModel {
        id: cityListModel
    }

    ListView {
        anchors.fill: parent
        anchors.margins: Theme.paddingSmall

        Label {
            id: coverHeader
            text: "Worldclock"
            width: parent.width - Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            horizontalAlignment: Text.Center
            color: Theme.highlightColor
        }

        ListView {
            id: cityList
            anchors.top: coverHeader.bottom
            height: 7 * (Theme.fontSizeSmall + Theme.paddingSmall) + 2
            width: parent.width - Theme.paddingSmall
            anchors.horizontalCenter: parent.horizontalCenter
            model: cityListModel

            delegate: Item {
                id: cityListItem
                width: parent.width
                height: cityLabel.height

                Label {
                    id: timeLabel
                    x: Theme.paddingSmall
                    text: zoneTime.replace(" ","")
                    height: font.pixelSize + Theme.paddingSmall
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Theme.fontSizeSmall
                }
                Label {
                    id: cityLabel
                    text: " " + zoneCity.replace(/_/g, " ")
                    anchors.left: timeLabel.right
                    font.pixelSize: Theme.fontSizeSmall
                }
            }
        }

        OpacityRampEffect {
            slope: 1
            offset: 0.5
            sourceItem: cityList
        }

        CoverActionList {
            id: coverAction

            CoverAction {
                iconSource: "image://theme/icon-cover-new"
                onTriggered: {
                    mainapp.coverAddZone = true
                    pageStack.replace(Qt.resolvedUrl("../pages/MainPage.qml"))
                    pageStack.completeAnimation()
                    mainapp.activate()
                }
            }
        }
    }
}
