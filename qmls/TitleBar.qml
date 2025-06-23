import QtQuick 2.6
import QtQuick.Window 2.6
import QtQuick.Controls 2.6
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import MsgCenter 1.0
import HomePage 1.0
import HomeBannerModel 1.0
import HomeActivitiesModel 1.0
import HomeHotGamesTabModel 1.0
import HomeGoodsTabModel 1.0
//import GameShopBannerModel 1.0
//import GameShopTabModel 1.0
import SearchResultModel 1.0
import GameLabelModel 1.0

Rectangle {
    id:rectTitleBar
    color: "transparent"
    property bool inputFocus: false

    //搜索
    Rectangle {
        id:rectSearchBtn
        visible: showSearchInput
        width: 360 * dpi
        height: 35 * dpi
        color: "#313744"
        radius: 50
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        TextField {
            id:inputSearch
            clip: true
            focus: inputFocus
            width: parent.width - searchIcon.width - 30 * dpi
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 15 * dpi
            font.pixelSize: 16 * dpi
            selectByMouse:true
            selectedTextColor: "white"
            placeholderText: qsTr("双人成行")
            placeholderTextColor: "#64FFFFFF"
            color: "white"
            background: Rectangle {
                color: "transparent"
                radius: 50
            }

        }

        Image {
            id:searchIcon
            source: "../res/v2/search.png"
            fillMode: Image.PreserveAspectFit
            anchors.right: parent.right
            anchors.rightMargin: 15 * dpi
            anchors.verticalCenter: parent.verticalCenter
            scale: dpi * 0.8
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    searchIcon.forceActiveFocus()
                    if (inputSearch.text.length === 0 || inputSearch.text === '' ||
                        inputSearch.text === null)
                    {
                        inputSearch.text = inputSearch.placeholderText
                    }

                    HomePage.homeSearch(inputSearch.text, SearchResultModel)
                }
            }
        }
    }

    //返回按钮
    Rectangle {
        id:rectBackBtn
        visible: showBackButton
        width: 25 * dpi
        height: 25 * dpi
        color: "transparent"
        Image {
            source: "../res/v2/back.png"
            anchors.fill: parent
        }

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                rectBackBtn.forceActiveFocus()
                if (selIndex === 8)
                {
                    selIndex = 7
                } else if (selIndex === 7  && isAllGamesPageEntry)
                {
                    selIndex = 2
                    isAllGamesPageEntry = false
                    showBackButton = false
                    showSearchInput = false
                    showSearchResult = false
                }
                else {
                    showSearchInput = true
                    showSearchResult = false
                    showBackButton = false
                    selIndex = lastSelIndex
                }
            }
        }
    }


    //签到
    Button {
        id:btnSign
        width: 60 * dpi
        height: 26 * dpi
        visible: HttpClient.userLogined
        anchors.right: btnRefresh.left
        anchors.rightMargin: 30 * dpi
        anchors.verticalCenter: parent.verticalCenter
        background: Rectangle {
            color: "transparent"
            Row {
                spacing: 5 * dpi
                anchors.centerIn: parent
                Image {
                    source: "../res/v2/signin.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    scale: dpi
                }

                Text {
                    text:"签到"
                    font.pixelSize: 16 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#A4A6AB"
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    btnSign.forceActiveFocus()
                    showPopup('SigninPopup.qml')
                    //mainWindow.showErrorMsgPopup(true, "暂不支持,请下载手机端App使用此功能")
                }
            }
        }
    }


    //刷新
    Button {
        id:btnRefresh
        width: 60 * dpi
        height: 26 * dpi
        visible: HttpClient.userLogined
        anchors.right: btnNotice.left
        anchors.rightMargin: 30 * dpi
        anchors.verticalCenter: parent.verticalCenter
        background: Rectangle {
            color: "transparent"
            Row {
                spacing: 5 * dpi
                anchors.centerIn: parent
                Image {
                    source: "../res/v2/icon_refresh.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    scale: dpi
                }

                Text {
                    text:"刷新"
                    font.pixelSize: 16 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#A4A6AB"
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    btnSign.forceActiveFocus()
                    if (selIndex === 0)
                    {
                        HomePage.getBannerData(HomeBannerModel, HomeActivitiesModel,
                                               HomeHotGamesTabModel, HomeGoodsTabModel)
                    } else if (selIndex === 1)
                    {
                        //HomePage.getGameShopBanner(GameShopBannerModel, GameShopTabModel)
                    } else if (selIndex === 2)
                    {
                        HomePage.getAllGameLabel(GameLabelModel)
                    } else if (selIndex === 4)
                    {
                        MsgCenter.getMsgListByType(0)
                    } else if (selIndex === 5)
                    {
                        HttpClient.getGoodsList(1001)
                    }
                }
            }
        }
    }

    //消息通知
    Button {
        id:btnNotice
        width:45 * dpi
        height:35 * dpi
        visible: HttpClient.userLogined
        anchors.right: btnAccount.left
        anchors.rightMargin: 24 * dpi
        anchors.verticalCenter: parent.verticalCenter
        background: Rectangle {
            color: "transparent"
        }

        Image {
            source: "../res/v2/notice.png"
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent
            scale: dpi
        }

        Rectangle {
            width: MsgCenter.totalUnreadNum <= 99 ? 20 * dpi : 30 * dpi
            height: 15 * dpi
            color: "red"
            radius: 100
            anchors.right: parent.right
            anchors.top: parent.top
            visible: MsgCenter.totalUnreadNum > 0
            Text {
                text:MsgCenter.totalUnreadNum <= 99 ? MsgCenter.totalUnreadNum.toString() :
                                                      "99+"
                font.pixelSize: 12 * dpi
                color: "white"
                anchors.centerIn: parent
            }
        }

        MouseArea {
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            anchors.fill: parent
            onClicked: {
                btnNotice.forceActiveFocus()
                rectLeft.selectMorePage(0)
                MsgCenter.getMsgListByType(0)
            }

            onEntered: {
                toolTipsNotice.visible = true
            }

            onExited: {
                toolTipsNotice.visible = false
            }
        }


        ToolTip {
            id:toolTipsNotice
            delay: 700
            timeout: 3000
            visible: false
            text: "消息"
            font.pixelSize: 12  * dpi
        }
    }


    //账户
    Button {
        id:btnAccount
        width:30 * dpi
        height:30 * dpi
        anchors.right: rectSettings.left
        anchors.rightMargin: 15 * dpi
        anchors.verticalCenter: parent.verticalCenter
        background: Rectangle {
            color: "transparent"
        }

        Image {
            source: "../res/v2/account.png"
            fillMode: Image.PreserveAspectFit
            scale: dpi
            anchors.centerIn: parent
        }

        MouseArea {
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            anchors.fill: parent
            onClicked: {
                btnAccount.forceActiveFocus()
                if (!HttpClient.userLogined)
                {
                    showPopup('LoginPopup.qml')
                } else {
                    rectLeft.selectMyPage(0)
                }
            }

            onEntered: {
                toolTipsAccount.visible = true
            }

            onExited: {
                toolTipsAccount.visible = false
            }
        }

        ToolTip {
            id:toolTipsAccount
            delay: 700
            timeout: 3000
            visible: false
            text: "账户"
            font.pixelSize: 12  * dpi
        }
    }


    //会员标识
