import QtQuick 1.1
import com.nokia.symbian 1.1
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
        anchors.topMargin: theme.padding.large

        Column {
            id: formColumn
            anchors.topMargin: theme.padding.large
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            spacing: 6
            anchors.margins: theme.padding.large

            Rectangle {
                id: errorRectangle
                width: parent.width * 0.8
                height: errorText.height + errorText.anchors.topMargin * 2
                color: theme.color.errorBackground
                visible: (errorText.text != "")
                border.width: 2
                border.color: theme.color.errorBorder
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: errorText
                    color: theme.color.errorText
                    anchors.topMargin: theme.padding.small
                    anchors.rightMargin: theme.padding.medium
                    anchors.leftMargin: theme.padding.medium
                    wrapMode: Text.WordWrap
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: parent.top
                    font.pixelSize: theme.font.large
                }
            }

            Text {
                id: themeLabel
                color: theme.color.normalText
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
