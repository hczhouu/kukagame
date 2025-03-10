import QtQuick 2.12
import QtQuick.Controls 2.12
import GameDetails 1.0

// 登录弹窗
Popup {
    id:loginPopup
    width:840 * dpi
    height:520 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape
    anchors.centerIn: parent

    property int iElapsed: 60
    property int tickCount: 60

    onOpened: {
        HttpClient.fetchImageVerifyCode()
    }

    onClosed: {
        loginRect.visible = true
        registerRect.visible = false
        modifyPassRect.visible = false
        loginPopup.destroy()
    }

    Connections {
        target: HttpClient

        //修改密码成功
        onModifySuccess: {
            loginRect.visible = true
            registerRect.visible = false
            modifyPassRect.visible = false
        }

        //注册账号成功
        onShowLoginView: {
            loginRect.visible = true
            registerRect.visible = false
            modifyPassRect.visible = false
        }

        //登录成功
        onLoginSuccess: {
            loginPopup.close()
            if (selIndex === 7)
            {
                GameDetails.refreshGameDetails()
            }
        }

        //登录错误信息
        onShowLoginErrorTips: {
            errTips.text = errStr
        }
    }


    background:Rectangle {
        anchors.fill: parent
        color: "transparent"

        Rectangle {
            width: 820 *dpi
            height: 500 * dpi
            color: "transparent"
            anchors.centerIn: parent
            Rectangle {
                id:rectswipeView
                width: 350 * dpi
                height: parent.height
                anchors.left: parent.left
                color: "transparent"
                Image {
                    source: "../res/v2/login_bk_02.png"
                    anchors.fill: parent
                }
            }

            Rectangle {
                width: parent.width - rectswipeView.width
                height: parent.height
                color: "transparent"
                anchors.right: parent.right
                Image {
                    source: "../res/v2/login_bk2.png"
                    anchors.fill: parent
                }

                //登录页面
                Column {
                    id:loginRect
                    visible: true
                    anchors.centerIn: parent
                    spacing: 17 * dpi
                    Rectangle {
                        width: 375 * dpi
                        height: 40 * dpi
                        color: "transparent"
                        Text {
                            text:"登录"
                            font.pixelSize: 24 * dpi
                            color: "#171D22"
                            font.bold: true
                            anchors.centerIn: parent
                        }
                    }

                    //账号
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "transparent"

                        Image {
                            source: "../res/v2/edit_bk_01.png"
                            anchors.fill: parent
                        }

                        TextField {
                            id:inputUser
                            width: parent.width - rectIcon.width
                            height: parent.height
                            selectByMouse:true
                            selectedTextColor: "white"
                            text:HttpClient.userName
                            placeholderText: qsTr("请输入账号")
                            validator: RegExpValidator{regExp: /^[0-9,/]+$/}
                            maximumLength: 11
                            background: Rectangle {
                                color: "transparent"
                            }

                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                        }

                        Rectangle {
                            id:rectIcon
                            width: 30 * dpi
                            height: 20 * dpi
                            color: "transparent"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: "../res/v2/icon_phone.png"
                                fillMode: Image.PreserveAspectFit
                                //scale: dpi
                            }
                        }
                    }

                    //密码
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "transparent"

                        Image {
                            source: "../res/v2/edit_bk_01.png"
                            anchors.fill: parent
                        }

                        TextField {
                            id:inputPass
                            width: parent.width - rectIconPass.width
                            height: parent.height
                            selectByMouse:true
                            selectedTextColor: "white"
                            placeholderText: qsTr("请输入密码")
                            echoMode: TextInput.Password
                            text:HttpClient.userPass
                            background: Rectangle {
                                color: "transparent"
                            }

                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                        }

                        Rectangle {
                            id:rectIconPass
                            width: 30 * dpi
                            height: 20 * dpi
                            color: "transparent"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: "../res/v2/icon_pass.png"
                                fillMode: Image.PreserveAspectFit
                                //scale: dpi
                            }
                        }
                    }

                    //验证码
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "transparent"

                        TextField {
                            id:inputVerifyCode
                            width: 200 * dpi
                            height: parent.height
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            selectByMouse:true
                            selectedTextColor: "white"
                            placeholderText: qsTr("请输入验证码")
                            background: Rectangle {
                                color: "transparent"
                                Image {
                                    source: "../res/v2/edit_bk.png"
                                    anchors.fill: parent
                                }
                            }

                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                        }

                        Rectangle {
                            width: 150 * dpi
                            height: parent.height
                            color: "transparent"
                            border.width: 1
                            border.color: "#D9ECE9"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                id:imageVerCode
                                source: HttpClient.captchaImage
                                asynchronous: true
                                fillMode: Image.PreserveAspectFit
                                anchors.centerIn: parent
                                cache: true
                            }

                            Loading {
                                visible: imageVerCode.status != Image.Ready
                                anchors.centerIn: parent
                                color: "#9A9D9C"
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape:  Qt.PointingHandCursor
                                onClicked: {
                                    HttpClient.fetchImageVerifyCode()
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: 375 * dpi
                        height: 40 * dpi
                        color: "transparent"
                        Column {
                            spacing: 5 * dpi
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            Row {
                                spacing: 5 * dpi
                                Button {
                                    id:checkRemPass
                                    width: 12 * dpi
                                    height: 12 * dpi
                                    checkable: true
                                    checked: HttpClient.rememberPass
                                    anchors.verticalCenter: parent.verticalCenter
                                    background: Rectangle {
                                        color: "transparent"
                                        Image {
                                            source: parent.parent.checked ? "../res/v2/check_sel.png" :
                                                                            "../res/v2/check_unsel.png"
                                            anchors.fill: parent
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            parent.checked = !parent.checked
                                        }
                                    }
                                }

                                Text {
                                    text:"记住密码"
                                    font.pixelSize: 15 * dpi
                                    color: "#848585"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Row {
                                spacing: 5 * dpi
                                Button {
                                    id:checkPolicy
                                    width: 12 * dpi
                                    height: 12 * dpi
                                    checkable: true
                                    checked: HttpClient.agreePolicy
                                    anchors.verticalCenter: parent.verticalCenter
                                    background: Rectangle {
                                        color: "transparent"
                                        Image {
                                            source: parent.parent.checked ? "../res/v2/check_sel.png" :
                                                                            "../res/v2/check_unsel.png"
                                            anchors.fill: parent
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            parent.checked = !parent.checked
                                        }
                                    }
                                }

                                Text {
                                    text:"我已阅读并同意"
                                    font.pixelSize: 15 * dpi
                                    color: "#848585"
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text:"《酷卡云游戏服务协议》"
                                    font.pixelSize: 15 * dpi
                                    color: "#848585"
                                    anchors.verticalCenter: parent.verticalCenter
                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            var url = "https://superkuka.com/service-agreement-kuka-game.html"
                                            Qt.openUrlExternally(url)
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
                    }

                    //登录
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "#1ECF9D"
                        radius: 10
                        Text {
                            text:"登录"
                            font.pixelSize: 18 * dpi
                            font.bold: true
                            color: "white"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                errTips.text = ""
                                var errMsg = ""
                                var userData  = inputUser.text
                                var userPass = inputPass.text
                                var verifyCode = inputVerifyCode.text
                                if (userData.length < 11)
                                {
                                    errTips.text = "*手机号格式不正确"
                                    return;
                                }

                                if (userData === '' || userPass === '')
                                {
                                    errTips.text = "*账号或密码不能为空"
                                    return;
                                }

                                if (verifyCode === null || verifyCode === '')
                                {
                                    errTips.text = "*验证码不能为空"
                                    return;
                                }

                                var rememberPass = checkRemPass.checked
                                if (!checkPolicy.checked)
                                {
                                    errTips.text = "*请阅读并同意云游戏服务协议"
                                    return;
                                }

                                HttpClient.agreePolicy = checkPolicy.checked
                                HttpClient.userLogin(userData, userPass, verifyCode, rememberPass)
                                inputVerifyCode.text = ""
                            }
                        }
                    }


                    // 新用户注册
                    Rectangle {
                        width: 375 * dpi
                        height: 20 * dpi
                        color: "transparent"
                        Text {
                            text:"新用户注册"
                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    loginRect.visible = false
                                    registerRect.visible = true
                                    modifyPassRect.visible = false

                                    inputRegUser.text = ""
                                    inputRegPass.text = ""
                                    inputRegPassAgain.text = ""
                                    inputRegInvite.text = ""
                                    inputRegVerCode.text = ""
                                    timerEsl.stop()
                                    iElapsed = 60
                                }

                                onEntered: {
                                    parent.font.underline = true
                                }

                                onExited: {
                                    parent.font.underline = false
                                }
                            }
                        }

                        Text {
                            text:"忘记密码"
                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    loginRect.visible = false
                                    registerRect.visible = false
                                    modifyPassRect.visible = true

                                    inputModifyUser.text = ""
                                    inputModifyPass.text = ""
                                    inputModifyPassAgain.text  =""
                                    inputModifyVerCode.text = ""
                                    inputVerifyCode.text = ""
                                    timerElapsed.stop()
                                    tickCount = 60
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

                    Rectangle {
                        width: 375 * dpi
                        height: errTips.height
                        color: "transparent"
                        Text {
                            id:errTips
                            width: parent.width
                            text:""
                            elide: Text.ElideRight
                            font.pixelSize: 15 * dpi
                            color: "red"
                            anchors.left: parent.left
                            clip: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                }


                //注册页面
                Column {
                    id:registerRect
                    visible: false
                    anchors.centerIn: parent
                    spacing: 15 * dpi
                    Rectangle {
                        width: 375 * dpi
                        height: 40 * dpi
                        color: "transparent"
                        Text {
                            text:"注册"
                            font.pixelSize: 24 * dpi
                            color: "#171D22"
                            font.bold: true
                            anchors.centerIn: parent
                        }
                    }

                    //账号
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "transparent"

                        Image {
                            source: "../res/v2/edit_bk_01.png"
                            anchors.fill: parent
                        }

                        TextField {
                            id:inputRegUser
                            width: parent.width - rectIconUser.width
                            height: parent.height
                            selectByMouse:true
                            selectedTextColor: "white"
                            placeholderText: qsTr("请输入账号")
                            validator: RegExpValidator{regExp: /^[0-9,/]+$/}
                            maximumLength: 11
                            background: Rectangle {
                                color: "transparent"
                            }

                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                        }

                        Rectangle {
                            id:rectIconUser
                            width: 30 * dpi
                            height: 20 * dpi
                            color: "transparent"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: "../res/v2/icon_phone.png"
                                fillMode: Image.PreserveAspectFit
                                //scale: dpi
                            }
                        }
                    }

                    //密码
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "transparent"

                        Image {
                            source: "../res/v2/edit_bk_01.png"
                            anchors.fill: parent
                        }

                        TextField {
                            id:inputRegPass
                            width: parent.width - rectIconRegPass.width
                            height: parent.height
                            selectByMouse:true
                            selectedTextColor: "white"
                            placeholderText: qsTr("请输入密码")
                            echoMode: TextInput.Password
                            background: Rectangle {
                                color: "transparent"
                            }

                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                        }

                        Rectangle {
                            id:rectIconRegPass
                            width: 30 * dpi
                            height: 20 * dpi
                            color: "transparent"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: "../res/v2/icon_pass.png"
                                fillMode: Image.PreserveAspectFit
                                //scale: dpi
                            }
                        }
                    }

                    //再次输入密码
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "transparent"

                        Image {
                            source: "../res/v2/edit_bk_01.png"
                            anchors.fill: parent
                        }

                        TextField {
                            id:inputRegPassAgain
                            width: parent.width - rectIconRegPassAgain.width
                            height: parent.height
                            selectByMouse:true
                            selectedTextColor: "white"
                            placeholderText: qsTr("请再次输入密码")
                            echoMode: TextInput.Password
                            background: Rectangle {
                                color: "transparent"
                            }

                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                        }

                        Rectangle {
                            id:rectIconRegPassAgain
                            width: 30 * dpi
                            height: 20 * dpi
                            color: "transparent"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: "../res/v2/icon_pass.png"
                                fillMode: Image.PreserveAspectFit
                                //scale: dpi
                            }
                        }
                    }

                    //邀请码
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "transparent"

                        Image {
                            source: "../res/v2/edit_bk_01.png"
                            anchors.fill: parent
                        }

                        TextField {
                            id:inputRegInvite
                            width: parent.width - rectIconAtiv.width
                            height: parent.height
                            selectByMouse:true
                            selectedTextColor: "white"
                            placeholderText: qsTr("请输入邀请码(选填)")
                            background: Rectangle {
                                color: "transparent"
                            }

                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                        }

                        Rectangle {
                            id:rectIconAtiv
                            width: 30 * dpi
                            height: 20 * dpi
                            color: "transparent"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: "../res/v2/icon_invite.png"
                                fillMode: Image.PreserveAspectFit
                                //scale: dpi
                            }
                        }
                    }


                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "transparent"

                        TextField {
                            id:inputRegVerCode
                            width: 200 * dpi
                            height: parent.height
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            selectByMouse:true
                            selectedTextColor: "white"
                            placeholderText: qsTr("请输入验证码")
                            background: Rectangle {
                                color: "transparent"
                                Image {
                                    source: "../res/v2/edit_bk.png"
                                    anchors.fill: parent
                                }
                            }

                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                        }

                        Rectangle {
                            id:btnSendSms
                            width: 150 * dpi
                            height: parent.height
                            color: "#D9ECE9"
                            radius: 10
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                id:textSendSms
                                text:"发送验证码"
                                font.pixelSize: 15 * dpi
                                color: "#12C195"
                                anchors.centerIn: parent
                            }

                            Timer {
                                id:timerEsl
                                repeat: true
                                interval: 1000
                                running: false
                                onTriggered: {
                                    iElapsed--
                                    textSendSms.text = "(" + iElapsed.toString() + "s)"
                                    if (iElapsed <= 0)
                                    {
                                        timerEsl.stop()
                                        iElapsed = 60
                                        btnSendSms.enabled = true
                                        textSendSms.text = "发送验证码"
                                    }
                                }
                            }


                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {

                                    if (inputRegUser.text.length < 11)
                                    {
                                        errRegTips.text = "*手机号格式不正确"
                                        return
                                    }

                                    timerEsl.start()
                                    btnSendSms.enabled = false
                                    var phoneNum = inputRegUser.text
                                    HttpClient.fetchRegSmsVerifyCode(phoneNum)
                                }
                            }
                        }
                    }



                    //注册
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "#1ECF9D"
                        radius: 10
                        Text {
                            text:"注册"
                            font.pixelSize: 18 * dpi
                            font.bold: true
                            color: "white"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                errRegTips.text = ""
                                var phone = inputRegUser.text
                                var pass = inputRegPass.text
                                var passagain = inputRegPassAgain.text
                                var vercode = inputRegVerCode.text
                                var invitationCode = inputRegInvite.text
                                if (phone == null || phone === '')
                                {
                                    errRegTips.text = "*手机号不能为空"
                                    return
                                }

                                if (pass == null || pass === '')
                                {
                                    errRegTips.text = "*密码不能为空"
                                    return
                                }

                                if (passagain == null || passagain === '')
                                {
                                    errRegTips.text = "*确认密码不能为空"
                                    return
                                }

                                if (pass !== passagain)
                                {
                                    errRegTips.text = "*两次输入密码不一致"
                                    return
                                }

                                if (vercode == null || vercode === '')
                                {
                                    errRegTips.text = "*验证码不能为空"
                                    return
                                }

                                HttpClient.userRegister(phone, pass, vercode, invitationCode)
                            }
                        }
                    }


                    //已有账号去登录
                    Rectangle {
                        width: 375 * dpi
                        height: 20 * dpi
                        color: "transparent"

                        Text {
                            id:errRegTips
                            text:""
                            font.pixelSize: 15 * dpi
                            color: "red"
                            clip: true
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                        }

                        Text {
                            text:"已有账号去登录"
                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    loginRect.visible = true
                                    registerRect.visible = false
                                    modifyPassRect.visible = false
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



                //修改密码页面
                Column {
                    id:modifyPassRect
                    visible: false
                    anchors.centerIn: parent
                    spacing: 17 * dpi
                    Rectangle {
                        width: 375 * dpi
                        height: 40 * dpi
                        color: "transparent"
                        Text {
                            text:"修改密码"
                            font.pixelSize: 24 * dpi
                            color: "#171D22"
                            font.bold: true
                            anchors.centerIn: parent
                        }
                    }

                    //账号
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "transparent"

                        Image {
                            source: "../res/v2/edit_bk_01.png"
                            anchors.fill: parent
                        }

                        TextField {
                            id:inputModifyUser
                            width: parent.width - rectIconPhone.width
                            height: parent.height
                            selectByMouse:true
                            selectedTextColor: "white"
                            placeholderText: qsTr("请输入账号")
                            validator: RegExpValidator{regExp: /^[0-9,/]+$/}
                            maximumLength: 11
                            background: Rectangle {
                                color: "transparent"
                            }

                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                        }

                        Rectangle {
                            id:rectIconPhone
                            width: 30 * dpi
                            height: 20 * dpi
                            color: "transparent"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: "../res/v2/icon_phone.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                    }

                    //密码
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "transparent"

                        Image {
                            source: "../res/v2/edit_bk_01.png"
                            anchors.fill: parent
                        }

                        TextField {
                            id:inputModifyPass
                            width: parent.width - rectIconModifyPass.width
                            height: parent.height
                            selectByMouse:true
                            selectedTextColor: "white"
                            placeholderText: qsTr("请输入密码")
                            echoMode: TextInput.Password
                            background: Rectangle {
                                color: "transparent"
                            }

                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                        }

                        Rectangle {
                            id:rectIconModifyPass
                            width: 30 * dpi
                            height: 20 * dpi
                            color: "transparent"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: "../res/v2/icon_pass.png"
                                fillMode: Image.PreserveAspectFit
                                //scale: dpi
                            }
                        }
                    }

                    //再次输入密码
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "transparent"

                        Image {
                            source: "../res/v2/edit_bk_01.png"
                            anchors.fill: parent
                        }

                        TextField {
                            id:inputModifyPassAgain
                            width: parent.width - rectIconModifyPassAgain.width
                            height: parent.height
                            selectByMouse:true
                            selectedTextColor: "white"
                            placeholderText: qsTr("请输入密码")
                            echoMode: TextInput.Password
                            background: Rectangle {
                                color: "transparent"
                            }

                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                        }

                        Rectangle {
                            id:rectIconModifyPassAgain
                            width: 30 * dpi
                            height: 20 * dpi
                            color: "transparent"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: "../res/v2/icon_pass.png"
                                fillMode: Image.PreserveAspectFit
                                //scale: dpi
                            }
                        }
                    }

                    //验证码
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "transparent"

                        TextField {
                            id:inputModifyVerCode
                            width: 200 * dpi
                            height: parent.height
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            selectByMouse:true
                            selectedTextColor: "white"
                            placeholderText: qsTr("请输入验证码")
                            background: Rectangle {
                                color: "transparent"
                                Image {
                                    source: "../res/v2/edit_bk.png"
                                    anchors.fill: parent
                                }
                            }

                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                        }

                        Rectangle {
                            id:rectSendSms
                            width: 150 * dpi
                            height: parent.height
                            color: "#D9ECE9"
                            radius: 10
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                id:textSms
                                text:"发送验证码"
                                font.pixelSize: 15 * dpi
                                color: "#12C195"
                                anchors.centerIn: parent
                            }

                            Timer {
                                id:timerElapsed
                                interval: 1000
                                running: false
                                repeat: true
                                onTriggered: {
                                    tickCount--
                                    textSms.text = "("+tickCount.toString()+"s)"
                                    if (tickCount <= 0) {
                                        timerElapsed.stop()
                                        tickCount = 60
                                        textSms.text = "发送验证码"
                                        rectSendSms.enabled = true
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (inputModifyUser.text.length < 11)
                                    {
                                        errModifyTips.text = "*手机号格式不正确"
                                        return
                                    }
                                    timerElapsed.start()
                                    rectSendSms.enabled = false
                                    var phoneNum = inputModifyUser.text
                                    HttpClient.fetchModifySmsVerifyCode(phoneNum)
                                }
                            }

                        }
                    }

                    //确认
                    Rectangle {
                        width: 375 * dpi
                        height: 50 * dpi
                        color: "#1ECF9D"
                        radius: 10
                        Text {
                            text:"确认"
                            font.pixelSize: 18 * dpi
                            font.bold: true
                            color: "white"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                errModifyTips.text = ""

                                var phone = inputModifyUser.text
                                var pass = inputModifyPass.text
                                var passagain = inputModifyPassAgain.text
                                var vercode = inputModifyVerCode.text

                                if (phone == null || phone === '')
                                {
                                    errModifyTips.text =  "*手机号不能为空"
                                    return
                                }

                                if (pass == null || pass === '')
                                {
                                    errModifyTips.text = "*密码不能为空"
                                    return
                                }

                                if (passagain == null || passagain === '')
                                {
                                    errModifyTips.text = "*确认密码不能为空"
                                    return
                                }

                                if (vercode == null || vercode === '')
                                {
                                    errModifyTips.text = "*验证码不能为空"
                                    return
                                }

                                if (pass !== passagain)
                                {
                                    errModifyTips.text = "*两次输入密码不一致"
                                    return
                                }

                                HttpClient.modifyPassword(phone, pass, vercode)
                            }
                        }
                    }


                    //忘记密码
                    Rectangle {
                        width: 375 * dpi
                        height: 20 * dpi
                        color: "transparent"

                        Text {
                            id:errModifyTips
                            text:""
                            color: "red"
                            font.pixelSize: 15 * dpi
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text:"返回登录"
                            color: "#9A9D9C"
                            font.pixelSize: 15 * dpi
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    loginRect.visible = true
                                    registerRect.visible = false
                                    modifyPassRect.visible = false
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

            }
        }

        Image {
            source: "../res/v2/login_close.png"
            anchors.right: parent.right
            anchors.top: parent.top
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    loginPopup.close()
                }
            }
        }
    }
}
