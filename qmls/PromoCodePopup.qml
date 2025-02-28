import QtQuick 2.15
import QtQuick.Controls 2.15
import HomePage 1.0

// 推广码弹窗
Popup {
    id:promocodePopup
    width:520 * dpi
    height:470 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    onOpened: {
        HomePage.getPromoCode()
    }

    onClosed: {
        promocodePopup.destroy()
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
            source: "../res/v2/viewpass_bk.png"
            anchors.fill: parent
        }

        Text {
            text:"推广码"
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
                    promocodePopup.close()
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
            source: "../res/v2/viewpass_bk_01.png"
            anchors.fill: parent
        }

        Row {
            id:rowPromocode
            anchors.top: parent.top
            anchors.topMargin: 40 * dpi
            spacing: 20 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                text:"专属邀请码"
                font.pixelSize: 14 * dpi
                anchors.verticalCenter: parent.verticalCenter
                color: "#131A25"
            }

            Text {
                text:HomePage.promoCodeText
                font.pixelSize: 16 * dpi
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                color: "#FF8400"
            }

            Rectangle {
                width: 60 * dpi
                height: 30 * dpi
                color: "#1FD3A8"
                radius: 20
                Text {
                    text:"复制"
                    font.pixelSize: 12 * dpi
                    color: "white"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape:Qt.PointingHandCursor
                    onClicked: {
                        HomePage.copyPromocode()
                    }
                }
            }
        }

        Rectangle {
            width: 200 * dpi
            height: 200 * dpi
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: rowPromocode.bottom
            anchors.topMargin: 20 * dpi

            Image {
                source: HomePage.promoCodeImage
                anchors.fill: parent
            }
        }
    }
}
