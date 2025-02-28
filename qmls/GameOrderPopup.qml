import QtQuick 2.15
import QtQuick.Controls 2.15
import GameDetails 1.0
import CDKeyListModel 1.0

// 游戏订单详情弹窗
Popup {
    id:gameOrderPopup
    width:820 * dpi
    height:590 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent
    property bool showLoading: true
    property string orderSn: ""

    Connections {
        target: GameDetails
        //获取订单详情成功
        function onGetOrderDetailSuccess()
        {
            showLoading = false
        }
    }

    onOpened: {
        GameDetails.getOrderDetail(orderSn, CDKeyListModel)
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
            text:"订单详情"
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
                    gameOrderPopup.close()
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

        AnimatedImage {
            id:animateLoading
            visible:showLoading
            source: "../res/newVersion/ani_loading.gif"
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            anchors.centerIn: parent
            scale: dpi
        }

        Rectangle {
            id:rectHead
            width: parent.width * 0.9
            height: 150 * dpi
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle {
                id:rectGameImage
                width: 225 * dpi
                height: 126 * dpi
                color: "transparent"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    source: GameDetails.goodsMainImage
                    anchors.fill: parent
                }
            }

            Column {
                anchors.left: rectGameImage.right
                anchors.leftMargin: 20 * dpi
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10 * dpi
                Text {
                    text:GameDetails.goodsName
                    font.pixelSize: 15 * dpi
                    color: "#3F4045"
                }

                Text {
                    text:GameDetails.skuName
                    font.pixelSize: 15 * dpi
                    color: "#989CAE"
                }
            }
        }


        Rectangle {
            id:rectLineHead
            visible: !showLoading
            width: parent.width * 0.9
            height: 1
            color: "#DDDFE8"
            anchors.top: rectHead.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            id:rectKey
            visible: !showLoading
            width: parent.width * 0.9
            height: 70 * dpi
            color: "transparent"
            anchors.top: rectLineHead.bottom
            anchors.topMargin: 5 * dpi
            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                visible:GameDetails.postStatus !== '已发货'
                anchors.centerIn: parent
                spacing: 10 * dpi
                Image {
                    source: GameDetails.payStatus === '支付成功' ? "../res/v2/pay_success.png" :
                                                                  "../res/v2/wait_pay.png"
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text:GameDetails.payStatus === '支付成功' ? "支付成功" : "未付款"
                    font.pixelSize: 13 * dpi
                    color: "#55565D"
                }
            }

            ListView {
                id:cdkeyList
                visible: GameDetails.postStatus === '已发货'
                anchors.fill: parent
                spacing: 10
                model: CDKeyListModel
                clip: true
                delegate: Rectangle {
                    width: parent.width
                    height: 30 * dpi
                    color: "transparent"
                    Text {
                        text:cdKey
                        font.pixelSize: 16 * dpi
                        font.bold: true
                        color:"#3F4045"
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Button {
                        width: 90 * dpi
                        height: 30 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        background: Rectangle {
                            color: "#1ECE99"
                            radius: 5
                        }

                        Text {
                            text:"复制兑换码"
                            font.pixelSize: 10 * dpi
                            color: "white"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape:Qt.PointingHandCursor
                            onClicked: {
                                GameDetails.copyCdKey(cdKey)
                            }
                        }
                    }
                }
            }
        }


        Rectangle {
            id:rectLine
            visible: !showLoading
            width: parent.width * 0.9
            height: 1
            color: "#DDDFE8"
            anchors.top: rectKey.bottom
            anchors.topMargin: 10 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            id:rectCaption
            visible: !showLoading
            width: parent.width * 0.9
            height: 30 * dpi
            color: "transparent"
            anchors.top: rectLine.bottom
            anchors.topMargin: 5 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                text:"订单信息"
                font.pixelSize: 13 * dpi
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: "#55565D"
            }
        }

        Rectangle {
            visible: !showLoading
            width: parent.width * 0.9
            height: 160 * dpi
            color: "transparent"
            anchors.top: rectCaption.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Column {
                width: parent.width
                anchors.left: parent.left
                spacing: 10 * dpi
                Rectangle {
                    width: parent.width
                    color: "transparent"
                    height: textOrderNum.height
                    Text {
                        id:textOrderNum
                        text:"订单编号"
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.left: parent.left
                    }

                    Text {
                        text:GameDetails.orderSn
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.right: parent.right
                    }
                }

                Rectangle {
                    width: parent.width
                    color: "transparent"
                    height: textOrderNum.height
                    Text {
                        text:"订单状态"
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.left: parent.left
                    }

                    Text {
                        text:GameDetails.payStatus === '支付成功' ? GameDetails.postStatus : "--"
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.right: parent.right
                    }
                }

                Rectangle {
                    width: parent.width
                    color: "transparent"
                    height: textOrderNum.height
                    Text {
                        text:"商品名称"
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.left: parent.left
                    }

                    Text {
                        text:GameDetails.goodsName
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.right: parent.right
                    }
                }

                Rectangle {
                    width: parent.width
                    color: "transparent"
                    height: textOrderNum.height
                    Text {
                        text:"规格"
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.left: parent.left
                    }

                    Text {
                        text:GameDetails.skuName
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.right: parent.right
                    }
                }

                Rectangle {
                    width: parent.width
                    color: "transparent"
                    height: textOrderNum.height
                    Text {
                        text:"购买数量"
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.left: parent.left
                    }

                    Text {
                        text:GameDetails.payNum.toString()
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.right: parent.right
                    }
                }

                Rectangle {
                    width: parent.width
                    color: "transparent"
                    height: textOrderNum.height
                    Text {
                        text:"订单金额"
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.left: parent.left
                    }

                    Text {
                        text:"￥" + GameDetails.payAmount
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.right: parent.right
                    }
                }

                Rectangle {
                    width: parent.width
                    color: "transparent"
                    height: textOrderNum.height
                    Text {
                        text:"付款时间"
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.left: parent.left
                    }

                    Text {
                        text:GameDetails.createTime
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.right: parent.right
                    }
                }

                Rectangle {
                    width: parent.width
                    color: "transparent"
                    height: textOrderNum.height
                    Text {
                        text:"支付方式"
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.left: parent.left
                    }

                    Text {
                        text:GameDetails.payType === 1 ? "支付宝":"微信"
                        font.pixelSize: 12 * dpi
                        color: "#989CAE"
                        anchors.right: parent.right
                    }
                }

            }
        }

    }
}
