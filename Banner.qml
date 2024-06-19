import QtQuick 6.5
import QtQuick.Controls 6.5



Rectangle {
    id: root
    height: 320
    width: parent.width
    color: "#a6b6f8"
    radius: 10

    property string imagePath: " "
        property string description: " "
            property QtObject format: { }
            property QtObject combo: comboBox0

                Column {
                    spacing:10
                    height: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width

                    Image {
                        id: image0
                        height: 240
                        source: imagePath
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Row {
                        spacing: parent.width - (label0.width + comboBox0.width + 40)
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter


                        Label {
                            id: label0
                            height: 58
                            font.pixelSize: 18
                            font.bold: true
                            // color: "black"
                            text: description
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter


                        }

                        ComboBox {
                            id: comboBox0
                            model: format
                            currentIndex: 0
                            textRole: "name"
                            valueRole: "cols"
                            width: 200
                            height: 58

                        }
                    }
                }
            }