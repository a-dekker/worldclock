import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem {
    id: background
    width: parent.width
    property alias countryName: countryName.text

    VerticalScrollDecorator { }

    anchors{
        left: parent.left
    }

            Rectangle {
                id: timeRect
                width: parent.width
                height: parent.height
                color: Theme.primaryColor
                opacity: 0.03
                visible: !(index & 1)
            }
    Label {
        id: countryName
        font.pixelSize: Theme.fontSizeSmall
        // color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left; anchors.leftMargin: 0
        anchors.right: parent.right; anchors.rightMargin: Theme.paddingSmall
        truncationMode: TruncationMode.Fade
        opacity: (index & 1) ? 0.9 : 1
    }

}
