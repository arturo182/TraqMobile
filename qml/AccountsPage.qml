import QtQuick 1.1
import com.nokia.symbian 1.1
import "theme.js" as Theme
import "database.js" as Database

Page {
    signal accountChosen(int id)

    function updateAccounts()
    {
        accountsModel.clear();
        Database.loadAccounts(accountsModel);
    }

    id: root
    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "images/toolbar-back.svg"
            onClicked: Qt.quit()
        }

        /*ToolButton {
            flat: true
            iconSource: "images/toolbar-settings.svg"
            onClicked: Qt.quit()
        }*/

        ToolButton {
            flat: true
            iconSource: "images/toolbar-add.svg"
            onClicked: pageStack.push(newAccountPage)
        }
    }

    onVisibleChanged: updateAccounts()

    NewAccountPage {
        id: newAccountPage
    }

    EditAccountPage {
        id: editAccountPage
    }

    ContextMenu {
        id: accountMenu

        MenuLayout {
            MenuItem {
                text: "Connect"
            }

            MenuItem {
                text: "Edit"
                onClicked: {
                    editAccountPage.setAccount(accountsModel.get(accountsList.currentIndex));
                    pageStack.push(editAccountPage);
                }
            }

            MenuItem {
                text: "Delete"
                onClicked: {
                    Database.deleteAccount(accountsList.currentId);
                    updateAccounts();
                }
            }
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

    ListModel {
        id: accountsModel
    }

    Component {
        id: accountsDelegate

        Item {
            id: listItem
            height: 50
            width: accountsList.width

            Rectangle {
                id: itemRectangle

                anchors.fill: parent
                border.width: 1
                border.color: Theme.colors.listItemText
                gradient: Gradient {
                    GradientStop {
                        position: 0.00;
                        color: Theme.colors.listItemGradientStart;
                    }
                    GradientStop {
                        position: 1.00;
                        color: Theme.colors.listItemGradientStop;
                    }
                }

                Text {
                    id: nameText
                    text: name
                    anchors.right: indicatorImage.left
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.top: parent.top
                    elide: Text.ElideRight
                    anchors.leftMargin: 20
                    verticalAlignment: Text.AlignVCenter
                    color: Theme.colors.listItemText
                }

                Image {
                    id: indicatorImage
                    width: sourceSize.width
                    height: sourceSize.height
                    anchors.rightMargin: 10
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/icon-list-indicator-blue.svg"
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: root.accountChosen(account_id)
                    onPressAndHold: {
                        accountsList.currentId = account_id;
                        accountsList.currentIndex = index;
                        accountMenu.open();
                    }
                }

            }
        }
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
            text: "Your Traqs:"
            anchors.leftMargin: 20
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            font.pixelSize: 20
        }
    }

    Rectangle {
        id: listRectangle

        height: Math.min(accountsModel.count * 50, backgroundRectangle.height - 60)
        color: Theme.colors.listItemText
        border.width: 2
        border.color: Theme.colors.listItemText
        anchors.top: headerRectangle.bottom
        anchors.topMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30

        ListView {
            property string currentId

            id: accountsList
            boundsBehavior: Flickable.StopAtBounds

            anchors.fill: parent
            cacheBuffer: height
            focus: true
            clip: true
            model: accountsModel
            delegate: accountsDelegate
        }
    }
}
