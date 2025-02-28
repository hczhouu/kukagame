import QtQuick 2.15
import QtQuick.Controls 2.15

// 关闭窗口提示
Popup {
    id:exitAppPopup
    width:500 * dpi
    height:280 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    property bool exitApp: false
    property bool noNotify: false

    onClosed: {
        exitAppPopup.destroy()
    }

    background: Rectangle {
        color: "transparent"

    }

    Rectangle {
        id:rectTitle
        width: parent.width
        height: 50 * dpi
        color: "#141B26"
        anchors.top: parent.top
        Text {
             text:"关闭提示"
             font.pixelSize: 18 * dpi
             font.bold: true
             anchors.centerIn: parent
             color: "#1ECE9A"
        }

        Image{
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
                    exitAppPopup.close()
                }
            }
        }
    }


    Rectangle {
        width: parent.width
        height: parent.height - rectTitle.height
        color: "white"
        anchors.bottom: parent.bottom


        Column {
            spacing: 10 * dpi
            anchors.left: parent.left
            anchors.leftMargin: 50 * dpi
            anchors.top: parent.top
            anchors.topMargin: 20 * dpi

            RadioButton {
                id:btnCatch
                checked: !HttpClient.closeExit
                indicator: Image {
                    source: btnCatch.checked ? "../res/v2/check_sel.png" :
                                               "../res/v2/check_unsel.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    scale: dpi
                }

                contentItem: Text {
                    text: "最小化到系统托盘"
                    font.pixelSize: 13 * dpi
                    opacity: enabled ? 1.0 : 0.3
                    color: "#A4A6AB"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: btnCatch.indicator.width
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        btnCatch.checked = true
                        exitApp = false
                        HttpClient.closeExit = false
                    }
                }
            }

            RadioButton {
                id:btnNotCatch
                checked:HttpClient.closeExit
                indicator: Image {
                    source: btnNotCatch.checked ? "../res/v2/check_sel.png" :
                                                  "../res/v2/check_unsel.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    scale: dpi
                }

                contentItem: Text {
                    text: "退出酷卡云游戏"
                    font.pixelSize: 13 * dpi
                    opacity: enabled ? 1.0 : 0.3
                    color: "#A4A6AB"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: btnNotCatch.indicator.width
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        btnNotCatch.checked = true
                        exitApp = true
                        HttpClient.closeExit = true
                    }
                }
            }
        }

        CheckBox {
            id:checkFps
            anchors.left: parent.left
            anchors.leftMargin: 50 * dpi
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30 * dpi
            checked: HttpClient.noNotify
            contentItem: Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: imagecheckFpsIcon.right
                anchors.leftMargin: 5 * dpi
                text:"不再提醒"
                color: "#A4A6AB"
                font.pixelSize: 12 * dpi
            }

            indicator: Image {
                id:imagecheckFpsIcon
                anchors.verticalCenter: parent.verticalCenter
                source: checkFps.checked ?  "../res/v2/check_sel.png" :
                                            "../res/v2/check_unsel.png"
                fillMode: Image.PreserveAspectFit
                scale: dpi
            }

            onClicked: {
                noNotify = checked
                HttpClient.noNotify = noNotify
            }
        }


        Rectangle {
            width: 170 * dpi
            height: 50 * dpi
            anchors.right: parent.right
            anchors.rightMargin: 30 * dpi
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30 * dpi
            radius: 10
            color: "#1ECE9A"
            Text {
                text:"确定"
                font.pixelSize: 16 * dpi
                color: "white"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    HttpClient.closeExit ? Qt.quit() : mainWindow.hide()
                    HttpClient.updateCloseSettings(exitApp)
                    HttpClient.updateNoNotifySettings(noNotify)
                    exitAppPopup.close()
                }
            }
        }

    }

}
