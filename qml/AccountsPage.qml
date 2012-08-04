import QtQuick 1.1
import com.nokia.symbian 1.1
import "database.js" as Database

BasePage {
    id: root

    function updateAccounts()
    {
        accountsModel.clear();
        Database.loadAccounts(accountsModel);
    }

    headerText: "Your Accounts:"

    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "images/toolbar_close.svg"
            onClicked: Qt.quit()
        }

        ToolButton {
            flat: true
            iconSource: "images/toolbar_settings.svg"
            onClicked: pageStack.push(settingsPage)
        }

        ToolButton {
            flat: true
            iconSource: "images/toolbar_add.svg"
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
                    editAccountPage.accountId = account.id;
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

        SmallListItem {
            id: listItem
            width: accountsList.width

            onClicked:  {
                var account = accountsModel.get(index);
                projectsPage.accountId = account.id;
                projectsPage.accountName = account.name;
                projectsPage.accountUrl = account.url;
                pageStack.push(projectsPage);
            }

            onPressAndHold: {
                var account = accountsModel.get(index);
                accountsList.currentId = account.id;
                accountsList.currentIndex = index;
                accountMenu.open();
            }
        }
    }

    Rectangle {
        id: listRectangle

        height: Math.min(accountsModel.count * theme.size.smallListItemHeight, root.height - theme.size.headerHeight - 2 * theme.padding.large)
        color: theme.color.normalText
        border.width: 2
        border.color: theme.color.normalText
        anchors.top: parent.top
        anchors.topMargin: theme.size.headerHeight + theme.padding.large
        anchors.right: parent.right
        anchors.rightMargin: theme.padding.large
        anchors.left: parent.left
        anchors.leftMargin: theme.padding.large

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

    ScrollDecorator {
        flickableItem: accountsList
    }
}
