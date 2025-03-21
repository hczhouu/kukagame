import QtQuick 2.12
import QtQuick.Controls 2.12
import GameDetails 1.0
import CDKeyListModel 1.0

// 游戏订单详情弹窗
Popup {
    id:gamePaySuccessPopup
    width:820 * dpi
    height:590 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent
    property bool showLoading: true
    property string gameMainImage: "" //商品主图
    property double oriPrice: 0.00 //原价
    property double skuPrice: 0.00 //单价
    property int buyNum: 1 //购买数量
    property double payAmount: 0.00 //支付价格
    property string gameName: "" //游戏名称
    property string gameSkuName: "" //购买规格

    Connections {
        target: GameDetails
        //获取订单详情成功
        onGetOrderDetailSuccess:
        {
            showLoading = false
        }
    }

    onOpened: {
        //GameDetails.getOrderDetail(orderSn, CDKeyListModel)
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
            text:"购买成功"
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
                    gamePaySuccessPopup.close()
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

        // AnimatedImage {
        //     id:animateLoading
        //     visible:showLoading
        //     source: "../res/newVersion/ani_loading.gif"
        //     fillMode: Image.PreserveAspectFit
        //     asynchronous: true
        //     anchors.centerIn: parent
        //     scale: dpi
        // }


        Rectangle {
            id:rectHead
            width: parent.width * 0.9
            height: 150 * dpi
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            Rectangle {
                id:gameImage
                width: 225 * dpi
                height: 126 * dpi
                color: "transparent"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    source: gameMainImage
                    anchors.fill: parent
                }
            }

            Column {
                anchors.left: gameImage.right
                anchors.leftMargin: 10 * dpi
                anchors.top:gameImage.top
                spacing: 10 * dpi
                Text {
                    text:gameName
                    font.pixelSize: 12 * dpi
                    color:"#3F4045"
                }

                Text {
                    text:gameSkuName
                    font.pixelSize: 12 * dpi
                    color:"#989CAE"
                }
            }


            Column {
                anchors.right: parent.right
                spacing: 30 * dpi
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    text:"￥" + skuPrice.toString()
                    font.pixelSize: 13 * dpi
                    color:"#3F4045"
                    anchors.right: parent.right
                }

                Text {
                    text:"×" + buyNum.toString()
                    font.pixelSize: 12 * dpi
                    color:"#989CAE"
                    anchors.right: parent.right
                }

                Row {
                    anchors.right: parent.right
                    Text {
                        text:"实付 "
                        height: 30 * dpi
                        font.pixelSize: 12 * dpi
                        color:"#989CAE"
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        text:"￥" + payAmount.toString()
                        font.pixelSize: 12 * dpi
                        color:"#12C195"
                        font.bold: true
                        height: 30 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }


        Rectangle {
            id:rectLine
            visible: true
            width: parent.width * 0.9
            height: 1
            color: "#DDDFE8"
            anchors.top: rectHead.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }


        Rectangle {
            id:rectKey
            visible:true
            width: parent.width * 0.9
            height: 100 * dpi
            color: "transparent"
            anchors.top: rectLine.bottom
            anchors.topMargin: 10 * dpi
            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                visible:GameDetails.postStatus !== '已发货'
                anchors.centerIn: parent
                spacing: 10 * dpi
                Image {
                    source: "../res/v2/pay_success.png"
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text:'支付成功, 待发货'
                    font.pixelSize: 13 * dpi
                    color: "#55565D"
                }
            }
        }


        Rectangle {
            visible: true
            width: parent.width * 0.9
            height: 160 * dpi
            color: "transparent"
            anchors.top: rectKey.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            TextField {
                anchors.fill: parent
                text:"亲，由于数字商品的特殊性，一经发货成功后无质量问题暂不支持退换，非常感谢您的理解！
购买前请先了解商品首页的详情说明，因个人原因等情况导致不能运行游戏的，请联系客服提供帮助"
                font.pixelSize: 12 * dpi
                color: "#989CAE"
                wrapMode: Text.WordWrap
                background: Rectangle {
                    color: "transparent"
                }
            }
        }

    }
}
