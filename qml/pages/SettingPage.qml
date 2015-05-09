import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.worldclock.Settings 1.0

Dialog {
    id: page
    canAccept: true

    onAccepted: {
        myset.setValue("sortorder", sorting.currentIndex)
        myset.setValue("sortorder_completeList", citylist_sorting.currentIndex)
        myset.setValue("hidelocal", localdisplay.checked)
        myset.sync()
        mainapp.city_id = "fromsettings"
    }

    objectName: "SettingPage"

    Image {
        id: coverBgImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "../images/earth.png"
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        MySettings {
            id: myset
        }

        clip: true

        ScrollDecorator {
        }

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            DialogHeader {

                acceptText: qsTr("Save")
                cancelText: qsTr("Cancel")
            }
            SectionHeader {
                text: qsTr("Settings")
            }

            ComboBox {
                id: sorting
                width: parent.width
                label: qsTr("Sort order") + ":"
                description: qsTr("Sort order of personal list")
                currentIndex: myset.value("sortorder")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("None") // 0
                    }
                    MenuItem {
                        text: qsTr("TimeZone") // 1
                    }
                    MenuItem {
                        text: qsTr("City") //2
                    }
                }
            }
            ComboBox {
                id: citylist_sorting
                width: parent.width
                label: qsTr("Sort order list") + ":"
                description: qsTr("Sort order of complete citylist")
                currentIndex: myset.value("sortorder_completeList")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Continent/City") // 0
                    }
                    MenuItem {
                        text: qsTr("TimeZone/Continent/City") // 1
                    }
                    MenuItem {
                        text: qsTr("City") // 2
                    }
                    MenuItem {
                        text: qsTr("Country") // 3
                    }
                }
            }

            TextSwitch {
                id: localdisplay
                width: parent.width
                text: qsTr("Hide if current")
                description: qsTr("Hide localtime if city is present and current")
                checked: myset.value("hidelocal") == "true"
            }
        }
    }
}
