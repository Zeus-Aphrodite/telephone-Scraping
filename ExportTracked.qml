import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Dialogs 6.5


Dialog {
    id: root

    property string address: " "
        property string mode: " "
            property QtObject headModel: { }
            property QtObject tableModel: { }
            property QtObject formatModel: { }

            signal clearSignal(string message)

            width : 600
            height: 450
            x: (pane2.width - width) / 2 + sideBar.width
            y: (pane2.height - height) / 2
            parent: Overlay.overlay

            modal: true
            title: "Export Tracked Results"
            standardButtons: Dialog.Cancel | Dialog.Ok

            onAccepted: {
                fileDialog.open()
            }

            GroupBox {
                label: Label {text: 'Save as'; color: Material.accent; font.pixelSize: 18; font.bold: true}

                anchors.horizontalCenter: parent.horizontalCenter

                Column {
                    spacing: 10
                    width: root.width - 50
                    anchors.horizontalCenter: parent.horizontalCenter

                    RadioButton {
                        text: "Excel"
                        checked: true
                        width: parent.width
                        onClicked: {
                            fileDialog.defaultSuffix = "xslx";
                        }
                    }
                    RadioButton {
                        id: button
                        text: "Html"
                        width: parent.width
                        onClicked: {
                            fileDialog.defaultSuffix = "html";
                        }
                    }
                    RadioButton {
                        text: "Pdf"
                        width: parent.width
                        onClicked: {
                            fileDialog.defaultSuffix = "pdf";
                        }
                    }
                    RadioButton {
                        text: "Doc"
                        width: parent.width
                        onClicked: {
                            fileDialog.defaultSuffix = "docx";
                        }
                    }
                }
            }



            FileDialog {
                id: fileDialog
                modality : Qt.WindowModal
                nameFilters: ["Text files (*.xlsx *.pdf *.html *.html *.doc *.docx)"]
                title: "Please Choose a Folder to save file"
                currentFolder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
                Component.onCompleted: visible = false
                fileMode : FileDialog.SaveFile
                defaultSuffix : "xlsx"
                selectedFile : root.address + "_tracked" + "." + fileDialog.defaultSuffix

                onAccepted: {
                    clearSignal("clear export")
                    previewExport.open()
                    console.log(fileDialog.selectedFile)
                    Backend.fetch_export(root.address, root.mode)
                }
                onRejected: fileDialog.close()
            }

            PreviewExport {
                id: previewExport
                title: fileDialog.selectedFile
                headModel: root.headModel
                tableModel: root.tableModel
                address: root.address
                mode: root.mode
                path: fileDialog.selectedFile
                extension: fileDialog.defaultSuffix
                formatModel : root.formatModel
            }


        }

