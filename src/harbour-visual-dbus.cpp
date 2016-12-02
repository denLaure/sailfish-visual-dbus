#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include "dbusserviceinspector.h"
#include <sailfishapp.h>
#include <QGuiApplication>
#include <QtQml>
#include <QObject>
#include <QQmlEngine>
#include <QQuickView>

int main(int argc, char *argv[])
{
    qmlRegisterType<DBusServiceInspector>("harbour.visual.dbus.dbusinspector", 1, 0, "DBusInspector");
    qmlRegisterType<InterfaceMember>("harbour.visual.dbus.interfacemember", 1, 0, "InterfaceMember");
    qmlRegisterType<Argument>("harbour.visual.dbus.argument", 1, 0, "Argument");

    QGuiApplication *app = SailfishApp::application(argc, argv);
    QQuickView* view = SailfishApp::createView();
    QObject::connect(view->engine(), &QQmlEngine::quit, app, &QGuiApplication::quit);
    view->setSource(SailfishApp::pathTo("qml/harbour-visual-dbus.qml"));
    view->showFullScreen();
    return app->exec();
}

