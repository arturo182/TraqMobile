import QtQuick 1.1
import com.nokia.symbian 1.1
import "theme.js" as Theme
import "database.js" as Database

BasePage {
    id: root

    function updateAccounts()
    {
        accountsModel.clear();
        Database.loadAccounts(accountsModel);
    }

    headerText: "Your Traqs:"

    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "images/toolbar-back.svg"
            onClicked: Qt.quit()
        }

        ToolButton {
            flat: true
            iconSource: "images/toolbar-settings.svg"
            onClicked: pageStack.push(settingsPage)
        }

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

    SettingsPage {
        id: settingsPage
    }

    ProjectsPage {
        id: projectsPage
    }

    ContextMenu {
        id: accountMenu

        MenuLayout {
            MenuItem {
                text: "Edit"
                onClicked: {
                    var account = accountsModel.get(accountsList.currentIndex);
                    editAccountPage.accountId = account.account_id;
                    editAccountPage.accountName = account.name;
                    editAccountPage.accountUrl = account.url;
                    editAccountPage.accountPrivateKey = account.private_key;

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
                border.color: Theme.colors["default"].listItemText
                gradient: Gradient {
                    GradientStop {
                        position: 0.00;
                        color: Theme.colors["default"].listItemGradientStart;
                    }
                    GradientStop {
                        position: 1.00;
                        color: Theme.colors["default"].listItemGradientStop;
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
                    color: Theme.colors["default"].listItemText
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

                    onClicked: {
                        var account = accountsModel.get(index);
                        projectsPage.accountId = account.account_id;
                        projectsPage.accountName = account.name;
                        projectsPage.accountUrl = account.url;
                        pageStack.push(projectsPage);
                    }

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
        id: listRectangle

        height: Math.min(accountsModel.count * 50, root.height - 60)
        color: Theme.colors["default"].listItemText
        border.width: 2
        border.color: Theme.colors["default"].listItemText
        anchors.top: parent.top
        anchors.topMargin: 30 + Theme.sizes.headerHeight
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
