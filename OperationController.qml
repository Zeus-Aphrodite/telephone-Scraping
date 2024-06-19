import QtQuick 6.5
import QtQuick.Controls 6.5
import QtCore 6.5




Item {
    id: root
    implicitWidth: 90
    implicitHeight: 60


    Timer {
        id : timer
        interval: 1500; running: false; repeat: false
        onTriggered: {
            stopBtn.visible = false
        }
    }


    function rootReset()
    {
        stopBtn.visible = true
        stopBtn.enabled = true
    }


    signal cancel(string message)
    signal stop(string message)

    CustomButton {
        id: stopBtn
        anchors.centerIn: parent
        text: "<b>Stop</b>"
        visible : true

        onClicked: {
            stopBtn.enabled = false
            timer.start()
            stop("stop")

        }
    }

    CustomButton {
        id: cancelBtn
        anchors.centerIn: parent
        text: "<b>Cancel</b>"
        visible : !stopBtn.visible

        onClicked: {
            rootReset()
            cancel("reset")
        }
    }

}