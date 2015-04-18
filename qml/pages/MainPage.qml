import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.worldclock.Launcher 1.0
import harbour.worldclock.TimeZone 1.0
import harbour.worldclock.Settings 1.0

Page {
    id: page

    RemorsePopup {
        id: remorse
    }

    Popup {
        id: banner
    }

    App {
        id: bar
    }

    MySettings {
        id: myset
    }

    property string local_city

    onStatusChanged: {
        if (status == PageStatus.Activating) {
            if (mainapp.city_id == "fromsettings") {
                myset.sync() // else skrewed up??
                sortModel()
                mainapp.city_id = ""
            }
            if (mainapp.city_id != "") {
                mainapp.city_id = mainapp.city_id.replace(/(.+)\(/, "")
                mainapp.city_id = mainapp.city_id.replace(")", "")
                var data
                data = timezones.readCityInfo(mainapp.city_id,mainapp.timeFormat)
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

                var allcities
                if (myset.contains("Cities")) {
                    allcities = myset.value("Cities").toString()
                    allcities = allcities.split(",")

                    if (allcities.indexOf(mainapp.city_id) >= 0) {
                        banner.notify("City already added")
                    } else {
                        appendList(zoneTime, zoneCity, zoneCountry, zoneDate,
                                   zoneUTC, zoneCityFull, zoneSecs)
                        if (allcities == "") {
                            allcities = mainapp.city_id
                        } else {
                            allcities = allcities + ',' + mainapp.city_id
                        }
                        myset.setValue("Cities", allcities)
                        myset.sync()
                        sortModel()
                    }
                } else {
                    allcities = mainapp.city_id
                    appendList(zoneTime, zoneCity, zoneCountry, zoneDate,
                               zoneUTC, zoneCityFull, zoneSecs)
                    myset.setValue("Cities", allcities)
                    myset.sync()
                }
            }
            if (myset.value("hidelocal") == "true") {
                hideLocalCity(local_city)
            }
            mainapp.city_id = ""
        }
        if (status == PageStatus.Active) {
            // if the activation was started by the covers add function
            if (mainapp.coverAddZone == true) {
                pageStack.push(Qt.resolvedUrl("Timezone.qml"))
                pageStack.completeAnimation()
                mainapp.coverAddZone = false
            }
        }
    }

    function updateTime() {
        var data
        for (var i = 0; i < listCityModel.count; ++i) {
            if (listCityModel.get(i).zoneCountry == "Local time") {
                data = timezones.readLocalTime(mainapp.timeFormat)
            } else {
                data = timezones.readCityTime(listCityModel.get(i).zoneCityFull,mainapp.timeFormat)
            }
            data = data.split(';')
            var zoneTime = data[0]
            var zoneDate = data[1]
            listCityModel.set(i, {
                                  zoneTime: zoneTime,
                                  zoneDate: zoneDate
                              })
        }
    }

    function hideLocalCity(currentCity) {
        var n
        var i
        for (n = 0; n < listCityModel.count; n++)
            if (listCityModel.get(n).zoneCity == currentCity
                    && listCityModel.get(n).zoneCityFull != "") {
                for (i = 0; i < listCityModel.count; i++)
                    if (listCityModel.get(i).zoneCity == currentCity
                            && listCityModel.get(i).zoneCityFull == "") {
                        listCityModel.remove(i)
                    }
            }
    }

    function sortModel() {
        var sortorder = myset.value("sortorder")
        // 0 = non;1 = time;2 = city
        var n
        var i
        if (sortorder == 1) {
            // date/time based
            for (n = 0; n < listCityModel.count; n++)
                for (i = n + 1; i < listCityModel.count; i++) {
                    if (+listCityModel.get(n).zoneSecs > +listCityModel.get(
                                i).zoneSecs) {
                        listCityModel.move(i, n, 1)
                        n = 0
                    }
                }
        }
        if (sortorder == 2) {
            // cityname based
            for (n = 0; n < listCityModel.count; n++)
                for (i = n + 1; i < listCityModel.count; i++) {
                    if (listCityModel.get(n).zoneCity > listCityModel.get(
                                i).zoneCity) {
                        listCityModel.move(i, n, 1)
                        n = 0
                    }
                }
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
        running: true
    }

    // helper function to add lists to the list
    function appendList(zoneTime, zoneCity, zoneCountry, zoneDate, zoneUTC, zoneCityFull, zoneSecs) {
        listCityModel.append({
                                 zoneTime: zoneTime,
                                 zoneCity: zoneCity,
                                 zoneCountry: zoneCountry,
                                 zoneDate: zoneDate,
                                 zoneUTC: zoneUTC,
                                 zoneCityFull: zoneCityFull,
                                 zoneSecs: zoneSecs
                             })
    }

    QtObject {
        id: local_datetime
        property var locale: Qt.locale()
        property date currentDateTime: new Date()
        property string timezone: currentDateTime.toLocaleString(locale, "t")
        property string local_date: currentDateTime.toLocaleString(
                                        locale, "ddd MMM d yyyy")
        property string local_utc_offset: currentDateTime.getTimezoneOffset()
        property string local_time: currentDateTime.toLocaleString(locale,
                                                                   "hh:mm")
    }

    Image {
        id: coverBgImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/earth.png"
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingPage.qml"))
            }
            MenuItem {
                text: qsTr("Add city")
                onClicked: pageStack.push(Qt.resolvedUrl("Timezone.qml"))
            }
        }

        TZ {
            id: timezones
        }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        SilicaListView {
            id: listCity
            width: parent.width
            height: parent.height
            anchors.fill: parent
            header: PageHeader {
                width: listCity.width
                title: "Worldclock"
            }
            VerticalScrollDecorator {
                VerticalScrollDecorator {
                    flickable: listCity
                }
            }
            model: ListModel {
                id: listCityModel
            }

            delegate: ListItem {
                id: listCityItem
                menu: contextMenu
                ListView.onRemove: animateRemoval(listCityItem)

                // helper function to remove current item
                function remove() {
                    // run remove via a silica remorse item
                    remorseAction("Deleting", function () {
                        var myCities = myset.value("Cities").toString()
                        var myCitiesNew = myCities
                        if (myset.contains("Cities")) {
                            myCities = myCities.split(",")
                            for (var myCity in myCities) {
                                if (myCities[myCity].indexOf(
                                            listCityModel.get(
                                                index).zoneCity) >= 0) {
                                    // must be removed
                                    myCitiesNew = myCitiesNew.replace(
                                                "," + myCities[myCity], "")
                                    myCitiesNew = myCitiesNew.replace(
                                                myCities[myCity] + ",", "")
                                    myCitiesNew = myCitiesNew.replace(
                                                myCities[myCity], "")
                                    myCitiesNew = myCitiesNew.replace(
                                                /\,[\r\n]/g, "")
                                    myset.setValue("Cities", myCitiesNew)
                                }
                            }
                        }
                        listCity.model.remove(index)
                    })
                }
                // remorse item for all remorse actions
                RemorseItem {
                    id: listRemorse
                }

                Rectangle {
                    id: timeRect
                    width: parent.width
                    height: parent.height
                    color: Theme.primaryColor
                    opacity: 0.05
                    visible: !(index & 1)
                }

                Label {
                    id: timeLabel
                    // append the listnames
                    text: zoneTime
                    font.pixelSize: mainapp.timeFormat == "24" ? Theme.fontSizeLarge : Theme.fontSizeMedium
                    color: Theme.highlightColor
                    width: mainapp.timeFormat == "24" ? parent.width - Theme.paddingLarge * 18 : parent.width - Theme.paddingLarge * 17
                    x: Theme.paddingSmall
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    opacity: (index & 1) ? 0.9 : 1
                }
                Label {
                    id: cityLabel
                    text: zoneCity.replace(/_/g, " ")
                    width: parent.width - Theme.paddingLarge * 9
                    anchors.left: timeLabel.right
                    opacity: (index & 1) ? 0.9 : 1
                }
                Label {
                    anchors.top: cityLabel.bottom
                    text: zoneCountry.replace(/([a-z])([A-Z])/g, "$1 $2")
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: (listCityItem.highlighted || listCityModel.get(
                                index).zoneCountry == "Local time"
                            || listCityModel.get(index).zoneCity
                            == local_city) ? Theme.highlightColor : Theme.secondaryColor
                    anchors.left: timeLabel.right
                    truncationMode: TruncationMode.Fade
                    opacity: (index & 1) ? 0.9 : 1
                }
                Label {
                    id: dateLabel
                    text: zoneDate
                    font.pixelSize: Theme.fontSizeExtraSmall
                    width: parent.width - (timeLabel.width + cityLabel.width + 2
                                           * Theme.paddingSmall)
                    anchors.left: cityLabel.right
                    anchors.rightMargin: Theme.paddingSmall
                    horizontalAlignment: Text.AlignRight
                    opacity: (index & 1) ? 0.9 : 1
                }
                Label {
                    anchors.top: dateLabel.bottom
                    text: zoneUTC
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: (listCityItem.highlighted || listCityModel.get(
                                index).zoneCountry == "Local time"
                            || listCityModel.get(index).zoneCity
                            == local_city) ? Theme.highlightColor : Theme.secondaryColor
                    width: dateLabel.width
                    anchors.left: cityLabel.right
                    anchors.rightMargin: Theme.paddingSmall
                    horizontalAlignment: Text.AlignRight
                    opacity: (index & 1) ? 0.9 : 1
                }
                Component {
                    id: contextMenu
                    ContextMenu {
                        MenuItem {
                            text: "Details"
                            onClicked: {
                                if (listCityModel.get(
                                            index).zoneCountry == "Local time") {
                                    banner.notify("No details for Local time")
                                    //hide()
                                } else {
                                    mainapp.city_id = listCityModel.get(
                                                index).zoneCityFull
                                    pageStack.push(Qt.resolvedUrl(
                                                       "CityDetail.qml"))
                                }
                            }
                        }
                        MenuItem {
                            text: "Remove"
                            onClicked: {
                                if (listCityModel.get(
                                            index).zoneCountry == "Local time") {
                                    hide()
                                    banner.notify("Cannot remove Local time")
                                } else {
                                    remove()
                                }
                            }
                        }
                    }
                }
                onClicked: {
                    if (listCityModel.get(index).zoneCountry != "Local time") {
                        mainapp.city_id = listCityModel.get(index).zoneCityFull
                        pageStack.push(Qt.resolvedUrl("CityDetail.qml"))
                    }
                }
            }

            Component.onCompleted: {
                var offset = new Date().toString().split(" ")[5].replace("GMT",
                                                                         "UTC ")
                offset = offset.substr(0, 7) + ":" + offset.substr(7)
                offset = offset.replace("+0", "+")
                offset = offset.replace("-0", "-")
                offset = offset.replace(":00", "")
                local_city = bar.launch("readlink /var/lib/timed/localtime")
                for (var i = 0; i < 3; i++) {
                    local_city = local_city.replace(/(.+)\//, "").replace(
                                /(\r\n|\n|\r)/gm, "")
                }
                appendList(local_datetime.local_time, local_city, "Local time",
                           local_datetime.local_date,
                           local_datetime.timezone + " (" + offset + ")", "",
                           local_datetime.local_utc_offset)
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

                            appendList(zoneTime, zoneCity, zoneCountry,
                                       zoneDate, zoneUTC,
                                       zoneCityFull, zoneSecs)
                        }
                    }
                }
                timerclock.start()
                if (myset.value("hidelocal") == "true") {
                    hideLocalCity(local_city)
                }
                sortModel()
            }
        }
    }
}
