import QtQuick 1.1
import com.nokia.symbian 1.1
import "theme.js" as Theme
import "database.js" as Database

Page {
    property string accountId

    id: root

    function setAccount(account)
    {
        accountId = account.account_id;
        nameField.text = account.name;
        urlField.text = account.url;
        apiKeyField.text = account.private_key;
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
            text: "Edit Traq:"
            anchors.leftMargin: 20
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pixelSize: 20
        }
    }

    Flickable {
        id: formFlickable
        clip: true
        contentHeight: formColumn.height * 1.2
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        anchors.top: headerRectangle.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

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
                color: Theme.colors.errorBackground
                visible: (errorText.text != "")
                border.width: 2
                border.color: Theme.colors.errorBorder
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: errorText
                    color: Theme.colors.errorText
                    anchors.topMargin: 5
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    wrapMode: Text.WordWrap
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: parent.top
                    font.pixelSize: Theme.fonts.listItem
                }
            }

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
                id: saveButton
                text: "Save"
                onClicked: {
                    errorText.text = "";

                    if(nameField.text == "") {
                        errorText.text = "Name cannot be blank."
                    }

                    if(urlField.text == "") {
                        if(errorText.text != "")
                            errorText.text += "\n";

                        errorText.text += "Url cannot be blank."
                    }

                    if(errorText.text != "") {
                        formFlickable.contentY = 0;
                        return;
                    }

                    Database.modifyAccount(accountId, nameField.text, urlField.text, apiKeyField.text);
                    pageStack.pop();
                }
            }
        }
    }
}
