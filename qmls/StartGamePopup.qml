import QtQuick 2.12
import QtQuick.Controls 2.12
import GameDetails 1.0

// 关于我们弹窗
Popup {
    id:startGamePopup
    width:520 * dpi
    height:380 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    background:Rectangle {
        color: "transparent"
    }

    onClosed: {
        startGamePopup.destroy()
    }

    Rectangle {
        id:rectTitle
        width: parent.width
        height: 90 * dpi
        color: "transparent"
        anchors.top: parent.top
        Image {
            source: "../res/v2/startgame_bk.png"
            anchors.fill: parent
        }

        Text {
            text:"温馨提示"
            font.pixelSize: 18 * dpi
            font.bold: true
            color: "#12C195"
            anchors.centerIn: parent
        }

        Image {
            source: "../res/v2/popup_close.png"
            fillMode: Image.PreserveAspectFit
            scale: dpi
            anchors.right: parent.right
            anchors.rightMargin: 20 * dpi
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    startGamePopup.close()
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
            source: "../res/v2/startgame_bk01.png"
            anchors.fill: parent
        }

        Text {
            text:"亲爱的玩家, 游戏即将启动并开始计算游玩时长"
            anchors.top: parent.top
            anchors.topMargin: 70 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#141B26"
            font.pixelSize: 14 * dpi
        }


        Rectangle {
            id:btnConfirm
            width: 300 * dpi
            height: 60 * dpi
            color: "#1ECF9C"
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: checkNoNotify.top
            anchors.bottomMargin: 10 * dpi
            Text {
                text:"确认"
                font.pixelSize: 14 * dpi
                color: "white"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    HttpClient.updateStartGameNoTipsSettings(btnCheck.checked)
                    GameDetails.queryUserRemainTime()
                    startGamePopup.close()
                }
            }
        }


        Row {
            id:checkNoNotify
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20 * dpi
            spacing: 5 * dpi
            Button {
                id:btnCheck
                width: 20
                height: 20
                checkable:true
                checked: false
                anchors.verticalCenter: parent.verticalCenter
                background: Rectangle {
                    color: "transparent"
                    Image {
                        source: btnCheck.checked ? "../res/v2/radio_check.png" :
                                           "../res/v2/radio_uncheck.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        btnCheck.checked = !btnCheck.checked
                    }
                }
            }

            Text {
                text:"不再提醒"
                font.pixelSize: 12 * dpi
                anchors.verticalCenter: parent.verticalCenter
                color: "#9AA8A6"
            }

        }
    }
}
