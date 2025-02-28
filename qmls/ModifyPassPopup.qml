import QtQuick 2.15
import QtQuick.Controls 2.15


// 修改密码弹窗
Popup {
    id:modifyPopup
    width:520 * dpi
    height:470 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    property bool youthModeModify: false
    onOpened: {
        textCurrPass.forceActiveFocus()
        textCurrPass.clear()
        textNewPass.clear()
        textNewPassAgain.clear()
        errTips.text = ""
    }

    onClosed: {
        modifyPopup.destroy()
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
            text:"修改密码"
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
                    modifyPopup.close()
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


        //当前密码
        Rectangle {
            id:rectCurrPass
            width: 460 * dpi
            height:60 * dpi
            color: "transparent"
            anchors.top: parent.top
            anchors.topMargin: 20 * dpi
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                source: "../res/v2/viewpass_edit.png"
                anchors.fill: parent
            }

            Image {
                id:imageCurrPass
                source: "../res/v2/viewpass_lock.png"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20 * dpi
            }

            TextField {
                id:textCurrPass
                clip: true
                width:parent.width - imageCurrPass.width - 51 * dpi
                height:parent.height
                font.pixelSize: 13 * dpi
                selectByMouse:true
                selectedTextColor: "white"
                echoMode: TextInput.Password
                background: Rectangle {
                    color: "transparent"
                }

                placeholderText: qsTr("请输入当前密码")
                placeholderTextColor: "#9AA8A6"
                anchors.left: imageCurrPass.right
                anchors.leftMargin: 10 * dpi
            }

        }

        //新密码
        Rectangle {
            id:rectNewPass
            width: 460 * dpi
            height:60 * dpi
            color: "transparent"
            anchors.top: rectCurrPass.bottom
            anchors.topMargin: 20 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            property int tickCount: 60
            Image {
                source: "../res/v2/viewpass_edit.png"
                anchors.fill: parent
            }

            Image {
                id:imageNewPass
                source: "../res/v2/viewpass_lock.png"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20 * dpi
            }

            TextField {
                id:textNewPass
                clip: true
                width:parent.width - imageNewPass.width - 51 * dpi
                height:parent.height
                font.pixelSize: 13 * dpi
                selectByMouse:true
                selectedTextColor: "white"
                echoMode: TextInput.Password
                background: Rectangle {
                    color: "transparent"
                }

                placeholderText: qsTr("请输入新密码")
                placeholderTextColor: "#9AA8A6"
                anchors.left: imageNewPass.right
                anchors.leftMargin: 10 * dpi
            }

        }



        //再次新密码
        Rectangle {
            id:rectNewPassAgain
            width: 460 * dpi
            height:60 * dpi
            color: "transparent"
            anchors.top: rectNewPass.bottom
            anchors.topMargin: 20 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            property int tickCount: 60
            Image {
                source: "../res/v2/viewpass_edit.png"
                anchors.fill: parent
            }

            Image {
                id:imagePassAgain
                source: "../res/v2/viewpass_lock.png"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20 * dpi
            }

            TextField {
                id:textNewPassAgain
                clip: true
                width:parent.width - imagePassAgain.width - 51 * dpi
                height:parent.height
                font.pixelSize: 13 * dpi
                selectByMouse:true
                selectedTextColor: "white"
                echoMode: TextInput.Password
                background: Rectangle {
                    color: "transparent"
                }

                placeholderText: qsTr("请再次输入新密码")
                placeholderTextColor: "#9AA8A6"
                anchors.left: imagePassAgain.right
                anchors.leftMargin: 10 * dpi
            }
        }


        //确认按钮
        Button {
            id:btnConfirm
            width: 300 * dpi
            height: 60 * dpi
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            background: Rectangle {
                color: "#1ECF9C"
                radius: 10 * dpi
            }

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
                    if (textCurrPass.text === null ||
                        textCurrPass.text === '') {
                        errTips.text = "*当前密码不能为空"
                        return
                    }

                    if (textNewPass.text == null ||
                        textNewPass.text === '') {
                        errTips.text = "*新密码不能为空"
                        return
                    }


                    if (textNewPassAgain.text == null ||
                        textNewPassAgain.text === '') {
                        errTips.text = "*再次输入新密码不能为空"
                        return
                    }

                    if (textNewPassAgain.text !== textNewPass.text)
                    {
                        errTips.text = "*两次输入密码不一致"
                        return
                    }

                    if (youthModeModify)
                    {
                        HttpClient.enableTeenageMode(true, textCurrPass.text, textNewPass.text)

                    } else {
                        HttpClient.modifyUserPass(textNewPass.text, textCurrPass.text)
                    }

                    modifyPopup.close()
                    errTips.text = ""
                }
            }
        }

        Text {
            id:errTips
            text:""
            anchors.top: btnConfirm.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: "red"
            font.pixelSize: 12 * dpi
        }

    }
}
