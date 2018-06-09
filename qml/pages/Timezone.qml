import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.worldclock.TimeZone 1.0
import SortFilterProxyModel 0.2
import "../components"

Page {
    id: page
    property bool largeScreen: screen.width >= 1080
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

    PageHeader {
        id: pageHeader
        title: qsTr("Select city")
        anchors.top: parent.top
        width: page.width
    }

    SearchField {
        id: searchField
        anchors.top: pageHeader.bottom
        width: parent.width
        EnterKey.onClicked: {
            searchField.focus = false
        }

        Binding {
            target: page
            property: "searchString"
            value: searchField.text.trim().toLowerCase()
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
        opacity: largeScreen ? 0.5 : 1
    }

    SilicaListView {
        id: cityList
        focus: true
        clip: true
        header: Item {
            id: header
            width: pageHeader.width
            height: pageHeader.height
            Component.onCompleted: pageHeader.parent = header
        }
        width: page.width
        height: page.height
        anchors.top: searchField.bottom
        anchors.bottom: parent.bottom

        model: listUnitProxyModel

        SortFilterProxyModel {
            id: listUnitProxyModel
            sourceModel: cityModel
            filters: RegExpFilter {
                roleName: "country"
                pattern: searchField.text.trim()
                caseSensitivity: Qt.CaseInsensitive
            }
        }

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

            height: contentItem.height
            width: ListView.view.width
            x: isPortrait ? 0 : Theme.paddingMedium

            CountryItem {
                id: contentItem
                width: parent.width
                countryName: Theme.highlightText(country, searchField.text, Theme.highlightColor)
                countryNameOrg: countryOrg
                anchors.leftMargin: Theme.paddingSmall

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
