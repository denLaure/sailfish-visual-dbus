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
                    console.log('node: ' + get(i).node);
                    interfaceModel.append({'name': get(i).node, 'type': 'Paths', 'method1': '',
                                          'method2': '', 'method3': '', 'method4': '',
                                          'method5': '', 'method6': '', 'method7': '',
                                          'method8': '', 'method9': '', 'method10': ''});
                }
            }
        }
    }

    XmlListModel {
        id: interfaceXmlModel
        query: '/node/interface'
        XmlRole {
            name: 'method1'
            query: 'method[1]/@name/string()'
        }
        XmlRole {
            name: 'method2'
            query: 'method[2]/@name/string()'
        }
        XmlRole {
            name: 'method3'
            query: 'method[3]/@name/string()'
        }
        XmlRole {
            name: 'method4'
            query: 'method[4]/@name/string()'
        }
        XmlRole {
            name: 'method5'
            query: 'method[5]/@name/string()'
        }
        XmlRole {
            name: 'method6'
            query: 'method[6]/@name/string()'
        }
        XmlRole {
            name: 'method7'
            query: 'method[7]/@name/string()'
        }
        XmlRole {
            name: 'method8'
            query: 'method[8]/@name/string()'
        }
        XmlRole {
            name: 'method9'
            query: 'method[9]/@name/string()'
        }
        XmlRole {
            name: 'method10'
            query: 'method[10]/@name/string()'
        }

        XmlRole {
            name: 'name'
            query: '@name/string()'
        }
        onStatusChanged: {
            if(status === XmlListModel.Ready) {
                for (var i=0; i < count; i++) {
                    var element = get(i);
                    console.log('interface: ' + element.name);
                    interfaceModel.append({'name': element.name, 'type': 'Interfaces', 'method1': element.method1,
                                          'method2': element.method2, 'method3': element.method3, 'method4': element.method4,
                                          'method5': element.method5, 'method6': element.method6, 'method7': element.method7,
                                          'method8': element.method8, 'method9': element.method9, 'method10': element.method10});
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

               menu: ContextMenu {
                   MenuItem {
                       text: type === 'Interfaces' && method1 !== '' ? method1 : ''
                       visible: type === 'Interfaces' && method1 !== ''
                   }
                   MenuItem {
                       text: type === 'Interfaces' && method2 !== '' ? method2 : ''
                       visible: type === 'Interfaces' && method2 !== ''
                   }
                   MenuItem {
                       text: type === 'Interfaces' && method3 !== '' ? method3 : ''
                       visible: type === 'Interfaces' && method3 !== ''
                   }
                   MenuItem {
                       text: type === 'Interfaces' && method4 !== '' ? method4 : ''
                       visible: type === 'Interfaces' && method4 !== ''
                   }
                   MenuItem {
                       text: type === 'Interfaces' && method5 !== '' ? method5 : ''
                       visible: type === 'Interfaces' && method5 !== ''
                   }
                   MenuItem {
                       text: type === 'Interfaces' && method6 !== '' ? method6 : ''
                       visible: type === 'Interfaces' && method6 !== ''
                   }
                   MenuItem {
                       text: type === 'Interfaces' && method7 !== '' ? method7 : ''
                       visible: type === 'Interfaces' && method7 !== ''
                   }
                   MenuItem {
                       text: type === 'Interfaces' && method8 !== '' ? method8 : ''
                       visible: type === 'Interfaces' && method8 !== ''
                   }
                   MenuItem {
                       text: type === 'Interfaces' && method9 !== '' ? method9 : ''
                       visible: type === 'Interfaces' && method9 !== ''
                   }
                   MenuItem {
                       text: type === 'Interfaces' && method10 !== '' ? method10 : ''
                       visible: type === 'Interfaces' && method10 !== ''
                   }
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
