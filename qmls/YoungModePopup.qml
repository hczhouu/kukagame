import QtQuick 2.15
import QtQuick.Controls 2.15


// 青少年模式弹窗
Popup {
    id:juvenilePopup
    width:820 * dpi
    height:590 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent
    background:Rectangle {
        color: "transparent"
    }

    onClosed: {
        juvenilePopup.destroy()
    }

    Rectangle {
        id:rectTitle
        width: parent.width
        height: 90 * dpi
        color: "transparent"
        anchors.top: parent.top
        Image {
            source: "../res/v2/youthmode_bk.png"
            anchors.fill: parent
        }

        Text {
            text:HttpClient.userJuniorStatus ? "青少年模式已开启" : "青少年模式未开启"
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
                    juvenilePopup.close()
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
            source: "../res/v2/youthmode_bk_01.png"
            anchors.fill: parent
        }


        Text {
            id:textTips
            anchors.top: parent.top
            anchors.topMargin: 45 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            text:"为呵护未成年人健康成长,酷卡云特别推出青少年模式,该模式下指定时间段内无法进行游戏体验，请监护人主动选择并\n设置监护密码"
            font.pixelSize: 14 * dpi
            color: "#131A25"
        }


        Rectangle {
            id:rectTimes
            width: 740 * dpi
            height:120 * dpi
            color: "#DDF5F1"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: textTips.bottom
            anchors.topMargin: 80 * dpi

            Row {
                spacing: 40 * dpi
                anchors.centerIn: parent
                Image {
                    source: "../res/v2/youthmode_icon.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }

                Image {
                    source: "../res/v2/youthmode_spliter.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text:"游戏体验时间\r\n周五、六、日和法定节假日每日20:00-21:00"
                    font.pixelSize: 14 * dpi
                    color: "#9AA8A6"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }


        Button {
            id:btnEnable
            width: 400 * dpi
            height: 60 * dpi
            anchors.top: rectTimes.bottom
            anchors.topMargin: 85 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                color: "#1ECE9B"
                radius: 10
            }

            Text {
                text: HttpClient.userJuniorStatus ? "关闭青少年模式" : "开启青少年模式"
                font.pixelSize: 16 * dpi
                color: "white"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    juvenilePopup.close()
                    if (!HttpClient.userJuniorStatus)
                    {
                        //juvenilePop.open()
                        showPopup('JuvenileSetPassPopup.qml')
                    } else {
                        //juvenileClosePop.open()
                        showPopup('JuvenileClosePopup.qml')
                    }
                }
            }
        }


        Text {
            visible: HttpClient.userJuniorStatus
            text:"修改密码"
            font.pixelSize: 12 * dpi
            color: "#9AA8A6"
            anchors.left: btnEnable.left
            anchors.top: btnEnable.bottom
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    juvenilePopup.close()
                    modifyPassPopup.youthModeModify = true
                    modifyPassPopup.open()
                }

                onEntered: {
                    parent.font.underline = true
                }

                onExited: {
                    parent.font.underline = false
                }
            }
        }


        Text {
            visible: HttpClient.userJuniorStatus
            text:"忘记密码"
            font.pixelSize: 12 * dpi
            color: "#9AA8A6"
            anchors.right: btnEnable.right
            anchors.top: btnEnable.bottom
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    juvenilePopup.close()
                    showPopup('JuvenileForgetPopup.qml')
                }

                onEntered: {
                    parent.font.underline = true
                }

                onExited: {
                    parent.font.underline = false
                }
            }
        }

    }
}
