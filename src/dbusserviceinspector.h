#ifndef DBUSSERVICEINSPECTOR_H
#define DBUSSERVICEINSPECTOR_H

#include <QDBusConnection>
#include <QObject>
#include <QStringList>
#include "interfacemember.h"

/*!
 * \brief The DBusServiceInspector class provides usable functions
 * to retrieve information about service registered to D-Bus.
 */
class DBusServiceInspector : public QObject
{
    Q_OBJECT
public:
    DBusServiceInspector() : serviceName(""), dDusConnection(QDBusConnection::systemBus()) {}
    Q_INVOKABLE QStringList getPathsList(QString serviceName, bool isSystemBus);
    Q_INVOKABLE QStringList getInterfacesList(QString serviceName, QString path, bool isSystemBus);
    Q_INVOKABLE QList<QObject*> getInterfaceMembers(QString serviceName, QString path,
                                                QString interface, bool isSystemBus);
    Q_INVOKABLE QString callMethod(QString serviceName, bool isSystemBus, QString path, QString interfaceName,
                                   QString methodName, QList<QVariant> arguments);
    Q_INVOKABLE QVariant getInterfaceProperty(QString serviceName, QString path, QString interfaceName,
                                              QString propertyName, bool isSystemBus);
    Q_INVOKABLE bool setInterfaceProperty(QString serviceName, QString path, QString interfaceName,
                                          QString propertyName, bool isSystemBus, QVariant value);
private:
    QString serviceName;
    QDBusConnection dDusConnection;
    QStringList extractPaths(QString xml, QString pathPrefix);
    QString introspectService(QString path);
};

#endif // DBUSSERVICEINSPECTOR_H
