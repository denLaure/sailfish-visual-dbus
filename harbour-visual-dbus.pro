TARGET = harbour-visual-dbus

CONFIG += sailfishapp \
    sailfishapp_i18n \
    c++11

QT += dbus

SOURCES += \
    src/dbusserviceinspector.cpp \
    src/interfacemember.cpp \
    src/argument.cpp \
    src/dbusutil.cpp \
    src/harbour-visual-dbus.cpp

OTHER_FILES += \
    qml/harbour-visual-dbus.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/ServicePathsListPage.qml \
    qml/pages/FailedToRecieveServicesDialog.qml \
    qml/pages/ServiceInterfacesListPage.qml \
    qml/pages/InterfaceMembersPage.qml \
    qml/pages/MethodCallPage.qml \
    qml/pages/PropertyPage.qml \
    rpm/harbour-visual-dbus.changes.in \
    rpm/harbour-visual-dbus.yaml \
    harbour-visual-dbus.desktop \
    translations/*.ts

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

HEADERS += \
    src/dbusserviceinspector.h \
    src/interfacemember.h \
    src/argument.h \
    src/dbusutil.h
