import QtQuick 1.1

Item {
    property alias color: colors
    property alias font: fonts
    property alias padding: paddings
    property alias size: sizes
    property alias gradient: gradients

    QtObject {
        id: colors

        property color pageBackground: "#e9e9e9"

        property color darkText: "#000000"
        property color normalText: "#3478aa"
        property color lightText: "#a9a9a9"

        property color headerBackground: "#3478aa"
        property color headerText: "#ffffff"

        property color errorBackground: "#fbe3e4"
        property color errorBorder: "#fbc2c4"
        property color errorText: "#8a1f11"
    }

    QtObject {
        id: fonts

        property int large: 20
        property int medium: 14
        property int small: 11
    }


    QtObject {
        id: paddings

        property int large: 15
        property int medium: 10
        property int small: 5
    }

    QtObject {
        id: sizes

        property int headerHeight: 50
        property int smallListItemHeight: 50
        property int largeListItemHeight: 75
    }

    QtObject {
        id: gradients

        property Gradient listItemNormal: Gradient {
            GradientStop {
                position: 0.00;
                color: "#ffffff";
            }
            GradientStop {
                position: 1.00;
                color: "#eaeaea";
            }
        }

        property Gradient listItemPressed: Gradient {
            GradientStop {
                position: 0.00;
                color: "#e0e1e2";
            }
            GradientStop {
                position: 1.00;
                color: "#ebebec";
            }
        }
    }
}
