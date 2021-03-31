import QtQuick 2.2
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
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            layer.effect: ShaderEffect {
                property color color: Theme.primaryColor

                fragmentShader: "
                varying mediump vec2 qt_TexCoord0;
                uniform highp float qt_Opacity;
                uniform lowp sampler2D source;
                uniform highp vec4 color;
                void main() {
                    highp vec4 pixelColor = texture2D(source, qt_TexCoord0);
                    gl_FragColor = vec4(mix(pixelColor.rgb/max(pixelColor.a, 0.00390625), color.rgb/max(color.a, 0.00390625), color.a) * pixelColor.a, pixelColor.a) * qt_Opacity;
                }
                "
            }
            layer.enabled: true
            layer.samplerName: "source"
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
                                 zoneTime: zoneTime,
                                 zoneCityTr: zoneCityTr,
                                 zoneSecs: zoneSecs,
                                 zoneCityFull: zoneCityFull
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
        if  ( cityIsReplaced === "true") {
            return true
        } else {
            return false
        }
    }

    function loadCityList() {
        wipeCityList()
        if (myset.contains("Cities")) {
            var myCities = myset.value("Cities").toString()
            if (myCities !== "") {
                var data
                myCities = myCities.split(",")
                for (var myCity in myCities) {
                    data = timezones.readCityInfo(myCities[myCity],
                                                  mainapp.timeFormat)
                    data = data.split(';')
                    var zoneTime = data[0].replace(/\./g, '')
                    var zoneCity = data[1]
                    var zoneCityFull = zoneCity
                    for (var i = 0; i < 3; i++) {
                        zoneCity = zoneCity.replace(/(.+)\//, "")
                    }
                    var zoneCountry = data[2]
                    var zoneDate = data[3]
                    var zoneUTC = data[4]
                    var zoneSecs = data[5]
                    var zoneCityTr = data[6]

                    appendCity(zoneTime, zoneCityTr, zoneSecs, zoneCityFull)
                }
            }
        }
        var customdata = mainapp.myAliases.split('\n')
        for (var i = 0; i < customdata.length - 1; i++) {
            var myCity = customdata[i].split("|")[1]
            data = timezones.readCityInfo(customdata[i].split("|")[0],
                                          mainapp.timeFormat)
            data = data.split(';')
            var zoneTime = data[0].replace(/\./g, '')
            var zoneCity = data[1]
            var zoneCityFull = zoneCity
            for (var x = 0; x < 3; x++) {
                zoneCity = zoneCity.replace(/(.+)\//, "")
            }
            zoneCity = myCity
            var zoneCountry = data[2]
            var zoneDate = data[3]
            var zoneUTC = data[4]
            var zoneSecs = data[5]
            var zoneCityTr = data[6]

            if (zoneCityFull === mainapp.localContinent + "/" + mainapp.localCity
                    && myset.value("hidelocal") === "true") {
                if (!replaceLocalCity(zoneCity)) {
                    appendCity(zoneTime, zoneCity, zoneSecs, zoneCityFull)
                }
            } else {
                appendCity(zoneTime, zoneCity, zoneSecs, zoneCityFull)
            }
        }
    }

    function updateTime() {
        var data
        for (var i = 0; i < cityListModel.count; ++i) {
            data = timezones.readCityTime(cityListModel.get(i).zoneCityFull,
                                          mainapp.timeFormat)
            data = data.split(';')
            var zoneTime = data[0].replace(/\./g, '')
            cityListModel.setProperty(i, "zoneTime", zoneTime)
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
