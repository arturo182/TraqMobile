import QtQuick 1.1
import com.nokia.symbian 1.1
import "database.js" as Database
import "api.js" as Api

BasePage {
    property string accountId
    property string accountUrl
    property string accountName

    function refreshProjects()
    {
        pageStack.busy = true;

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

        ToolButton {
            flat: true
            iconSource: "images/toolbar-refresh.svg"
            onClicked: refreshProjects()
        }
    }

    onStatusChanged: {
        if(status == PageStatus.Activating) {
            refreshProjects();
        }
    }

    TicketsPage {
        id: ticketsPage
    }

    ListModel {
        id: projectsModel
    }

    Component {
        id: projectsDelegate

        Item {
            id: listItem
            height: theme.size.smallListItemHeight
            width: projectsList.width

            Rectangle {
                id: itemRectangle

                anchors.fill: parent
                border.width: 1
                border.color: theme.color.normalText
                gradient: theme.gradient.listItemNormal

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
                    color: theme.color.normalText
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
                        var project = projectsModel.get(index);
                        ticketsPage.accountId = accountId;
                        ticketsPage.projectName = project.name;
                        ticketsPage.projectSlug = project.slug;
                        pageStack.push(ticketsPage);
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

        height: Math.min(projectsModel.count * theme.size.smallListItemHeight, root.height - theme.size.headerHeight - 2 * theme.padding.large)
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
