import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.worldclock.Settings 1.0
import harbour.worldclock.TimeZone 1.0

CoverBackground {
    BackgroundItem {
        anchors.fill: parent

        HighlightImage {
            id: coverBgImage
            color: Theme.primaryColor
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "../images/earth.png"
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
    function appendCity(zoneTime, zoneCityTr, zoneSecs, zoneCityFull) {
        cityListModel.append({
                                 "zoneTime": zoneTime,
                                 "zoneCityTr": zoneCityTr,
                                 "zoneSecs": zoneSecs,
                                 "zoneCityFull": zoneCityFull
                             })
    }

    // helper function to wipe the city element
    function wipeCityList() {
        cityListModel.clear()
    }

    function replaceLocalCity(aliasCity) {
        var n
        var cityIsReplaced
        for (n = 0; n < cityListModel.count; n++) {
            if (cityListModel.get(n).zoneCityTr === mainapp.localCityTr) {
                cityListModel.setProperty(n, "zoneCityTr", aliasCity)
                cityIsReplaced = "true"
            }
        }
        if (cityIsReplaced === "true") {
            return true
        } else {
            return false
        }
    }

    function loadCityList() {
        wipeCityList()
        var data = timezones.readCityInfo(localContinent + "/" + localCity,
                                          mainapp.timeFormat)
        var local_city_tr = data["zoneCityTr"]
        var zoneSecs = data["zoneSecs"]
        var zoneCountryOrg = data["zoneCountryOrg"]
        var zoneCityFull = data["zoneCity"].toString()
        // add city as localtime
        appendCity(timezones.readLocalTime(mainapp.timeFormat)['zoneTime'],
                   local_city_tr, zoneSecs, zoneCityFull)

        if (myset.contains("Cities")) {
            var myCities = myset.value("Cities").toString()
            if (myCities !== "") {
                var data
                myCities = myCities.split(",")
                for (var myCity in myCities) {
                    data = timezones.readCityInfo(myCities[myCity],
                                                  mainapp.timeFormat)
                    var zoneTime = data["zoneTime"].replace(/\./g, '')
                    var zoneCity = data["zoneCity"].toString()
                    var zoneCityFull = zoneCity.toString()
                    for (var i = 0; i < 3; i++) {
                        zoneCity = zoneCity.replace(/(.+)\//, "")
                    }
                    var zoneCountry = data["zoneCountry"]
                    var zoneDate = data["zoneDate"]
                    var zoneUTC = data["zoneUTC"]
                    var zoneSecs = data["zoneSecs"]
                    var zoneCityTr = data["zoneCityTr"]

                    if (zoneCity !== mainapp.localCity) {
                        appendCity(zoneTime, zoneCityTr, zoneSecs, zoneCityFull)
                    }
                }
            }
        }
        var customdata = mainapp.myAliases.split('\n')
        for (var i = 0; i < customdata.length - 1; i++) {
            var myCity = customdata[i].split("|")[1]
            data = timezones.readCityInfo(customdata[i].split("|")[0],
                                          mainapp.timeFormat)
            var zoneTime = data["zoneTime"].replace(/\./g, '')
            var zoneCity = data["zoneCity"].toString()
            var zoneCityFull = zoneCity.toString()
            for (var x = 0; x < 3; x++) {
                zoneCity = zoneCity.replace(/(.+)\//, "")
            }
            zoneCity = myCity
            var zoneCountry = data["zoneCountry"]
            var zoneDate = data["zoneDate"]
            var zoneUTC = data["zoneUTC"]
            var zoneSecs = data["zoneSecs"]
            var zoneCityTr = data["zoneCityTr"]

            if (zoneCityFull === mainapp.localContinent + "/" + mainapp.localCity
                    && myset.value("hidelocal") === "true") {
                if (!replaceLocalCity(zoneCity)) {
                    appendCity(zoneTime, zoneCity, zoneSecs, zoneCityFull)
                    console.log(zoneCity)
                }
            } else {
                appendCity(zoneTime, zoneCity, zoneSecs, zoneCityFull)
            }
        }
    }

    function updateTime() {
        var data
        for (var i = 0; i < cityListModel.count; ++i) {
            if (cityListModel.get(
                        i).zoneCountry === mainapp.localContinent + "/" + mainapp.localCity) {
                data = timezones.readLocalTime(mainapp.timeFormat)
            } else {
                data = timezones.readCityTime(cityListModel.get(
                                                  i).zoneCityFull,
                                              mainapp.timeFormat)
            }
            cityListModel.setProperty(i, "zoneTime",
                                      data['zoneTime'].replace(/\./g, ''))
        }
    }

    function sortModel() {
        var sortorder = myset.value("sortorder")
        // 0 = non;1 = time;2 = city
        var n
        var i
        if (sortorder === "1") {
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
        if (sortorder === "2") {
            // cityname based
            for (n = 0; n < cityListModel.count; n++)
                for (i = n + 1; i < cityListModel.count; i++) {
                    if (cityListModel.get(n).zoneCityTr > cityListModel.get(
                                i).zoneCityTr) {
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
            text: "🕒 " + qsTr("Worldclock")
            width: parent.width - Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            horizontalAlignment: Text.Center
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeSmall
        }

        Separator {
            id: coverHeaderSeparator
            color: Theme.primaryColor
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: coverHeader.bottom
            horizontalAlignment: Qt.AlignHCenter
        }

        ListView {
            id: cityList
            anchors.top: coverHeader.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: Theme.paddingSmall
            anchors.leftMargin: Theme.paddingSmall
            anchors.rightMargin: Theme.paddingSmall
            anchors.bottomMargin: Theme.paddingLarge

            model: cityListModel

            delegate: Item {
                id: cityListItem
                width: parent.width
                height: cityLabel.height

                Label {
                    id: timeLabel
                    x: Theme.paddingSmall
                    text: zoneTime.replace(" ", "").substr(0, 7)
                    height: font.pixelSize + Theme.paddingSmall
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: Theme.fontSizeSmall
                }
                Label {
                    id: cityLabel
                    text: " " + zoneCityTr.replace(/_/g, " ")
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
                    pageStack.completeAnimation()
                    mainapp.activate()
                    mainapp.newCity()
                }
            }
        }
    }
}
