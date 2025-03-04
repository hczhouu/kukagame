import QtQuick 2.12
import QtQuick.Controls 2.12
import GameDetails 1.0

// 游戏支付页面弹窗
Popup {
    id:gamePayPopup
    width:820 * dpi
    height:590 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    property string gameName: "" //游戏名称
    property string gameSkuName: "" //游戏SKU名称
    property double gameOriPrice: 0.00 //原价
    property double gameSkuPrice: 0.00 //单价
    property string gameIcon: "" //商品图片
    property string gameSkuDesc: "" //游戏SKU描述
    property double payAmount: 999.9 //支付金额
    property int remainStock: 0 //库存
    property string gameSkuId: "" //SKU ID
    property int payType: 0 //支付方式 1微信 2支付宝
    property int payNum: 0 //购买数量
    property int countDown: 90 //倒计时

    onOpened: {
        GameDetails.qrLoading = true
        GameDetails.queryPayStatus()
        GameDetails.createGameOrder(payNum, payAmount, gameSkuId, payType)
        countDown = 90
        timerQueryOrder.start()
    }

    onClosed: {
        timerQueryOrder.stop()
        GameDetails.closeOrder()
    }

    background:Rectangle {
        color: "transparent"
    }

    Timer {
        id:timerQueryOrder
        repeat: true
        interval: 1000
        running: false
        onTriggered: {
            if (countDown <= 0)
            {
                gamePayPopup.close()
                return
            }

            countDown--
        }
    }

    Connections {
        target: GameDetails
        function onClosePayPopup(orderSn)
        {
            gamePayPopup.close()
            gamePaySuccPop.gameMainImage = gameIcon
            gamePaySuccPop.gameName = gameName
            gamePaySuccPop.gameSkuName = gameSkuName
            gamePaySuccPop.skuPrice = gameSkuPrice
            gamePaySuccPop.buyNum = payNum
            gamePaySuccPop.payAmount = payAmount
            gamePaySuccPop.open()
        }

        //创建订单
        function onCreateOrderStatus(status)
        {
            if (!status)
            {
                gamePayPopup.close()
            } else {
                GameDetails.queryPayStatus()
            }
        }
    }

    Rectangle {
        id:rectTitle
        width: parent.width
        height: 90 * dpi
        color: "transparent"
        anchors.top: parent.top
        Image {
            source: "../res/v2/about_bk.png"
            anchors.fill: parent
        }

        Text {
            text:"商品支付"
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
                    gamePayPopup.close()
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
            source: "../res/v2/recharge_bk.png"
            anchors.fill: parent
        }

        Rectangle {
            id:rectGoodsDesc
            width: 330 * dpi
            height: parent.height
            color: "transparent"
            anchors.left: parent.left

            Rectangle {
                id:rectGoodsInfo
                width: parent.width * 0.90
                height: 102 * dpi
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 35 * dpi

                Rectangle {
                    id:rectGameIcon
                    width: 180 * dpi
                    height: 102 * dpi
                    color: "transparent"
                    anchors.left:parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 10
                    Image {
                        source: gameIcon
                        anchors.fill: parent
                    }
                }

                Column {
                    spacing: 10 * dpi
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - rectGameIcon.width - 10 * dpi
                    clip: true
                    Text {
                        text:gameName
                        font.pixelSize: 18 * dpi
                        color: "#3F4045"
                        width: parent.width
                        elide: Text.ElideRight
                        clip: true
                        anchors.left: parent.left
                    }

                    Text {
                        text:"剩余"+ remainStock.toString() +"库存"
                        font.pixelSize: 14 * dpi
                        color: "#989CAE"
                        width: parent.width
                        elide: Text.ElideRight
                        clip: true
                        anchors.left: parent.left
                    }

                    Row {
                        anchors.left: parent.left
                        width: parent.width
                        Text {
                            text:"参考价"
                            font.pixelSize: 14 * dpi
                            color: "#989CAE"
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text:'￥' + gameOriPrice.toString()
                            font.pixelSize: 18 * dpi
                            font.bold: true
                            color: "#12C195"
                            clip: true
                            width: 80 * dpi
                            elide: Text.ElideRight
                            anchors.verticalCenter: parent.verticalCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }


                }
            }

            Text {
                id:textTitle
                text:"购买须知:"
                width: parent.width * 0.90
                font.pixelSize: 16 * dpi
                color: "#55565D"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectGoodsInfo.bottom
                anchors.topMargin: 30 * dpi
            }

            Text {
                id:textTips
                width: parent.width * 0.90
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: textTitle.bottom
                anchors.topMargin: 5 * dpi
                text:"亲，由于数字商品的特殊性，一经发货成功后无质量问题暂不支持退换，非常感谢您的理解！
购买前请先了解商品首页的详情说明，因个人原因等情况导致不能运行游戏的，请联系客服提供帮助"
                color: "#989CAE"
                wrapMode: Text.WordWrap
                font.pixelSize: 16 * dpi
            }

            Row {
                width: parent.width * 0.90
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30 * dpi
                Text {
                    text:"支付视为同意"
                    color: "#989CAE"
                    font.pixelSize: 16 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id:textUserPolicy
                    text:"《用户服务协议》"
                    color: "#12C195"
                    font.pixelSize: 16 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape:Qt.PointingHandCursor
                        onClicked: {
                            var url = "https://superkuka.com/service-agreement-kuka-game.html"
                            Qt.openUrlExternally(url)
                        }

                        onEntered: {
                            textUserPolicy.color = "#C812C195"
                        }

                        onExited: {
                            textUserPolicy.color = "#12C195"
                        }
                    }
                }
            }


        }


        Rectangle {
            width: parent.width - rectGoodsDesc.width
            height: parent.height
            color: "transparent"
            anchors.right: parent.right

            Column {
                spacing: 10 * dpi
                width: parent.width * 0.9
                anchors.centerIn: parent

                Row {
                    width: parent.width
                    height: 90 * dpi
                    spacing: 30 * dpi
                    Text {
                        text:"支付方式:"
                        font.pixelSize: 16 * dpi
                        color: "#55565D"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Row {
                        spacing: 40 * dpi
                        height: 40 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        ListModel {
                            id:listModel
                            ListElement {
                                name:"微信"
                                icon_unsel:"../res/v2/wechat_unsel.png"
                                icon_sel:"../res/v2/wechat_sel.png"
                                textcolor:"#15BA11"
                            }

                            ListElement {
                                name:"支付宝"
                                icon_unsel:"../res/v2/alipay_unsel.png"
                                icon_sel:"../res/v2/alipay_sel.png"
                                textcolor:"#1296DB"
                            }
                        }

                        ButtonGroup {
                            id:btnGroup
                            exclusive: true
                        }

                        Repeater {
                            model: listModel
                            delegate: Button {
                                id:btnPay
                                width: 120 * dpi
                                height: 39 * dpi
                                anchors.verticalCenter: parent.verticalCenter
                                checkable:true
                                checked:index === payType
                                ButtonGroup.group: btnGroup
                                background: Rectangle {
                                    color: "transparent"
                                    border.width: 1 * dpi
                                    border.color: parent.checked ? "#12C195" : "#989CAE"
                                }

                                Row {
                                    spacing: 5 * dpi
                                    anchors.centerIn: parent
                                    Image {
                                        source: btnPay.checked ? icon_sel : icon_unsel
                                        fillMode: Image.PreserveAspectFit
                                        scale: dpi
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Text {
                                        text:name
                                        font.pixelSize: 16 * dpi
                                        color: btnPay.checked ? textcolor : "#989CAE"
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked:  {
                                        timerQueryOrder.stop()
                                        countDown = 90
                                        timerQueryOrder.start()
                                        GameDetails.qrLoading = true
                                        parent.checked = true
                                        index == 0 ? payTips.text = "打开微信扫一扫" :
                                                     payTips.text = "打开支付宝扫一扫"
                                        payType = index

                                        GameDetails.createGameOrder(payNum, payAmount, gameSkuId, payType)
                                    }
                                }
                            }
                        }
                    }
                }


                Column {
                    width: parent.width
                    height: 70 * dpi
                    spacing: 5* dpi
                    Text {
                        id:textGoodsTitle
                        text:"已选商品:"
                        font.pixelSize: 16 * dpi
                        color: "#55565D"
                    }

                    Text {
                        id:textGoodsName
                        width: parent.width
                        elide: Text.ElideRight
                        text:gameSkuName + "(" + gameSkuDesc +")"
                        font.pixelSize: 16 * dpi
                        color: "#55565D"
                    }
                }


                Text {
                    text:"购买数量: " + payNum.toString()
                    height: 30 * dpi
                    font.pixelSize: 16 * dpi
                    color: "#3F4045"
                    width: parent.width
                    elide: Text.ElideRight
                }


                Rectangle {
                    width: parent.width
                    height: 200 * dpi
                    color: "transparent"

                    Rectangle {
                        id:rectQR
                        width: 180 * dpi
                        height: parent.height
                        anchors.left: parent.left
                        color: "transparent"
                        border.width: 1
                        border.color: "#E5E5E5"
                        Rectangle {
                            id:rectQRImage
                            width: 160 * dpi
                            height:160 * dpi
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 10 * dpi
                            Image {
                                id:imageQr
                                visible: !GameDetails.qrLoading
                                source: GameDetails.imageQR
                                fillMode: Image.PreserveAspectFit
                                asynchronous: true
                                anchors.centerIn: parent
                                scale: dpi
                            }

                            AnimatedImage {
                                id:animateLoading
                                visible:GameDetails.qrLoading
                                source: "../res/newVersion/ani_loading.gif"
                                fillMode: Image.PreserveAspectFit
                                asynchronous: true
                                anchors.centerIn: parent
                                scale: dpi
                            }
                        }

                        Row {
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 10 * dpi
                            anchors.horizontalCenter: parent.horizontalCenter
                            Text {
                                id:payTips
                                text:"打开微信扫一扫"
                                font.pixelSize: 16 * dpi
                                color: "#989CAE"
                            }

                            Text {
                                id:textCountDown
                                text:"(" + countDown.toString() + "s)"
                                font.pixelSize: 16 * dpi
                                color: "#989CAE"
                            }
                        }
                    }

                    Rectangle {
                        id:rectPrice
                        width: parent.width - rectQR.width
                        height: parent.height
                        anchors.right: parent.right
                        color: "transparent"

                        Column {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            Row {
                                spacing: 10 * dpi
                                Text {
                                    text:"同意并支付"
                                    font.pixelSize: 16 * dpi
                                    color: "#55565D"
                                    anchors.verticalCenter: parent.verticalCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Text {
                                    text:"￥" + payAmount
                                    font.pixelSize: 30 * dpi
                                    color: "#FF5745"
                                    font.bold: true
                                    clip: true
                                    anchors.verticalCenter: parent.verticalCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            Text {
                                text:"已经阅读并同意 | 付费授权协议"
                                font.pixelSize: 14 * dpi
                                color: "#989CAE"
                            }
                        }
                    }
                }
            }

        }

    }
}
