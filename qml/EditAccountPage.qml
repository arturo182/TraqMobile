import QtQuick 1.1
import com.nokia.symbian 1.1
import "database.js" as Database

BasePage {
    property string accountId
    property alias accountName: nameField.text
    property alias accountUrl: urlField.text
    property alias accountPrivateKey: privateKeyField.text

    id: root
    headerText: "Edit Account"

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
        anchors.topMargin: theme.size.headerHeight

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
                    font.pixelSize: 0
                }
            }

            Text {
                id: nameLabel
                color: theme.color.normalText
                text: "Name:"
            }
            TextField {
                id: nameField
                width: parent.width
            }

            Text {
                id: urlLabel
                color: theme.color.normalText
                text: "Url:"
            }
            TextField {
                id: urlField
                width: parent.width
                placeholderText: "http://"
            }

            Text {
                id: apiKeyLabel
                color: theme.color.normalText
                text: "API key:"
            }
            TextField {
                id: privateKeyField
                width: parent.width
            }
        }
    }


    ScrollDecorator {
        flickableItem: formFlickable
    }
}
