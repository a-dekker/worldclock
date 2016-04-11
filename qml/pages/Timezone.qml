import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.worldclock.TimeZone 1.0
import "../components"

Page {
    id: page
    allowedOrientations: Orientation.Portrait | Orientation.Landscape
                         | Orientation.LandscapeInverted
    property bool largeScreen: Screen.sizeCategory === Screen.Large ||
                               Screen.sizeCategory === Screen.ExtraLarge
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
        model: cityModel
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
                var regexp = new RegExp('(^| |/|\\[|\\(|-)' + searchString.replace(/\+/g,'\\+'), 'i')
                if (regexp.test(mycountry)) {
                    return Theme.highlightText(mycountry, regexp,
                                               Theme.highlightColor)
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
