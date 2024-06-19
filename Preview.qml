import QtQuick 6.5
import QtQuick.Controls 6.5


ApplicationWindow {
    id: root
    width: 1334
    height: 750
    minimumHeight: 400
    minimumWidth: 800
    visible: false
    title: root.title // dynamic render of the file name
    modality: Qt.WindowModal

    ViewSingle {
        id: viewSingle
    }

    BusyIndicator {
        anchors.centerIn: parent
        z: 10
        running: tableModel.count == 0
    }

    function setUndefined(args, sub)
    {
        if (typeof args !== 'undefined' && args !== null)
        {
            return args
        }

        return sub
    }

    property QtObject headModel: { }
    property QtObject tableModel: { }
    property QtObject formatModel: { }
    property var widthdict: { }
    property var headWidth: { }
    property int totalWidth: 0


        function clearExport()
        {
            root.address= " "
            root.mode= " "
            root.path= " "
            root.extension= " "
            root.headModel.clear()
            root.tableModel.clear()
            root.formatModel.clear()
            root.widthdict.clear()
            root.totalWidth= 0
        }



        Component.onCompleted: {
            setWidth()
        }


        function setWidth()
        {
            var jsdict = { }
                for (let i = 0; i < formatModel.count ; i++) {
                    var currkey = formatModel.get(i)
                    jsdict[currkey.key] = currkey.width
                }
                root.widthdict = jsdict
            }



            function open()
            {
                root.visible = true
            }

            function close()
            {
                root.visible = false
            }


            Flickable {
                id: flickable
                anchors.fill: parent
                contentHeight: exportView.height
                contentWidth: exportView.width
                flickableDirection : Flickable.HorizontalFlick
                boundsBehavior : Flickable.StopAtBounds
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                clip:true

                ScrollBar.horizontal: ScrollBar { height: 12}



                ListView {
                    id : exportView
                    anchors.centerIn: parent
                    width: root.totalWidth
                    height: root.height - 100
                    spacing : 0
                    clip: true
                    focus: true
                    headerPositioning :ListView.OverlayHeader

                    ScrollBar.vertical: ScrollBar { width: 12 }

                    header: ItemDelegate {
                        id : rangeItemHead
                        z: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        height: 40


                        function rangeExtractor()
                        {
                            for (var x = 0; x < addtfModel.count; x++) {
                                if (format.currentText === headModel.get(x).name)
                                {
                                    var resultList = [ ]
                                    var totalWidth = 0
                                    var jlist = JSON.parse(headModel.get(x).cols)
                                    for (let i = 0; i < jlist.length; i++) {
                                        resultList.push([jlist[i], root.widthdict[jlist[i]]])
                                        totalWidth += root.widthdict[jlist[i]]
                                    }
                                    root.totalWidth = totalWidth
                                    root.headWidth = resultList
                                    return resultList
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

                                Label {
                                    id:rangeheadcell
                                    font.pixelSize: 15
                                    text :"<b>" + modelData[0] + "</b>"
                                    width: modelData[1]
                                    height: 40
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    color: "#808080"
                                    elide: Text.ElideRight
                                    background: Rectangle {
                                        width: modelData[1]
                                        height: 40
                                        border.width: 1
                                        color: "#f4f4f4"
                                        border.color: "#808080"

                                    }
                                }

                            }
                        }
                    }

                    model: tableModel


                    delegate: ItemDelegate {
                        id : rangeitemd
                        width: exportView.width
                        height: 40



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
                                            hotList.push([eachRow[coldList[i]], root.widthdict[coldList[i]]])
                                        }
                                        return hotList
                                    }
                                    return [ ]
                                }





                                Label {
                                    id: cell
                                    height:40
                                    width: modelData[1]
                                    font.pixelSize: 15
                                    text : setUndefined(modelData[0], " ")
                                    elide: Text.ElideRight
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    background: Rectangle {
                                        width: modelData[1]
                                        height: 40
                                        border.width: 1
                                        border.color: "#808080"
                                        color: "transparent"
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
                                    viewSingle.singleDetails = convertObjectToList(eachRow)
                                    viewSingle.open()
                                    viewSingle.title = eachRow["number"] + " - Details"
                                }

                            }
                        }
                    }


                }
            }

            footer: Rectangle {
                height: 70
                width: root.width
                // color: "#2D2D2A"
                Row {
                    anchors.centerIn: parent
                    spacing: 20

                    Label {
                        text: "Choose Track Format: "
                        color: Material.accent
                        font.pixelSize: 18
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }


                    ComboBox {
                        id: format
                        model: addtfModel
                        currentIndex: 0
                        textRole: "name"
                        valueRole: "cols"
                        width: 200
                        height: 58
                    }


                }
            }

        }