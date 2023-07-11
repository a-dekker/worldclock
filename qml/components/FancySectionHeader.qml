import QtQuick 2.5
import Sailfish.Silica 1.0

Item {
    property alias text: header.text
    property alias iconSource: image.source

    width: parent.width
    height: header.height
    x: Theme.paddingSmall

    Label {
        id: header
        width: parent.width - (image.visible ? image.width + Theme.paddingLarge
                                               + Theme.paddingMedium : 0)
        elide: Text.ElideRight
        truncationMode: TruncationMode.Fade
        horizontalAlignment: Text.AlignRight
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeSmall
    }

    Image {
        id: image
        visible: source.toString()
        anchors {
            verticalCenter: header.verticalCenter
            left: header.right
            rightMargin: Theme.paddingLarge
            leftMargin: Theme.paddingMedium
        }
        width: Theme.iconSizeLauncher
        height: Theme.iconSizeLauncher
        fillMode: Image.PreserveAspectFit
    }
}
