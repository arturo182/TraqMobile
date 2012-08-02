import QtQuick 1.1
import com.nokia.symbian 1.1
import "theme.js" as Theme
import "database.js" as Database

BasePage {
    property string accountId
    property alias accountName: nameField.text
    property alias accountUrl: urlField.text
    property alias accountPrivateKey: privateKeyField.text

    id: root
    headerText: "Edit Traq"

    onAccountNameChanged: {
        nameField.focus = true;
    }

    tools: ToolBarLayout {
        ToolButton {
            text: "Save"
            onClicked: {
                errorText.text = "";

                if(accountName == "") {
                    errorText.text = "Name cannot be blank."
                }

                if(accountUrl == "") {
                    if(errorText.text != "")
                        errorText.text += "\n";

                    errorText.text += "Url cannot be blank."
                }

                if(errorText.text != "") {
                    formFlickable.contentY = 0;
                    return;
                }

                Database.modifyAccount(accountId, accountName, accountUrl, accountPrivateKey);
                pageStack.pop();
            }
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
                    font.pixelSize: 0
                }
            }

            Text {
                id: nameLabel
                color: Theme.colors["default"].listItemText
                text: "Name:"
            }
            TextField {
                id: nameField
                width: parent.width
            }

            Text {
                id: urlLabel
                color: Theme.colors["default"].listItemText
                text: "Url:"
            }
            TextField {
                id: urlField
                width: parent.width
                placeholderText: "http://"
            }

            Text {
                id: apiKeyLabel
                color: Theme.colors["default"].listItemText
                text: "API key:"
            }
            TextField {
                id: privateKeyField
                width: parent.width
            }
        }
    }
}
