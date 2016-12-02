#include "dbusserviceinspector.h"
#include "dbusutil.h"
#include <QDBusInterface>
#include <QDBusReply>
#include <QDBusMessage>
#include <QXmlStreamReader>

/*!
 * Returns the list of possible paths for a service registered to D-Bus with given name.
 * \param serviceName Name of a D-Bus service to get paths for.
 * \param isSystemBus Whether the service is registered in system bus or not.
 * \return The list of possible paths for a service registered to D-Bus with given name.
 */
QStringList DBusServiceInspector::getPathsList(QString serviceName, bool isSystemBus) {
    this->serviceName = serviceName;
    dDusConnection = isSystemBus ? QDBusConnection::systemBus() : QDBusConnection::sessionBus();
    return extractPaths(introspectService("/"), "/");
}

QString DBusServiceInspector::introspectService(QString path) {
    QDBusInterface interface(serviceName, path, "org.freedesktop.DBus.Introspectable", dDusConnection);
    QDBusReply<QString> xmlReply = interface.call("Introspect");
    if (xmlReply.isValid()) return xmlReply.value();
    return "";
}

/*!
 * Extracts and returns the list of possible paths from given service XML description.
 * \param xml XML description of the service.
 * \return The list of possible paths from given service XML description.
 */
QStringList DBusServiceInspector::extractPaths(QString xml, QString pathPrefix) {
    QXmlStreamReader xmlReader(xml);
    QStringList pathsList;
    while (!xmlReader.atEnd() && !xmlReader.hasError()) {
        QXmlStreamReader::TokenType token = xmlReader.readNext();
        if (token == QXmlStreamReader::StartDocument)
            continue;
        if (token == QXmlStreamReader::StartElement) {
            if (xmlReader.name() == "interface") {
                QXmlStreamAttributes attributes = xmlReader.attributes();
                if (attributes.hasAttribute("name") &&
                        attributes.value("name") != "org.freedesktop.DBus.Introspectable" &&
                        attributes.value("name") != "org.freedesktop.DBus.Peer")
                    if (!pathsList.contains(pathPrefix)) pathsList.append(pathPrefix);
            } else if (xmlReader.name() == "node") {
                QXmlStreamAttributes attributes = xmlReader.attributes();
                if (attributes.hasAttribute("name") && attributes.value("name") != pathPrefix) {
                    QString path = attributes.value("name").toString();
                    if (path.at(0) == '/' || pathPrefix.at(pathPrefix.length() - 1) == '/') {
                        path = pathPrefix + path;
                    } else {
                        path = pathPrefix + "/" + path;
                    }
                    pathsList.append(extractPaths(introspectService(path), path));
                }
            }
        }
    }
    return pathsList;
}

/*!
 * Returns the list of all interfaces for service with given name and path
 * \param serviceName Name of a D-Bus service to get interfaces for.
 * \param path Path in a D-Bus service to get interfaces for.
 * \param isSystemBus Whether the service is registered in system bus or not.
 * \return the list of all interfaces
 */
QStringList DBusServiceInspector::getInterfacesList(QString serviceName, QString path, bool isSystemBus) {
    this->serviceName = serviceName;
    dDusConnection = isSystemBus ? QDBusConnection::systemBus() : QDBusConnection::sessionBus();
    QXmlStreamReader xmlReader(introspectService(path));
    QStringList interfacesList;
    while(!xmlReader.atEnd() && !xmlReader.hasError()) {
        QXmlStreamReader::TokenType token = xmlReader.readNext();
        if (token == QXmlStreamReader::StartElement) {
            if (xmlReader.name() == "interface") {
                QXmlStreamAttributes attributes = xmlReader.attributes();
                if (attributes.hasAttribute("name"))
                    interfacesList.append(attributes.value("name").toString());
            }
        }
    }
    return interfacesList;
}

/*!
 * Returns the list of all member with information about them for interface witch given name, path and service name.
 * \param serviceName Name of a D-Bus service to get members for.
 * \param path Path in a D-Bus service to get interfaces for.
 * \param interface Name of a interface to get members for.
 * \param isSystemBus Whether the service is registered in system bus or not.
 * \return the list of all members
 */
