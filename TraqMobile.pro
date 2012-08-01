QT      += declarative network
CONFIG  += qt-components
SOURCES += main.cpp
ICON     = TraqMobile.svg

qmls.sources = qml/*.qml qml/*.js
qmls.path = qml
images.sources = qml/images/*
images.path = qml/images
DEPLOYMENT += qmls images

OTHER_FILES += \
    qml/main.qml \
    qml/SplashPage.qml \
    qml/AccountsPage.qml \
    qml/database.js \
    qml/theme.js \
    qml/AddAccountPage.qml \
    qml/EditAccountPage.qml

symbian {
    TARGET.UID3 = 0xE1AB3181
    TARGET.CAPABILITY += NetworkServices
}
