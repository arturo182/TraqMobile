import QtQuick 1.1
import com.nokia.symbian 1.1
import "database.js" as Database
import "api.js" as Api

BasePage {
    property string accountId
    property string projectId
    property string projectName
    property string projectSlug

    function refreshTickets()
    {
        pageStack.busy = true;

        ticketsModel.clear();
        Api.loadTickets(ticketsModel, accountId, projectSlug);
    }

    id: root
    headerText: projectName + " / Tickets"

    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "images/toolbar_back.svg"
            onClicked: pageStack.pop()
        }

        ToolButton {
            flat: true
            iconSource: "images/toolbar_grid.svg"
        }

        ToolButton {
            flat: true
            iconSource: "images/toolbar_refresh.svg"
            onClicked: refreshTickets()
        }
    }

    onStatusChanged: {
        if(status == PageStatus.Activating) {
            refreshTickets();
        }
    }

    ListModel {
        id: ticketsModel
    }

    Component {
        id: ticketsDelegate

        Item {
            id: listItem
            width: ticketsList.width
            height: theme.size.largeListItemHeight

            Rectangle {
                id: itemRectangle

                anchors.fill: parent
                border.width: 1
                border.color: theme.color.normalText
                gradient: theme.gradient.listItemNormal

                Text {
                    id: idText

                    text: "#" + id
                    color: theme.color.normalText
                    width: 50
                    font.pixelSize: (parseInt(id) / 100.0 >= 1) ? theme.font.medium : theme.font.large

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                }

                Rectangle {
                    id: verticalLine

                    width: 1
                    color: theme.color.normalText

                    anchors.left: idText.right
                    anchors.top: parent.top
                    anchors.topMargin: theme.padding.medium
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: theme.padding.medium
                }

                Text {
                    id: summaryText

                    text: summary
                    color: theme.color.darkText
                    font.pixelSize: (theme.font.large + theme.font.medium) / 2
                    font.bold: true

                    anchors.left: verticalLine.right
                    anchors.leftMargin: theme.padding.small
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: theme.padding.medium
                }

                Grid {
                    property int itemWidth: width / columns

                    id: propertyGrid
                    columns: 2
                    spacing: 2

                    anchors.top: summaryText.bottom
                    anchors.topMargin: theme.padding.small / 2
                    anchors.left: summaryText.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    TicketProperty {
                        width: propertyGrid.itemWidth
                        image: "images/icon_user.png"
                        text: user ? user.name : ""
                    }

                    TicketProperty {
                        width: propertyGrid.itemWidth
                        image: "images/icon_pencil.png"
                        text: updated_at
                    }

                    TicketProperty {
                        width: propertyGrid.itemWidth
                        image: "images/icon_cog.png"
                        text: status ? status.name : ""
                    }

                    TicketProperty {
                        width: propertyGrid.itemWidth
                        image: "images/icon_error.png"
                        text: type ? type.name : ""
                    }
                }
            }
        }
    }

    ListView {
        property string currentId

        id: ticketsList

        anchors.topMargin: theme.size.headerHeight
        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds
        cacheBuffer: height
        focus: true
        clip: true
        model: ticketsModel
        delegate: ticketsDelegate
    }

    ScrollDecorator {
        flickableItem: ticketsList
    }
}
