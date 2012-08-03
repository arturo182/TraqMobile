import QtQuick 1.1

Item {
    signal clicked()
    signal pressAndHold()

    id: root
    height: theme.size.smallListItemHeight

    TraqTheme { id: theme }

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
            gradient: theme.gradient.listItemPressed
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

            onExited: {
                itemRectangle.state = "";
            }

            onCanceled: {
                itemRectangle.state = "";
            }

            onClicked: root.clicked()
            onPressAndHold: {
                root.pressAndHold();
                itemRectangle.state = "";
            }
        }
    }
}
