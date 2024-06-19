template = """
 Pane {
                    id: pane


                    Flickable {
                        id: flickable
                        anchors.fill: parent
                        contentHeight: column.height


                        Column {
                            id: column
                            width: parent.width
                            spacing : 30


                            Rectangle {
                                id: rectangle1
                                height: 400
                                width: parent.width
                                color: "#a6b6f8"
                                radius: 10

                                Column {
                                    spacing:10
                                    height: parent
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: parent.width

                                    Image {
                                        id: image
                                        height: 320
                                        source: "images/singleBanner.png"
                                        width: parent.width
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    Row {
                                        spacing: parent.width - (label2.width + comboBox.width + 40)
                                        width: parent.width
                                        anchors.horizontalCenter: parent.horizontalCenter


                                        Label {
                                            id: label2
                                            height: 58
                                            font.pixelSize: 18
                                            font.bold: true
                                            // color: "black"
                                            text: "Track a single Air waybill"
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter


                                        }

                                        ComboBox {
                                            id: comboBox
                                            model: ["Format 1", "Format 2", "Format 3"]
                                            width: 200
                                            height: 58


                                        }
                                    }
                                }
                            }


                            Row {
                                spacing : 50
                                width: parent.width
                                height: 80


                                TextField {
                                    id: textField
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 296
                                    height: 50
                                    inputMethodHints : Qt.ImhFormattedNumbersOnly


                                    placeholderText: qsTr("Tracking Number")
                                }

                                Button {
                                    id: button
                                    text: "<b>Track</b>"

                                    height: 60
                                    anchors.verticalCenter: parent.verticalCenter

                                    background: Rectangle {
                                        color: button.down ? "#041f60" : "#a6b6f8"
                                        border.color: "#041f60"
                                        border.width: 2
                                        radius: 5

                                    }
                                }

                            }


                            Rectangle {
                                id: rectangle2

                                width: parent.width
                                height: 209
                                color: "red"
                                radius: 10
                            }
                        }
                    }
                }
"""

print(template.find("id:"))