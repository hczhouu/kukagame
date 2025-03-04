import QtQuick 2.12
import QtQuick.Controls 2.12


// 青少年模式忘记密码弹窗
Popup {
    id:juvenileForgetPopup
    width:820 * dpi
    height:590 * dpi
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
            source: "../res/v2/youthmode_bk.png"
            anchors.fill: parent
        }

        Text {
            text:"忘记密码"
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
                    juvenileForgetPopup.close()
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

        TextArea {
            anchors.top: parent.top
            anchors.topMargin: 100 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 40 * dpi
            width: parent.width - 100 * dpi
            height: 200 * dpi
            wrapMode: Text.WordWrap
            font.pixelSize: 14 * dpi
            readOnly: true
            color: "#131A25"
            text:"若您需要重置青少年模式的密码，请您联系客服，将您的账号及相关身份证明信息发送至客服，申请重置。您的资料仅用于密码重置申诉，酷卡云不会泄露您的个人信息，并会尽快为您处理。"
        }

        Button {
            id:btnOK
            width: 300 * dpi
            height: 60 * dpi
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 40 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                color: "#1ECF9A"
                radius: 10
            }

            Text {
                text: "我知道了"
                font.pixelSize: 16 * dpi
                color: "white"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    juvenileForgetPopup.close()
                }
            }
        }
    }
}
