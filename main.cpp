#include <QDeclarativeEngine>
#include <QDeclarativeView>
#include <QApplication>

int main(int argc, char **argv)
{
	QApplication app(argc, argv);

	QDeclarativeView view;
	view.setSource(QUrl("qml/main.qml"));
	view.window()->showFullScreen();

	QObject::connect(view.engine(), SIGNAL(quit()), &view, SLOT(close()));
	return app.exec();
}
