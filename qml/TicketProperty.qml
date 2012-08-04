import QtQuick 1.1

Item {
    property alias image: image.source
    property alias text: text.text

    id: root

    visible: (text.text != "")
    height: text.height

    TraqTheme { id: theme }

    Image {
        id: image
        smooth: true
        width: 15
        height: 15
    }

    Text {
        id: text

        color: theme.color.lightText
        font.bold: true
        font.pixelSize: theme.font.small
        anchors.left: image.right
        anchors.leftMargin: theme.padding.small
        anchors.top: image.top
        anchors.bottom: image.bottom
        verticalAlignment: Text.AlignVCenter
    }
}
