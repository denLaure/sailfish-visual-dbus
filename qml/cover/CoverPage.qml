import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Column {
        anchors.centerIn: parent
        Image {
            width: parent.width
            height: parent.width * 2
            fillMode: Image.PreserveAspectFit
            source: "qrc:/d-bus.jpg"
        }
        Label {
            text: qsTr("Visual D-Bus")
        }
    }
}


