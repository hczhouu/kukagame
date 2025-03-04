import QtQuick 2.12
import QtQuick.Controls 2.12

// 青少年模式设置密码弹窗
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

    onOpened: {
        inputPass.forceActiveFocus()
        inputPass.clear()
        inputPassAgain.clear()
        errTips.text = ""
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
            text:"开启青少年模式"
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

        Column {
            spacing: 10 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 75 * dpi

            Text {
                id:textPass
                text:"设置密码"
                font.pixelSize: 14 * dpi
                color: "#131A25"
            }

            Rectangle {
                width:740 * dpi
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
                    placeholderText: qsTr("请输入四位密码(由数字和字母组合)")
                    placeholderTextColor: "#9AA8A6"
                    anchors.horizontalCenter: parent.horizontalCenter
                    background: Rectangle {
                        color: "transparent"
                    }
                }
            }
        }

        Column {
            spacing: 10 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 200 * dpi
            Text {
                id:textPassAgain
                text:"确认密码"
                font.pixelSize: 14 * dpi
                color: "#131A25"
            }

            Rectangle {
                width:740 * dpi
                height:60 * dpi
                color: "transparent"
                Image {
                    source: "../res/v2/youthmode_edit.png"
                    anchors.fill: parent
                }

                TextField {
                    id:inputPassAgain
                    clip: true
                    anchors.fill: parent
                    anchors.margins: 2
                    font.pixelSize: 12 * dpi
                    selectByMouse:true
                    selectedTextColor: "white"
                    echoMode: TextInput.Password
                    placeholderText: qsTr("请再次输入四位密码(由数字和字母组合)")
                    placeholderTextColor: "#9AA8A6"
                    anchors.horizontalCenter: parent.horizontalCenter
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
            anchors.bottomMargin: 70 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                color: "#1ECF9B"
                radius: 10
            }

            Text {
                text: "确认"
                font.pixelSize: 16 * dpi
                color: "white"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (inputPass.text === null || inputPass.text === '')
                    {
                        errTips.text = "*设置密码不能为空"
                        return
                    }


                    if (inputPassAgain.text === null || inputPassAgain.text === '')
                    {
                        errTips.text = "*确认密码不能为空"
                        return
                    }

                    if (inputPass.text !== inputPassAgain.text)
                    {
                        errTips.text = "*两次输入密码不一致"
                        return
                    }


                    HttpClient.enableTeenageMode(true, "", inputPassAgain.text)
                    juvenilePopup.close()
                    errTips.text = ""
                }
            }
        }

        Text {
            id:errTips
            text:""
            color: "red"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: btnOK.bottom
            font.pixelSize: 12 * dpi
        }

    }

}
