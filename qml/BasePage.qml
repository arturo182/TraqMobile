import QtQuick 1.1
import com.nokia.symbian 1.1
import "database.js" as Database

Page {
    property alias headerText: headerTxt.text
    property alias theme: themeInst

    id: root

    TraqTheme { id: themeInst }

    Rectangle {
        id: backgroundRectangle
        color: theme.color.pageBackground
        anchors.top: headerRectangle.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
    }

    Rectangle {
        id: headerRectangle
        height: theme.size.headerHeight
        color: theme.color.headerBackground
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left

        Text {
            id: headerTxt
            elide: Text.ElideRight
            color: theme.color.headerText
            anchors.leftMargin: theme.padding.large
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pixelSize: theme.font.large
        }
    }
}
