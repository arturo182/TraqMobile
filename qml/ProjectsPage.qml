import QtQuick 1.1
import com.nokia.symbian 1.1
import "theme.js" as Theme
import "database.js" as Database
import "api.js" as Api

BasePage {
    property string accountId
    property string accountUrl
    property string accountName

    function updateProjects()
    {
        projectsModel.clear();
        Api.loadProjects(projectsModel, accountId);
    }

    id: root
    headerText: accountName + " / Projects"

    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "images/toolbar-back.svg"
            onClicked: pageStack.pop()
        }
    }

    onVisibleChanged: {
        if(visible)
            updateProjects();
    }

    ListModel {
        id: projectsModel
    }

    Component {
        id: projectsDelegate

        Item {
            id: listItem
            height: 50
            width: projectsList.width

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
                        //var account = accountsModel.get(index);
                        //projectsPage.accountName = account.name;
                        //projectsPage.accountUrl = account.url;
                        //pageStack.push(projectsPage);
                    }

                    onPressAndHold: {
                        //accountsList.currentId = account_id;
                        //accountsList.currentIndex = index;
                        //accountMenu.open();
                    }
                }

            }
        }
    }

    Rectangle {
        id: listRectangle

        height: Math.min(projectsModel.count * 50, root.height - 60)
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

            id: projectsList
            boundsBehavior: Flickable.StopAtBounds

            anchors.fill: parent
            cacheBuffer: height
            focus: true
            clip: true
            model: projectsModel
            delegate: projectsDelegate
        }
    }
}
