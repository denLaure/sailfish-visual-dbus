import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.visual.dbus.dbusinspector 1.0
import harbour.visual.dbus.interfacemember 1.0

Page {
    property alias serviceName: header.title
    property string servicePath: value
    property string interfaceName: value
    property InterfaceMember property: value
    property bool isSystemBus: true

    DBusInspector {
        id: dbusInspector
    }

    PageHeader {
        id: header
        anchors.top: parent.top
    }

    SilicaFlickable {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentHeight: column.height
        clip: true
        Column {
            id: column
            anchors {
                top: parent.top
                left: parent.left
                leftMargin: Theme.horizontalPageMargin
                right: parent.right
                rightMargin: Theme.horizontalPageMargin
            }
            Label {
                width: parent.width
                text: 'Path: ' + servicePath
                font.pixelSize: Theme.fontSizeLarge
                wrapMode: Text.Wrap
            }
            Label {
                width: parent.width
                text: 'Interface: ' + interfaceName
                font.pixelSize: Theme.fontSizeLarge
                wrapMode: Text.Wrap
            }
            Label {
                width: parent.width
                text: 'Property: ' + property.name
                font.pixelSize: Theme.fontSizeLarge
                wrapMode: Text.Wrap
            }
            Label {
                width: parent.width
                text: 'Type: ' + property.type
                font.pixelSize: Theme.fontSizeLarge
                wrapMode: Text.Wrap
            }
            Rectangle {
                height: 3
                x: -Theme.horizontalPageMargin
                width: parent.width + 2 * Theme.horizontalPageMargin
                color: Theme.highlightColor
            }
            Rectangle {
                height: Theme.paddingLarge
                width: parent.width
                color: "transparent"
            }
            Label {
                id: valueLabel
                width: parent.width
                text: property.access === "write" ? "Property cannot be read" : "Value: "
                                                    + dbusInspector.getInterfaceProperty(serviceName, servicePath,
                                                                                         interfaceName, property.name, isSystemBus)
                font.pixelSize: Theme.fontSizeLarge
                wrapMode: Text.Wrap
            }
            Row {
                width: parent.width
                Label {
                    id: textAreaName
                    text: "New Value: "
                    font.pixelSize: Theme.fontSizeLarge
                }
                TextArea {
                    id: newValueArea
                    width: parent.width - textAreaName.width
                    height: Theme.itemSizeMedium
                    placeholderText: property.access === "read" ? "Cannot be written" : "Enter new value"
                    readOnly: property.access === "read"
                }
            }
            Button {
                enabled: property.access !== "read"
                width: parent.width
                text: 'Write'
                onClicked: {
                    dbusInspector.setInterfaceProperty(serviceName, servicePath, interfaceName,
                                                       property.name, isSystemBus, newValueArea.text);
                    valueLabel.text = "Value: " + dbusInspector.getInterfaceProperty(serviceName, servicePath,
                                                                                     interfaceName, property.name, isSystemBus)
                }
            }
        }
        VerticalScrollDecorator { }
    }
}
