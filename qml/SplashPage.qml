import QtQuick 1.1

Item {
    id: root

    property alias image: splash.source
    property int timeout: 1000
    property int fadeout: 1000

    signal finished

    function activate() {
        animation.start();
    }

    anchors.fill: parent

    Image {
        id: splash
        smooth: true

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: root.image
    }

    SequentialAnimation {
        id: animation

        PauseAnimation { duration: root.timeout }

        PropertyAnimation {
            target: splash
            properties: "opacity"
            duration: root.fadeout
            to: 0
        }

        ScriptAction { script: finished() }
    }
}
