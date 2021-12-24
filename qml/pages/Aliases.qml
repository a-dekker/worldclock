import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.Timezone 1.0 // not_allowed_in_store
import harbour.worldclock.Settings 1.0
import harbour.worldclock.TimeZone 1.0
import "../localdb.js" as DB

Dialog {
    id: aliasesDialog
    property bool largeScreen: screen.width > 1080
    property bool mediumScreen: (screen.width > 540 && screen.width <= 1080)
    property string isReplace: "false"
    property int currIndex: 0

    TZ {
        id: timezones
    }

    MySettings {
        id: myset
    }

    function appendCustomCity(city, citytr, cityinfo, alias, displayed) {
        customcitylist.model.append({
                                        City: city,
                                        CityTr: citytr,
                                        CityInfo: cityinfo,
                                        Alias: alias,
                                        Displayed: displayed
                                    })
    }

    onStatusChanged: {
        if (status === PageStatus.Activating && mainapp.city_id !== "") {
            // find possible translation
            var data = timezones.readCityInfo(mainapp.city_id,
                                              mainapp.timeFormat)
            data = data.split(';')
            var zoneCityTr = data[6]
            // strip city info
            mainapp.city_id = mainapp.city_id.replace(/(.+)\(/, "")
            mainapp.city_id = mainapp.city_id.replace(")", "")
            // extract cityname
            var cityName = mainapp.city_id.replace(/.+\//, "")
            cityName = cityName.replace(/_/g, " ")
            if (isReplace === "true") {
                customcitylist.model.setProperty(currIndex, "City", cityName)
                customcitylist.model.setProperty(currIndex, "CityTr",
                                                 zoneCityTr)
                customcitylist.model.setProperty(currIndex, "CityInfo",
                                                 mainapp.city_id)
            } else {
                appendCustomCity(cityName, zoneCityTr, mainapp.city_id,
                                 "", "true")
            }
            mainapp.city_id = ""
        }
    }

    DialogHeader {
        id: header
        acceptText: qsTr("Save")
        cancelText: qsTr("Cancel")
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

    SilicaListView {
        id: customcitylist
        anchors.leftMargin: Theme.paddingSmall
        anchors.rightMargin: Theme.paddingSmall
        width: parent.width
        x: isPortrait ? 0 : Theme.paddingMedium
        y: header.height + Theme.paddingMedium
        contentHeight: customcitylist.count * Theme.itemSizeSmall
        height: parent.height - (header.height + Theme.paddingMedium + addButton.height)
        VerticalScrollDecorator {
        }
        model: ListModel {
        }

        function loadcustomcitylist() {
            DB.readAliases()
            // find and add translations from selected locale
            for (var i = 0; i < customcitylist.model.count; ++i) {
                var data = timezones.readCityInfo(customcitylist.model.get(
                                                      i).CityInfo,
                                                  mainapp.timeFormat)
                data = data.split(';')
                var zoneCityTr = data[6]
                customcitylist.model.setProperty(i, "CityTr", zoneCityTr)
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
                    }
                    pageStack.pop()
                }
            }
        }

        Component.onCompleted: {
            loadcustomcitylist()
        }

        delegate: ListItem {
            id: timerItem
            contentHeight: Theme.itemSizeSmall
            ListView.onRemove: animateRemoval(timerItem)

            function remove() {
                remorseAction(qsTr('Deleting'), function () {
                    var idx = index
                    customcitylist.model.remove(idx)
                })
            }

            Item {
                IconButton {
                    id: do_display
                    width: Theme.paddingLarge * 2
                    icon.source: customcitylist.model.get(
                                     index).Displayed === "true" ? "image://theme/icon-m-favorite-selected" : "image://theme/icon-m-favorite"
                    onClicked: {
                        if (customcitylist.model.get(
                                    index).Displayed === "true") {
                            customcitylist.model.setProperty(index,
                                                             'Displayed',
                                                             "false")
                        } else {
                            customcitylist.model.setProperty(index,
                                                             'Displayed',
                                                             "true")
                        }
                    }
                    highlighted: down
                }
                Rectangle {
                    id: littleSpace
                    anchors.left: do_display.right
                    // some whitespace
                    width: largeScreen ? Theme.paddingLarge : Theme.paddingMedium
                    height: 1
                    opacity: 0
                    visible: isLandscape || largeScreen
                }
                Button {
                    id: name
                    text: CityTr
                    anchors.left: isPortrait
                                  && !largeScreen ? do_display.right : littleSpace.right
                    //width: font.pixelSize * 8
                    onClicked: {
                        if (myset.value("city_pickertype", "0") === "0") {
                            pageStack.push(Qt.resolvedUrl("Timezone.qml"))
                        } else {
                            pageStack.push(timezonePickerComponent) // not_allowed_in_store
                        }
                        isReplace = "true"
                        currIndex = index
                    }
                }
                TextField {
                    id: cityalias
                    font.pixelSize: Theme.fontSizeSmall
                    anchors.left: name.right
                    placeholderText: qsTr("Alt. name")
                    text: Alias
                    width: isPortrait ? (largeScreen ? font.pixelSize * 18 : font.pixelSize * 7) : (largeScreen ? font.pixelSize * 30 : font.pixelSize * 20)
                    horizontalAlignment: TextInput.AlignRight
                    maximumLength: 18
                    onTextChanged: {
                        customcitylist.model.setProperty(index, 'Alias', text)
                    }
                    EnterKey.onClicked: {
                        cityalias.focus = false
                    }
                }
                IconButton {
                    id: trashIcon
                    anchors.left: cityalias.right
                    icon.source: 'image://theme/icon-m-delete'
                    onClicked: remove()
                }
            }
        }
        VerticalScrollDecorator {
            flickable: customcitylist
        }
        ViewPlaceholder {
            enabled: customcitylist.count === 0
            text: qsTr('No custom city names defined. Press the plus button to add one.')
        }
    }
    IconButton {
        id: addButton
        anchors.top: customcitylist.bottom
        anchors.right: customcitylist.right
        anchors.rightMargin: Theme.paddingMedium
        icon.source: largeScreen ? 'image://theme/icon-l-add' : 'image://theme/icon-m-add'
        visible: customcitylist.count < 20
        onClicked: {
            if (myset.value("city_pickertype", "0") === "0") {
                pageStack.push(Qt.resolvedUrl("Timezone.qml"))
            } else {
                pageStack.push(timezonePickerComponent) // not_allowed_in_store
            }
            isReplace = "false"
            customcitylist.positionViewAtEnd()
        }
    }

    onDone: {
        mainapp.city_id = ""
        console.log('Done:', (result === DialogResult.Accepted))
        if (result === DialogResult.Accepted) {
            // first delete every Alias record
            mainapp.city_id = "fromaliases"
            DB.removeAllAliases()
            // Then loop through current list and save
            for (var i = 0; i < customcitylist.model.count; ++i) {
                if (customcitylist.model.get(i).Alias !== "") {
                    DB.writeAlias(customcitylist.model.get(i).CityInfo,
                                  customcitylist.model.get(i).City,
                                  customcitylist.model.get(i).Alias.trim(),
                                  customcitylist.model.get(i).Displayed)
                }
            }
        }
    }
}
