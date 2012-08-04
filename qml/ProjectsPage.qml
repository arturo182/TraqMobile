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
            iconSource: "images/toolbar_back.svg"
            onClicked: pageStack.pop()
        }

        ToolButton {
            flat: true
            iconSource: "images/toolbar_refresh.svg"
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

        SmallListItem {
            id: listItem
            width: projectsList.width

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

    ScrollDecorator {
        flickableItem: projectsList
    }
}
