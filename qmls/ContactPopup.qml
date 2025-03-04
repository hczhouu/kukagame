import QtQuick 2.12
import QtQuick.Window 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

// 联系我们弹窗
Popup {
    id:contactPopup
    width:520 * dpi
    height:470 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape
    anchors.centerIn: parent

    onClosed: {
        contactPopup.destroy()
    }

    background:Rectangle {
        color: "transparent"

        Rectangle {
            id:rectTitle
            width: parent.width
            height: 90 * dpi
            color: "transparent"
            anchors.top: parent.top

            Image {
                source: "../res/v2/contact_bk.png"
                anchors.fill: parent
            }

            Text {
                text:"联系我们"
                font.pixelSize: 18 * dpi
                font.bold: true
                color: "#12C195"
                anchors.centerIn: parent
            }

            Image {
                source: "../res/v2/popup_close.png"
                fillMode: Image.PreserveAspectFit
                anchors.right: parent.right
                anchors.rightMargin: 20 * dpi
                anchors.verticalCenter: parent.verticalCenter
                scale: dpi

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        contactPopup.close()
                    }
                }
            }
        }


        Rectangle {
            width: parent.width
            height: parent.height - rectTitle.height
            anchors.bottom: parent.bottom
            color: "transparent"
            Image {
                source: "../res/v2/contact_bk_01.png"
                anchors.fill: parent
            }

            Rectangle {
                id:rectQr
                width: 360 * dpi
                height: 190 * dpi
                anchors.top: parent.top
                anchors.topMargin: 28 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                border.width: 1
                border.color:"#12C195"
                radius: 10
                Row {
                    spacing: 20 * dpi
                    anchors.centerIn: parent
                    Column {
                        spacing: 10 * dpi
                        Rectangle {
                            width: 116 * dpi
                            height: 116 * dpi
                            color: "transparent"
                            Image {
                                source: "../res/v2/qr_bk.png"
                                anchors.fill: parent
                                Image {
                                    source: "../res/v2/qq_group.png"
                                    fillMode: Image.PreserveAspectFit
                                    anchors.centerIn: parent
                                    scale: dpi
                                }
                            }
                        }


                        Text {
                            text:"QQ游戏交流群"
                            font.pixelSize: 12 * dpi
                            color: "#889593"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }


                    Column {
                        spacing: 10 * dpi
                        Rectangle {
                            width: 116 * dpi
                            height: 116 * dpi
                            color: "transparent"
                            Image {
                                source: "../res/v2/qr_bk.png"
                                anchors.fill: parent
                                Image {
                                    source: "../res/v2/wechat.png"
                                    fillMode: Image.PreserveAspectFit
                                    anchors.centerIn: parent
                                    scale: dpi
                                }
                            }
                        }

                        Text {
                            text:"即时微信客服"
                            font.pixelSize: 12 * dpi
                            color: "#889593"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            Column {
                spacing: 15 * dpi
                anchors.top: rectQr.bottom
                anchors.topMargin: 20 * dpi
                anchors.left: rectQr.left
                Row {
                    spacing: 10 * dpi
                    Image {
                        source: "../res/v2/contact_home.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Column {
                        spacing: 5 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text:"官网地址"
                            font.pixelSize: 12 * dpi
                            color: "#141B26"
                        }

                        Text {
                            text:"https://www.superkuka.com/"
                            font.pixelSize: 12 * dpi
                            color: "#141B26"
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Qt.openUrlExternally(parent.text)
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

                Row {
                    spacing: 10 * dpi
                    Image {
                        source: "../res/v2/contact_phone.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Column {
                        spacing: 5 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text:"人工客服"
                            font.pixelSize: 12 * dpi
                            color: "#141B26"
                        }

                        Text {
                            text:"400-1169-868（周一至周五 9:00-18:00）"
                            font.pixelSize: 12 * dpi
                            color: "#141B26"
                        }
                    }
                }
            }
        }
    }
}
