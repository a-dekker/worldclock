import QtQuick 2.2
import Sailfish.Silica 1.0

BackgroundItem {
    id: background
    width: parent.width
    property alias countryName: countryName.text
    property string countryNameOrg: countryOrg
    property bool largeScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge

    anchors {
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
    Image {
        id: countryFlag
        anchors.verticalCenter: parent.verticalCenter
        height: 41
        width: 71
        source: countryOrg === "" ? "" : countryOrg === "Default"
                                    && isLightTheme ? '../images/Default_lighttheme.png' : '../images/' + countryOrg + '.png'
        visible: isLandscape || largeScreen
    }
    Label {
        id: countryName
        textFormat: Text.StyledText
        color: background.down ? Theme.highlightColor : Theme.primaryColor
        font.pixelSize: Theme.fontSizeSmall
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: isPortrait
                      && !largeScreen ? parent.left : countryFlag.right
        anchors.leftMargin: isPortrait && !largeScreen ? 0 : Theme.paddingSmall
        anchors.right: parent.right
        anchors.rightMargin: Theme.paddingSmall
        truncationMode: TruncationMode.Fade
        opacity: (index & 1) ? 0.9 : 1
    }
}
