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


    BusyIndicator {
        anchors.centerIn: parent
        z: 10
        running: sheetModel.count == 0
    }

    function clearData()
    {
        globalVariable.highList = []
        globalVariable.waybillHighlist = []
        autoSwitch.checked = false
        root.sheetModel.clear() // seems this didnt suit an array, it throws error
        root.columnModel.clear()
        root.sheetNameModel= [ ]
        root.rowModel= [ ]
        root.sheetCurrentIndex= -1
        root.awbList= [ ]
    }


    QtObject {
        id: globalVariable
        property var highList: []
        property var waybillHighlist: [ ]

    }


    Popup {
        id: cellPopup
        property string cellValue: " "

            contentItem: TextEdit {
                text: cellPopup.cellValue
                readOnly: true
                font.pixelSize: 15
            }
        }


        property QtObject sheetModel: { } // seems this didnt suit an array, it throws error
            property QtObject columnModel: { }
            property var sheetNameModel: [ ]
            property var rowModel: [ ]
            property int sheetCurrentIndex: -1
                property var awbList: [ ]
                property var name: sheet_combo.currentText


                    function open(args)
                    {
                        root.visible = true
                    }

                    function close(args)
                    {
                        root.visible = false
                    }


                    function getWidth()
                    {
                        var allWidth = 0
                        for (var i = 0; i < columnModel.count; i++) {
                            var headcol = columnModel.get(i)
                            allWidth += headcol["width"]
                        }
                        return allWidth
                    }

                    function getColumn()
                    {
                        var coln = columnModel.get(columnModel.count - 1)
                        if (typeof coln !== 'undefined' && coln !== null)
                        {
                            return coln["value"]
                        }
                        return " "
                    }

                    function getHighlighted()
                    {
                        var allWidth = 0
                        for (var i = 0; i < sheetModel.count; i++) {
                            var headcol = sheetModel.get(i)
                            allWidth += headcol["highlighted"]
                        }
                        return allWidth
                    }



                    header: Rectangle {
                        height: 60
                        width: parent.width
                        // color: "#2D2D2A"


                        Row {
                            spacing: 20
                            anchors.centerIn: parent

                            CustomLabel {
                                title: "Auto detected waybill"
                                anchors.verticalCenter: parent.verticalCenter
                                input : getHighlighted()
                            }

                            CustomLabel {
                                title: "User Selected waybill"
                                anchors.verticalCenter: parent.verticalCenter
                                input : globalVariable.highList.length
                            }

                            CustomLabel {
                                title: "max column"
                                anchors.verticalCenter: parent.verticalCenter
                                input : getColumn()
                            }
                            CustomLabel {
                                title: "max row"
                                anchors.verticalCenter: parent.verticalCenter
                                input :rowModel.length
                            }
                            CustomLabel {
                                title: "Total sheets"
                                anchors.verticalCenter: parent.verticalCenter
                                input :sheetNameModel.length
                            }
                        }


                    }




                    Flickable {
                        id: flickable
                        anchors.fill: parent
                        contentHeight: sheetView.height
                        contentWidth: sheetView.width
                        flickableDirection : Flickable.HorizontalFlick
                        boundsBehavior : Flickable.StopAtBounds
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        anchors.topMargin: 10
                        anchors.bottomMargin: 10
                        clip:true

                        ScrollBar.horizontal: ScrollBar { height: 12}

                        ListView {
                            id : sheetView
                            height: root.height - 150
                            width: getWidth()
                            spacing : 0
                            clip: true
                            focus: true
                            headerPositioning :ListView.OverlayHeader

                            ScrollBar.vertical: ScrollBar { width: 12 }

                            header: ItemDelegate {
                                id : itemHead
                                width: parent.width
                                height: 40
                                z : 10


                                Row {
                                    spacing: 0
                                    anchors.fill:parent
                                    Repeater {
                                        id:headrepeater
                                        // model: ["A", "B", "C", "D", "E", "F", "G", "H"]
                                        model: columnModel


                                        Label {
                                            text : model.value
                                            height: 40
                                            width: model.width
                                            elide: Text.ElideRight
                                            color: col_combo.currentText === model.value? "blue" : "#808080"
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            background: Rectangle {
                                                border.width: 1
                                                border.color: col_combo.currentText === model.value? "blue" : "#808080"
                                                height: 40
                                                width: model.width
                                                color: model.color
                                            }
                                        }

                                    }
                                }
                            }

                            model: sheetModel


                            delegate: ItemDelegate {
                                id : itemd
                                width: sheetView.width
                                height: 40



                                Row {
                                    spacing: 0
                                    anchors.fill:parent

                                    Repeater {
                                        id: repeater

                                        function getRow()
                                        {
                                            var rowList = sheetModel.get(index)
                                             console.log(rowList);
                                            if (typeof rowList !== 'undefined' && rowList !== null)
                                            {
                                                var eachRow = rowList["row"];
                                                console.log(eachRow);
                                                return JSON.parse(eachRow)
                                            }
                                            return []
                                        }

                                        model:getRow() // model.id : integer (index) available


                                        delegate : Label {
                                            id: cell
                                            text : modelData.value
                                            height: 40
                                            width: modelData.width
                                            elide: Text.ElideRight
                                            color: getColor()
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            background: Rectangle {
                                                border.width: 1
                                                border.color: ((modelData.coordinate === "x") && (row_combo.currentText === modelData.value))? "blue" : "#808080"
                                                height: 40
                                                width: modelData.width
                                                color: modelData.coordinate === col_combo.currentText + row_combo.currentText || globalVariable.highList.includes(modelData.coordinate) ? "#8E82D9": modelData.color
                                            }

                                            function getColor()
                                            {
                                                if (modelData.coordinate === "x")
                                                {
                                                    if (row_combo.currentText === modelData.value)
                                                    {
                                                        return "blue"
                                                    }
                                                    else {
                                                        return "#808080"
                                                    }
                                                }
                                                else {
                                                    return "black"
                                                }
                                            }




                                            function showValue()
                                            {
                                                cellPopup.cellValue = modelData.value
                                                cellPopup.x = (cell.width - cellPopup.width)/2
                                                cellPopup.y = cell.height/2 - cellPopup.height
                                                cellPopup.parent = cell
                                                cellPopup.open()
                                            }



                                            MouseArea {
                                                anchors.fill: parent
                                                acceptedButtons: Qt.RightButton | Qt.LeftButton| Qt.MiddleButton
                                                focus: true

                                                onClicked: (mouse)=> {
                                                if (modelData.coordinate !== "x")
                                                {
                                                    if (mouse.button === Qt.RightButton)
                                                    {
                                                        showValue()
                                                    }
                                                    col_combo.currentIndex = modelData.col + 1
                                                    row_combo.currentIndex = modelData.row - 1
                                                    last_combo.focus = false
                                                }
                                                parent.forceActiveFocus()
                                            }

                                            onDoubleClicked: showValue()


                                        }
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

                        ComboBox {
                            id : sheet_combo
                            width : 150
                            model: sheetNameModel
                            onActivated: {
                                globalVariable.highList = []
                                autoSwitch.checked = false
                                Backend.change_sheet(sheet_combo.currentText)
                            }
                            currentIndex: sheetCurrentIndex
                        }

                        ComboBox {
                            id : col_combo
                            width : 150
                            model: columnModel
                            textRole: "value"
                            valueRole: "coordinate"
                        }

                        ComboBox {
                            id : row_combo
                            // editable : true
                            width : 150
                            model: rowModel
                            onActivated : last_combo.currentIndex = -1
                        }

                        ComboBox {
                            id : last_combo
                            // editable : true
                            width : 150
                            currentIndex : -1
                            editable: true

                            model: getLastList()


                            function handleHighlight()
                            {
                                var highList = []
                                var lastRow = 0
                                for (var i = row_combo.currentIndex ; i < (last_combo.currentIndex + row_combo.currentIndex + 2) ; i++ ) {
                                    highList.push( col_combo.currentText + rowModel[i])
                                    lastRow = i
                                }
                                globalVariable.highList = highList
                                sheetView.positionViewAtIndex(lastRow + 16, ListView.End)
                                sheetView.positionViewAtIndex(lastRow, ListView.End)
                            }

                            onAccepted: handleHighlight()

                            onActivated: handleHighlight()

                            function getLastList()
                            {
                                var lastList = []
                                for (var i = row_combo.currentIndex + 1; i < rowModel.length; i++ ) {
                                    lastList.push(rowModel[i])
                                }
                                return lastList
                            }

                            Menu {
                                visible: last_combo.focus
                                y : - height
                                closePolicy : Popup.NoAutoClose

                                Action {
                                    text: "Last row ( " + rowModel.length + " )"
                                    onTriggered: {
                                        last_combo.currentIndex = last_combo.count - 1
                                        last_combo.accepted()
                                    }
                                }
                                Action {
                                    text: "Cancel"
                                    onTriggered: {
                                        last_combo.currentIndex = -1
                                        row_combo.currentIndex = -1
                                        last_combo.accepted()
                                        globalVariable.highList = []
                                        autoSwitch.checked = false
                                    }
                                }

                            }

                        }

                        CustomButton {
                            id: autoDetect
                            text: "<b>Track</b>"
                            anchors.verticalCenter: parent.verticalCenter


                            onClicked: {
                                var coordinateList = [];
                                if (autoSwitch.checked)
                                {
                                    const highList = Backend.getHighList();
                                    for (var i = 0; i < highList.length; i++) {
                                        coordinateList.push(highList[i].value);
                                    }
                                }
                                else {
                                    var coordinateDict = Backend.getAllCellValues();
                                    for (var i = 0; i < globalVariable.highList.length; i++) {
                                        var coordinate = globalVariable.highList[i]
                                        var cellValue = coordinateDict[coordinate]
                                        coordinateList.push(cellValue)
                                    }
                                }
                                root.awbList = globalVariable.waybillHighlist = coordinateList
                                excelWaybillWindow.awbCount = coordinateList.length
                                excelWaybillWindow.awbText = globalVariable.waybillHighlist.join("\n")
                                excelWaybillWindow.show()
                            }
                        }


                        Switch {
                            id: autoSwitch
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("Use Auto detected waybills")

                            Component.onCompleted: {
                                globalVariable.highList = []
                            }

                            onClicked: {
                                if (checked)
                                {
                                    const highList = Backend.getHighList();
                                    var coordinateList = [];

                                    for (var i = 0; i < highList.length; i++) {
                                        coordinateList.push(highList[i].coordinate);
                                    }
                                    globalVariable.highList = coordinateList
                                    sheetView.positionViewAtIndex(sheetView.currentIndex + 16, ListView.End)
                                    sheetView.positionViewAtIndex(sheetView.currentIndex, ListView.End)
                                }
                                else {
                                    globalVariable.highList = globalVariable.waybillHighlist = root.awbList = []

                                }
                            }
                        }
                    }
                }

            }