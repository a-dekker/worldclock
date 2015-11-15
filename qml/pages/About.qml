import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage
    allowedOrientations: Orientation.Portrait | Orientation.Landscape | Orientation.LandscapeInverted
    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {
        }

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: qsTr("About")
            }
            SectionHeader {
                text: qsTr("Info")
                visible: isPortrait
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: isPortrait
            }
            Label {
                text: "Worldclock"
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: 80
                height: width
                radius: 100
                anchors.horizontalCenter: parent.horizontalCenter
                NumberAnimation on rotation {
                    from: 0
                    to: 360
                    duration: 5000
                    loops: 1
                }
                Image {
                    source: "/usr/share/icons/hicolor/86x86/apps/harbour-worldclock.png"
                }
            }
            Label {
                text: qsTr("Version") + " " + version
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryHighlightColor
            }
            Label {
                text: qsTr("City times across the world")
                font.pixelSize: Theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
            }
            SectionHeader {
                text: qsTr("Author")
                visible: isPortrait
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: isPortrait
            }
            Label {
                text: "© Arno Dekker 2015"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                x: Theme.paddingLarge
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeTiny
                text: "Countryflags thanks to <a href='#'>free-country-flags.com</a>"
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(
                                     "http://www.free-country-flags.com/index.php")
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
