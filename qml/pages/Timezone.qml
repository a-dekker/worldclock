import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.worldclock.TimeZone 1.0
import "../components"

Page {
    id: page
    allowedOrientations: Orientation.Portrait | Orientation.Landscape
                         | Orientation.LandscapeInverted
    property string searchString

    TZ {
        id: timezones
    }

    function addCity() {
        var data
        data = timezones.readAllCities()
        data = data.split('\n')
        for (var i = 0; i < data.length; i++) {
            cityModel.append({
                                 country: data[i].replace(/_/g,
                                                          " ").replace(/\;.*/,
                                                                       ''),
                                 zoneInfo: data[i].replace(/(.+)\]\;/,
                                                           '').replace(/\;.*/,
                                                                       ''),
                                 countryOrg: data[i].replace(/(.+)\;/, '')
                             })
        }
    }

    Component.onCompleted: {
        addCity()
    }

    ListModel {
        id: cityModel
    }

    Column {
        id: headerContainer

        width: page.width

        PageHeader {
            title: qsTr("Select city")
        }

        SearchField {
            id: searchField
            width: parent.width

            Binding {
                target: page
                property: "searchString"
                value: searchField.text.trim().toLowerCase()
            }
        }
    }

    /**************************************************************************
     * Header for section
     *************************************************************************/
    Component {
        id: sectionHeading
        Rectangle {
            width: page.width
            height: 0
            color: Theme.highlightColor
            anchors.leftMargin: Theme.paddingSmall
            visible: false
            Text {
                text: section
                font.bold: true
                visible: false
            }
        }
    }

    Image {
        id: coverBgImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/earth.png"
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
    }

    SilicaListView {
        id: cityList
        focus: true
        model: cityModel
        header: Item {
            id: header
            width: headerContainer.width
            height: headerContainer.height
            Component.onCompleted: headerContainer.parent = header
        }
        width: page.width
        height: page.height
        anchors.top: parent.top
        x: isPortrait ? 0 : Theme.paddingMedium

        Connections {
            target: searchField.activeFocus ? cityList : null
            ignoreUnknownSignals: true
            onContentYChanged: {
                if (cityList.contentY > (Screen.height / 2)) {
                    searchField.focus = false
                }
            }
        }

        delegate: Item {
            id: cityListItem

            // height is performance bottleneck
            height: contentItem.visible ? contentItem.height : 0
            width: ListView.view.width

            function findString(mycountry) {
                if (searchString.length === 0) {
                    return mycountry
                }
                var regexp = new RegExp('\\b' + searchString, 'i')
                if (regexp.test(mycountry)) {
                    return Theme.highlightText(mycountry, regexp, Theme.highlightColor)
                } else {
                    // record not in search result
                    return "X"
                }
            }

            CountryItem {
                id: contentItem
                width: parent.width
                countryName: findString(country)
                countryNameOrg: countryOrg
                anchors.leftMargin: Theme.paddingSmall

                visible: countryName !== "X"

                onClicked: {
                    searchField.text = ""
                    mainapp.city_id = zoneInfo.replace(/ /g, "_")
                    // ex. Pacific/Rarotonga
                    pageStack.pop()
                }
            }
        }
         VerticalScrollDecorator {}
    }
}
