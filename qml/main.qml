import QtQuick 1.1
import com.nokia.symbian 1.1
import "database.js" as Database
import "api.js" as Api

PageStackWindow {
    id: window
    initialPage: splashPage
    showStatusBar: false
    showToolBar: true

    Component.onCompleted: {
        Api.pageStack = pageStack;
        Database.init();
    }

    AccountsPage {
        id: accountsPage
    }

    BusyIndicator {
        height: 60
        width: 60

        visible: pageStack.busy
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        smooth: true
        running: true
    }

    SplashPage {
        id: splashPage

        image: "images/splash.png"
        Component.onCompleted: splashPage.activate()
        onFinished: {
            window.showStatusBar = true;
            pageStack.push(accountsPage);
        }
    }
}
