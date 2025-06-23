import QtQuick 2.6
import QtQuick.Window 2.6
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import OrderListTableModel 1.0
import RedeemTableModel 1.0
import DurationTableModel 1.0
import GamesOrderTableModel 1.0

//个人中心页面
Item {

    //订单记录
    OrderListTableModel{
        id: orderListmodel
    }

    //兑换记录
    RedeemTableModel {
        id: redeemModel
    }

    //兑换记录
    DurationTableModel {
        id: durationTableModel
    }

    //游戏商品订单列表
    GamesOrderTableModel {
        id: gameOrderTableModel
    }

    Rectangle {
        id:rectUserInfo
        width: parent.width
        height: 120 * dpi
        color: "transparent"

        Rectangle {
            width: 960 * dpi
            height: parent.height
            color: "#1D222E"
            anchors.centerIn: parent
            radius: 10

            //头像
            Rectangle {
                id:rectHeadLogo
                width: 70 * dpi
                height:70 * dpi
                color: "transparent"
                anchors.left: parent.left
                anchors.leftMargin: 15 *dpi
                anchors.verticalCenter: parent.verticalCenter
                Rectangle {
                    id:rectHead
                    width:70 * dpi
                    height:70 * dpi
                    color: "transparent"
                    border.color: "#82999F"
                    radius: 100
                    anchors.centerIn: parent
                    MouseArea {
                        id: imageRect
                        width: 70 * dpi
                        height: 70 * dpi
                        anchors.centerIn: parent
                        //头像
                        Image {
                            id: nameIamge
                            anchors.fill: parent
                            scale: dpi
                            source: "../res/newVersion/no-head-logo.jpg"
                            visible: false
                            cache: false
                            asynchronous: true
                        }

                        Rectangle{
                            id: mask
                            anchors.fill: parent
                            radius: 100
                            visible: false
                        }

                        OpacityMask {
                            anchors.fill: parent
                            source: nameIamge
                            maskSource: mask
                        }
                    }
                }
            }


            Rectangle {
                width: 110 * dpi
                height: 70 * dpi
                color: "transparent"
                anchors.left: rectHeadLogo.right
                anchors.leftMargin: 10 * dpi
                anchors.verticalCenter: parent.verticalCenter
                Column {
                    anchors.centerIn: parent
                    spacing: 5 * dpi
                    Text {
                        width: parent.parent.width
                        text: HttpClient.nickName
                        visible: HttpClient.nickName !== ''
                        font.pixelSize: 16 *dpi
                        color: "white"
                        elide: Text.ElideMiddle
                    }

                    Text {
                        width: parent.parent.width
                        text: HttpClient.userAccount
                        font.pixelSize: 15 *dpi
                        color: "#A4A6AB"
                    }
                }
            }


//            Rectangle {
//                id:rectPrivileged
//                width: 320 * dpi
//                height: 90 * dpi
//                color: "#222733"
//                visible: false
//                radius: 10
//                border.width: 1
//                border.color: "#2B303C"
//                anchors.right: rectTry.left
//                anchors.rightMargin: 30 * dpi
//                anchors.verticalCenter: parent.verticalCenter

//                Image {
//                    id:imageIconPrivi
//                    source: "../res/v2/privileged_01.png"
//                    fillMode: Image.PreserveAspectFit
//                    scale: dpi
//                    anchors.left: parent.left
//                    anchors.leftMargin: 24 * dpi
//                    anchors.verticalCenter: parent.verticalCenter
//                }


//                Rectangle {
//                    id:rectSplit
//                    width: 1
//                    height: 69 * dpi
//                    color: "#2B303C"
//                    anchors.left: imageIconPrivi.right
//                    anchors.leftMargin: 21 * dpi
//                    anchors.verticalCenter: parent.verticalCenter
//                }


//                Rectangle {
//                    width: 130 * dpi
//                    height: parent.height
//                    color: "transparent"
//                    anchors.left: rectSplit.right
//                    anchors.leftMargin: 25 * dpi
//                    Column {
//                        anchors.centerIn: parent
//                        Text {
//                            width: parent.parent.width
//                            text:"尊享时长"
//                            font.pixelSize: 16 * dpi
//                            color: "white"
//                            elide: Text.ElideRight
//                        }

//                        Text {
//                            width: parent.parent.width
//                            text:HttpClient.remainPayTime
//                            font.pixelSize: 14 * dpi
//                            color: "#A4A6AB"
//                            elide: Text.ElideRight
//                        }
//                    }
//                }

//                //购买  V2隐藏
//                Rectangle {
//                    width: 60 * dpi
//                    height: 34 * dpi
//                    color: "#2D3443"
//                    radius: 30
//                    anchors.right: parent.right
//                    anchors.rightMargin: 14 * dpi
//                    anchors.verticalCenter: parent.verticalCenter
//                    Text {
//                        text:"购买"
//                        font.pixelSize: 12 * dpi
//                        color: "#A4A6AB"
//                        anchors.centerIn: parent
//                    }

//                    MouseArea {
//                        anchors.fill: parent
//                        hoverEnabled: true
//                        cursorShape: Qt.PointingHandCursor
//                        onClicked: {
//                            parent.forceActiveFocus()
//                            rectLeft.selectMorePage(1);
//                        }
//                    }
//                }
//            }

            Rectangle {
                id:rectTry
                width: 320 * dpi
                height: 90 * dpi
                color: "#222733"
                radius: 10
                border.width: 1
                border.color: "#2B303C"
                anchors.right: parent.right
                anchors.rightMargin: 36 * dpi
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id:imageIconTry
                    source: "../res/v2/try_01.png"
                    fillMode: Image.PreserveAspectFit
                    scale: dpi
                    anchors.left: parent.left
                    anchors.leftMargin: 24 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    id:rectSplitTry
                    width: 1
                    height: 69 * dpi
                    color: "#2B303C"
                    anchors.left: imageIconTry.right
                    anchors.leftMargin: 30 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }

                //体验时长
                Rectangle {
                    width: 130 * dpi
                    height: parent.height
                    color: "transparent"
                    anchors.left: rectSplitTry.right
                    anchors.leftMargin: 25 * dpi
                    Column {
                        anchors.centerIn: parent
                        Text {
                            width: parent.parent.width
                            text:"体验时长"
                            font.pixelSize: 16 * dpi
                            color: "white"
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.parent.width
                            text:HttpClient.remainFreeTime
                            font.pixelSize: 14 * dpi
                            color: "#A4A6AB"
                            elide: Text.ElideRight
                        }
                    }

                }

                Column {
                    anchors.right: parent.right
                    anchors.rightMargin: 14 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 5 * dpi
                    //邀请
                    Button {
                        width: 60 * dpi
                        height: 34 * dpi
                        background: Rectangle {
                            color: "#2D3443"
                            radius: 30
                        }

                        Text {
                            text:"邀请"
                            font.pixelSize: 12 * dpi
                            color: "#A4A6AB"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                parent.forceActiveFocus()
                                showPopup('PromoCodePopup.qml')
                            }
                        }
                    }

                    Button {
                        width: 60 * dpi
                        height: 34 * dpi
                        background: Rectangle {
                            color: "#2D3443"
                            radius: 30
                        }

                        Text {
                            text:"兑换"
                            font.pixelSize: 12 * dpi
                            color: "#A4A6AB"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                parent.forceActiveFocus()
                                showPopup('ExchangePopup.qml')
                            }
                        }
                    }
                }

            }
        }
    }


    Rectangle {
        id:rectTabBar
        width: parent.width
        height: 30 * dpi
        color: "transparent"
        anchors.top: rectUserInfo.bottom
        anchors.topMargin: 20 * dpi
        Rectangle {
            width: 960 * dpi
            height: parent.height
            color: "transparent"
            anchors.centerIn: parent

            TabBar {
                width: parent.width
                height: 30 * dpi
                anchors.top: parent.top
                background: Rectangle {
                    color: "transparent"
                }

                ListModel {
                    id:listModelTabBtn
                    ListElement {
                        name:"账号信息"
                        icon_path:"../res/v2/userinfo1.png"
                        icon_path_sel:"../res/v2/userinfo.png"
                    }

                    ListElement {
                        name:"我的订单"
                        icon_path:"../res/v2/orderlist.png"
                        icon_path_sel:"../res/v2/orderlist_sel.png"
                    }

                    ListElement {
                        name:"登录记录"
                        icon_path:"../res/v2/loginrecord.png"
                        icon_path_sel:"../res/v2/loginrecord_sel.png"
                    }

                    ListElement {
                        name:"兑换记录"
                        icon_path:"../res/v2/exchangerecord.png"
                        icon_path_sel:"../res/v2/exchangerecord_sel.png"
                    }
                }

                ButtonGroup {
                    id:btnGroup
                    exclusive: true
                }

                Repeater {
                    model: listModelTabBtn
                    delegate: TabButton {
                        id:tabBtn
                        width: 120 * dpi
                        height: 30 * dpi
                        checkable: true
                        checked: index === 0
                        anchors.verticalCenter: parent.verticalCenter
                        ButtonGroup.group: btnGroup
                        background: Rectangle {
                            color: "transparent"
                            Image {
                                id:imageIcon
                                source: tabBtn.checked ? icon_path_sel : icon_path
                                fillMode: Image.PreserveAspectFit
                                anchors.verticalCenter: parent.verticalCenter
                                scale: dpi
                                anchors.left: parent.left
                                anchors.leftMargin: 5 * dpi
                            }

                            Text {
                                id:textBtnName
                                text:name
                                anchors.left: imageIcon.right
                                anchors.leftMargin: 10 * dpi
                                anchors.verticalCenter: imageIcon.verticalCenter
                                font.pixelSize: 16 * dpi
                                color: tabBtn.checked ? "#00D9B2" : "#A4A6AB"
                                font.bold: tabBtn.checked
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                parent.forceActiveFocus()
                                parent.checked = true
                                stackLayout.currentIndex = index
                            }
                        }
                    }
                }
            }
        }
    }


    Rectangle {
        width: parent.width
        height: 550 * dpi
        color: "transparent"
        anchors.top: rectTabBar.bottom
        anchors.topMargin: 5 * dpi
        Rectangle {
            id:rectStack
            width: 960 * dpi
            height: parent.height
            color: "transparent"
            anchors.centerIn: parent

            StackLayout {
                id:stackLayout
                anchors.fill: parent
                currentIndex: 0

                //账户信息
                AccountDetailsPage {

                }

                //订单记录
                Item {
                    Rectangle {
                        anchors.fill: parent
                        color: "#1D222E"
                        radius: 10

                        ButtonGroup {
                            id:tabGroup
                            exclusive: true
                        }

                        TabBar {
                            id:rectTabHeader
                            height: 30 * dpi
                            anchors.left: parent.left
                            anchors.leftMargin: 10 * dpi
                            anchors.top: parent.top
                            anchors.topMargin: 10 * dpi
                            background: Rectangle {
                                color: "transparent"
                            }

                            Repeater {
                                model: ["时长订单","应用商品订单"]
                                //model: ["时长订单"]
                                delegate: TabButton {
                                    width: 80 * dpi
                                    height: 30 * dpi
                                    ButtonGroup.group: tabGroup
                                    checkable: true
                                    checked: index === 0
                                    anchors.verticalCenter: parent.verticalCenter
                                    background: Rectangle {
                                        color: "transparent"
                                    }

                                    Text {
                                        text:modelData
                                        color: parent.checked ? "white" : "#A4A6AB"
                                        font.pixelSize: 16 * dpi
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape:Qt.PointingHandCursor
                                        onClicked: {
                                            parent.forceActiveFocus()
                                            parent.checked = true
                                            orderListStack.currentIndex = index
                                        }
                                    }
                                }
                            }
                        }



                        StackLayout {
                            id:orderListStack
                            width: parent.width
                            height: parent.height - rectTabHeader.height - 10 * dpi
                            anchors.top: rectTabHeader.bottom
                            OrderListTableView {
                                modelIndex: 0
                                columnWidthArr: [240, 200, 130, 60, 100, 100, 100]
                            }

                            OrderListTableView {
                                modelIndex: 3
                                columnWidthArr: [190, 150, 150, 60, 100, 100, 100, 80]
                            }

                        }
                    }
                }


                //登录记录
                OrderListTableView {
                    modelIndex: 2
                    columnWidthArr: [140, 140, 210, 220, 220]
                }

                //兑换记录
                OrderListTableView {
                    modelIndex: 1
                    columnWidthArr: [150, 100, 180, 150, 150, 100, 100]
                }
            }

        }
    }

}
