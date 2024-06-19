import QtCore 6.5
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 6.5

ApplicationWindow {
    id: window
    width: 1334
    height: 750
    minimumHeight: 400
    minimumWidth: 800
    visible: true
    title: "Auto Tracker"

    ViewSingle {
        id: viewSingle
    }

    Dialog {
        id: messageDialog
        standardButtons: Dialog.Ok
        modal: true
        title: "Message"
        width: 400
        z: 10

        x: (window.width - width) / 2 + sideBar.width
        y: (window.height - height) / 2 + toolBar.height

        property string infoText: " "

            contentItem: Label {
                text: messageDialog.infoText
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        SpreadSheet {
            id: sheet
            title: getLastFilenameWithoutExtension(globalSettings.filePath)
            visible: false
            sheetModel: sheetModel
            columnModel: columnModel

            ListModel {
                id: sheetModel
            }

            ListModel {
                id: columnModel
            }
        }

        ExportTracked {
            id: exportTracked
            headModel: addtfModel
            tableModel: exportResult
            formatModel: formatModel

            onClearSignal: exportResult.clear()

            ListModel {
                id: exportResult
            }
        }

        QtObject {
            id: globalSettings
            property string filePath: ""
                property int currentLoginIndex: 0
                    property string currentTrack: " "
                    }

                    function loadHistory()
                    {
                        historyModel.clear();
                        var history = Backend.history();
                        for (var i = 0; i < history.length; i++) {
                            historyModel.append(history[i]);
                        }
                        // console.log(JSON.stringify(Backend.history()))
                    }

                    function getRowModel(index)
                    {
                        var rown = historyModel.get(index);
                        if (typeof rown !== 'undefined' && rown !== null)
                        {
                            return rown;
                        }
                        return {};
                        }

                        function setUndefined(args, sub)
                        {
                            if (typeof args !== 'undefined' && args !== null)
                            {
                                return args;
                            }
                            return sub;
                        }

                        function getLastFilenameWithoutExtension(filePath)
                        {
                            const pathSegments = filePath.split(/[\\/]/);
                            const lastSegment = pathSegments[pathSegments.length - 1];
                            const filenameParts = lastSegment.split(".");
                            const filenameWithoutExtension = filenameParts[0];
                            return filenameWithoutExtension;
                        }

                        function loadfile(args)
                        {
                            globalSettings.filePath = args;
                            Backend.load_excel(globalSettings.filePath);
                            loadrow.visible = true;
                            choosefile.visible = false;
                            remove_file.visible = true;
                            globalSettings.currentTrack = "Excel";
                        }

                        ToolTip {
                            id: warningTip
                            timeout: 2000
                            delay: 100
                            anchors.centerIn: parent
                        }

                        ToolBar {
                            id: toolBar
                            height: 64
                            position: ToolBar.Header
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.rightMargin: 0
                            anchors.leftMargin: 0
                            anchors.topMargin: 0

                            Label {
                                id: label
                                width: listView.width
                                text: qsTr("SmarTracker")
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                anchors.leftMargin: 5
                                anchors.topMargin: 5
                                anchors.bottomMargin: 5
                                font.italic: false
                                font.bold: true
                                font.weight: Font.Bold
                                font.pointSize: 25
                                color: "white"
                            }

                            Label {
                                id: currPage
                                text: qsTr("Home")
                                anchors.left: label.right
                                anchors.right: parent.right
                                anchors.leftMargin: 10
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                anchors.rightMargin: 5
                                font.pointSize: 25
                                anchors.topMargin: 5
                                font.bold: true
                                font.italic: false
                                font.weight: Font.Bold
                                anchors.bottomMargin: 5
                                color: "white"
                            }
                        }

                        Rectangle {
                            id: sideBar
                            width: 252
                            color: "transparent"
                            anchors.left: parent.left
                            anchors.top: toolBar.bottom
                            anchors.bottom: parent.bottom
                            anchors.topMargin: 0
                            anchors.bottomMargin: 0
                            anchors.leftMargin: 0

                            ListView {
                                id: listView
                                anchors.fill: parent
                                focus: true
                                clip: true
                                highlightMoveDuration: 200
                                highlightMoveVelocity: -1
                                currentIndex: swipeView.currentIndex
                                anchors.rightMargin: 5
                                anchors.leftMargin: 5
                                anchors.bottomMargin: 5
                                anchors.topMargin: 5
                                highlight: Rectangle {
                                    color: "transparent"
                                    Rectangle {
                                        width: 5  // Set the left border width
                                        height: parent.height
                                        color: "darkblue"
                                        anchors.left: parent.left
                                        radius: 3
                                    }
                                }

                                model: ListModel {
                              

                                    ListElement {
                                        page: "Single"
                                        head: "Mode"
                                    }

                                    ListElement {
                                        page: "Excel"
                                        head: "Mode"
                                    }

                                    ListElement {
                                        page: "Paste"
                                        head: "Mode"
                                    }

                                    ListElement {
                                        page: "Formats"
                                        head: "Menu"
                                    }
                                    ListElement {
                                        page: "History"
                                        head: "Menu"
                                    }

                                    ListElement {
                                        page: "Logins"
                                        head: "Menu"
                                    }

                                   
                                }

                                delegate: ItemDelegate {
                                    width: listView.width
                                    text: model.page
                                    font.pixelSize: 16
                                    font.bold: true

                                    Rectangle {
                                        id: isPageActive
                                        anchors.verticalCenter: parent.verticalCenter
                                        height: 18
                                        width: 18
                                        border.width: 0.5
                                        border.color: "#808080"
                                        radius: 9
                                        opacity: 0.8
                                        color: "#39FF14"
                                        visible: activePage()
                                        x: parent.width - 23
                                    }

                                    function activePage()   // status: bool, page:str
                                    {
                                        if (model.page == "Logins")
                                        {
                                            return !saveLogin.enabled;
                                        } else if (model.page == "Single") {
                                        return !singleTrack.enabled;
                                    } else if (model.page == "Excel") {
                                    return !button2.enabled;  // come here asap to correct this
                                } else if (model.page == "Paste") {
                                return !button4b.enabled;  // come here asap to correct this
                            } else {
                            return false;
                        }
                    }

                    highlighted: ListView.isCurrentItem
                    onClicked: {
                        listView.currentIndex = index;
                        swipeView.currentIndex = listView.currentIndex;
                        currPage.text = qsTr(model.page);
                    }
                }

                section.property: "head"
                section.criteria: ViewSection.FullString
                section.delegate: sectionHeading

                Component {
                    id: sectionHeading
                    Rectangle {
                        width: listView.width
                        height: 40
                        anchors.leftMargin: 4
                        radius: 5
                        color: "#a6b6f8" //"#272C3F"
                        required property string section

                        Text {
                            text: section
                            anchors.leftMargin: 10
                            font.bold: true
                            font.pixelSize: 22
                            color: "white"
                            // anchors.verticalCenter: parent.verticalCenter
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }

        Rectangle {
            id: workSpace
            color: "#303ebb"
            anchors.left: sideBar.right
            anchors.right: parent.right
            anchors.top: toolBar.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
            radius: 5

            SwipeView {
                id: swipeView
                anchors.fill: parent
                anchors.rightMargin: 5
                anchors.leftMargin: 5
                anchors.bottomMargin: 5
                anchors.topMargin: 5
                currentIndex: listView.currentIndex
                clip: true
                interactive: false
                orientation: Qt.Vertical

          
                Pane {
                    id: pane0

                    Flickable {
                        id: flickable0
                        anchors.fill: parent
                        contentHeight: column0.height + 100
                        clip: true

                        Column {
                            id: column0
                            width: parent.width
                            spacing: 30

                            Banner {
                                id: singleBanner
                                imagePath: "images/singleBanner.png"
                                description: "     Track a single Number"
                                format: addtfModel
                            }

                            Row {
                                spacing: 50
                                width: parent.width
                                height: 80

                                TextField {
                                    id: textField0
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: 296
                                    height: 50
                                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                                    placeholderText: qsTr("Tracking Number")

                                    ToolTip {
                                        id: singleTip
                                        timeout: 1000
                                        delay: 300
                                    }

                                    onAccepted: {
                                        singleTrack.clicked();
                                    }

                                    onEditingFinished: {
                                        if (length > 0)
                                        {
                                        if (length < 7 || length > 15 || !Number.isFinite(Number(text))) {
                                            singleTip.show(textField0.text + " is invalid tracking number");
                                        }
                                    }
                                }
                            }

                            CustomButton {
                                id: singleTrack
                                text: "<b>Track</b>"
                                anchors.verticalCenter: parent.verticalCenter

                                onClicked: {
                                    if (textField0.length > 7 && textField0.length < 15 && Number.isFinite(Number(textField0.text)))
                                    {
                                        textField0.enabled = singleTrack.enabled = false;
                                        Backend.track_single(textField0.text);
                                    } else {
                                    singleTip.show(textField0.text + " is invalid tracking number");
                                }
                            }
                        }
                    }

                    CustomTable {
                        width: parent.width
                        format: singleBanner.combo
                        headModel: addtfModel
                        tableModel: singleResult
                        viewSingle: viewSingle

                        ListModel {
                            id: singleResult
                        }
                    }
                }
            }
        }

        Pane {
            id: pane2

            FileDialog {
                id: fileDialog
                modality: Qt.WindowModal
                nameFilters: ["Text files (*.xlsx)"]
                title: "Please choose an Excel file"
                currentFolder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
                Component.onCompleted: visible = false
                fileMode: FileDialog.OpenFile

                onAccepted: {
                    loadfile(fileDialog.selectedFile);
                    fileDialog.close();
                }
                onRejected: fileDialog.close()
            }

            Flickable {
                id: flickable2
                anchors.fill: parent
                contentHeight: column2.height + 100
                clip: true

                Column {
                    id: column2
                    width: parent.width
                    spacing: 30

                    Banner {
                        id: excelBanner
                        imagePath: "images/excelBanner.png"
                        description: "     Track Numbers Listed In An Excel File"
                        format: addtfModel

                        DropArea {
                            id: dropArea
                            anchors.fill: parent
                            enabled: true

                            onEntered: drag => {
                            handleDrag(drag);
                        }
                        onDropped: drop => {
                        handleDrop(drop);
                    }
                    onExited: {
                        excelBanner.border.color = "grey";
                        excelBanner.border.width = 0;
                        excelBanner.opacity = 1;
                    }

                    Rectangle {

                        width: 400
                        height: 60
                        border.color: excelBanner.border.color
                        border.width: 3
                        visible: excelBanner.opacity == 1 ? false : true
                        y: 5
                        x: (parent.width - width) / 2
                        radius: 5

                        Label {
                            id: infoLabel
                            anchors.centerIn: parent
                            text: "Here is the drop text"
                            font.pixelSize: 15
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    function handleDrag(drag)
                    {
                        if (loadrow.visible)
                        {
                            infoLabel.text = "Error!!! \nThere is a file loaded already\nRemove the current file to add another one";
                            infoLabel.color = "red";
                            excelBanner.border.color = "red";
                            excelBanner.border.width = 6;
                            excelBanner.opacity = 0.4;
                        } else {
                        var urlist = [];
                        for (var i = 0; i < drag.urls.length; i++) {
                            urlist.push(drag.urls[i]);
                        }
                        if (urlist.length == 1)
                        {
                        if (validateFileExtension(urlist[0])) {
                            infoLabel.text = "Success \nDrop it here";
                            infoLabel.color = "green";
                            excelBanner.border.color = "#0063B2";
                            excelBanner.border.width = 4;
                            excelBanner.opacity = 0.5;
                        } else {
                        infoLabel.text = "Error!!! \nDoes not support this file, only Excel file";
                        infoLabel.color = "red";
                        excelBanner.border.color = "red";
                        excelBanner.border.width = 6;
                        excelBanner.opacity = 0.4;
                    }
                } else {
                infoLabel.text = "Error!!! \nDoes not support multiple files";
                infoLabel.color = "red";
                excelBanner.border.color = "red";
                excelBanner.border.width = 6;
                excelBanner.opacity = 0.4;
            }
        }
    }

    function handleDrop(drop)
    {
        excelBanner.border.color = "grey";
        excelBanner.border.width = 0;
        excelBanner.opacity = 1;
        if (infoLabel.text == "Success \nDrop it here")
        {
            var urlist = [];
            for (var i = 0; i < drop.urls.length; i++) {
                urlist.push(drop.urls[i]);
            }
            loadfile(urlist[0].toString());
            infoLabel.text = " ";
        }
    }

    function validateFileExtension(filePath)
    {
        // Convert filePath to a string
        filePath = filePath.toString();
        // Now you can safely use split on filePath
        var parts = filePath.split('.');
        var extension = parts[parts.length - 1].toLowerCase();
        return extension === "xlsx";
    }
}
}

Row {
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 0
    width: parent.width
    height: 60

    Rectangle {
        id: loadAction
        height: 60
        width: choosefile.width
        color: "transparent"

        CustomButton {
            id: choosefile
            anchors.centerIn: parent
            text: "<b>Choose an Excel File</b>"
            anchors.verticalCenter: parent.verticalCenter

            ToolTip.delay: 500
            ToolTip.timeout: 3000
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Choose an Excel file from your File Manager")

            onClicked: {
                fileDialog.open();
            }
        }

        CustomButton {
            id: remove_file
            anchors.centerIn: parent
            text: "<b>Remove<b/>"
            visible: false

            onClicked: {
                confirmationDialog.open();
            }

            Dialog {
                id: confirmationDialog

                x: (pane2.width - width) / 2 + sideBar.width
                y: (pane2.height - height) / 2
                parent: Overlay.overlay

                modal: true
                title: "Confirmation"
                standardButtons: Dialog.Yes | Dialog.No

                onAccepted: {
                    excelControl.excelReset();
                    remove_file.visible = false;
                    choosefile.visible = true;
                    loadrow.visible = false;
                }

                Column {
                    spacing: 20
                    anchors.fill: parent
                    Label {
                        text: "Are you sure you want to Remove this File.\n file: " + getLastFilenameWithoutExtension(globalSettings.filePath)

                        horizontalAlignment: Text.AlignHCenter
                    }
                    CheckBox {
                        text: "Do not ask again"
                        anchors.right: parent.right
                    }
                }
            }
        }
    }

    Row {
        id: loadrow
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 0
        visible: false
        width: pane2.width - (60 + loadAction.width)

        Label {
            id: fileLink
            wrapMode: Text.WordWrap
            width: parent.width
            font.pixelSize: 16
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: TextInput.AlignHCenter
            text: getLastFilenameWithoutExtension(globalSettings.filePath)

            BusyIndicator {
                anchors.centerIn: parent
                running: sheet.sheetModel.count == 0
            }
        }

        Rectangle {
            id: fileicon
            height: 60
            width: 60

            Image {
                anchors.fill: parent
                source: "images/excel_icon.png"

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.OpenHandCursor
                    onClicked: Qt.openUrlExternally(globalSettings.filePath)
                    onEntered: {
                        fileicon.opacity = 0.7;
                        fileTip.show("Tap to open File");
                    }
                    onExited: {
                        fileicon.opacity = 1;
                    }

                    ToolTip {
                        id: fileTip
                        timeout: 2000
                        delay: 400
                    }
                }
            }
        }
    }
}

Row {
    anchors.horizontalCenter: parent.horizontalCenter
    visible: remove_file.visible
    spacing: 20

    CustomButton {
        id: button2
        text: "<b>Track</b>"

        onClicked: {
            excelControl.rootReset();
            if (!previewbtn.enabled)
            {
                excelWaybillWindow.accepted("accepted");
            } else {
            excelWaybillWindow.show();
        }
    }
}

CustomButton {
    id: previewbtn
    text: "<b>Preview</b>"
    busy: false

    onClicked: {
        sheet.open();
    }
}

OperationController {
    id: excelControl
    anchors.verticalCenter: parent.verticalCenter
    visible: previewbtn.enabled === false
    onCancel: excelReset()

    onStop: {
        // button2.enabled = true
        Backend.stop_excel();
    }

    function excelReset()
    {
        if (!button2.enabled)
        {
            Backend.stop_excel();
        }
        excelResult.clear();
        excelProgress.status = "";
        excelProgress.visible = false;
        sheet.clearData();
        remove_file.visible = false;
        choosefile.visible = true;
        loadrow.visible = false;
        excelProgress.reset();
        button2.enabled = true;
    }
}

CustomButton {
    text: "<b>Export</b>"
    visible: excelProgress.progress > 0 && excelProgress.progress === excelProgress.total
    onClicked: {
        const filename = getLastFilenameWithoutExtension(globalSettings.filePath);
        console.log(filename);
        exportTracked.address = filename;
        exportTracked.mode = "Excel";
        exportTracked.open();
    }
}
}

CustomProgressBar {
    id: excelProgress
    progress: excelResult.count
    total: excelWaybillWindow.awbCount
    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false
}

CustomTable {
    width: parent.width
    format: excelBanner.combo
    headModel: addtfModel
    tableModel: excelResult
    viewSingle: viewSingle

    ListModel {
        id: excelResult
    }
}
}
}

WaybillWindow {
    id: excelWaybillWindow
    onAccepted: {
        const waybills = sheet.awbList;
        var track_name = getLastFilenameWithoutExtension(globalSettings.filePath) + "_" + sheet.name;
        Backend.track_excel(sheet.awbList, track_name, excelResult.count);
        // console.log(sheet.awbList, "\nabout to track excel")
        sheet.close();
        excelProgress.visible = true;
        button2.enabled = previewbtn.enabled = false;
    }
}
}

Pane {
    id: pane4b

    Flickable {
        id: flickable4b
        anchors.fill: parent
        contentHeight: column4b.height + 100
        clip: true

        Column {
            id: column4b
            width: parent.width
            spacing: 30

            Banner {
                id: pasteBanner
                imagePath: "images/pasteBanner.png"
                description: "Track Copied Tracking Numbers From Email, Excel, Document. \n Paste it below to Track, it will Filter only the Valid Tracking Number"

                format: addtfModel
            }

            Row {
                id: row4b
                spacing: 50
                width: parent.width

                ScrollView {
                    width: 600
                    height: 200

                    TextArea {
                        id: textField4b
                        width: 580
                        wrapMode: TextArea.Wrap
                        placeholderText: qsTr("Paste any text that has Tracking Number here.......")
                    }
                }

                CustomButton {
                    id: button4b2
                    text: "<b>Clear</b>"
                    anchors.verticalCenter: parent.verticalCenter

                    onClicked: {
                        pasteControl.pasteReset();
                    }
                }

                CustomButton {
                    id: button4b
                    text: "<b>Track</b>"
                    anchors.verticalCenter: parent.verticalCenter

                    onClicked: {
                        if (textField4b.length > 8)
                        {
                            var awbs = Backend.extract_awb_from_text(textField4b.text);
                            console.log(awbs);
                            pasteWaybillWindow.awbText = awbs.join("\n");
                            pasteWaybillWindow.awbCount = awbs.length;
                            pasteWaybillWindow.show();
                        } else {
                        warningTip.show("Paste Tracking numbers in the Text Area");
                    }
                }
            }

            OperationController {
                id: pasteControl
                visible: textField4b.enabled === false
                onCancel: pasteReset()
                onStop: Backend.stop_paste()
                anchors.verticalCenter: parent.verticalCenter

                function pasteReset()
                {
                    pasteResult.clear();
                    textField4b.clear();
                    textField4b.enabled = true;
                    pasteProgress.status = "";
                    pasteProgress.visible = false;
                    pasteProgress.reset();
                }
            }
        }

        CustomProgressBar {
            id: pasteProgress
            progress: pasteResult.count
            total: pasteWaybillWindow.awbCount
            width: parent.width
            // status: "Tracking ......"
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false
        }

        CustomTable {
            width: parent.width
            format: pasteBanner.combo
            headModel: addtfModel
            tableModel: pasteResult
            viewSingle: viewSingle

            ListModel {
                id: pasteResult
            }
        }
    }
}
WaybillWindow {
    id: pasteWaybillWindow
    onAccepted: {
        var awbs = Backend.extract_awb_from_text(textField4b.text);
        var track_name = "paste_" + awbs[0] + "..." + awbs[awbs.length - 1];
        Backend.track_paste(awbs, track_name, pasteResult.count);
        // console.log(sheet.awbList, "\nabout to track excel")
        textField4b.enabled = button4b.enabled = false;
        pasteProgress.visible = true;
    }
}
}

Pane {
    id: pane8

    Flickable {
        id: flickable8
        anchors.fill: parent
        contentHeight: column8.height
        clip: true

        ListModel {
            id: formatModel

            ListElement {
                key: "SN"
                value: "1"
                checked: false
                width: 60
            }

            ListElement {
                key: "number"
                value: "0942392338"
                checked: true
                width: 110
            }

            ListElement {
                key: "name"
                value: "John Doe"
                checked: false
                width: 200
            }

            ListElement {
                key: "working_hours"
                checked: false
                value: "Monday: 7am - 9pm"
                width: 200
            }

            ListElement {
                key: "rest_days"
                checked: false
                value: "Sunday: Closed"
                width: 200
            }

            ListElement {
                key: "formatted_address"
                checked: false
                value: "Japan, kusaume jifaji"
                width: 200
            }

            ListElement {
                key: "rating"
                checked: false
                value: "4.5"
                width: 60
            }

            ListElement {
                key: "TrackOn"
                checked: false
                value: "9/25/23 10:05AM"
                width: 200
            }
        }

        Column {
            id: column8
            width: pane8.width
            height: pane8.height
            spacing: 5

            Row {

                width: parent.width
                height: parent.height / 7 * 5

                Rectangle {
                    width: parent.width / 2
                    height: parent.height

                    Column {
                        spacing: 20
                        width: parent.width
                        height: parent.height
                        anchors.centerIn: parent

                        Label {
                            text: "Create a Format here, Choose colums you need and want to be re-using \n Slide format in the saves ones to remove"
                            height: 50
                            font.pixelSize: 15
                            font.bold: true
                            wrapMode: TextArea.Wrap
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        ListView {
                            id: checkView
                            height: parent.height - 70
                            width: parent.width
                            anchors.centerIn: parent
                            focus: true
                            clip: true
                            highlightMoveDuration: 100
                            highlightMoveVelocity: -1
                            model: formatModel

                            delegate: CheckDelegate {
                                text: model.key
                                height: 40
                                width: checkView.width
                                checked: model.checked
                                enabled: index == 1 ? false : true

                                onClicked: {
                                    if (checked)
                                    {
                                    if (model.key == "SN") {
                                        tfModel.insert(0, formatModel.get(index));
                                    } else {
                                    tfModel.append(formatModel.get(index));
                                }
                                model.checked = true;
                            } else {
                            for (var i = 0; i < tfModel.count; i++) {
                                if (formatModel.get(index).key == tfModel.get(i).key)
                                {
                                    tfModel.remove(i);
                                }
                            }
                            model.checked = false;
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        width: parent.width / 2
        height: parent.height

        Column {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            padding: 10
            spacing: 10
            TextField {
                id: formatTxt
                maximumLength: 25
                placeholderText: "Enter suggested name for Format"
                width: parent.width - 50
            }

            CustomButton {
                id: saveFormat
                text: "Save Format"

                onClicked: {
                    var elementExist = false;
                    var cols = 0;
                    if (formatTxt.length > 3)
                    {
                    for (var i = 0; i < formatModel.count; i++) {
                        if (formatModel.get(i).checked)
                        {
                            cols = cols + 1;
                        }
                    }
                    for (var i = 0; i < addtfModel.count; i++) {
                        if (addtfModel.get(i).name === formatTxt.text)
                        {
                            elementExist = true;
                            break;
                        }
                    }
                    if (elementExist)
                    {
                        warningTip.show("Format Name Exists, Try Using Another Name");
                    } else if (cols < 3) {
                    warningTip.show("Choose 3 colums and above in order to save");
                } else {
                var colsList = [];
                for (var i = 0; i < formatModel.count; i++) {
                    if (formatModel.get(i).checked)
                    {
                        colsList.push(formatModel.get(i).key);
                        if (i != 1)
                        {
                            formatModel.get(i).checked = false;
                        }
                    }
                }
                addtfModel.append({
                "name": formatTxt.text,
                "cols": JSON.stringify(colsList)
            });
            Backend.format_to_db(formatTxt.text, JSON.stringify(colsList));
            formatTxt.clear();
            tfModel.clear();
            tfModel.append({
            "key": "number",
            "value": "0942392338"
        });
        console.log(colsList);
    }
} else {
warningTip.show("Invalid Format Name");
}
}
}

ListModel {
    id: addtfModel
}

Component.onCompleted: {
    var formats = Backend.get_saved_formats();
    for (var i = 0; i < formats.length; i++) {
        addtfModel.append(formats[i]);
    }
}

Rectangle {
    width: parent.width - 50
    height: parent.height - (60 + formatTxt.height + 30)
    border.width: 2
    border.color: "red"
    radius: 5

    ListView {
        id: formatView
        anchors.centerIn: parent
        width: parent.width - 5
        height: parent.height - 5
        focus: true
        clip: true
        highlightMoveDuration: 200
        highlightMoveVelocity: -1
        currentIndex: -1

        model: addtfModel

        delegate: SwipeDelegate {
            id: formatDelegate
            text: model.name
            width: parent.width

            Component {
                id: formatComponent

                Rectangle {
                    color: SwipeDelegate.pressed ? "#333" : "#444"
                    width: parent.width
                    height: parent.height
                    clip: true

                    SwipeDelegate.onClicked: {
                        if (index === 0)
                        {
                            warningTip.show("Can Not Remove Default");
                        } else {
                        Backend.remove_format_from_db(addtfModel.get(index).name);
                        addtfModel.remove(index);
                    }
                }

                Label {
                    font.pixelSize: formatDelegate.font.pixelSize
                    text: "Remove"
                    color: "white"
                    anchors.centerIn: parent
                }
            }
        }

        swipe.left: formatComponent
        swipe.right: formatComponent
    }
}
}
}
}
}

Rectangle {
    width: parent.width
    height: parent.height / 7 * 2
    Layout.columnSpan: 2

    ListView {
        height: parent.height
        width: parent.width
        anchors.centerIn: parent
        focus: true
        clip: true
        highlightMoveDuration: 100
        highlightMoveVelocity: -1
        orientation: Qt.Horizontal
        layoutDirection: Qt.LeftToRight
        model: tfModel

        ListModel {
            id: tfModel
            ListElement {
                key: "number"
                value: "0942392338"
            }
        }

        ScrollIndicator.horizontal: ScrollIndicator {
            height: 10
            anchors.bottom: parent.bottom
        }

        delegate: Column {

            Label {
                height: 70
                width: formatSample.width
                text: model.key
                wrapMode: TextArea.Wrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                background: Rectangle {
                    color: "#A0A0A0"
                    border.width: 1
                    border.color: "#808080"
                }
            }

            Label {
                id: formatSample
                height: 70
                width: model.key == "SN" ? 80 : 150
                // width: model.key.length > model.value.length ? model.key.length + 20 : model.value.length + 20
                text: model.value
                wrapMode: TextArea.Wrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                background: Rectangle {
                    color: "whitesmoke"
                    border.width: 1
                    border.color: "#808080"
                }
            }
        }
    }
}
}
}
}

Pane {
    id: pane9

    Column {
        id: column9
        anchors.fill: parent
        spacing: 10

        Label {
            text: "Click on each label to see detail, right click for more options"
            height: 30
            font.pixelSize: 16
            width: parent.width
        }

        Preview {
            id: preview
            headModel: addtfModel
            tableModel: exportResult
            formatModel: formatModel
        }

        Dialog {
            id: popup
            anchors.centerIn: workSpace
            parent: workSpace
            width: 700
            height: contentHeight + 160
            modal: true
            focus: true
            title: "Track Details"
            standardButtons: Dialog.Close

            property int index: 1
                property var model: { }

                exit: Transition {
                    NumberAnimation {
                        property: "opacity"
                        from: 1.0
                        to: 0.0
                    }
                }

                enter: Transition {
                    NumberAnimation {
                        property: "opacity"
                        from: 0.0
                        to: 1.0
                    }
                }

                contentItem: ScrollView {
                    Column {
                        spacing: 15

                        Repeater {

                            property var rowModel: getRowModel(popup.index)
                            model: [["Name :", rowModel.name], ["Mode :", rowModel.mode], ["Modified :", rowModel.last_updated], ["Created :", rowModel.timestamp], ["Total Waybills :", rowModel.total], ["Progress :", rowModel.progress], ["Completed :", rowModel.completed]]
                            Row {
                                spacing: 10

                                Label {
                                    text: modelData[0]
                                    font.pixelSize: 16
                                    width: 150
                                    font.italic: true
                                    horizontalAlignment: Text.AlignRight
                                }
                                Label {
                                    width: 400
                                    text: setUndefined(modelData[1], " ")
                                    font.pixelSize: 16
                                    font.bold: true
                                }
                            }
                        }

                        Button {
                            id: moreBtn
                            text: "More.."
                            anchors.horizontalCenter: parent.horizontalCenter
                            onClicked: {
                                historyMenu.index = popup.index;
                                historyMenu.model = popup.model;
                                historyMenu.x = moreBtn.width * 2 - historyMenu.width / 2;
                                historyMenu.y = moreBtn.height / 2;
                                historyMenu.parent = moreBtn;
                                historyMenu.open();
                            }
                        }

                        Row {
                            spacing: 15
                            visible: popup.model.progress < popup.model.total
                            Label {
                                text: "This Tracking was not completed, <b>" + popup.model.progress + "</b>  waybills was tracked out of  <b>" + popup.model.total + "</b>, remains <b>" + (popup.model.total - popup.model.progress) + "</b> <br>Do you want to continue?"
                                font.pixelSize: 14
                                width: 500
                                wrapMode: Text.WordWrap
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Button {
                                text: "Continue"
                                onClicked: popup.close()
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Row {
                            spacing: 15
                            visible: popup.model.delivered < popup.model.total
                            Label {
                                text: "<b>" + popup.model.delivered + "</b> out of <b>" + popup.model.total + "</b> shipments has been delivered so far, remains <b>" + (popup.model.total - popup.model.delivered) + "</b><br>Do you want to re-track for update?"
                                font.pixelSize: 14
                                wrapMode: Text.WordWrap
                                width: 500
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Button {
                                text: "Update"
                                onClicked: popup.close()
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }
            }

            Dialog {
                id: waybillDialog
                anchors.centerIn: workSpace
                parent: workSpace
                width: 400
                height: 500
                modal: true
                focus: true
                title: "Waybills ( " + waybillrepeater.count + " )"
                standardButtons: Dialog.Close

                property var model: []

                contentItem: ScrollView {
                    Column {
                        spacing: 10

                        Repeater {
                            id: waybillrepeater
                            model: waybillDialog.model

                            Text {
                                text: modelData
                            }
                        }
                    }
                }
            }

            Menu {
                id: historyMenu

                property int index: 0
                    property var model: { }

                    Action {
                        text: "View"
                        onTriggered: {
                            exportResult.clear();
                            preview.open();
                            preview.title = historyMenu.model.name;
                            Backend.fetch_export(historyMenu.model.name, historyMenu.model.mode);
                        }
                    }
                    Action {
                        text: "Export"
                        onTriggered: {
                            exportTracked.address = historyMenu.model.name;
                            exportTracked.mode = historyMenu.model.mode;
                            exportTracked.open();
                        }
                    }
                    Action {
                        text: "numbers"
                        onTriggered: {
                            var awblist = historyMenu.model.waybills;
                            var delimeter = ", ";
                            var hotlist = awblist.split(delimeter.trim());
                            waybillDialog.model = hotlist;
                            waybillDialog.open();
                        }
                    }
                    Action {
                        text: "Delete"
                        onTriggered: {
                            confirmationDelete.index = historyMenu.index;
                            confirmationDelete.model = historyMenu.model;
                            confirmationDelete.open();
                        }
                    }
                }

                Dialog {
                    id: confirmationDelete

                    x: (workSpace.width - width) / 2 + sideBar.width
                    y: (workSpace.height - height) / 2
                    parent: Overlay.overlay

                    property int index: 0
                        property var model: { }

                        modal: true
                        title: "Confirmation"
                        standardButtons: Dialog.Yes | Dialog.No

                        onAccepted: {
                            Backend.remove_history_from_db(confirmationDelete.model.name); // do something here
                            historyModel.remove(confirmationDelete.index);
                            popup.close();
                            waybillDialog.close();
                        }

                        Column {
                            spacing: 20
                            anchors.fill: parent
                            Label {
                                text: "Are you sure you want to Remove this History.\n Track details: " + confirmationDelete.model.name

                                horizontalAlignment: Text.AlignHCenter
                            }
                            CheckBox {
                                text: "Do not ask again"
                                anchors.right: parent.right
                            }
                        }
                    }
                    ListView {
                        id: historyListView
                        height: parent.height - 50
                        width: parent.width
                        headerPositioning: ListView.OverlayHeader
                        focus: true
                        clip: true
                        highlightMoveDuration: 200
                        highlightMoveVelocity: -1

                        header: ItemDelegate {
                            z: 10
                            width: historyListView.width
                            Row {
                                anchors.fill: parent
                                spacing: 10

                                Repeater {
                                    model: [["Mode", 120], ["Name", historyListView.width - 550], ["Total", 80], ["Progress", 80], ["Completed", 80]]

                                    Label {
                                        text: modelData[0]
                                        width: modelData[1]
                                        font.pixelSize: 15
                                        font.bold: true
                                        height: parent.height
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter

                                        background: Rectangle {
                                            border.width: 1
                                            border.color: Material.primary
                                            radius: 5
                                        }
                                    }
                                }
                            }
                        }

                        ListModel {
                            id: historyModel
                        }

                        Component.onCompleted: {
                            loadHistory();
                        }

                        model: historyModel // put model here

                        delegate: ItemDelegate {
                            id: itemHistory
                            width: historyListView.width

                            onClicked: {
                                popup.open();
                                popup.model = model;
                                popup.index = index;
                            }

                            MouseArea {
                                id: historyMouseArea
                                anchors.fill: parent
                                acceptedButtons: Qt.RightButton | Qt.LeftButton | Qt.MiddleButton

                                onClicked: mouse => {
                                if (mouse.button === Qt.RightButton)
                                {
                                    historyMenu.index = index;
                                    historyMenu.model = model;
                                    historyMenu.x = (itemHistory.width - historyMenu.width) / 2;
                                    historyMenu.y = itemHistory.height / 2;
                                    historyMenu.parent = itemHistory;
                                    historyMenu.open();
                                } else {
                                popup.open();
                                popup.model = model;
                                popup.index = index;
                            }
                        }
                    }

                    Row {
                        anchors.fill: parent
                        spacing: 10

                        Repeater {
                            id: historyRepaeter

                            property var rowModel: getRowModel(index)
                            model: [[rowModel.mode, 120], [rowModel.name, historyListView.width - 550], [rowModel.total, 80], [rowModel.progress, 80], [rowModel.completed, 80]]

                            Label {
                                text: setUndefined(modelData[0], " ")
                                width: modelData[1]
                                font.pixelSize: 16
                                color: "grey"
                                font.bold: true
                                height: parent.height
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }

                section.property: "category"
                section.criteria: ViewSection.FullString
                section.delegate: historysectionHeading

                Component {
                    id: historysectionHeading
                    Rectangle {
                        width: listView.width
                        height: 40
                        anchors.leftMargin: 4
                        radius: 5

                        //color: "#a6b6f8" //"#272C3F"

                        required property string section

                        Text {
                            text: section
                            anchors.leftMargin: 10
                            font.bold: true
                            font.pixelSize: 22
                            color: "black"
                            anchors.verticalCenter: parent.verticalCenter
                            // anchors.centerIn: parent
                        }
                    }
                }
            }
        }
    }

    Pane {
        id: pane10

        Flickable {
            id: flickable10
            anchors.fill: parent
            contentHeight: column10.height + 100
            clip: true

            Row {
                spacing: 20
                width: parent.width

                Column {
                    id: column10

                    spacing: 30

                    Column {
                        id: loginForm
                        spacing: 10
                        width: 400

                        Label {
                            id: addLogin
                            text: "<b> + Add Api Key</b> <br/> Note: For Fast and Effective tracking, Add your Api Key and set it to default"
                            height: 70
                            width: parent.width
                            font.pixelSize: 16
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            verticalAlignment: Text.AlignVCenter
                        }

                        TextField {
                            id: apiKey
                            placeholderText: "Api Key"
                            width: parent.width
                            onAccepted: username.focus = true
                        }

                        TextField {
                            id: username
                            placeholderText: "Username"
                            width: parent.width
                        }

                        CustomButton {
                            id: saveLogin
                            text: "<b>Save</b>"
                            enabled: true
                            height: 60

                            onClicked: {
                                if (apiKey.length > 3 && username.length > 3)
                                {
                                var elementToAdd = {
                                    "api_key": apiKey.text,
                                    "username": username.text
                                };
                                var elementExists = false;
                                for (var i = 0; i < loginModel.count; ++i) {
                                    if (loginModel.get(i).username === elementToAdd.username)
                                    {
                                        elementExists = true;
                                        break;
                                    }
                                }
                                if (!elementExists)
                                {
                                    saveLogin.enabled = false;
                                    Backend.login_to_db(apiKey.text, username.text);
                                } else {
                                warningTip.show("Username already Existed, Remove it to Add This");
                            }
                        } else {
                        warningTip.show("Fill Account number, Username and Password Correctly");
                    }
                }
            }
        }

        Row {
            spacing: 10

            Component.onCompleted: {
                globalSettings.currentLoginIndex = Backend.get_current_login_index();
            }

            Label {
                text: "Set Default"
                font.pixelSize: 16
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                width: 120
                height: 60
            }

            ComboBox {
                model: getList()
                width: 200
                currentIndex: globalSettings.currentLoginIndex

                onActivated: {
                    Backend.set_current_login_index(currentIndex);
                }

                function getList()
                {
                    var loginList = [];
                    for (var i = 0; i < loginModel.count; i++) {
                        if (loginModel.get(i).username == "wemmy")
                        {
                            loginList.push("Default");
                        } else {
                        loginList.push(loginModel.get(i).username);
                    }
                }
                return loginList;
            }
        }
    }
}

ListModel {
    id: loginModel
}

Component.onCompleted: {
    var logins = Backend.get_saved_logins();
    for (var i = 0; i < logins.length; i++) {
        loginModel.append(logins[i]);
    }
}

Rectangle {
    id: loginCont
    width: parent.width / 2
    height: pane2.height - 40
    radius: 10
    border.width: 2
    border.color: "red"

    ListView {
        id: loginView
        width: parent.width - 20
        height: parent.width - 20
        anchors.centerIn: parent
        focus: true
        clip: true
        highlightMoveDuration: 100
        highlightMoveVelocity: -1
        model: loginModel
        headerPositioning: ListView.OverlayHeader

        header: Rectangle {
            width: parent.width
            height: 70

            Column {
                spacing: 5
                anchors.fill: parent

                Label {
                    text: "Saved Api keys"
                    font.pixelSize: 23
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    text: "Swipe to left or right to delete"
                    font.pixelSize: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        delegate: SwipeDelegate {
            id: swipeDelegateLogin
            text: model.username == "wemmy" ? "Default" : model.username
            font.pixelSize: 16
            font.bold: true
            width: loginCont.width - 20

            Dialog {
                id: loginDialog

                x: (pane2.width - width) / 2 + sideBar.width
                y: (pane2.height - height) / 2
                parent: Overlay.overlay

                modal: true
                title: "Confirmation"
                standardButtons: Dialog.Yes | Dialog.No

                onAccepted: {
                    if (index == 0)
                    {
                        loginDialog.close();
                    } else {
                    loginModel.remove(index);
                    Backend.remove_login_from_db(swipeDelegateLogin.text);
                    Backend.set_current_login_index(0);
                }
            }

            Column {
                spacing: 20
                anchors.fill: parent
                Label {
                    text: index == 0 ? "You cannot Delete a Default Api key" : "Are you sure you want to Delete this Api key.\n Username : " + swipeDelegateLogin.text
                    horizontalAlignment: Text.AlignHCenter
                }
                CheckBox {
                    text: "Do not ask again"
                    anchors.right: parent.right
                }
            }
        }

        Component {
            id: removeComponent

            Rectangle {
                color: SwipeDelegate.pressed ? "#333" : "#444"
                width: parent.width
                height: parent.height
                clip: true

                SwipeDelegate.onClicked: {
                    loginDialog.open();
                }

                Label {
                    font.pixelSize: swipeDelegateLogin.font.pixelSize
                    text: "Delete"
                    color: "white"
                    anchors.centerIn: parent
                }
            }
        }

        swipe.left: removeComponent
        swipe.right: removeComponent
    }
}
}
}
}
}




}
}

function findInHistory(path)
{
    listView.itemAtIndex(7).clicked();
    for (var i = 0; i < historyModel.count; i++) {
        if (path === historyModel.get(i).name)
        {
            historyListView.currentIndex = i;
            historyListView.positionViewAtIndex(i, ListView.Center);
            console.log("seen in history");
            historyListView.itemAtIndex(i).clicked();
        }
    }
}

function handleLoad(loads)
{
    if (loads["access"])
    {
        
        sheet.sheetModel.clear();
        sheet.columnModel.clear();
        var backend_sheet = Backend.sheetList();
 
        for (var i = 0; i < backend_sheet.length; i++) {
            sheet.sheetModel.append(backend_sheet[i]);
        }
        // sheet.sheetModel.append(backend_sheet);
        sheet.columnModel.append(JSON.parse(loads["cols"]));
        sheet.rowModel = JSON.parse(loads["rows"]);
        sheet.sheetNameModel = JSON.parse(loads["sheet_names"]);
        sheet.sheetCurrentIndex = loads["active_sheet_index"];
       
        sheet.open();
    } else {
    warningTip.show(loads["status"]);
    messageDialog.infoText = loads["status"];
    messageDialog.open();
}
}

function handleSingle(sign)
{
    if (sign["truth"])
    {
        sign["SN"] = singleResult.count + 1;
        // console.log(JSON.stringify(sign));
        singleResult.append(sign);
    } else {
    warningTip.show(sign["status"]);
}
loadHistory();
textField0.enabled = singleTrack.enabled = true;
}

function handleExcel(excel)
{
    if (excel["truth"])
    {
        excelResult.append(excel);
        excelProgress.status = "Tracking";
    } else {
    if (sheet.awbList.length === excelResult.count)
    {
        excelProgress.status = "Completed  ✅";
        button2.enabled = previewbtn.enabled = true;
        warningTip.show(excel["status"]);
        loadHistory();
        // update the database on tima and status
    } else if (excel["status"] === "Completed") {
    excelProgress.status = "Completed Before  ✅";
    button2.enabled = true;
    warningTip.show(excel["status"]);
    findInHistory(excel["path"]);
} else if (excel["status"] === "Stopped") {
button2.enabled = true;
warningTip.show(excel["status"]);
excelProgress.status = "Stooped or Paused";
} else {
button2.enabled = true;
loadHistory();
console.log("Error handling excel");
excelProgress.status = "Oopps Tracking stops, check network or website server 📶";
}
}
}

function handlePaste(paste)
{
    if (paste["truth"])
    {
        pasteResult.append(paste);
        pasteProgress.status = "Tracking";
    } else {
    if (pasteWaybillWindow.awbCount === pasteResult.count)
    {
        pasteProgress.status = "Completed  ✅";
        button4b.enabled = textField4b.enabled = true;
        warningTip.show(paste["status"]);
        loadHistory();
        // update the database on tima and status
    } else if (paste["status"] === "Completed") {
    pasteProgress.status = "Completed Before  ✅";
    button4b.enabled = textField4b.enabled = true;
    warningTip.show(paste["status"]);
    findInHistory(paste["path"]);
} else if (paste["status"] === "Stopped") {
button4b.enabled = true;
warningTip.show(paste["status"]);
pasteProgress.status = "Stooped or Paused";
} else {
button3.enabled = true;
loadHistory();
console.log("Error handling paste");
pasteProgress.status = "Oopps Tracking stops, check network or website server 📶";
}
}
}

function handleCheck(checked)
{
    console.log(checked);
    if (checked[0])
    {
    var elementToAdd = {
        "api_key": checked[2],
        "username": checked[3]
    };
    loginModel.append(elementToAdd);
    apiKey.clear();
    username.clear();
}
warningTip.show(checked[1]);
saveLogin.enabled = true;
}

function handleFetch(fetches)
{
    // console.log(fetches)
    exportResult.append(fetches);

}

function handleSave(save)
{
    messageDialog.infoText = save["status"];
    messageDialog.open();
}

Connections {
    target: Backend

    function onCheck(checked)
    {
        handleCheck(checked);
    }

    function onLoad(loads)
    {
        handleLoad(loads);
    }

    function onFetch(fetches)
    {
        handleFetch(fetches);
    }

    function onSave(save)
    {
        handleSave(save);
    }

    function onSingle(sign)
    {
        handleSingle(sign);
    }

    function onExcels(excel)
    {
        handleExcel(excel);
    }

    function onPastes(paste)
    {
        handlePaste(paste);
    }
}
}
