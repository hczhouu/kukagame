import QtQuick 2.15
import QtQuick.Controls 2.15


// 支付页面弹窗
Popup {
    id:payPopup
    property string name: ""
    property string desc: ""
    property string origPrice: ""
    property string payAmount: ""
    property string orderAmount: ""
    property string goodsRemark: ""
    property int mealType: 1  //1时长卡 2周期卡
    property int limTime: 0
    property int totaTime: 0
    property string labelTips: ""
    property bool show_Label: false

    property int countDown: 0
    property bool wechatSelected: true
    property bool isBuyVIP: false

    width:820 * dpi
    height:590 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    Timer {
        id:timerClose
        repeat: true
        running: false
        interval: 1000
        onTriggered: {
            payPopup.countDown --
            if (payPopup.countDown <= 0)
            {
                payPopup.close()
                timerClose.stop()
                timerQuery.stop()
            }
        }
    }

    Timer {
        id:timerQuery
        repeat: true
        running: false
        interval: 2000
        onTriggered: {
            wechatSelected ? HttpClient.queryWechatOrderStatus() :
                             HttpClient.queryAlipayOrderStatus()
        }
    }

    onOpened: {
        HttpClient.qrLoading = true
        btnWechat.checked = true
        btnAlipay.checked = false
        payPopup.countDown = 90
        wechatSelected  = true
        timerClose.start()
        timerQuery.start()
    }

    onClosed: {
        timerClose.stop()
        timerQuery.stop()
        if (wechatSelected)
        {
            HttpClient.closeWechatOrder()
            return;
        }

        HttpClient.closeAlipayOrder()
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
            source: "../res/v2/about_bk.png"
            anchors.fill: parent
        }

        Text {
            text:"充值"
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
                    payPopup.close()
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
            id:rectPackage
            width: 380 * dpi
            height: parent.height
            color: "transparent"
            anchors.left: parent.left
            PackageItem {
                id:packageItem
                anchors.top: parent.top
                anchors.topMargin: 44 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                goods_name: name
                goods_desc: desc
                pay_Amount: payAmount
                order_Amount: orderAmount
                original_Price: origPrice
                showLabel: show_Label
                limit_Time: limTime
                total_Time: totaTime
                label_tips: labelTips
                showBuyBtn:false
                remark:goodsRemark
                visible: !isBuyVIP
            }

            VipPackageItem {
                id:vippackageItem
                anchors.top: parent.top
                anchors.topMargin: 44 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                goods_name: name
                goods_desc: desc
                pay_Amount: payAmount
                order_Amount: orderAmount
                original_Price: origPrice
                showLabel: show_Label
                limit_Time: limTime
                total_Time: totaTime
                label_tips: labelTips
                showBuyBtn:false
                remark:goodsRemark
                bkImage: name === "VIP" ? "../res/v2/vip_bk.png": "../res/v2/svip_bk.png"
                visible: isBuyVIP
            }


            Text {
                id:textTips
                width: isBuyVIP ? vippackageItem.width : packageItem.width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: isBuyVIP ? vippackageItem.bottom : packageItem.bottom
                anchors.topMargin: 30 * dpi
                //text:"充值须知:
   // 1.充值成功之日起开始计算有效期，具体有效期以您购买的类型为准。
   // 2.请在有效期内使用完您的服务时长，过期将自动失效，无法继续使用。
   // 3.因商品为虚拟产品，请您充值前确认购买的类型是否涵盖了您的使用需求，同时确认充值的账号是否正确，付款成功后不支持权益转换和退款。"

                text:"充值须知:
虚拟产品充值前请确认相关信息是否正确，付款成功后
不支持权益转换和退款；有效期从购买日开始计算。
有任何问题加客服微信:whsrcw咨询。"
                color: "#989CAE"
                wrapMode: Text.WordWrap
                font.pixelSize: 13 * dpi
            }
        }


        Rectangle {
            width: parent.width - rectPackage.width
            height: parent.height
            color: "transparent"
            anchors.right: parent.right

            Column {
                spacing: 10 * dpi
                anchors.centerIn: parent
                Row {
                    spacing: 10 * dpi
                    height: 40 * dpi
                    Text {
                        id:textPayMethod
                        text:"支付方式:"
                        font.pixelSize: 14 * dpi
                        color: "#55565D"
                        anchors.verticalCenter: btnWechat.verticalCenter
                    }


                    //微信
                    Button {
                        id:btnWechat
                        width: 120 * dpi
                        height: 39 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        checkable:true
                        checked:true

                        background: Rectangle {
                            color: "transparent"
                            border.width: 1 * dpi
                            border.color: parent.checked ? "#12C195" : "#989CAE"
                        }


                        Row {
                            spacing: 5 * dpi
                            anchors.centerIn: parent
                            Image {
                                source: btnWechat.checked ? "../res/v2/wechat_sel.png" :
                                                            "../res/v2/wechat_unsel.png"
                                fillMode: Image.PreserveAspectFit
                                scale: dpi
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text:"微信支付"
                                font.pixelSize: 14 * dpi
                                color: btnWechat.checked ? "#15BA11" : "#989CAE"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked:  {
                                if(btnWechat.checked)
                                {
                                    return
                                }

                                btnAlipay.checked = false
                                btnWechat.checked = true
                                wechatSelected = true
                                timerQuery.stop()
                                payPopup.countDown = 90
                                timerQuery.start()
                                HttpClient.qrLoading = true
                                HttpClient.generateWechatQR(payAmount)
                            }
                        }

                    }


                    //支付宝
                    Button {
                        id:btnAlipay
                        width: 120 * dpi
                        height: 39 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        checkable:true
                        checked:false

                        background: Rectangle {
                            color: "transparent"
                            border.width: 1 * dpi
                            border.color: parent.checked ? "#12C195" : "#989CAE"
                        }

                        Row {
                            spacing: 5 * dpi
                            anchors.centerIn: parent
                            Image {
                                source: btnAlipay.checked ? "../res/v2/alipay_sel.png" :
                                                            "../res/v2/alipay_unsel.png"
                                fillMode: Image.PreserveAspectFit
                                scale: dpi
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            Text {
                                text:"支付宝"
                                font.pixelSize: 14 * dpi
                                color: btnAlipay.checked ? "#1296DB" : "#989CAE"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked:  {
                                if (btnAlipay.checked)
                                {
                                    return
                                }

                                btnAlipay.checked = true
                                btnWechat.checked = false
                                wechatSelected = false
                                timerQuery.stop()
                                payPopup.countDown = 90
                                timerQuery.start()
                                HttpClient.qrLoading = true
                                HttpClient.generateAlipayQR(payAmount, orderAmount)
                            }
                        }
                    }
                }


                Row {
                    spacing:10 * dpi
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        id:textGoodsTitle
                        text:"已选商品:"
                        font.pixelSize: 14 * dpi
                        color: "#55565D"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        id:textGoodsVal
                        text:name
                        font.pixelSize: 14 * dpi
                        color: "#55565D"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }


                Row {
                    spacing: 5 * dpi
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        id:textPay
                        text:"需支付  ￥"
                        font.pixelSize: 14 * dpi
                        color: "#55565D"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text:{
                            if (isBuyVIP)
                            {
                                return payAmount
                            }

                            var realPay = Number(payAmount) * HttpClient.payPercent
                            return realPay.toFixed(2).toString()
                        }
                        font.pixelSize: 36 * dpi
                        color: "#FF6000"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }


                Text {
                    id:textCountDown
                    text:"("+payPopup.countDown.toString()+"s)"
                    font.pixelSize: 12 * dpi
                    color: "#55565D"
                    anchors.horizontalCenter: parent.horizontalCenter
                }


                Rectangle {
                    id:rectQR
                    width: 160 * dpi
                    height:160 * dpi
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image {
                        id:imageQr
                        visible: !HttpClient.qrLoading
                        source: HttpClient.codeUrl
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        anchors.centerIn: parent
                        scale: dpi
                    }

                    AnimatedImage {
                        id:animateLoading
                        visible:HttpClient.qrLoading
                        source: "../res/newVersion/ani_loading.gif"
                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        anchors.centerIn: parent
                        scale: dpi
                    }
                }

                Row {
                    id:rowPayMethod
                    spacing: 10 * dpi
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image {
                        source: btnWechat.checked ? "../res/v2/wechat_sel.png" :
                                                    "../res/v2/alipay_sel.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                        scale: dpi
                    }

                    Text {
                        text:btnWechat.checked ? "微信扫码支付" : "支付宝扫码支付"
                        color: "#55565D"
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 14 * dpi
                    }
                }

            }

        }

    }
}
