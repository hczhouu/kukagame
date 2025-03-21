import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import GameDetails 1.0
import GameSkuModel 1.0

//游戏SKU详情页
Item {

    property int itemWidth: 960 * dpi
    property double payAmount: GameSkuModel.skuPrice * payNum
    property double gameSkuPrice: GameSkuModel.skuPrice
    property double gameOriPrice: GameSkuModel.skuOriPrice
    property string gameName: GameDetails.gameName
    property string gameSkuName: GameSkuModel.skuName
    property string gameSkuDesc: GameSkuModel.skuDesc
    property int gameSkuStock: GameSkuModel.skuStock
    property string gameSkuID: GameSkuModel.skuId
    property int payNum: 1
    property int payType: 0
    property bool showLoading: true

    Connections {
        target: GameDetails
        //获取游戏详情页成功
        onGetGameSkuSuccess:
        {
            showLoading = !success
            if (!success)
            {
               selIndex = 7
            } else {
                payNum = 1
                payType = 0
                payAmount = GameSkuModel.skuPrice * payNum
                gameSkuPrice = GameSkuModel.skuPrice
                gameOriPrice = GameSkuModel.skuOriPrice
                gameName = GameDetails.gameName
                gameSkuName = GameSkuModel.skuName
                gameSkuDesc = GameSkuModel.skuDesc
                gameSkuStock = GameSkuModel.skuStock
                gameSkuID = GameSkuModel.skuId
            }
        }
    }

    Loading {
        anchors.centerIn: parent
        visible: showLoading
    }

    ScrollView {
        visible: !showLoading
        anchors.fill: parent
        contentHeight: rect.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip: true
        Rectangle {
            id:rect
            width: parent.width
            height: 1020 * dpi
            color: "transparent"

            Rectangle {
                id:rectTopBanner
                width: itemWidth
                height: 377 * dpi
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top

                Rectangle {
                    id:rectImage
                    width: 670 * dpi
                    height: 377 * dpi
                    color: "transparent"
                    anchors.left: parent.left
                    Image {
                        id:imageGame
                        source: GameDetails.gameMainImg
                        anchors.fill: parent
                    }

                    Loading {
                        anchors.centerIn: parent
                        visible: imageGame.status != Image.Ready
                    }
                }

                Column {
                    anchors.right: parent.right
                    spacing: 10 * dpi
                    height: parent.height
                    width: parent.width - rectImage.width - 10
                    Rectangle {
                        width: parent.width
                        height: 80 * dpi
                        color: "transparent"
                        Column {
                            anchors.left: parent.left
                            width: parent.width
                            Text {
                                text:gameName
                                font.pixelSize: 18 * dpi
                                font.bold: true
                                width: parent.width
                                color: "white"
                                height: 30 * dpi
                                clip: true
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                            }

                            Text {
                                text:gameSkuName + "(" + gameSkuDesc + ")"
                                font.pixelSize: 14 * dpi
                                width: parent.width
                                color: "#A4A6AB"
                                height: 30 * dpi
                                clip: true
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 150 * dpi
                        color: "#222733"
                        radius: 10
                        Column {
                            anchors.centerIn: parent
                            width: parent.width
                            Row {
                                width: parent.width * 0.8
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text:"参考价 "
                                    font.pixelSize: 14 * dpi
                                    color: "white"
                                    height: 30 * dpi
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Text {
                                    text:"￥" + gameOriPrice.toString()
                                    font.pixelSize: 18 * dpi
                                    font.bold: true
                                    color: "#00D9B2"
                                    height: 30 * dpi
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }


                            Text {
                                text:"剩余 "+ gameSkuStock.toString() +" 库存"
                                font.pixelSize: 14 * dpi
                                color: "white"
                                height: 30 * dpi
                                width: parent.width * 0.8
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                        }
                    }
                }
            }

            Rectangle {
                id:rectGoodsTitle
                width: itemWidth
                height: 30 * dpi
                color: "transparent"
                anchors.top: rectTopBanner.bottom
                anchors.topMargin: 20 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:"商品类型"
                    font.pixelSize: 20 *dpi
                    font.bold: true
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                }
            }

            ListView {
                id:rectSku
                width: itemWidth
                height: 90 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectGoodsTitle.bottom
                anchors.topMargin: 5 * dpi
                spacing: 20
                clip: true
                layoutDirection: Qt.LeftToRight
                orientation: Qt.Horizontal

                ButtonGroup {
                    id:btnGroup
                    exclusive: true
                }

                model: GameSkuModel
                delegate: Button {
                    id:btnSku
                    width: 225 * dpi
                    height: 90 * dpi
                    checkable:true
                    checked:index === 0
                    ButtonGroup.group: btnGroup
                    background: Rectangle {
                        color: parent.checked ? "#1ECE9A" : "#222733"
                        radius: 10
                        border.color: "#2B303C"
                        border.width: parent.checked ? 0 : 1
                    }

                    Column {
                        width: parent.width
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            width: parent.width * 0.8
                            clip: true
                            elide: Text.ElideMiddle
                            font.pixelSize: 18 * dpi
                            font.bold: true
                            color: btnSku.checked ? "white" : "#A4A6AB"
                            text:skuName
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        Text {
                            width: parent.width * 0.9
                            elide: Text.ElideMiddle
                            clip: true
                            font.pixelSize: 15 * dpi
                            color: btnSku.checked ? "white" : "#A4A6AB"
                            text:skuDesc
                            horizontalAlignment: Text.AlignHCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape:Qt.PointingHandCursor
                        onClicked: {
                            showSearchResult = false
                            parent.checked = true
                            gameSkuID = skuId
                            gameSkuName = skuName
                            gameSkuDesc = skuDesc
                            gameSkuStock = skuStock
                            payAmount = skuPrice * payNum
                            gameSkuPrice = skuPrice
                            gameOriPrice = skuOriPrice
                        }
                    }
                }
            }


            Rectangle {
                id:rectStock
                width: itemWidth
                height: 30 * dpi
                color: "transparent"
                anchors.top: rectSku.bottom
                anchors.topMargin: 20 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:"剩余库存"
                    font.pixelSize: 20 *dpi
                    font.bold: true
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                }
            }

            Rectangle {
                id:rectStockVal
                width: itemWidth
                height: 50 * dpi
                color: "transparent"
                anchors.top: rectStock.bottom
                anchors.topMargin: 5 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    width: 150 * dpi
                    height: parent.height
                    color: "#222733"
                    radius: 10
                    border.width: 1
                    border.color: "#2B303C"
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        text:gameSkuStock.toString()
                        font.pixelSize: 16 *dpi
                        anchors.centerIn: parent
                        color: "white"
                    }
                }
            }

            Rectangle {
                id:rectType
                width: itemWidth
                height: 30 * dpi
                color: "transparent"
                anchors.top: rectStockVal.bottom
                anchors.topMargin: 20 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:"发货方式"
                    font.pixelSize: 20 *dpi
                    font.bold: true
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                }
            }


            Rectangle {
                id:rectExchageCode
                width: itemWidth
                height: 50 * dpi
                color: "transparent"
                anchors.top: rectType.bottom
                anchors.topMargin: 5 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    width: 150 * dpi
                    height: parent.height
                    color: "#222733"
                    radius: 10
                    border.width: 1
                    border.color: "#2B303C"
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        text:"兑换码"
                        font.pixelSize: 16 *dpi
                        anchors.centerIn: parent
                        color: "white"
                    }
                }
            }

            Rectangle {
                id:rectNumTitle
                width: itemWidth
                height: 30 * dpi
                color: "transparent"
                anchors.top: rectExchageCode.bottom
                anchors.topMargin: 20 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:"商品数量"
                    font.pixelSize: 20 *dpi
                    font.bold: true
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                }
            }

            Rectangle {
                id:rectNum
                width: itemWidth
                height: 50 * dpi
                color: "transparent"
                anchors.top: rectNumTitle.bottom
                anchors.topMargin: 5 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                SpinBox {
                    width: 150 * dpi
                    height: 50 * dpi
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    from: 1
                    to:gameSkuStock
                    value:payNum
                    enabled: gameSkuStock > 0
                    background: Rectangle {
                        color: "#222733"
                        radius: 10
                        border.width: 1
                        border.color: "#2B303C"
                    }

                    contentItem: Text {
                        text:parent.value
                        width: 100 * dpi
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 16 * dpi
                        anchors.centerIn: parent
                        color: "white"
                    }

                    down.indicator: Rectangle {
                        width: 30 * dpi
                        height: parent.height
                        color: "transparent"
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text:"-"
                            font.pixelSize: 22 * dpi
                            anchors.centerIn: parent
                            color: "white"
                        }

                    }

                    up.indicator: Rectangle {
                        width: 30 * dpi
                        height: parent.height
                        color: "transparent"
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text:"+"
                            font.pixelSize: 22 * dpi
                            anchors.centerIn: parent
                            color: "white"
                        }
                    }

                    onValueModified: {
                        payNum = value
                        payAmount = gameSkuPrice * payNum
                    }
                }
            }

            Rectangle {
                id:rectLine
                width: itemWidth
                height: 1
                color: "#222733"
                anchors.top: rectNum.bottom
                anchors.topMargin: 20 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                id:rectPrice
                width: itemWidth
                height: 60 * dpi
                color: "transparent"
                anchors.top: rectLine.bottom
                anchors.topMargin: 10 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                Column {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    Row {
                        spacing: 10 * dpi
                        Text {
                            text: "总计"
                            font.pixelSize: 16 * dpi
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            id:textSkuPrice
                            text: '￥' + payAmount.toString()
                            font.pixelSize: 30 * dpi
                            font.bold: true
                            color: "#00D9B2"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Text {
                        text:"优惠 " + GameSkuModel.skuSavePrice
                        font.pixelSize: 15 * dpi
                        color: "#A4A6AB"
                    }
                }
            }


            Rectangle {
                id:rectBuy
                width: itemWidth
                height: 58 * dpi
                color: "transparent"
                anchors.top: rectPrice.bottom
                anchors.topMargin: 10 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    width: 200 * dpi
                    height: parent.height
                    enabled: gameSkuStock > 0
                    background: Rectangle {
                        color: "#1ECF9A"
                        radius: 10
                    }

                    Text {
                        text:gameSkuStock > 0 ? "立即支付" : "暂无库存"
                        font.pixelSize: 24 * dpi
                        font.bold: true
                        anchors.centerIn: parent
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape:Qt.PointingHandCursor
                        onClicked: {
                            gamePayPopup.gameName = GameDetails.gameName
                            gamePayPopup.gameIcon = GameDetails.gameMainImg
                            gamePayPopup.gameOriPrice = gameOriPrice * payNum
                            gamePayPopup.gameSkuPrice = gameSkuPrice
                            gamePayPopup.gameSkuDesc = gameSkuDesc
                            gamePayPopup.gameSkuName = gameSkuName
                            gamePayPopup.gameSkuId = gameSkuID
                            gamePayPopup.payAmount = payAmount
                            gamePayPopup.payType = payType
                            if (gameSkuStock > payNum)
                            {
                                gamePayPopup.remainStock = gameSkuStock - payNum
                            } else {
                                gamePayPopup.remainStock = 0
                            }

                            gamePayPopup.payNum = payNum
                            gamePayPopup.open()
                        }
                    }
                }
            }
        }
    }

}
