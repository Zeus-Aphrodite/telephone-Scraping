import QtQuick 6.5
import QtQuick.Controls 6.5


Column {
    id: root
    spacing: 15
    height: 100
    width: root.width

    property int progress: 0
        property int total: 0
            property string status: ""
                property string dot: ""

                    function reset()
                    {
                        root.status= ""
                        root.dot= ""
                        root.visible = false
                        innerRect.width = 0
                    }


                    Label {
                        id:range_processName
                        text: dotTimer.running? root.dot : root.status
                        font.bold: true
                        font.pixelSize: 20
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        height:40
                        color: "#0063B2"
                        background: Rectangle {
                            border.width: 1
                            radius: 5
                            border.color: Material.primary
                        }

                        Timer {
                            id: dotTimer
                            interval: 500 // Adjust the interval to control the speed of the animation
                            repeat: true
                            running: root.progress !== root.total && root.progress !== 0 && root.status === "Tracking"


                            onTriggered: {
                                // Update the text to show dots
                                if (root.dot.length === 0)
                                {
                                    root.dot = root.status
                                }
                                root.dot += "."
                                if ( root.dot.length > 11)
                                {
                                    root.dot = "Tracking"
                                }
                            }
                        }
                    }



                    Rectangle {
                     width: root.width
                        height: 30
                        radius : 5
                        border.width: 1
                        border.color: "#808080"
                        color: "#F9F9F9"

                        // Set your initial progress value here

                        Rectangle {
                            id: innerRect
                            width: root.width * (root.progress/root.total) - 4
                            height: parent.height - 4
                            x:2
                            color: Material.primary
                            radius: 5 // Adjust the corner radius as desired
                            anchors.verticalCenter: parent.verticalCenter

                            Behavior on width {
                            NumberAnimation {
                                duration: 500 // Animation duration in milliseconds
                                easing.type: Easing.OutCubic // Easing type
                            }
                        }

                        Behavior on x {
                        NumberAnimation {
                            duration: 500 // Animation duration in milliseconds
                            easing.type: Easing.OutCubic // Easing type
                        }
                    }

                    transitions: Transition {
                        NumberAnimation {
                            properties: "x, width"
                            duration: 500 // Animation duration in milliseconds
                            easing.type: Easing.OutCubic // Easing type
                        }
                    }

                    Text {
                        id:inLinepercent
                        text: root.progress >= 1? Math.round((root.progress/root.total) * 100) + "%" : ""
                        anchors.centerIn: parent
                        color: "#a6b6f8"
                        font.italic: true
                        font.bold: true
                        font.pixelSize: 14

                    }

                }

            }



            Row {
                spacing: root.width - (range_load_percent.width + range_frac.width )
                height: 20
                anchors.horizontalCenter: parent.horizontalCenter

                Text {id: range_load_percent; font.pixelSize : 12;font.bold: true ; text: root.progress >= 1? ((root.progress/root.total)*10000)/100 + "%" : "0%"}
                Text {id:range_frac; font.pixelSize : 12 ;font.bold: true; text: root.progress >= 1? root.progress + " / " + root.total : "0/0"}
            }
        }