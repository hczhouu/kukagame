import QtQuick 2.12
import QtQuick.Controls 2.12


// 青少年模式关闭弹窗
Popup {
    id:juvenileClosePopup
    width:820 * dpi
    height:590 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent
    background:Rectangle {
        color: "transparent"
    }

    onOpened: {
        inputPass.clear()
        inputPass.forceActiveFocus()
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
            text:"关闭青少年模式"
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
                    juvenileClosePopup.close()
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

        Column {
            spacing: 10 * dpi
            anchors.top: parent.top
            anchors.topMargin: 150 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            width: 740 * dpi
            Text {
                id:textPass
                text:"验证密码"
                font.pixelSize: 14 * dpi
                color: "#131A25"
            }


            Rectangle {
                width:parent.width
                height:60 * dpi
                color: "transparent"
                Image {
                    source: "../res/v2/youthmode_edit.png"
                    anchors.fill: parent
                }

                TextField {
                    id:inputPass
                    clip: true
                    anchors.fill: parent
                    anchors.margins: 2
                    font.pixelSize: 12 * dpi
                    selectByMouse:true
                    selectedTextColor: "white"
                    echoMode: TextInput.Password
                    placeholderText: qsTr("请输入密码")
                    placeholderTextColor: "#9AA8A6"
                    background: Rectangle {
                        color: "transparent"
                    }
                }
            }
        }


        Button {
            id:btnOK
            width: 300 * dpi
            height: 60 * dpi
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 50 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                color:"#1FCE9B"
                radius: 10
            }

            Text {
                text: "确认"
                font.pixelSize: 14 * dpi
                color: "white"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (inputPass.text == null || inputPass.text === '')
                    {
                        return
                    }

                    HttpClient.enableTeenageMode(false, "", inputPass.text)
                    juvenileClosePopup.close()
                }
            }
        }
    }
}
