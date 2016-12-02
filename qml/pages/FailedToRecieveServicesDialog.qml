import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {

    Column {
        width: parent.width

        DialogHeader {
            acceptText: qsTr("Try again")
            cancelText: qsTr("Close")
        }

        Label {
            font.weight: Theme.fontSizeLarge
            width: parent.width
            wrapMode: Text.WordWrap
            text: qsTr("Failed to recieve list of services. You can try again or close the application.")
        }
    }

    onDone: {
        if(result === DialogResult.Accepted) {
            pageStack.clear();
            pageStack.push(Qt.resolvedUrl("MainPage.qml"));
        } else {
            Qt.quit();
        }
    }
}
