#ifndef DBUSUTIL_H
#define DBUSUTIL_H

#include <QtCore/qstring.h>
#include <QtCore/qvariant.h>
#include <QtCore/qlist.h>
#include <QDBusInterface>

/*!
 * DBusUtil is a namespace that copies needed useful method of original QDBusUtil namespace.
 * QDBusUtil is no longer supported by Qt and, therefore, its methods cannot be used in application.
 * However, QDBusUtil sources are available at: http://code.qt.io/cgit/qt/qtbase.git/tree/src/dbus/qdbusutil.cpp
 *
 * The namespace also includes some useful methods from QDBusViewer sources, that is also no longer supported.
 * The sources can be found here: https://github.com/GafferHQ/dependencies/blob/master/qt-everywhere-opensource-src-4.8.5/tools/qdbus/qdbusviewer/qdbusviewer.cpp
 */
namespace DBusUtil {
    QString argumentToString(const QVariant &variant);
    QList<QVariant> convertToDBusArguments(QList<QVariant> &pureArguments, QDBusInterface &interface, QString methodName);
}

#endif // DBUSUTIL_H
