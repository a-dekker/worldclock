import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.Timezone 1.0
// not_allowed_in_store
import harbour.worldclock.TimeZone 1.0
import harbour.worldclock.Settings 1.0
import Nemo.Notifications 1.0
import "../localdb.js" as DB

Page {
    id: mainpage
    property bool largeScreen: screen.width > 1080
    property bool mediumScreen: (screen.width > 540 && screen.width <= 1080)
    property bool smallScreen: (screen.width <= 540)

    RemorsePopup {
        id: remorse
    }

    MySettings {
        id: myset
    }

    property string local_city_tr

    function loadData() {
        var offset = new Date().toString().split(" ")[5].replace("GMT", "UTC ")
        offset = offset.substr(0, 7) + ":" + offset.substr(7)
        offset = offset.replace("+0", "+")
        offset = offset.replace("-0", "-")
        offset = offset.replace(":00", "")

        // Check if local city is translated
        var data = timezones.readCityInfo(localContinent + "/" + localCity,
                                          mainapp.timeFormat)
        data = data.split(';')
        local_city_tr = data[6]
        zoneCountryOrg = data[7]

        mainapp.localCityTr = local_city_tr
        // add city as localtime
        appendList(local_datetime.local_time, localCity, "local_time",
                   local_datetime.local_date,
                   local_datetime.timezone + " (" + offset + ")", "",
                   local_datetime.local_utc_offset, local_city_tr,
                   zoneCountryOrg)

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
                    var zoneCountryOrg = data[7]

                    appendList(zoneTime, zoneCity, zoneCountry, zoneDate,
                               zoneUTC, zoneCityFull, zoneSecs, zoneCityTr,
                               zoneCountryOrg)
                }
            }
        }
        // load alias values
        DB.readActiveAliases()
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
            zoneCityTr = myCity
            var zoneCountry = data[2]
            var zoneDate = data[3]
            var zoneUTC = data[4]
            var zoneSecs = data[5]
            var zoneCountryOrg = data[7]

            if (zoneCityFull === localContinent + "/" + localCity
                    && myset.value("hidelocal") === "true") {
                replaceLocalCity(zoneCity)
            } else {
                // localContinent
                appendList(zoneTime, zoneCity, zoneCountry, zoneDate, zoneUTC,
                           zoneCityFull, zoneSecs, zoneCityTr, zoneCountryOrg)
            }
        }
    }

    function storeCity() {
        if (mainapp.city_id !== "") {
            // read info
            var data = timezones.readCityInfo(mainapp.city_id,
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
            var zoneCountryOrg = data[7]

            var allcities
            if (myset.contains("Cities")) {
                allcities = myset.value("Cities").toString()
                allcities = allcities.split(",")

                if (allcities.indexOf(mainapp.city_id) >= 0) {
                    banner("ERROR", qsTr("City already added"))
                } else {
                    appendList(zoneTime, zoneCity, zoneCountry, zoneDate,
                               zoneUTC, zoneCityFull, zoneSecs, zoneCityTr,
                               zoneCountryOrg)
                    if (allcities === "") {
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
                appendList(zoneTime, zoneCity, zoneCountry, zoneDate, zoneUTC,
                           zoneCityFull, zoneSecs, zoneCityTr)
                myset.setValue("Cities", allcities)
                myset.sync()
            }
        }
    }

    Component.onCompleted: {
        DB.initializeDB()
        loadData()
        sortModel()
        timerclock.start()
        // if (myset.value("hidelocal") === "true") {
        //     hideLocalCity(localCity)
        // }
    }

    Component.onDestruction: notification.close()

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            if (mainapp.city_id === "fromsettings") {
                myset.sync() // else screwed up??
                listCityModel.clear()
                loadData()
                sortModel()
                // if (myset.value("hidelocal") === "true") {
                //     hideLocalCity(localCity)
                // }
                mainapp.city_id = ""
            }
            if (mainapp.city_id === "fromaliases") {
                // accepted, cleanup current listmodel
                listCityModel.clear()
                loadData()
                sortModel()
                mainapp.city_id = ""
            }
            storeCity()
            mainapp.city_id = ""
        }
    }

    function banner(notificationType, message) {
        notification.close()
        var notificationCategory
        switch (notificationType) {
        case "OK":
            notificationCategory = "x-jolla.store.sideloading-success"
            break
        case "INFO":
            notificationCategory = "x-jolla.lipstick.credentials.needUpdate.notification"
            break
        case "WARNING":
            notificationCategory = "x-jolla.store.error"
            break
        case "ERROR":
            notificationCategory = "x-jolla.store.error"
            break
        }
        notification.category = notificationCategory
        notification.previewBody = message
        notification.publish()
    }

    Notification {
        id: notification
        itemCount: 1
    }

    function updateTime() {
        var data
        for (var i = 0; i < listCityModel.count; ++i) {
            if (listCityModel.get(i).zoneCountry === "local_time") {
                data = timezones.readLocalTime(mainapp.timeFormat)
            } else {
                data = timezones.readCityTime(listCityModel.get(
                                                  i).zoneCityFull,
                                              mainapp.timeFormat)
            }
            data = data.split(';')
            var zoneTime = data[0].replace(/\./g, '')
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
            if (listCityModel.get(n).zoneCity === currentCity
                    && listCityModel.get(n).zoneCityFull !== "") {
                for (i = 0; i < listCityModel.count; i++)
                    if (listCityModel.get(i).zoneCity === currentCity
                            && listCityModel.get(i).zoneCityFull === "") {
                        listCityModel.remove(i)
                    }
            }
    }

    function replaceLocalCity(aliasCity) {
        var n
        for (n = 0; n < listCityModel.count; n++)
            if (listCityModel.get(n).zoneCity === localCity) {
                listCityModel.setProperty(n, "zoneCityTr", aliasCity)
            }
    }

    function sortModel() {
        var sortorder = myset.value("sortorder")
        // 0 = non;1 = time;2 = city
        var n
        var i
        if (sortorder === "1") {
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
        if (sortorder === "2") {
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
    function appendList(zoneTime, zoneCity, zoneCountry, zoneDate, zoneUTC, zoneCityFull, zoneSecs, zoneCityTr, zoneCountryOrg) {
        listCityModel.append({
                                 zoneTime: zoneTime,
                                 zoneCity: zoneCity,
                                 zoneCountry: zoneCountry,
                                 zoneDate: zoneDate,
                                 zoneUTC: zoneUTC,
                                 zoneCityFull: zoneCityFull,
                                 zoneSecs: zoneSecs,
                                 zoneCityTr: zoneCityTr,
                                 zoneCountryOrg: zoneCountryOrg
                             })
    }

    function isLongAMPM() {
        if (mainapp.timeFormat === "12") {
            switch (parseInt(myset.value("language"))) {
            case Languages.DE:
                // German
                return true
            case Languages.RU:
                // Russian
                return true
            default:
                return false
            }
        } else {
            return false
        }
    }

    function isArabic() {
        // as it from right to left we use another width for fading
        switch (parseInt(myset.value("language"))) {
        case Languages.AR:
            return true
        default:
            return false
        }
    }

    QtObject {
        id: local_datetime
        property var locale: Qt.locale("en_US")
        property date currentDateTime: new Date()
        property string timezone: currentDateTime.toLocaleString(locale, "t")
        property string local_date: currentDateTime.toLocaleString(
                                        locale, "ddd MMM d yyyy")
        // javascript has it just the other way around: negative = +UTC
        property string local_utc_offset: -currentDateTime.getTimezoneOffset()
        property string local_time: currentDateTime.toLocaleString(locale,
                                                                   "hh:mm")
    }

    HighlightImage {
        id: coverBgImage
        color: Theme.primaryColor
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/earth.png"
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        opacity: largeScreen || mediumScreen ? 0.5 : 1
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
                text: qsTr("Custom city names")
                onClicked: pageStack.push(Qt.resolvedUrl("Aliases.qml"))
            }
            MenuItem {
                text: qsTr("Add city")
                onClicked: if (myset.value("city_pickertype", "0") === "0") {
                               pageStack.push(Qt.resolvedUrl("Timezone.qml"))
                           } else {
                               pageStack.push(
                                           timezonePickerComponent) // not_allowed_in_store
                           }
            }
        }
        // not_allowed_in_store
        Component {
            id: timezonePickerComponent
            TimezonePicker {
                onTimezoneClicked: {
                    console.log(name)
                    if (name !== "") {
                        mainapp.city_id = name
                        storeCity()
                        mainapp.city_id = ""
                    }
                    pageStack.pop()
                }
            }
        }

        TZ {
            id: timezones
        }

        // Place our content in a Column. The PageHeader is always placed at the top
        // of the page, followed by our content.
        SilicaListView {
            id: listCity
            width: parent.width
            height: parent.height
            // anchors.fill: parent
            header: PageHeader {
                width: listCity.width
                title: qsTr("Worldclock")
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

                // helper function to remove current item
                function remove() {
                    // run remove via a silica remorse item
                    remorseAction(qsTr("Deleting") + " '" + listCityModel.get(
                                      index).zoneCityTr + "'", function () {
                                          var isReplaced = "false"
                                          var myCities = myset.value(
                                                      "Cities").toString()
                                          var myCitiesNew = myCities
                                          if (myset.contains("Cities")) {
                                              myCities = myCities.split(",")
                                              for (var myCity in myCities) {
                                                  if (myCities[myCity].indexOf(
                                                              listCityModel.get(
                                                                  index).zoneCity) >= 0) {
                                                      // must be removed
                                                      myCitiesNew = myCitiesNew.replace(
                                                                  "," + myCities[myCity],
                                                                  "")
                                                      myCitiesNew = myCitiesNew.replace(
                                                                  myCities[myCity] + ",",
                                                                  "")
                                                      myCitiesNew = myCitiesNew.replace(
                                                                  myCities[myCity],
                                                                  "")
                                                      myCitiesNew = myCitiesNew.replace(
                                                                  /\,[\r\n]/g,
                                                                  "")
                                                      myset.setValue(
                                                                  "Cities",
                                                                  myCitiesNew)
                                                      isReplaced = "true"
                                                  }
                                              }
                                              if (isReplaced === "false") {
                                                  banner("WARNING", qsTr(
                                                             "Manage custom cities on other page"))
                                              } else {
                                                  listCity.model.remove(index)
                                              }
                                          }
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
                    id: timeLabel_split
                    // append the listnames
                    text: zoneTime.split(" ")[0]
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.highlightColor
                    width: parent.width - Theme.paddingLarge * 17
                    x: Theme.paddingSmall
                    font.bold: true
                    opacity: (index & 1) ? 0.9 : 1
                    visible: isLongAMPM()
                }
                Label {
                    anchors.top: timeLabel_split.bottom
                    text: zoneTime.replace(zoneTime.split(" ")[0], "")
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.highlightColor
                    width: parent.width - Theme.paddingLarge * 17
                    x: Theme.paddingSmall
                    truncationMode: TruncationMode.Fade
                    opacity: (index & 1) ? 0.9 : 1
                    visible: isLongAMPM()
                }
                Label {
                    id: timeLabel
                    // append the listnames
                    text: zoneTime
                    font.pixelSize: mainapp.timeFormat
                                    === "24" ? Theme.fontSizeLarge : Theme.fontSizeMedium
                    color: Theme.highlightColor
                    width: mainapp.timeFormat === "24" ? (smallScreen
                                                          && isPortrait ? parent.width / 5 : parent.width / 6) : (smallScreen && isPortrait ? parent.width / 4.5 : parent.width / 5)
                    x: Theme.paddingSmall
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    opacity: (index & 1) ? 0.9 : 1
                    visible: !isLongAMPM()
                }
                Image {
                    id: countryFlag
                    anchors.left: timeLabel.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: largeScreen ? 82 : (mediumScreen ? 76 : 41)
                    width: largeScreen ? 142 : (mediumScreen ? 122 : 71)
                    source: zoneCountryOrg === "Default" && isLightTheme ? '../images/Default_lighttheme.png' : '../images/' + zoneCountryOrg + '.png'
                    visible: isLandscape || largeScreen || mediumScreen
                }
                Rectangle {
                    // some whitespace
                    id: extraImgSpace
                    width: Theme.paddingMedium
                    anchors.left: countryFlag.right
                    height: 1
                    opacity: 0
                    visible: isLandscape || largeScreen
                }
                Label {
                    id: cityLabel
                    text: zoneCityTr.replace(/_/g, " ")
                    width: isPortrait ? parent.width
                                        * (isArabic()
                                           || mediumScreen ? 0.40 : 0.50) : parent.width * 0.50
                    anchors.left: isPortrait && !largeScreen
                                  && !mediumScreen ? timeLabel.right : extraImgSpace.right
                    opacity: (index & 1) ? 0.9 : 1
                    truncationMode: TruncationMode.Fade
                }
                Label {
                    id: countryLabel
                    anchors.top: cityLabel.bottom
                    text: zoneCountry.replace("local_time", qsTr("Local time"))
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: (listCityItem.highlighted || listCityModel.get(
                                index).zoneCountry === "local_time"
                            || listCityModel.get(index).zoneCity
                            === localCity) ? Theme.highlightColor : Theme.secondaryColor
                    anchors.left: isPortrait && !largeScreen
                                  && !mediumScreen ? timeLabel.right : extraImgSpace.right
                    width: cityLabel.width
                    truncationMode: TruncationMode.Fade
                    opacity: (index & 1) ? 0.9 : 1
                }
                Label {
                    id: dateLabel
                    text: zoneDate
                    font.pixelSize: Theme.fontSizeExtraSmall
                    width: parent.width
                           - (Theme.paddingSmall * 4 + timeLabel.width
                              + (isPortrait
                                 && smallScreen ? -Theme.paddingMedium : countryFlag.width)
                              + cityLabel.width)
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
                                index).zoneCountry === "local_time"
                            || listCityModel.get(index).zoneCity
                            === localCity) ? Theme.highlightColor : Theme.secondaryColor
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
                            text: qsTr("Details")
                            onClicked: {
                                if (listCityModel.get(
                                            index).zoneCountry === "local_time") {
                                    mainapp.city_id = localContinent + "/" + localCity
                                    pageStack.push(Qt.resolvedUrl(
                                                       "CityDetail.qml"))
                                } else {
                                    mainapp.city_id = listCityModel.get(
                                                index).zoneCityFull
                                    pageStack.push(Qt.resolvedUrl(
                                                       "CityDetail.qml"))
                                }
                            }
                        }
                        MenuItem {
                            text: qsTr("Remove")
                            onClicked: {
                                if (listCityModel.get(
                                            index).zoneCountry === "local_time") {
                                    close()
                                    banner("ERROR",
                                           qsTr("Cannot remove Local time"))
                                } else {
                                    remove()
                                }
                            }
                        }
                    }
                }
                onClicked: {
                    if (listCityModel.get(index).zoneCountry === "local_time") {
                        mainapp.city_id = localContinent + "/" + localCity
                    } else {
                        mainapp.city_id = listCityModel.get(index).zoneCityFull
                    }
                    pageStack.push(Qt.resolvedUrl("CityDetail.qml"))
                }
            }
        }
    }
}
