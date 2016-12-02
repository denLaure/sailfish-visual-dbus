import QtQuick 2.2
import Sailfish.Silica 1.0
import org.nemomobile.dbus 2.0


Page {
    property variant sessionServices
    property variant systemServices
    property bool isSessionServices: true

    id: page

    Component.onCompleted: {
        dbusList.typedCall('ListNames', undefined,
                           function(result) {
                               sessionServices = result.filter(function(value) {return value[0] !== ':'}).sort();
                           }, function() {
                               pageStack.push(Qt.resolvedUrl("FailedToRecieveServicesDialog.qml"));
                           });
        dbusList.bus = DBus.SystemBus;
        dbusList.typedCall('ListNames', undefined,
                           function(result) {
                               systemServices = result.filter(function(value) {return value[0] !== ':'}).sort();
                           }, function() {
                               pageStack.push(Qt.resolvedUrl("FailedToRecieveServicesDialog.qml"));
                           });
    }

DBusInterface {
    id: dbusList
    service: 'org.freedesktop.DBus'
    path: '/org/freedesktop/DBus'
    iface: 'org.freedesktop.DBus'
    bus: DBus.SessionBus
}

    PageHeader {
        id: header
        anchors.top: parent.top
        title: "Visual D-Bus"
    }

    SilicaListView {
        anchors {
            top: header.bottom
            right: parent.right
            left: parent.left
            bottom: switchButton.top
        }
        clip: true
        model: isSessionServices ? sessionServices : systemServices
        spacing: Theme.paddingSmall
        delegate: ListItem {
            id: listItem
            contentHeight: Theme.itemSizeSmall
            width: parent.width
            Label {
                id: serviceNameLabel
                wrapMode: Text.Wrap
                anchors {
                    fill: parent
                    margins: Theme.paddingLarge
                }
                verticalAlignment: Text.AlignVCenter
                text: isSessionServices ? sessionServices[index] : systemServices[index]
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                pageStack.push(Qt.resolvedUrl("ServicePathsListPage.qml"),
                               {"serviceName": serviceNameLabel.text, "isSystemBus": !isSessionServices});
            }
        }
    }

    ValueButton {
        id: switchButton
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        label: "Bus: "
        value: isSessionServices ? "Session" : "System"
        onClicked: isSessionServices = !isSessionServices
    }
}


