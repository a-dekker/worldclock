import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.worldclock.TimeZone 1.0
import "../components"

Page {
    id: page
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
                                 country: data[i].replace(/_/g, " ")
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
                value: searchField.text.toLowerCase().trim()
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

        delegate: Item {
            id: cityListItem

            height: contentItem.visible ? contentItem.height : 0
            width: ListView.view.width

            function containString(countryName) {
                var retVal = false
                if (searchString.length > 0) {
                    retVal = retVal || countryName.toLowerCase().indexOf(
                                searchString) !== -1
                    return retVal
                } else {
                    return true
                }
            }
            CountryItem {
                id: contentItem
                width: parent.width
                countryName: country
                anchors.leftMargin: Theme.paddingSmall

                visible: containString(countryName)

                onClicked: {
                    searchField.text = ""
                    mainapp.city_id = countryName.replace(/ /g, "_")
                    pageStack.pop()
                }
            }
        }
    }
}
