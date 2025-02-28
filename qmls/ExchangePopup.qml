import QtQuick 2.5
import QtQuick.Window 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

// 兑换激活码弹窗
Popup {
    id:exchangePopup
    width:520 * dpi
    height:380 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    onOpened: {
        textInput.clear()
        textInput.forceActiveFocus()
    }

    onClosed: {
        exchangePopup.destroy()
    }

    background: Rectangle {
        color: "transparent"

        Rectangle {
            id:rectTitle
            width: parent.width
            height: 90 * dpi
            color: "transparent"
            anchors.top: parent.top
            Image {
                source: "../res/v2/exchange_bk.png"
                anchors.fill: parent
            }

            Text {
                text:"兑换"
                font.pixelSize: 18 * dpi
                font.bold: true
                color: "#1ECF9A"
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
                        exchangePopup.close()
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
                source: "../res/v2/exchange_bk_01.png"
                anchors.fill: parent
            }


            Rectangle {
                id:rectInput
                width:460 * dpi
                height:60 * dpi
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 170 * dpi
                Image {
                    anchors.fill: parent
                    source: "../res/v2/exchange_edit_bk.png"
                }

                Row {
                    spacing: 10 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15 * dpi
                    Image {
                        id:imageIconExchange
                        anchors.verticalCenter: parent.verticalCenter
                        source: "../res/v2/exchange_icon.png"
                        scale: dpi
                        fillMode: Image.PreserveAspectFit
                    }

                    Rectangle {
                        id:imageSpliterExchange
                        width: 1 * dpi
                        height:25 * dpi
                        color: "transparent"
                        anchors.verticalCenter: parent.verticalCenter
                        Image {
                            source: "../res/v2/exchange_spliter.png"
                            anchors.fill: parent
                        }
                    }

                    TextField {
                        id:textInput
                        clip: true
                        width:rectInput.width - imageIconExchange.width - imageSpliterExchange.width - 40 * dpi
                        height:rectInput.height
                        font.pixelSize: 13 * dpi
                        selectByMouse:true
                        selectedTextColor: "white"
                        background: Rectangle {
                            color: "transparent"
                        }

                        placeholderText: qsTr("请输入兑换码")
                        placeholderTextColor: "#9AA8A6"
                    }
                }

            }



            Button {
                width: 300 * dpi
                height:60 * dpi
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 65 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    color: "#1ECE9B"
                    radius: 10 * dpi
                    Text {
                        text:"立即兑换"
                        font.pixelSize: 14 * dpi
                        color: "white"
                        anchors.centerIn: parent
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        var inputData = textInput.text
                        if (inputData == undefined ||
                                inputData == null ||
                                inputData === '') {
                            return
                        }

                        exchangePopup.close()
                        HttpClient.exchangeActivateCode(inputData)
                    }
                }

            }
        }

    }
}
