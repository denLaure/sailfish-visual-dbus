import QtQuick 2.0
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
                                sessionServices = result.filter(function(value) {return value[0] !== ':'});
                           },
                           function() { console.log('failed to receive session services.') });
        dbusList.bus = DBus.SystemBus;
        dbusList.typedCall('ListNames', undefined,
                           function(result) {
                                systemServices = result.filter(function(value) {return value[0] !== ':'});
                           },
                           function() { console.log('failed to receive system services.') });
    }

    DBusInterface {
        id: dbusList
        service: 'org.freedesktop.DBus'
        path: '/org/freedesktop/DBus'
        iface: 'org.freedesktop.DBus'
        bus: DBus.SessionBus
    }
    SilicaListView {
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            bottom: switchButton.top
        }
        clip: true
        model: isSessionServices ? sessionServices: systemServices
        spacing: Theme.paddingSmall
        delegate: ListItem {
            id: listItem
            contentHeight: Theme.itemSizeSmall
            width: parent.width
            Label {
                wrapMode: Text.Wrap
                anchors {
                    fill: parent
                    margins: Theme.paddingLarge
                }
                verticalAlignment: Text.AlignVCenter
                text: isSessionServices ? sessionServices[index] : systemServices[index]
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
        }
    }
    ValueButton {
        id: switchButton
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: Theme.horizontalPageMargin
        }
        label: "Bus"
        value: isSessionServices ? "Session" : "System"
        onClicked: isSessionServices = !isSessionServices
    }
}


