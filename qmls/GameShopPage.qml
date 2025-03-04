import QtQuick 2.6
import QtQuick.Window 2.6
import QtQuick.Controls 2.6
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import GameShopBannerModel 1.0
import GameShopTabModel 1.0
import GameShopItemModel 1.0
import GameDetails 1.0
import HomePage 1.0

Item {

    ScrollView {
        anchors.fill: parent
        contentHeight: rect.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip: true
        Rectangle {
            id:rect
            width: parent.width
            height: 950 * dpi
            color: "transparent"

            Rectangle {
                id:rectBanner
                width: 960 * dpi
                height: 280 * dpi
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                Loading {
                    anchors.centerIn: parent
                    visible: !HomePage.shopBannerIsReady
                }

                //轮播图
                SwipeView {
                    id:swipeView
                    currentIndex: 0
                    clip: true
                    anchors.fill: parent
                    visible: HomePage.shopBannerIsReady
                    Repeater {
                        model:GameShopBannerModel
                        delegate: Image {
                            id:imageUrl
                            source: bannerUrl
                            fillMode: Image.PreserveAspectFit

                            Loading {
                                anchors.centerIn: parent
                                visible: imageUrl.status != Image.Ready
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    showSearchResult = false
                                    swipeView.forceActiveFocus()
                                    if (bannerType == 1)
                                    {
                                        //跳转到游戏详情
                                        selIndex = 7
                                        showSearchInput = false
                                        showBackButton = true
                                        GameDetails.getGameDetailsInfo(bannerAppId, '')
                                    } else if(bannerType == 2)
                                    {
                                        //跳转到消息详情
                                        var msgCaption = "未知消息"
                                        if (bannerMsgType == 1)
                                        {
                                            msgCaption = "公告消息"
                                        } else if(bannerMsgType == 2)
                                        {
                                            msgCaption = "活动消息"
                                        } else if(bannerMsgType == 3)
                                        {
                                            msgCaption = "动态消息"
                                        }

                                        var component = Qt.createComponent('ActivitiesNoticePopup.qml');
                                        var dynamicObject = component.createObject(mainWindow,
                                             {"msgId":bannerMsgId, "msgType":msgCaption});
                                        dynamicObject.open()
                                    } else if(bannerType == 3)
                                    {
                                        //打开内部链接
                                        HomePage.showInternalLink(bannerInternalLink)
                                    } else if(bannerType == 4)
                                    {
                                        //打开外部链接
                                        Qt.openUrlExternally(bannerExternalLink)
                                    }
                                }
                            }
                        }
                    }

                    Timer {
                        interval: 3000
                        repeat: true
                        running: true
                        onTriggered: {
                            var curIndex = (swipeView.currentIndex + 1) % GameShopBannerModel.rowCount();
                            swipeView.currentIndex = curIndex
                            listTitleDesc.currentIndex = swipeView.currentIndex
                        }
                    }
                }

                //标题
                Rectangle {
                    width: 220 * dpi
                    height: parent.height
                    color: "transparent"
                    anchors.right: parent.right
                    ListView {
                        id:listTitleDesc
                        anchors.fill: parent
                        anchors.margins: 5 * dpi
                        clip: true
                        model: GameShopBannerModel
                        delegate: Rectangle {
                            width: 220 * dpi
                            height: 70 * dpi
                            color: "transparent"
                            clip: true
                            Image {
                                source: "../res/v2/item_bk.png"
                                anchors.fill: parent
                                visible: index === listTitleDesc.currentIndex
                            }

                            Column {
                                spacing: 5 * dpi
                                anchors.verticalCenter: parent.verticalCenter
                                Text {
                                    id:textName
                                    text:bannerName
                                    width: 170 * dpi
                                    clip: true
                                    font.pixelSize: 16 * dpi
                                    color: "white"
                                    font.bold: true
                                    elide: Text.ElideRight
                                }

                                Text {
                                    id:textDesc
                                    text:bannerDesc
                                    width: 170 * dpi
                                    font.pixelSize: 14 * dpi
                                    color: "white"
                                    clip: true
                                    elide: Text.ElideRight
                                }

                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    showSearchResult = false
                                    swipeView.currentIndex = index
                                    listTitleDesc.forceActiveFocus()
                                }
                            }
                        }
                    }
                }

            }


            Rectangle {
                id:rectBtns
                width: 960 * dpi
                height: 70 * dpi
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectBanner.bottom
                anchors.topMargin: 20 * dpi
                Row {
                    spacing: 20 * dpi
                    Repeater {
                        model: GameShopTabModel
                        delegate: Rectangle {
                            width: 225 * dpi
                            height: 70 * dpi
                            color: "#222733"
                            radius: 5
                            border.width: 1
                            border.color: "#2B303C"
                            Row {
                                spacing: 5 * dpi
                                anchors.centerIn: parent
                                Image {
                                    source: tabIcon
                                    fillMode: Image.PreserveAspectFit
                                    scale: dpi
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text:tabTitle
                                    font.pixelSize: 18 * dpi
                                    font.bold: true
                                    color: "white"
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked:{
                                    showSearchResult = false
                                    rectBtns.forceActiveFocus()
                                    GameShopTabModel.selectIndex(index)
                                }
                            }
                        }
                    }
                }
            }


            Rectangle {
                id:stackLayoutGameItem
                width: 980 * dpi
                height: 630 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectBtns.bottom
                anchors.topMargin: 20 * dpi
                color: "transparent"

                Loading {
                    anchors.centerIn: parent
                    visible: !HomePage.shopGoodModelIsReady
                }

                GridView {
                    anchors.fill: parent
                    model: GameShopItemModel
                    clip: true
                    cellWidth:stackLayoutGameItem.width / 4
                    cellHeight: 277 * dpi
                    boundsBehavior: Flickable.StopAtBounds
                    visible: HomePage.shopGoodModelIsReady
                    delegate: Rectangle {
                        width:stackLayoutGameItem.width / 4
                        height: 277 * dpi
                        color: "transparent"
                        Rectangle {
                            width: 225 * dpi
                            height: 250 * dpi
                            color: "#222733"
                            radius: 10 * dpi
                            anchors.horizontalCenter: parent.horizontalCenter
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    selIndex = 7
                                    showSearchInput = false
                                    showSearchResult = false
                                    showBackButton = true
                                    stackLayoutGameItem.forceActiveFocus()
                                    GameDetails.getGameDetailsInfo(itemGameId, itemGoodsId)
                                }
                            }


                            Column {
                                anchors.centerIn: parent
                                Rectangle {
                                    id:rectImage
                                    width: 225 * dpi
                                    height: 126 * dpi
                                    color: "transparent"
                                    Image {
                                        id:imageIconUrl
                                        source: itemMainImage
                                        anchors.fill: parent
                                    }

                                    Loading {
                                        anchors.centerIn: parent
                                        visible: imageIconUrl.status != Image.Ready
                                    }
                                }

                                Rectangle {
                                    width: 225 * dpi
                                    height: parent.parent.height - rectImage.height
                                    color: "transparent"
                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        Rectangle {
                                            width: parent.parent.width
                                            height: textName.height
                                            color: "transparent"
                                            clip: true
                                            Text {
                                                id:textName
                                                text:itemName
                                                width: parent.width * 0.9
                                                elide: Text.ElideRight
                                                font.pixelSize: 16 * dpi
                                                font.bold: true
                                                color: "white"
                                                anchors.left: parent.left
                                                anchors.leftMargin: 10 * dpi
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }


                                        Rectangle {
                                            width: parent.parent.width
                                            height: textDesc.height
                                            color: "transparent"
                                            Text {
                                                id:textDesc
                                                text:itemLabel
                                                clip: true
                                                width: parent.width * 0.9
                                                elide: Text.ElideRight
                                                font.pixelSize: 14 * dpi
                                                color: "white"
                                                anchors.left: parent.left
                                                anchors.leftMargin: 10 * dpi
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }


                                        Rectangle {
                                            width: parent.parent.width
                                            height: 70 * dpi
                                            color: "transparent"
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            Rectangle {
                                                width: 120 * dpi
                                                height: parent.height
                                                color: "transparent"
                                                anchors.left: parent.left
                                                anchors.bottom: parent.bottom
                                                Column {
                                                    anchors.left: parent.left
                                                    anchors.leftMargin: 10 * dpi
                                                    anchors.bottom: parent.bottom
                                                    anchors.bottomMargin: 10 * dpi
                                                    Text {
                                                        text:"￥" + itemPrice
                                                        font.pixelSize: 24 * dpi
                                                        color: "#00D9B2"
                                                    }

                                                    Row {
                                                        spacing: 10 * dpi
                                                        Text {
                                                            text: "￥" +  itemOriginalPrice
                                                            font.pixelSize: 14 * dpi
                                                            font.strikeout: true
                                                            color: "#A4A6AB"
                                                        }

                                                        Text {
                                                            text: itemPriceSave
                                                            font.pixelSize: 14 * dpi
                                                            color: "#A4A6AB"
                                                        }
                                                    }
                                                }
                                            }



                                            Rectangle {
                                                width: 80 * dpi
                                                height: 30 * dpi
                                                radius: 20 * dpi
                                                color: "#1ECF9E"
                                                anchors.right: parent.right
                                                anchors.rightMargin: 10 * dpi
                                                anchors.bottom: parent.bottom
                                                anchors.bottomMargin: 10 * dpi
                                                Text {
                                                    text:"立即购买"
                                                    font.pixelSize: 15 * dpi
                                                    font.bold: true
                                                    color: "white"
                                                    anchors.centerIn: parent
                                                }

                                                MouseArea {
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        selIndex = 7
                                                        showSearchInput = false
                                                        showSearchResult = false
                                                        showBackButton = true
                                                        stackLayoutGameItem.forceActiveFocus()
                                                        GameDetails.getGameDetailsInfo(itemGameId, itemGoodsId)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                            }

                        }

                    }

                }
            }

        }

    }
}
