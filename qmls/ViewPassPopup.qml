import QtQuick 2.12
import QtQuick.Controls 2.12

// 查看密码弹窗
Popup {
    id:viewPassPopup
    width:520 * dpi
    height:470 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    onOpened: {
        textPhoneNum.forceActiveFocus()
        textPhoneNum.clear()
        textVerifyCode.clear()
        timerVerify.stop()
        errTips.text = ""
        textVerify.text = "获取验证码"
        textVerify.enabled = true
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
            text:"查看登录密码"
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
                    viewPassPopup.close()
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


        //手机号
        Rectangle {
            id:rectPhoneNum
            width: 460 * dpi
            height:60 * dpi
            color: "transparent"
            anchors.top: parent.top
            anchors.topMargin: 60 * dpi
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                source: "../res/v2/viewpass_edit.png"
                anchors.fill: parent
            }

            Image {
                id:imageIconPhone
                source: "../res/v2/viewpass_phone.png"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20 * dpi
            }

            TextField {
                id:textPhoneNum
                clip: true
                width:parent.width - imageIconPhone.width - 51 * dpi
                height:parent.height
                font.pixelSize: 13 * dpi
                selectByMouse:true
                selectedTextColor: "white"
                validator: RegExpValidator{regExp: /^[0-9,/]+$/}
                maximumLength: 11
                background: Rectangle {
                    color: "transparent"
                }

                placeholderText: qsTr("请输入手机号")
                placeholderTextColor: "#9AA8A6"
                anchors.left: imageIconPhone.right
                anchors.leftMargin: 10 * dpi
            }

        }

        //验证码
        Rectangle {
            id:rectVerifyCode
            width: 460 * dpi
            height:60 * dpi
            color: "transparent"
            anchors.top: rectPhoneNum.bottom
            anchors.topMargin: 26 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            property int tickCount: 60
            Image {
                source: "../res/v2/viewpass_edit.png"
                anchors.fill: parent
            }

            Image {
                id:imageIconLock
                source: "../res/v2/viewpass_lock.png"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20 * dpi
            }

            TextField {
                id:textVerifyCode
                clip: true
                width:parent.width - imageIconLock.width -  textVerify.width - 70 * dpi
                height:parent.height
                font.pixelSize: 13 * dpi
                selectByMouse:true
                selectedTextColor: "white"
                background: Rectangle {
                    color: "transparent"
                }

                placeholderText: qsTr("请输入验证码")
                placeholderTextColor: "#9AA8A6"
                anchors.left: imageIconLock.right
                anchors.leftMargin: 10 * dpi
            }

            Text {
                id:textVerify
                text:"获取验证码"
                font.pixelSize: 13 * dpi
                color: "#12C195"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 15 * dpi

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (textPhoneNum.text == null ||
                            textPhoneNum.text === '')
                        {
                            errTips.text = "*手机号不能为空"
                            return
                        }

                        if (textPhoneNum.text.length < 11)
                        {
                            errTips.text = "*手机号格式不正确"
                            return
                        }

                        rectVerifyCode.tickCount = 60
                        timerVerify.start()
                        textVerify.enabled = false
                        HttpClient.fetchModifySmsVerifyCode(textPhoneNum.text)
                    }
                }
            }

            Timer {
                id:timerVerify
                repeat: true
                interval: 1000
                onTriggered: {
                    rectVerifyCode.tickCount --
                    textVerify.text = rectVerifyCode.tickCount.toString() + "s"
                    if (rectVerifyCode.tickCount == 0) {
                        textVerify.text = "获取验证码"
                        timerVerify.stop()
                        textVerify.enabled = true
                    }
                }
            }
        }



        //确认按钮
        Button {
            id:btnConfirm
            width: 300 * dpi
            height: 60 * dpi
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50 * dpi
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

                    if (textPhoneNum.text == null ||
                        textPhoneNum.text === '')
                    {
                        errTips.text = "*手机号不能为空"
                        return
                    }

                    if (textPhoneNum.text.length < 11)
                    {
                        errTips.text = "*手机号格式不正确"
                        return
                    }

                    if (textVerifyCode.text === null ||
                         textVerifyCode.text === '')
                    {
                        errTips.text = "*验证码不能为空"
                        return
                    }

                    HttpClient.viewLoginPass(textPhoneNum.text,
                                             textVerifyCode.text)
                    viewPassPopup.close()
                    errTips.text = ""
                }
            }
        }

        Text {
            id:errTips
            text:""
            color: "red"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: btnConfirm.bottom
            font.pixelSize: 12 * dpi
        }

    }
}
