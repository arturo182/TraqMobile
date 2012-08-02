import QtQuick 1.1
import com.nokia.symbian 1.1
import "theme.js" as Theme
import "database.js" as Database

BasePage {
    id: root
    headerText: "Settings"

    onVisibleChanged: {
        themeList.focus = true;
        errorText.text = "";
    }

    tools: ToolBarLayout {
        ToolButton {
            text: "Save"
            onClicked: pageStack.pop()
        }

        ToolButton {
            text: "Cancel"
            onClicked: pageStack.pop()
        }
    }

    Flickable {
        id: formFlickable
        clip: true
        contentHeight: formColumn.height * 1.2
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: parent
        anchors.topMargin: Theme.sizes.headerHeight

        Column {
            id: formColumn
            anchors.topMargin: 25
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            spacing: 6
            anchors.margins: 25

            Rectangle {
                id: errorRectangle
                width: parent.width * 0.8
                height: errorText.height + errorText.anchors.topMargin * 2
                color: Theme.colors["default"].errorBackground
                visible: (errorText.text != "")
                border.width: 2
                border.color: Theme.colors["default"].errorBorder
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: errorText
                    color: Theme.colors["default"].errorText
                    anchors.topMargin: 5
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    wrapMode: Text.WordWrap
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: parent.top
                    font.pixelSize: Theme.fonts.big
                }
            }

            Text {
                id: themeLabel
                color: Theme.colors["default"].listItemText
                text: "Theme:"
            }
            SelectionListItem {
                id: themeList
                width: parent.width
                title: (themeDialog.selectedIndex >= 0) ? themeDialog.model.get(themeDialog.selectedIndex).name : "Please select"
                platformInverted: true

                onClicked: themeDialog.open()

                SelectionDialog {
                    id: themeDialog
                    titleText: "Select one of the values"
                    selectedIndex: (Database.setting("theme") == "default") ? 0 : -1
                    model: ListModel {
                        ListElement { name: "default" }
                    }
                }
            }
        }
    }
}
