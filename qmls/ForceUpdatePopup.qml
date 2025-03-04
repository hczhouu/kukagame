import QtQuick 2.12
import QtQuick.Controls 2.12


// 强制更新弹窗
Popup {
    id:forceUpdatePopup
    width:520 * dpi
    height:470 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    onClosed:{
        forceUpdatePopup.close()
    }

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
            text:"发现新版本"
            font.pixelSize: 18 * dpi
            font.bold: true
            color: "#1ECE9A"
            anchors.centerIn: parent
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
            width: parent.width * 0.9
            height:250 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20 * dpi
            ScrollBar.horizontal.policy:Qt.ScrollBarAlwaysOff
            TextArea {
                text:HttpClient.verMessage
                font.pixelSize: 14 * dpi
                color: "#131A25"
                wrapMode: Text.WordWrap
                readOnly: true
                enabled: false
                clip: true
                background: Rectangle {
                    color: "transparent"
                }
            }
        }


        Button {
            id:btnUpdate
            width: 180 * dpi
            height: 60 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20 * dpi
            background: Rectangle {
                color: "#1ECF9B"
                radius: 10

                Text {
                    id:textStart
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
                    btnUpdate.enabled = false
                    HttpClient.downloadUpdatePackage()
                }
            }


            Timer {
                id:timerProgress
                repeat: true
                interval: 100
                running: false
                onTriggered: {
                    textStart.text = HttpClient.getDownPercent()
                }
            }
        }
    }

}