//    Image {
//        id:iconVip
//        source: HttpClient.vipFlags
//        fillMode: Image.PreserveAspectFit
//        scale: dpi
//        anchors.right: rectSettings.left
//        anchors.rightMargin: 20 * dpi
//        anchors.verticalCenter: rectSettings.verticalCenter
//    }


    //菜单
    Rectangle {
        id:rectSettings
        visible: HttpClient.userLogined
        width: 24 * dpi
        height:24 * dpi
        color: "transparent"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: rectMinBtn.left
        anchors.rightMargin: 5 * dpi
        Button {
            id:btnMenu
            anchors.fill: parent
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
                Image {
                    anchors.centerIn: parent
                    source: "../res/newVersion/icon_menu.png"
                    fillMode: Image.PreserveAspectFit
                }
             }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    btnMenu.forceActiveFocus()
                    rectSettings.color="#48FFFFFF"
                    toolTipsMenu.visible = true
                    btnMenu.forceActiveFocus()
                }

                onExited: {
                    rectSettings.color="transparent"
                    toolTipsMenu.visible = false
                }

                onClicked: {
                    menu.x = btnMenu.x + btnMenu.width/2 - menu.width/2
                    menu.y = btnMenu.y + btnMenu.height + 2 * dpi
                    menu.open()
                }
            }

            ToolTip {
                id:toolTipsMenu
                delay: 700
                timeout: 3000
                visible: false
                text: "菜单"
                font.pixelSize: 12 * dpi
            }
        }

        Menu {
            id: menu
            width: 100 * dpi
            height: 90 * dpi
            background: Rectangle {
                color: "#5C606A"
                radius: 5
            }

            MenuItem {
                width: parent.width
                height:menu.height / 3
                background: Rectangle {
                    color: "transparent"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            parent.color="#16FFFFFF"
                        }

                        onExited: {
                            parent.color="transparent"
                        }

                        onClicked: {
                            menu.close()
                            showPopup('CheckUpdatePopup.qml')
                        }
                    }
                }

                Text {
                    text: qsTr("检查更新")
                    font.pixelSize: 12 * dpi
                    color: "white"
                    anchors.centerIn: parent
                }
            }

            MenuItem {
                width: parent.width
                height:menu.height / 3
                background: Rectangle {
                    color: "transparent"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            parent.color="#16FFFFFF"
                        }

                        onExited: {
                            parent.color="transparent"
                        }

                        onClicked: {
                            menu.close()
                            //关于我们弹窗
                            showPopup('About.qml')
                        }
                    }
                }

                Text {
                    text: qsTr("关于我们")
                    font.pixelSize: 12 * dpi
                    color: "white"
                    anchors.centerIn: parent
                }
            }


            MenuItem {
                width: parent.width
                height:menu.height / 3
                background: Rectangle {
                    color: "transparent"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            parent.color="#16FFFFFF"
                        }

                        onExited: {
                            parent.color="transparent"
                        }

                        onClicked: {
                            menu.close()
                            HttpClient.userLogined = false
                            HttpClient.userLogout()
                            showPopup('LoginPopup.qml')
                        }
                    }
                }


                Text {
                    text: qsTr("退出登录")
                    font.pixelSize: 12 * dpi
                    color: "white"
                    anchors.centerIn: parent
                }
            }

        }
    }


    //最小化
    Rectangle {
        id:rectMinBtn
        width: 24 * dpi
        height:24 * dpi
        color: "transparent"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: rectCloseBtn.left
        anchors.rightMargin: 5 * dpi
        Button {
            id:btnMin
            anchors.fill: parent
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
                Image {
                    anchors.centerIn: parent
                    source: "../res/newVersion/icon_min.png"
                    fillMode: Image.PreserveAspectFit
                }

            ToolTip {
                id:tooltipMin
                delay: 700
                timeout: 3000
                visible: false
                text: "最小化"
                font.pixelSize: 12 * dpi
                }
             }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    btnMin.forceActiveFocus()
                    rectMinBtn.color="#48FFFFFF"
                    tooltipMin.visible = true
                }

                onExited: {
                    rectMinBtn.color="transparent"
                    tooltipMin.visible = false
                }

                onClicked: {
                    mainWindow.visibility = Window.Minimized
                }
            }
        }
    }


    //关闭
    Rectangle {
        id:rectCloseBtn
        width: 24 * dpi
        height:24 * dpi
        anchors.right: parent.right
        color: "transparent"
        anchors.verticalCenter: parent.verticalCenter
        Button {
            id:btnClose
            anchors.fill: parent
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
                Image {
                    anchors.centerIn: parent
                    source: "../res/newVersion/icon_close.png"
                    fillMode: Image.PreserveAspectFit
                }

                ToolTip {
                    id:tooltipClose
                    delay: 700
                    timeout: 3000
                    visible: false
                    text: "关闭"
                    font.pixelSize: 12  * dpi
                }
             }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    rectCloseBtn.color="red"
                    tooltipClose.visible = true
                }

                onExited: {
                    rectCloseBtn.color="transparent"
                    tooltipClose.visible = false
                }

                onClicked: {
                    btnClose.forceActiveFocus()
                    if (!HttpClient.noNotify)
                    {
                        showPopup('ExitAppTips.qml')
                        return
                    }

                    if (HttpClient.closeExit)
                    {
                        Qt.quit()
                    } else {
                        mainWindow.hide()
                    }
                }
            }
        }
    }

}



