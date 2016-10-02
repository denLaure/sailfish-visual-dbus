import QtQuick 2.2
import Sailfish.Silica 1.0
import org.nemomobile.dbus 2.0

Page {
    property alias serviceName: methodCaller.service
    property alias serviceBus: methodCaller.bus
    property alias servicePath: methodCaller.path
    property alias serviceInterface: methodCaller.iface
    property string methodName

    DBusInterface {
        id: methodCaller
    }

    Component.onCompleted: {
        methodCaller.typedCall(methodName, undefined, function(result) {
                                resultLabel.text = encodeURIComponent(result);
                                console.log(result.toString());
                           },
                           function() { console.log('Method call failed.') });
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id: column
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: Theme.horizontalPageMargin
            }
            spacing: Theme.paddingMedium
            Label {
                 text: serviceBus === DBus.SessionBus ? 'Bus: Session' : 'Bus: System'
                 width: parent.width
                 wrapMode: Text.Wrap
                   }
            Label {
               text: 'Service: ' + serviceName
               width: parent.width
               wrapMode: Text.Wrap
                   }
            Label {
                 text: 'Path: ' + servicePath
                 width: parent.width
                 wrapMode: Text.Wrap
                   }
            Label {
                 text: 'Interface: ' + serviceInterface
                 width: parent.width
                 wrapMode: Text.Wrap
                   }
            Label {
                 text: 'Method: ' + methodName
                 width: parent.width
                 wrapMode: Text.Wrap
                   }
            Rectangle {
                height: 3
                width: parent.width
                color: Theme.highlightColor
            }
            Label {
                id: resultLabel
                anchors.left: parent.left
                width: parent.width
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.Wrap
            }
        }
        VerticalScrollDecorator { flickable: parent }
    }
}

