import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.visual.dbus.dbusinspector 1.0
import harbour.visual.dbus.interfacemember 1.0
import harbour.visual.dbus.argument 1.0

Page {
    property alias serviceName: header.title
    property string servicePath: value
    property string interfaceName: value
    property InterfaceMember method: value
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
                text: 'Method: ' + method.name
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
            Button {
                width: parent.width
                text: 'Execute'
                onClicked: {
                    var arguments = [];
                    for (var i = 0; i < inputArgumentsView.count; i++) {
                        arguments[i] = inputArgumentsView.children[0].contentItem.children[i].children[1].text;
                    }
                    var result = dbusInspector.callMethod(serviceName, isSystemBus, servicePath,
                                                          interfaceName, method.name, arguments);
                    outputTextArea.text = result.length === 0 ? 'No response' : result;
                }
            }
            SectionHeader {
                text: 'Input arguments'
                wrapMode: Text.Wrap
            }
            ColumnView {
                id: inputArgumentsView
                width: parent.width
                itemHeight: Theme.itemSizeExtraLarge
                flickable: flickable
                delegate: Column {
                    width: parent.width
                    Label {
                        text: modelData.name + " (" + modelData.type + ")"
                    }
                    TextField {
                        id: argumentInput
                        width: parent.width
                    }
                }
                model: method.inputArguments
            }
            SectionHeader {
                text: 'Output'
                wrapMode: Text.Wrap
            }
            TextArea {
                id: outputTextArea
                width: parent.width
                height: Theme.itemSizeHuge * 2
                placeholderText: 'The result will be here..'
                readOnly: true
            }
        }
        VerticalScrollDecorator { }
    }
}
