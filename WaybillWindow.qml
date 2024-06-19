import QtQuick 6.5
import QtQuick.Controls 6.5


Window {
    id: root
    x: (window.width - width) / 2 + sideBar.width
    y: (window.height - height) / 2 + toolBar.height
    modality: Qt.WindowModal
    width: 600
    height :500
    maximumHeight : 500
    maximumWidth : 600
    minimumHeight : 500
    minimumWidth : 600
    title: "Choosen Waybill"

    signal accepted(string message)


    property int awbCount: 0
        property string awbText: " "



            Dialog {
                id: messageDialog
                standardButtons: Dialog.Ok
                modal: true
                title: "Message"
                width: 400
                anchors.centerIn: parent


                property string infoText: " "

                    contentItem: Label {
                        text: messageDialog.infoText
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                }



                Column {
                    spacing:10
                    width: parent.width - 10
                    height: parent.height - 10
                    anchors.centerIn: parent



                    Label {
                        height: 50
                        width: parent.width
                        text: root.awbCount + " Waybills found"
                        color: "blue"
                        font.pixelSize: 18
                        font.bold : true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        background: Rectangle {
                            border.width: 2
                            border.color: "blue"
                            radius: 5
                        }
                    }


                    Rectangle {
                        width: parent.width
                        height: parent.height - 150
                        border.width: 2
                        border.color: "blue"
                        radius: 5
                        anchors.horizontalCenter: parent.horizontalCenter

                        ScrollView {
                            anchors.fill: parent
                            Text {
                                width: parent.width
                                x: 20
                                text: root.awbText
                                font.pixelSize : 16

                            }
                        }

                    }

                    Row {
                        spacing: 20
                        Label {
                            text: "Continue Tracking? "
                            height: 50
                            width: 400
                            color: "blue"
                            font.pixelSize: 16
                            font.bold : true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                        }

                        CustomButton {
                            id: waybillYes
                            text: "<b>YES</b>"

                            onClicked: {
                                if (root.awbCount!==0)
                                {
                                    accepted("accepted")
                                    root.close()
                                }
                                else {
                                    messageDialog.infoText = "No waybill found"
                                    messageDialog.open()
                                }

                            }

                        }
                        CustomButton {
                            id: waybillNo
                            text: "<b>NO</b>"

                            onClicked: {
                                root.close()
                            }
                        }

                    }

                }

            }