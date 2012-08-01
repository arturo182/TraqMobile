import QtQuick 1.1
import com.nokia.symbian 1.1
import "theme.js" as Theme
import "database.js" as Database

Page {
    id: root

    onVisibleChanged: {
        nameField.text = "";
        urlField.text = "";
        apiKeyField.text = "";
        nameField.focus = true;
    }

    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "images/toolbar-back.svg"
            onClicked: pageStack.pop()
        }
    }

    Rectangle {
        id: backgroundRectangle
        color: Theme.colors.pageBackground
        anchors.top: headerRectangle.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
    }

    Rectangle {
        id: headerRectangle
        height: 50
        color: Theme.colors.headerBackground
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left

        Text {
            id: headerText
            color: Theme.colors.headerText
            text: "Add a Traq:"
            anchors.leftMargin: 20
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pixelSize: 20
        }
    }

    Flickable {
        id: flickable1
        clip: true
        contentHeight: formColumn.height
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        anchors.top: headerRectangle.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        Column {
            id: formColumn
            x: 25
            y: 25
            anchors.topMargin: 25
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            spacing: 6
            anchors.margins: 25

            Label {
                id: nameLabel
                color: Theme.colors.listItemText
                text: "Name:"
            }
            TextField {
                id: nameField
                width: parent.width
            }

            Label {
                id: urlLabel
                color: Theme.colors.listItemText
                text: "Url:"
            }
            TextField {
                id: urlField
                width: parent.width
                placeholderText: "http://"
            }

            Label {
                id: apiKeyLabel
                color: Theme.colors.listItemText
                text: "API key:"
            }
            TextField {
                id: apiKeyField
                width: parent.width
            }

            Button {
                id: addButton
                text: "Add Traq"
                onClicked: {
                    Database.addAccount(nameField.text, urlField.text, apiKeyField.text);
                    pageStack.pop();
                }
        }
    }
    }
}
