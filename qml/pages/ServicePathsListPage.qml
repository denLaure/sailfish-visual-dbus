import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.visual.dbus.dbusinspector 1.0


Page {
    property alias serviceName: header.title
    property bool isSystemBus: true

    DBusInspector {
        id: dbusInspector
    }

    PageHeader {
        id: header
        anchors.top: parent.top
    }

    Label {
        id: listHeader
        text: pathsListView.model.length === 0 ? 'No paths available for this service.' : 'Paths:'
        font.pixelSize: Theme.fontSizeLarge
        font.underline: pathsListView.model.length !== 0
        anchors {
            top: header.bottom
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
        }
        wrapMode: Text.Wrap
    }

    SilicaListView {
        id: pathsListView
        anchors {
            top: listHeader.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
        }
        spacing: 0
        clip: true
        model: dbusInspector.getPathsList(serviceName, isSystemBus)
        delegate: ListItem {
            id: listItem
            height: label.contentHeight + Theme.paddingLarge
            contentHeight: label.contentHeight + Theme.paddingLarge
            Label {
                id: label
                text: modelData
                anchors {
                    fill: parent
                    leftMargin: Theme.horizontalPageMargin * 1.5
                    rightMargin: Theme.horizontalPageMargin * 1.5
                }
                wrapMode: Text.Wrap
                verticalAlignment: Text.AlignVCenter
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            }
            onClicked: {
                pageStack.push(Qt.resolvedUrl("ServiceInterfacesListPage.qml"),
                               {"serviceName": serviceName, "servicePath": modelData, "isSystemBus": isSystemBus});
            }
        }
    }
}
