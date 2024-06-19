import QtQuick 6.5
import QtQuick.Controls 6.5


Rectangle {
    id: root

    width: root.width
    height: calculateHeight()
    radius: 10
    border.width: 3
    border.color: Material.accent


    property QtObject viewSingle: { }

    property QtObject format: { }
    property QtObject headModel: { }
    property QtObject tableModel: { }

    function calculateHeight()
    {
        var calculatedHeight = rangetrackingView.count * 60 + 120;
        return Math.min(calculatedHeight, 450);
    }


    ListView {
        id : rangetrackingView
        anchors.centerIn: parent
        width: parent.width - 20
        height: parent.height - 20
        spacing : 0
        clip: true
        focus: true
        headerPositioning :ListView.OverlayHeader
        currentIndex : rangetrackingView.count - 1
        onMovementStarted: {
            rangetrackingView.highlightFollowsCurrentItem = false
            timer.restart()
        }
        onMovementEnded: {
            timer.start()
        }

        Timer {
            id: timer
            interval: 5000
            repeat: false
            running : false
            onTriggered: {
                rangetrackingView.highlightFollowsCurrentItem = true
            }
        }


        header: ItemDelegate {
            id : rangeItemHead
            z: 10
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: 60


            function rangeExtractor()
            {
                for (var i = 0; i < addtfModel.count; i++) {
                    if (format.currentText === headModel.get(i).name)
                    {
                        return JSON.parse(headModel.get(i).cols)
                    }
                }

            }


            Row {
                spacing: 0
                anchors.fill:parent
                Repeater {
                    id:rangeheadrepeater
                    // model: ["SN", "TRACKING NUMBER", "SENDER", "P.O.D", "PHONE", "STATUS", "SENDER", "P.O.D"]
                    model: rangeExtractor()



                    Rectangle {
                        width: rangeItemHead.width/rangeheadrepeater.count
                        height: parent.height
                        border.width: 1
                        color: "#f4f4f4"
                        border.color: "#808080"


                        Label {
                            id:rangeheadcell
                            anchors.centerIn: parent
                            font.pixelSize: 90/rangeheadrepeater.count + 2
                            text :"<b>" + modelData + "</b>"
                            font.bold: true
                            wrapMode: TextArea.Wrap
                            color: "#808080"

                        }
                    }

                }
            }
        }

        model: tableModel


        delegate: ItemDelegate {
            id : rangeitemd
            width: rangetrackingView.width
            height: 60

            Rectangle {
                anchors.fill: parent
                color: index % 2 == 1? "#f4f4f4" : "transparent"


                Row {
                    spacing: 0
                    anchors.fill:parent


                    Repeater {
                        id:rangerow_repeater
                        model: rangeupdateTable()

                        function rangeupdateTable()
                        {
                            var coldList = JSON.parse(format.currentValue)
                            // console.log(coldList)
                            var hotList = [];

                            var eachRow = tableModel.get(index)
                            if (typeof eachRow !== 'undefined' && eachRow !== null)
                            {
                                for (var i = 0; i < coldList.length ; i++) {
                                    hotList.push(eachRow[coldList[i]])
                                }
                                return hotList
                            }
                            return [ ]
                        }





                        Label {
                            id:cell
                            width: rangeitemd.width / rangerow_repeater.count
                            height: parent.height
                            font.pixelSize: 90/rangerow_repeater.count
                            text : modelData
                            color : "black"
                            wrapMode: TextArea.Wrap
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            background: Rectangle {
                                width: rangeitemd.width / rangerow_repeater.count
                                height: parent.height
                                border.width: 1
                                border.color: "#808080"
                                color: "transparent"
                            }
                        }

                    }
                }

            }

            MouseArea {
                anchors.fill: parent
                onClicked: {

                    function convertObjectToList(obj)
                    {
                        var result = [];
                        for (var key in obj) {

                            result.push([key, obj[key]]);

                        }
                        return result;
                    }

                    var eachRow = tableModel.get(index)
                    if (typeof eachRow !== 'undefined' && eachRow !== null)
                    {
                        root.viewSingle.singleDetails = convertObjectToList(eachRow)
                        root.viewSingle.title = eachRow["number"] + " - Details"
                        root.viewSingle.open()

                    }

                }
            }
        }


    }

}