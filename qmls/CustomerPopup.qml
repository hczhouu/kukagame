import QtQuick 2.15
import QtQuick.Controls 2.15

// 关于我们弹窗
Popup {
    id:customerPopup
    width:580 * dpi
    height:689 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape
    anchors.centerIn: parent

    background:Rectangle {
        color: "transparent"
    }

    onClosed: {
        customerPopup.destroy()
    }

    Rectangle {
        id:rectQr
        width: parent.width
        height: 520 * dpi
        color: "white"
        radius: 20
        anchors.top: parent.top

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 52 * dpi
            spacing: 16 * dpi
            Text {
                text:"联系客服兑换"
                font.pixelSize: 42 * dpi
                font.bold: true
                color: "black"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text:"添加客服的QQ或者微信即可兑换"
                font.pixelSize: 26 * dpi
                color: "#999999"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 65 * dpi
            spacing: 32 * dpi

            Column {
                spacing: 17 * dpi
                Image {
                    source: "../res/v2/customer_wx.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text:"扫一扫添加微信"
                    font.pixelSize: 24 * dpi
                    color: "#9C9C9C"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }


            Column {
                spacing: 17 * dpi
                Image {
                    source: "../res/v2/customer_qq.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text:"扫一扫添加QQ"
                    font.pixelSize: 24 * dpi
                    color: "#9C9C9C"
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    Image {
        source: "../res/v2/customer_close.png"
        fillMode: Image.PreserveAspectFit
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape:Qt.PointingHandCursor
            onClicked: {
                customerPopup.close()
            }
        }
    }
}
