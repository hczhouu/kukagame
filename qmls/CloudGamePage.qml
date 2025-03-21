import QtQuick 2.6
import QtQuick.Window 2.6
import QtQuick.Controls 2.6
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import ComputerManager 1.0
import SdlGamepadKeyNavigation 1.0
import StreamLauncher 1.0

//云游戏页面
Item {
    property string remainTime: "--"
    property int selIndex: 0
    property int timeDays: 0
    property int timeHours: 0
    property int timeMins: 0
    property bool shutDownExit: false
    property int progressVal: 0
    property string connTips: ""
    Connections {
        target: StreamLauncher
        function onShowDisplay(session)
        {
            gc()
            SdlGamepadKeyNavigation.disable()
            session.exec(Screen.virtualX, Screen.virtualY)
        }

        onQuitStream:{
            SdlGamepadKeyNavigation.enable();
            gc();

            timerProgress.stop()
            textTips.visible = false
            btnStart.enabled = true

            textProgress.text = "连接"
            btnShutDown.visible = true

            if (!shutDownExit)
            {
                //imageHoverBalls.visible = true
            }
        }

        function onShowStreamPopup(msg)
        {
            mainWindow.showErrorMsgPopup(true, msg);

            timerConection.stop()
        }

        function onEntryDesktopSuccess()
        {
            btnStart.enabled = false
            progressVal = 0
            timerProgress.stop()
            textProgress.text = "连接成功(100%)"
        }

        function onUpdateLaunchTips(msg)
        {
            connTips = msg
        }

        function onShowMsgPopup(msgType, msgData)
        {
            messagePop.showMessage(msgType, msgData)
        }

        function onCloseHoverBalls()
        {
            //imageHoverBalls.visible = false
            //imageMinDuration.visible = false
            //shutDownExit = true
        }

        function onBackStartPage()
        {
            timerProgress.stop()
            textTips.visible = false
            btnStart.enabled = true
            progressVal = 0
            textProgress.text = "立即启动"
        }
    }

    Connections {
        target: HttpClient
        onBackStartPage:
        {
            timerProgress.stop()
            textTips.visible = false
            btnStart.enabled = true
            progressVal = 0
            textProgress.text = "立即启动"
        }

        onUpdateRemainTimes:{
            var msg = "%1天%2时%3分"
            remainTime = msg.arg(days).arg(hours).arg(mins)
        }
    }


    Timer {
        id:timerConection
        repeat: true
        interval: 20 * 1000
        running: false
        onTriggered: {
            timerConection.stop()
            rectMainPage.startConnTimer = false
            launchProgressBar.visible = false
            textTips.visible = false
            btnStart.visible = true
            btnStart.enabled = true
        }
    }


    Rectangle {
        id:rectStart
        width: parent.width
        height: 40 * dpi
        color: "transparent"
        anchors.top: parent.top
        Rectangle {
            width: 960 * dpi
            height: parent.height
            color: "transparent"
            anchors.centerIn: parent
            Text {
                id:textName
                text:"扣费优先级"
                font.pixelSize: 14 *dpi
                font.bold: true
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }



            ComboBox {
                id:comCard
                width: 120 * dpi
                height:40 * dpi
                model: ["时长卡","周期卡","时段卡"]
                currentIndex: 0
                font.pixelSize: 12 * dpi
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: textName.right
                anchors.leftMargin: 10 * dpi
                background: Rectangle {
                    color: "transparent"
                    border.width:1
                    border.color:"#2B303C"
                    radius: 5
                }

                delegate: ItemDelegate {
                      width: comCard.width
                      contentItem: Text {
                          id:textItem
                          text: modelData
                          color: "#889593"
                          font: comCard.font
                          elide: Text.ElideRight
                          verticalAlignment: Text.AlignVCenter
                      }

                      highlighted: comCard.highlightedIndex === index
                }

                contentItem: Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * dpi
                    text: comCard.displayText
                    font: comCard.font
                    color: "#889593"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                indicator: Image{
                    source: "../res/v2/down.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    scale: dpi
                    x: comCard.width - width - comCard.rightPadding
                    y: comCard.topPadding + (comCard.availableHeight - height) / 2
                }

                onCurrentIndexChanged: {
                    if (currentIndex == 0)
                    {

                    } else {

                    }
                }
            }

            //网速测试按钮
            Button {
                width: 199 * dpi
                height: 40 * dpi
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: btnSettings.left
                anchors.rightMargin: 15 * dpi
                background: Rectangle {
                    color: "#131A25"
                    border.width: 1
                    border.color: "#2B303C"
                    radius: 10
                    Row {
                        anchors.centerIn: parent
                        spacing: 10 * dpi
                        Image {
                            source: "../res/v2/speed.png"
                            fillMode: Image.PreserveAspectFit
                            scale: dpi
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text:"当前网络正常"
                            font.pixelSize: 12 * dpi
                            color: "#A4A6AB"
                        }

                        Text {
                            text:"测网速"
                            font.pixelSize: 12 * dpi
                            color: "white"
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        showPopup('NetSpeedPopup.qml')
                    }
                }
            }


            //设置按钮
            Button {
                id:btnSettings
                width: 40 * dpi
                height: 40 * dpi
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                background: Rectangle {
                    color: "#131A25"
                    border.width: 1
                    border.color: "#2B303C"
                    radius: 10
                    Image {
                        source: "../res/v2/settings.png"
                        fillMode: Image.PreserveAspectFit
                        scale: dpi
                        anchors.centerIn: parent
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {

                    }
                }
            }
        }
    }


    Rectangle {
        id:rectType
        width: parent.width
        height: 232 * dpi
        color: "transparent"
        anchors.top: rectStart.bottom
        anchors.topMargin: 10 * dpi
        Rectangle {
            width: 960 * dpi
            height: parent.height
            color: "transparent"
            anchors.centerIn: parent

            Rectangle {
                width: 465 * dpi
                height: 232 * dpi
                color: "#1D222E"
                radius: 10
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id:iconGame
                    source: "../res/v2/icon_game.png"
                    fillMode: Image.PreserveAspectFit
                    scale: dpi
                    anchors.left: parent.left
                    anchors.leftMargin: 22 * dpi
                    anchors.top: parent.top
                    anchors.topMargin: 16 * dpi
                }

                Text {
                    id:textType
                    text:"尊享区"
                    font.pixelSize: 12 * dpi
                    color: "white"
                    anchors.verticalCenter: iconGame.verticalCenter
                    anchors.left: iconGame.right
                    anchors.leftMargin: 10 * dpi
                }

                Text {
                    text:"剩余尊享时长 " + remainTime
                    font.pixelSize: 12 * dpi
                    color: "#A4A6AB"
                    anchors.verticalCenter: textType.verticalCenter
                    anchors.left: textType.right
                    anchors.leftMargin: 10 * dpi
                }


                Rectangle {
                    width: 200 * dpi
                    height: 50 * dpi
                    color: "#222733"
                    anchors.left: parent.left
                    anchors.leftMargin: 22 * dpi
                    anchors.top: parent.top
                    anchors.topMargin: 72 * dpi
                    radius: 10
                    border.width: 1
                    border.color: "#2B303C"
                    Row {
                        spacing: 10
                        anchors.centerIn: parent
                        Image {
                            source: "../res/v2/icon_exchange.png"
                            fillMode: Image.PreserveAspectFit
                            scale: dpi
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text:"时长兑换"
                            font.pixelSize: 13 * dpi
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            showPopup('ExchangePopup.qml')
                        }
                    }
                }


                Rectangle {
                    width: 200 * dpi
                    height: 50 * dpi
                    color: "#222733"
                    anchors.right: parent.right
                    anchors.rightMargin: 22 * dpi
                    anchors.top: parent.top
                    anchors.topMargin: 72 * dpi
                    radius: 10
                    border.width: 1
                    border.color: "#2B303C"
                    Row {
                        spacing: 10
                        anchors.centerIn: parent
                        Image {
                            source: "../res/v2/icon_timer.png"
                            fillMode: Image.PreserveAspectFit
                            scale: dpi
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text:"时长购买"
                            font.pixelSize: 13 * dpi
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {

                        }
                    }
                }


                Text {
                    id:textTips
                    text:connTips
                    font.pixelSize: 12 * dpi
                    color: "#A4A6AB"
                    anchors.bottom: rowBtns.top
                    anchors.bottomMargin: 5 * dpi
                    anchors.horizontalCenter: rowBtns.horizontalCenter
                }


                Row {
                    id:rowBtns
                    spacing: 20 * dpi
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 18 * dpi
                    anchors.horizontalCenter: parent.horizontalCenter

                    //立即启动
                    Rectangle {
                        id:btnStart
                        width: 200 * dpi
                        height: 50 * dpi
                        color: "#1ECF9B"
                        radius: 10

                        Text {
                            id:textProgress
                            text:"立即启动"
                            font.pixelSize: 14 * dpi
                            anchors.centerIn: parent
                            color: "#1D222E"
                        }

                        Timer {
                            id:timerProgress
                            interval: 85
                            repeat: true
                            running: false
                            onTriggered: {
                                if (progressVal <= 95) {
                                    progressVal += 1
                                    textProgress.text = "正在连接(" + progressVal.toString() +"%)"
                                } else {
                                    timerProgress.stop()
                                }
                            }
                        }


                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                btnShutDown.visible = false
                                selIndex = 0
                                HttpClient.queryQueueNum(0)
                            }
                        }
                    }


                    //关机
                    Rectangle {
                        id:btnShutDown
                        width: 200 * dpi
                        height: 50 * dpi
                        color: "transparent"
                        radius: 5
                        border.width: 1
                        border.color: "#1ECF9B"
                        visible: false
                        Text {
                            text:"关机"
                            font.pixelSize: 14 * dpi
                            anchors.centerIn: parent
                            color: "#1ECF9B"
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                textProgress.text = "立即启动"
                                parent.visible = false
                                HttpClient.restartComputer()
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: 465 * dpi
                height: 232 * dpi
                color: "#1D222E"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                radius: 10

                Image {
                    id:iconTry
                    source: "../res/v2/icon_rocket.png"
                    fillMode: Image.PreserveAspectFit
                    scale: dpi
                    anchors.left: parent.left
                    anchors.leftMargin: 22 * dpi
                    anchors.top: parent.top
                    anchors.topMargin: 16 * dpi
                }

                Text {
                    id:textTry
                    text:"体验区"
                    font.pixelSize: 12 * dpi
                    color: "white"
                    anchors.verticalCenter: iconTry.verticalCenter
                    anchors.left: iconTry.right
                    anchors.leftMargin: 10 * dpi
                }

                Text {
                    text:"剩余体验时长 " + remainTime
                    font.pixelSize: 12 * dpi
                    color: "#A4A6AB"
                    anchors.verticalCenter: textTry.verticalCenter
                    anchors.left: textTry.right
                    anchors.leftMargin: 10 * dpi
                }


                Rectangle {
                    width: 200 * dpi
                    height: 50 * dpi
                    color: "#222733"
                    anchors.left: parent.left
                    anchors.leftMargin: 22 * dpi
                    anchors.top: parent.top
                    anchors.topMargin: 72 * dpi
                    radius: 10
                    border.width: 1
                    border.color: "#2B303C"
                    Row {
                        spacing: 10
                        anchors.centerIn: parent
                        Image {
                            source: "../res/v2/icon_signin.png"
                            fillMode: Image.PreserveAspectFit
                            scale: dpi
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text:"签到打卡"
                            font.pixelSize: 13 * dpi
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            showPopup('SigninPopup.qml')
                        }
                    }
                }


                Rectangle {
                    width: 200 * dpi
                    height: 50 * dpi
                    color: "#222733"
                    anchors.right: parent.right
                    anchors.rightMargin: 22 * dpi
                    anchors.top: parent.top
                    anchors.topMargin: 72 * dpi
                    radius: 10
                    border.width: 1
                    border.color: "#2B303C"
                    Row {
                        spacing: 10
                        anchors.centerIn: parent
                        Image {
                            source: "../res/v2/icon_ative.png"
                            fillMode: Image.PreserveAspectFit
                            scale: dpi
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text:"邀请好友"
                            font.pixelSize: 13 * dpi
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {

                        }
                    }
                }

                Row {
                    spacing: 20 * dpi
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 18 * dpi
                    anchors.horizontalCenter: parent.horizontalCenter

                    //立即启动
                    Rectangle {
                        id:btnStartFree
                        width: 200 * dpi
                        height: 50 * dpi
                        color: "#1ECF9B"
                        radius: 10
                        enabled: false
                        Text {
                            id:textProgressFree
                            text:"暂不可用"
                            font.pixelSize: 14 * dpi
                            anchors.centerIn: parent
                            color: "#1D222E"
                        }

                        Timer {
                            id:timerProgressFree
                            interval: 85
                            repeat: true
                            running: false
                            onTriggered: {
                                if (progressVal <= 95) {
                                    progressVal += 1
                                    textProgressFree.text = "正在连接(" + progressVal.toString() +"%)"
                                } else {
                                    textProgressFree.stop()
                                }
                            }
                        }


                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                selIndex = 1
                                HttpClient.queryQueueNum(1)
                            }
                        }
                    }


                    //关机
                    Rectangle {
                        width: 200 * dpi
                        height: 50 * dpi
                        color: "transparent"
                        radius: 5
                        border.width: 1
                        border.color: "#1ECF9B"
                        visible: false
                        Text {
                            text:"关机"
                            font.pixelSize: 14 * dpi
                            anchors.centerIn: parent
                            color: "#1ECF9B"
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                btnStartFree.visible = true
                                parent.visible = false
                            }
                        }
                    }
                }


            }
        }
    }

    Rectangle {
        id:rectCaption
        width: parent.width
        height: textTitle.height
        color: "transparent"
        anchors.top: rectType.bottom
        anchors.topMargin: 20 * dpi
        Rectangle {
            width: 960 * dpi
            height: parent.height
            color: "transparent"
            anchors.centerIn: parent
            Row {
                anchors.fill: parent
                Text {
                    id:textTitle
                    text:"免费玩"
                    font.pixelSize: 14 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    font.bold: true
                }

                Text {
                    text:"500+"
                    font.pixelSize: 14 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#00D9B2"
                    font.bold: true
                }

                Text {
                    text:"款游戏"
                    font.pixelSize: 14 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    font.bold: true
                }
            }


        }

    }


    Rectangle {
        width: parent.width
        height: 380 * dpi
        color: "transparent"
        anchors.top: rectCaption.bottom
        anchors.topMargin: 10 * dpi
        Rectangle {
            width: 960 * dpi
            height: parent.height
            anchors.centerIn: parent
            color: "transparent"

            ScrollView {
                anchors.fill: parent
                GridView {
                    anchors.fill: parent
                    model: 11
                    clip: true
                    cellWidth:width / 4
                    cellHeight: 135 * dpi
                    delegate: Rectangle {
                        width: 225 * dpi
                        height: 125 * dpi
                        color: "#222733"
                        radius: 10 * dpi
                        Image {
                            source: ""
                            anchors.fill: parent
                        }

                        Rectangle {
                            width: parent.width
                            height: 35 * dpi
                            color: "transparent"
                            anchors.bottom: parent.bottom
                            Image {
                                source: ""
                                anchors.fill: parent
                            }

                            Text {
                                id:textGameName
                                width: parent.width
                                elide: Text.ElideMiddle
                                horizontalAlignment: Text.AlignHCenter
                                text:"尼尔:机械纪元"
                                font.pixelSize: 12 * dpi
                                color: "#A4A6AB"
                                anchors.centerIn: parent
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onEntered: {
                                textGameName.color = "white"
                            }

                            onExited: {
                                textGameName.color = "#A4A6AB"
                            }
                        }
                    }

                }
            }
        }
    }

}
