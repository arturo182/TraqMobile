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

        Item {
            id: listItem
            height: theme.size.smallListItemHeight
            width: accountsList.width

            Rectangle {
                id: itemRectangle

                anchors.fill: parent
                border.width: 1
                border.color: theme.color.normalText
                gradient: theme.gradient.listItemNormal
                states: [
                    State {
                        name: "pressed"

                        PropertyChanges {
                            target: highlightRectangle
                            opacity: 1.0
                        }
                    }
                ]

                Rectangle {
                    id: highlightRectangle

                    opacity: 0.0
                    anchors.fill: parent
                    border.width: 1
                    border.color: theme.color.normalText
                    gradient: Gradient {
                        GradientStop {
                            position: 0.00
                            color: "red"
                        }
                        GradientStop {
                            position: 1.00
                            color: "blue"
                        }
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
                    anchors.leftMargin: theme.padding.large
                    verticalAlignment: Text.AlignVCenter
                    color: theme.color.normalText
                }

                Image {
                    id: indicatorImage
                    width: sourceSize.width
                    height: sourceSize.height
                    anchors.rightMargin: theme.padding.medium
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/icon-list-indicator-blue.svg"
                }

                MouseArea {
                    anchors.fill: parent

                    onPressed: {
                        itemRectangle.state = "pressed";
                    }

                    onReleased: {
                        itemRectangle.state = "";
                    }

                    onClicked: {
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
}
