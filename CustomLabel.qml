import QtQuick 6.5
import QtQuick.Controls 6.5



Row {
    id: root
    property string title: ""
        property string input: ""

            spacing:10

            Label {
                text: title + " : "
                font.pixelSize: 15
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }

            TextField {
                readOnly: true
                text: input
                width: 70
                height: 50
            }



        }