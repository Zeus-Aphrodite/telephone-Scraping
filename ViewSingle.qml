import QtQuick 6.5
import QtQuick.Controls 6.5




Dialog {
    id: root
    standardButtons: Dialog.Ok
    modal: true
    title: "Details"
    width: 700
    height: 600
    z: 10

    x: (window.width - width) / 2
    y: (window.height - height) / 2

    property var singleDetails: { }


    contentItem: ScrollView {
        width: parent.width
        height: parent.height - 40
        anchors.centerIn: parent


        Column {
            spacing : 15

            Repeater {
                model: singleDetails

                Row {
                    spacing: 15

                    Label {
                        text: modelData[0] + " :"
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        font.italic :true
                        width: 200
                    }

                    TextEdit {
                        text: modelData[1]
                        wrapMode: Text.WordWrap
                        readOnly: true
                        font.bold: true
                        font.pixelSize: 14

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }

}