QList<QObject*> DBusServiceInspector::getInterfaceMembers(QString serviceName, QString path, QString interface, bool isSystemBus) {
    this->serviceName = serviceName;
    dDusConnection = isSystemBus ? QDBusConnection::systemBus() : QDBusConnection::sessionBus();
    QXmlStreamReader xmlReader(introspectService(path));
    QList<QObject*> interfaceMembersList, inputArgs, outputArgs;
    InterfaceMember *interfaceMember;
    while(!xmlReader.atEnd() && !xmlReader.hasError()) {
        QXmlStreamReader::TokenType token = xmlReader.readNext();
        if (token == QXmlStreamReader::StartElement) {
            QXmlStreamAttributes attributes = xmlReader.attributes();
            if(xmlReader.name() == "interface") {
                if(attributes.hasAttribute("name") && attributes.value("name").toString() != interface)
                    xmlReader.skipCurrentElement();
            } else if(xmlReader.name() == "arg") {
                (attributes.hasAttribute("direction") && attributes.value("direction") == "out" || interfaceMember->kind() == "signal")
                        ? outputArgs.append(new Argument(attributes.value("type").toString(), attributes.value("name").toString()))
                        : inputArgs.append(new Argument(attributes.value("type").toString(), attributes.value("name").toString()));
            } else if(xmlReader.name() == "method" || xmlReader.name() == "property" || xmlReader.name() == "signal")
                interfaceMember = new InterfaceMember(attributes.value("name").toString(), xmlReader.name().toString(),
                                                      attributes.value("type").toString(), attributes.value("access").toString());
        } else if (token == QXmlStreamReader::EndElement)
            if(xmlReader.name() == "interface")
                return interfaceMembersList;
            else if(xmlReader.name() == "method" || xmlReader.name() == "property" || xmlReader.name() == "signal") {
                interfaceMember->setInputArguments(inputArgs);
                interfaceMember->setOutputArguments(outputArgs);
                interfaceMembersList.append(interfaceMember);
                inputArgs.clear(); outputArgs.clear();
            }
    }
    return interfaceMembersList;
}

/*!
 * Calls a method with given name and arguments on the given service and its interface.
 * \param serviceName The name of the service to call the method.
 * \param isSystemBus Whether the service is registered in system bus or not.
 * \param path Path to the interface to call the method on.
 * \param interfaceName Name of the interface that contains the method.
 * \param methodName Name of the method to call.
 * \param arguments List of arguments for the method.
 * \return String with all reply arguments, if the call suceeds, and error message otherwise.
 */
QString DBusServiceInspector::callMethod(QString serviceName, bool isSystemBus, QString path, QString interfaceName,
                                         QString methodName, QList<QVariant> arguments) {
    dDusConnection = isSystemBus ? QDBusConnection::systemBus() : QDBusConnection::sessionBus();
    QDBusInterface interface(serviceName, path, interfaceName, dDusConnection);
    QDBusMessage reply = interface.callWithArgumentList(QDBus::Block, methodName,
                                                        DBusUtil::convertToDBusArguments(arguments, interface, methodName));
    if (reply.type() == QDBusMessage::ErrorMessage) return interface.lastError().message();
    QList<QVariant> replyArguments = reply.arguments();
    if (replyArguments.isEmpty()) return "Success (no arguments)";
    QString outMessage = "";
    foreach (QVariant argument, replyArguments) {
        outMessage += DBusUtil::argumentToString(argument);
        outMessage += QLatin1String(", ");
    }
    outMessage.chop(2);
    return outMessage;
}


/*!
 * Returns the value of the given property of the given interface.
 * \param serviceName The name of the service to get the property.
 * \param path Path to the interface to get the property on.
 * \param interfaceName Name of the interface that contains the property.
 * \param propertyName Name of the property for which value are required.
 * \param isSystemBus Whether the service is registered in system bus or not.
 * \return value of the property
 */
QVariant DBusServiceInspector::getInterfaceProperty(QString serviceName, QString path, QString interfaceName,
                                                    QString propertyName, bool isSystemBus) {
    dDusConnection = isSystemBus ? QDBusConnection::systemBus() : QDBusConnection::sessionBus();
    QDBusInterface interface(serviceName, path, interfaceName, dDusConnection);
    return interface.property(propertyName.toStdString().c_str());
}

/*!
 * Sets the value of the given property of the given interface.
 * \param serviceName The name of the service to set the property.
 * \param path Path to the interface to set the property on.
 * \param interfaceName Name of the interface that contains the property.
 * \param propertyName Name of the property for which value are set.
 * \param isSystemBus Whether the service is registered in system bus or not.
 * \param value The value to be set.
 * \return true if value successfully changed, false otherwise
 */
bool DBusServiceInspector::setInterfaceProperty(QString serviceName, QString path, QString interfaceName,
                                                QString propertyName, bool isSystemBus, QVariant value) {
    dDusConnection = isSystemBus ? QDBusConnection::systemBus() : QDBusConnection::sessionBus();
    QDBusInterface interface(serviceName, path, interfaceName, dDusConnection);
    return interface.setProperty(propertyName.toStdString().c_str(), value);
}
