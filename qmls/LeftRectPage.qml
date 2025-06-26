import QtQuick 2.6
import QtQuick.Window 2.6
import QtQuick.Controls 2.6
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import HomePage 1.0
//import GameShopBannerModel 1.0
//import GameShopTabModel 1.0
import HomeBannerModel 1.0
import HomeActivitiesModel 1.0
import HomeHotGamesTabModel 1.0
import HomeGoodsTabModel 1.0
import GameLabelModel 1.0
import MsgCenter 1.0


Rectangle {
    id:rectLeft

    MouseArea {
        anchors.fill: parent
        onClicked: {
            showSearchResult = false
        }
    }

    function selectPage(index)
    {
        repeaterHomePage.itemAt(index).checked = true
        showSearchInput = true
        showSearchResult = false
        if (index === 1)
        {
            showBackButton = false
        }

        selIndex = index
        lastSelIndex = selIndex
    }

    function selectMyPage(index)
    {
        repeaterMy.itemAt(index).checked = true
        showSearchInput = true
        showSearchResult = false
        showBackButton = false
        selIndex = index + 2
        lastSelIndex = selIndex
    }

    function selectMorePage(index)
    {
        repeaterMore.itemAt(index).checked = true
        showSearchInput = true
        showSearchResult = false
        showBackButton = false
        selIndex = index + 3
        lastSelIndex = selIndex
        if (index === 1)
        {
            //HttpClient.getGoodsList(1001)
        }
    }

    Connections {
        target: HomePage
        onShowRechargeView:
        {
//            if (!userLogined)
//            {
//                showPopup("LoginPopup.qml")
//                return
//            }

//            HttpClient.getGoodsList(1001)
//            selectMorePage(1)
        }

        onShowContactView:
        {
            showPopup('CustomerPopup.qml')
            showSearchResult = false
        }
    }

    ButtonGroup {
        id:btnGroup
        exclusive: true
    }

    Rectangle {
        id:rectLogo
        width: parent.width
        height: 100 * dpi
        color: "transparent"
        anchors.top: parent.top
        Image {
            source: "../res/v2/logo_bk.png"
            anchors.fill: parent
            Image {
                anchors.centerIn: parent
                source: "../res/v2/logo.png"
                fillMode: Image.PreserveAspectFit
                scale: dpi
            }
        }
    }

    Column {
        id: groupHome
        width: parent.width
        anchors.top: rectLogo.bottom
        anchors.topMargin: 10 * dpi
        ListModel {
            id:listModelHome
            ListElement {
                name:"首页"
                icon_path:"../res/v2/homepage.png"
                icon_path_sel:"../res/v2/homepage_sel.png"
            }

            //V2隐藏
            // ListElement {
            //     name:"游戏商城";
            //     icon_path:"../res/v2/gameshop.png"
            //     icon_path_sel:"../res/v2/gameshop_sel.png"
            // }

            ListElement {
                name:"全部游戏";
                icon_path:"../res/v2/cloudgame.png"
                icon_path_sel:"../res/v2/cloudgame_sel.png"
            }
        }

        Repeater {
            id:repeaterHomePage
            model: listModelHome
            delegate: Button {
                id:btnHome
                checkable: true
                checked: index === 0
                width: 220 * dpi
                height: 50 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                ButtonGroup.group: btnGroup
                background: Rectangle {
                    id:rectBackground
                    color: parent.checked ? "#222836" :"transparent"
                    radius: 5
                    Row {
                        spacing: 5 * dpi
                        anchors.left: parent.left
                        anchors.leftMargin: 70 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle {
                            width: 22 * dpi
                            height: 22 * dpi
                            color: "transparent"
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: btnHome.checked ? icon_path_sel : icon_path
                                fillMode: Image.PreserveAspectFit
                                scale: dpi
                                anchors.centerIn: parent
                            }
                        }

                        Text {
                            text:name
                            color: btnHome.checked ? "white" : "#A4A6AB"
                            font.pixelSize: 16 * dpi
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        btnHome.forceActiveFocus()
                        if (!userLogined && index !== 0)
                        {
                            showPopup('LoginPopup.qml')
                            return
                        }


                        if (index === 1 && selIndex !== 1)
                        {
                            showSearchInput = true
                            showSearchResult = false
                            showBackButton = false
                            HomePage.getAllGameLabel(GameLabelModel)
                        } else if (index === 0 && selIndex !== 0) {
                            showSearchInput = true
                            showSearchResult = false
                            showBackButton = false
                            //刷新首页数据
                            HomePage.getBannerData(HomeBannerModel, HomeActivitiesModel,
                                                   HomeHotGamesTabModel, HomeGoodsTabModel)
                        } else if(index === 2 && selIndex !== 2) {

                            // showSearchInput = false
                            // showSearchResult = false
                            // showBackButton = false
                            // HomePage.getAllGameLabel(GameLabelModel)
                            // console.log("2   HomePage.getAllGameLabel(GameLabelModel)")
                        }

                        parent.checked = true
                        selIndex = index
                        lastSelIndex = selIndex
                    }
                }

            }
        }
    }


    Column {
        id:gpBoxMy
        width: parent.width
        anchors.top: groupHome.bottom
        anchors.topMargin: 20 * dpi
        ListModel {
            id:listModelMy
            ListElement {
                name:"个人中心"
                icon_path:"../res/v2/user_center.png"
                icon_path_sel:"../res/v2/user_center_sel.png"
            }
        }

        Text {
            text:"我的"
            font.pixelSize: 16 * dpi
            color: "white"
            anchors.left: parent.left
            anchors.leftMargin: 85 * dpi
        }

        Repeater {
            id:repeaterMy
            model: listModelMy
            delegate: Button {
                id:btnMy
                checkable: true
                checked: false
                width: 220 * dpi
                height: 50 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                ButtonGroup.group: btnGroup
                background: Rectangle {
                    color: parent.checked ? "#222836" :"transparent"
                    radius: 5
                    Row {
                        spacing: 5 * dpi
                        anchors.left: parent.left
                        anchors.leftMargin: 70 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle {
                            width: 22 * dpi
                            height: 22 * dpi
                            color: "transparent"
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: btnMy.checked ? icon_path_sel : icon_path
                                fillMode: Image.PreserveAspectFit
                                scale: dpi
                                anchors.centerIn: parent
                            }
                        }

                        Text {
                            text:name
                            color: btnMy.checked ? "white" : "#A4A6AB"
                            font.pixelSize: 16 * dpi
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        btnMy.forceActiveFocus()
                        if (!userLogined)
                        {
                            showPopup('LoginPopup.qml')
                            return
                        }

                        parent.checked = true
                        showSearchInput = true
                        showSearchResult = false
                        showBackButton = false
                        selIndex = index + 2
                        lastSelIndex = selIndex

                        if(index === 0)
                        {
                            HttpClient.getOrderList()
                        }
                    }
                }
            }
        }
    }

    Column {
        id:gpBoxMore
        width: parent.width
        anchors.top: gpBoxMy.bottom
        anchors.topMargin: 20 * dpi
        ListModel {
            id:listModelCenter
            ListElement {
                name:"消息中心"
                icon_path:"../res/v2/msg_center.png"
                icon_path_sel:"../res/v2/msg_center_sel.png"
            }

//            ListElement {
//                name:"充值中心"
//                icon_path:"../res/v2/recharge_center.png"
//                icon_path_sel:"../res/v2/recharge_center_sel.png"
//            }
        }

        Text {
            text:"更多"
            font.pixelSize: 16 * dpi
            color: "white"
            anchors.left: parent.left
            anchors.leftMargin: 85 * dpi
        }

        Repeater {
            id:repeaterMore
            model:listModelCenter
            delegate: Button {
                id:btnMore
                checkable: true
                checked: false
                width: 220 * dpi
                height: 50 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                ButtonGroup.group: btnGroup
                background: Rectangle {
                    id:rectCenter
                    color: parent.checked ? "#222836" :"transparent"
                    radius: 5
                    Row {
                        spacing: 5 * dpi
                        anchors.left: parent.left
                        anchors.leftMargin: 70 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle {
                            width: 22 * dpi
                            height: 22 * dpi
                            color: "transparent"
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: btnMore.checked ? icon_path_sel : icon_path
                                fillMode: Image.PreserveAspectFit
                                scale: dpi
                                anchors.centerIn: parent
                            }
                        }

                        Text {
                            text:name
                            color: btnMore.checked ? "white" : "#A4A6AB"
                            font.pixelSize: 16 * dpi
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        btnMore.forceActiveFocus()
                        if (!userLogined)
                        {
                            showPopup('LoginPopup.qml')
                            return
                        }

                        parent.checked = true
                        showSearchInput = true
                        showSearchResult = false
                        showBackButton = false

                        if (index === 1)
                        {
//                            selIndex = index + 4
//                            lastSelIndex = selIndex
//                            HttpClient.getGoodsList(1001)
                            //mainWindow.showErrorMsgPopup(true, "暂不支持,请下载手机端App使用此功能")
                        } else if (index === 0 )
                        {
                            //刷新公告消息列表
                            selIndex = index + 3
                            lastSelIndex = selIndex
                            MsgCenter.getMsgListByType(0)
                            console.log(index)
                        }
                    }
                }
            }
        }
    }



    Column {
        id:gpBoxService
        width: parent.width
        anchors.top: gpBoxMore.bottom
        anchors.topMargin: 20 * dpi
        ListModel {
            id:listModelService
            ListElement {
                name:"智能客服"
                icon_path:"../res/v2/service.png"
                icon_path_sel:"../res/v2/service.png"
            }

            ListElement {
                name:"联系我们"
                icon_path:"../res/v2/contact.png"
                icon_path_sel:"../res/v2/contact.png"
            }
        }


        Repeater {
            id:repeaterService
            model:listModelService
            delegate: Button {
                id:btnService
                checkable: true
                checked: false
                width: 220 * dpi
                height: 50 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                ButtonGroup.group: btnGroup
                background: Rectangle {
                    id:rectService
                    color: parent.checked ? "#222836" :"transparent"
                    radius: 5
                    Row {
                        spacing: 5 * dpi
                        anchors.left: parent.left
                        anchors.leftMargin: 70 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        Rectangle {
                            width: 22 * dpi
                            height: 22 * dpi
                            color: "transparent"
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: btnService.checked ? icon_path_sel : icon_path
                                fillMode: Image.PreserveAspectFit
                                scale: dpi
                                anchors.centerIn: parent
                            }
                        }

                        Text {
                            text:name
                            color: btnService.checked ? "white" : "#A4A6AB"
                            font.pixelSize: 16 * dpi
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        btnService.forceActiveFocus()
                        if (!userLogined)
                        {
                            showPopup('LoginPopup.qml')
                            return
                        }

                        parent.checked = true
                        showSearchInput = true
                        showSearchResult = false
                        showBackButton = false

                        if (index === 0)
                        {
                            showPopup('ServicePopup.qml')
                        } else if (index === 1)
                        {
                            showPopup('ContactPopup.qml')
                        }
                    }
                }
            }
        }
    }


    Column {
        spacing: 10
        anchors.top: gpBoxService.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: gpBoxService.horizontalCenter
        Image {
            source: "../res/v2/kuka_ocr.png"
            fillMode: Image.PreserveAspectFit
            anchors.horizontalCenter: parent.horizontalCenter
        }


        Text {
            text: "进入酷卡会购买会员"
            font.pixelSize: 15
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}

