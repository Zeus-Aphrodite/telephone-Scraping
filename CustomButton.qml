import QtQuick 6.5
import QtQuick.Controls 6.5



Button {
    id: root
    text: root.text
    implicitHeight: 60

    property bool busy: true

        BusyIndicator {
            anchors.centerIn: parent
            running: root.enabled == false && root.busy
        }


        background: Rectangle {
            color: root.down ? "#041f60" : "#a6b6f8"
            border.color: "#041f60"
            border.width: 2
            radius: 5

        }
    }