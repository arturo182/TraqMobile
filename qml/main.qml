import QtQuick 1.1
import com.nokia.symbian 1.1
import "database.js" as Database

PageStackWindow {
    id: window
    initialPage: splashPage
    showStatusBar: false
    showToolBar: true

    AccountsPage {
        id: accountsPage

        Component.onCompleted: Database.init()
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
