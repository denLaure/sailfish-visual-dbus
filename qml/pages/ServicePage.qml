import QtQuick 2.2
import Sailfish.Silica 1.0
import QtQuick.XmlListModel 2.0
import org.nemomobile.dbus 2.0


Page {
    property alias serviceName: serviceInterface.service
    property alias serviceBus: serviceInterface.bus
    property alias servicePath: serviceInterface.path

    DBusInterface {
        id: serviceInterface
        service: 'org.freedesktop.DBus'
        path: '/'
        iface: 'org.freedesktop.DBus.Introspectable'
        bus: DBus.SessionBus
    }

    ListModel {
        id: interfaceModel
    }

    XmlListModel {
        id: nodeXmlModel
        query: '/node/node'
        XmlRole {
            name: 'node'
            query: '@name/string()'
        }
        onStatusChanged: {
            if(status === XmlListModel.Ready) {
                for (var i=0; i < count; i++) {
                    console.log('node: ' + get(i).node)
                    interfaceModel.append({'name': get(i).node, 'type': 'Paths'})
                }
            }
        }
    }

    XmlListModel {
        id: interfaceXmlModel
        query: '/node/interface'
        XmlRole {
            name: 'name'
            query: '@name/string()'
        }
        onStatusChanged: {
            if(status === XmlListModel.Ready) {
                for (var i=0; i < count; i++) {
                    console.log('interface: ' + get(i).name)
                    interfaceModel.append({'name': get(i).name, 'type': 'Interfaces'})
                }
            }
        }
    }

    Component.onCompleted: {
        serviceInterface.typedCall('Introspect', undefined,
                           function(result) {
                               console.log(result)
                               interfaceXmlModel.xml = result;
                               nodeXmlModel.xml = result;
                           },
                           function() { console.log('Introspect failed.') });
    }

   SilicaListView {
       id: serviceDesc
       anchors.fill: parent
       model: interfaceModel
       header: Column {
           width: serviceDesc.width
           Label {
               anchors.left: parent.left
               anchors.leftMargin: Theme.paddingLarge * 1.5
                      text: 'Service: ' + serviceName
                      width: parent.width
                      wrapMode: Text.Wrap
                  }
           Label {
               anchors.left: parent.left
               anchors.leftMargin: Theme.paddingLarge * 1.5
                text: 'Path: ' + servicePath
                width: parent.width
                wrapMode: Text.Wrap
                  }
           Rectangle {
               height: 3
               width: parent.width
               color: Theme.highlightColor
           }
       }

       delegate: ListItem {
               id: listItem
               contentHeight: Theme.itemSizeMedium

               Label {
                   id: label
                   text: name
                   anchors {
                       fill: parent
                       margins: Theme.paddingLarge
                   }
                   wrapMode: Text.Wrap
                   verticalAlignment: Text.AlignVCenter
                   color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
               }

               onClicked: {
                   if (type === 'Paths') {
                       var path = servicePath[servicePath.length - 1] === '/' ? servicePath + name : servicePath + '/' + name;
                       pageStack.push(Qt.resolvedUrl("ServicePage.qml"),
                                      {"serviceName": serviceName,
                                          "serviceBus": serviceBus,
                                          "servicePath": path});
                   }
               }
           }
       section.property: "type"
       section.delegate: Label {
           id: sectionDelegate
           text: '   ' + section
           font.pixelSize: Theme.fontSizeLarge
       }
   }

}
