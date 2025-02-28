import QtQuick 2.15
import QtQuick.Window 2.0
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

// 检查更新弹窗
Popup {
    id:checkupdatePopup
    width:520 * dpi
    height:470 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent
    background:Rectangle {
        color: "transparent"
    }

    Rectangle {
        id:rectTitle
        width: parent.width
        height: 90 * dpi
        color: "transparent"
        anchors.top: parent.top
        Image {
            source: "../res/v2/checkupdate_bk.png"
            anchors.fill: parent
        }

        Text {
            text:"检查更新"
            font.pixelSize: 18 * dpi
            font.bold: true
            color: "#1ECE9A"
            anchors.centerIn: parent
        }

        Image {
            id:imageClose
            source: "../res/v2/popup_close.png"
            scale: dpi
            fillMode: Image.PreserveAspectFit
            anchors.right: parent.right
            anchors.rightMargin: 20 * dpi
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    checkupdatePopup.close()
                }
            }
        }
    }


    Rectangle {
        width: parent.width
        height: parent.height - rectTitle.height
        color: "transparent"
        anchors.bottom: parent.bottom

        Image {
            source: "../res/v2/checkupdate_bk_01.png"
            anchors.fill: parent
        }

        ScrollView {
            width: 380 * dpi
            height:180 * dpi
            anchors.left: parent.left
            anchors.leftMargin: 45 * dpi
            anchors.top: parent.top
            anchors.topMargin: 20 * dpi

            TextArea {
                text:HttpClient.verMessage
                font.pixelSize: 18 * dpi
                color: "#889593"
                wrapMode: Text.WordWrap
                readOnly: true
                enabled: false
                background: Rectangle {
                    color: "transparent"
                }
            }
        }


    }


    Button {
        id:btnStartUpdate
        width: 180 * dpi
        height:60 * dpi
        anchors.left: parent.left
        anchors.leftMargin: 50 * dpi
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 90 * dpi
        visible: HttpClient.findNewVersion
        background: Rectangle {
            id:imageBtnDown
            color: "#1ECF9A"
            radius: 10 * dpi
            Text {
                id:btnCaption
                text: "立即更新"
                font.pixelSize: 16 * dpi
                font.bold: true
                color: "white"
                anchors.centerIn: parent
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                timerProgress.start()
                btnStartUpdate.enabled = false
                HttpClient.downloadUpdatePackage()
            }

            onEntered: {
                opaMaskBtnDown.layer.enabled = true
            }

            onExited: {
                opaMaskBtnDown.layer.enabled = false
            }
        }


        Rectangle {
            id: maskBtnDown
            anchors.fill: parent
            visible: false
        }

        OpacityMask {
            id:opaMaskBtnDown
            anchors.fill: parent
            source: imageBtnDown
            maskSource: maskBtnDown

            layer.enabled: false  // 设置layer为enable
            layer.effect: DropShadow {
                visible: false
                transparentBorder: true
                color: "#72FFFFFF"
                samples:40
            }
        }

        Timer {
            id:timerProgress
            repeat: true
            interval: 100
            running: false
            onTriggered: {
                btnCaption.text = HttpClient.getDownPercent()
            }
        }

    }


    Button {
        id:btnCancel
        width: 180 * dpi
        height:60 * dpi
        anchors.left: parent.left
        anchors.leftMargin: 50 * dpi
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 90 * dpi
        visible: !HttpClient.findNewVersion
        background: Rectangle {
            color: "#1ECF9A"
            radius: 10 * dpi
            Text {
                text: "我知道了"
                font.pixelSize: 16  * dpi
                font.bold: true
                color: "white"
                anchors.centerIn: parent
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                checkupdatePopup.close()
            }
        }

    }

    onOpened: {
        HttpClient.checkUpdateVersion(true)
    }
}
