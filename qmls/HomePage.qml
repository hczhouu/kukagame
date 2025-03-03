import QtQuick 2.6
import QtQuick.Window 2.6
import QtQuick.Controls 2.6
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import HomePage 1.0
import HomeBannerModel 1.0
import HomeActivitiesModel 1.0
import HomeHotGamesTabModel 1.0
import HomeHotGamesModel 1.0
import HomeGoodsTabModel 1.0
import HomeGoodsModel 1.0
import GameDetails 1.0


Item {
    id:itemHomePage
    property int hotGameTabIndex: 0
    property int goodsTabIndex: 0

    MouseArea {
        anchors.fill: parent
        onClicked: {
            showSearchResult = false
        }
    }

    ScrollView {
        anchors.fill: parent
        contentHeight: rectContent.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip: true


        Rectangle {
            id:rectContent
            width: parent.width
            //height: 1310 * dpi
            height: 1100 * dpi
            color: "transparent"

            //顶部轮播图
            Rectangle {
                id:rectPics
                width: 960 * dpi
                height: 280 * dpi
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top

                Loading {
                    anchors.centerIn: parent
                    visible: !HomePage.bannerModelIsReady
                }

                SwipeView {
                    id:swipeView
                    currentIndex: 0
                    clip: true
                    anchors.fill: parent
                    visible: HomePage.bannerModelIsReady
                    Repeater {
                        model:HomeBannerModel
                        delegate: Image {
                            id:bannerImage
                            source:bannerUrl
                            fillMode: Image.PreserveAspectFit
                            cache: false
                            asynchronous: true

                            Loading {
                                visible: bannerImage.status != Image.Ready
                                anchors.centerIn: parent
                                color: "#9A9D9C"
                            }


                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    showSearchResult = false
                                    bannerImage.forceActiveFocus()
                                    if (bannerType == 1)
                                    {
                                        //跳转到游戏详情
                                        selIndex = 6
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
                            swipeView.currentIndex = (swipeView.currentIndex + 1) % HomeBannerModel.rowCount();
                        }
                    }

                    Component.onCompleted: {
                        HomePage.getBannerData(HomeBannerModel, HomeActivitiesModel,
                                               HomeHotGamesTabModel, HomeGoodsTabModel)
                    }
                }


                Rectangle {
                    width: 220 * dpi
                    height: parent.height
                    color: "transparent"
                    anchors.right: parent.right
                    visible: HomePage.bannerModelIsReady
                    ListView {
                        id:listTitleDesc
                        anchors.fill: parent
                        anchors.margins: 5 * dpi
                        clip: true
                        model: HomeBannerModel
                        delegate: Rectangle {
                            width: 220 * dpi
                            height: 70 * dpi
                            color: "transparent"
                            clip: true
                            Image {
                                source: "../res/v2/item_bk.png"
                                anchors.fill: parent
                            }

                            Column {
                                spacing: 5 * dpi
                                anchors.verticalCenter: parent.verticalCenter
                                Text {
                                    id:textName
                                    text:bannerName
                                    width: parent.parent.width * 0.9
                                    clip: true
                                    font.pixelSize: 16 * dpi
                                    color: "white"
                                    font.bold: true
                                    elide: Text.ElideRight
                                }

                                Text {
                                    id:textDesc
                                    text:bannerDesc
                                    width: parent.parent.width * 0.9
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
                                    listTitleDesc.forceActiveFocus()
                                    showSearchResult = false
                                    swipeView.currentIndex = index
                                }
                            }
                        }
                    }
                }
            }


            //活动动态标题
            // Rectangle {
            //     id:rectCaption
            //     width: 960 * dpi
            //     height: textTitle.height
            //     color: "transparent"
            //     anchors.horizontalCenter: parent.horizontalCenter
            //     anchors.top: rectPics.bottom
            //     anchors.topMargin: 20 * dpi
            //     Text {
            //         id:textTitle
            //         text:"活动动态"
            //         font.bold: true
            //         font.pixelSize: 18
            //         anchors.left: parent.left
            //         color: "white"
            //         anchors.verticalCenter: parent.verticalCenter
            //     }
            // }


            //活动动态轮播图
            // Rectangle {
            //     id:rectActivity
            //     width: 960 * dpi
            //     height: 200 * dpi
            //     color: "transparent"
            //     anchors.horizontalCenter: parent.horizontalCenter
            //     anchors.top: rectCaption.bottom
            //     anchors.topMargin: 10 * dpi

            //     Rectangle {
            //         width: 560 * dpi
            //         height: parent.height
            //         color: "transparent"
            //         anchors.left: parent.left

            //         Loading {
            //             anchors.centerIn: parent
            //             visible: !HomePage.bannerModelIsReady
            //         }

            //         SwipeView {
            //             id:swipeViewActivities
            //             currentIndex: 0
            //             clip: true
            //             anchors.fill: parent
            //             visible: HomePage.bannerModelIsReady
            //             Repeater {
            //                 model:HomeActivitiesModel
            //                 delegate: Rectangle {
            //                     width: parent.parent.width
            //                     height: parent.parent.height
            //                     color: "transparent"

            //                     Image {
            //                         id:activitiesImage
            //                         source: activitiesBannerUrl
            //                         anchors.fill: parent
            //                         cache: false
            //                         asynchronous: true
            //                     }

            //                     Loading {
            //                         anchors.centerIn: parent
            //                         visible: activitiesImage.status != Image.Ready
            //                     }

            //                     MouseArea {
            //                         anchors.fill: parent
            //                         hoverEnabled: true
            //                         cursorShape: Qt.PointingHandCursor
            //                         onClicked: {
            //                             showSearchResult = false
            //                             swipeViewActivities.forceActiveFocus()
            //                             if (activitiesBannerType == 1)
            //                             {
            //                                 //跳转到游戏详情
            //                                 selIndex = 7
            //                                 showSearchInput = false
            //                                 showBackButton = true
            //                                 GameDetails.getGameDetailsInfo(activitiesBannerAppId, '')
            //                             } else if(activitiesBannerType == 2)
            //                             {
            //                                 //跳转到消息详情
            //                                 var msgCaption = "未知消息"
            //                                 if (activitiesBannerMsgType == 1)
            //                                 {
            //                                     msgCaption = "公告消息"
            //                                 } else if(activitiesBannerMsgType == 2)
            //                                 {
            //                                     msgCaption = "活动消息"
            //                                 } else if(activitiesBannerMsgType == 3)
            //                                 {
            //                                     msgCaption = "动态消息"
            //                                 }

            //                                 var component = Qt.createComponent('ActivitiesNoticePopup.qml');
            //                                 var dynamicObject = component.createObject(mainWindow,
            //                                      {"msgId":activitiesBannerMsgId, "msgType":msgCaption});
            //                                 dynamicObject.open()
            //                             } else if(activitiesBannerType == 3)
            //                             {
            //                                 //打开内部链接
            //                                 HomePage.showInternalLink(activitiesBannerInternalLink)
            //                             } else if(activitiesBannerType == 4)
            //                             {
            //                                 //打开外部链接
            //                                 Qt.openUrlExternally(activitiesBannerExternalLink)
            //                             }

            //                         }
            //                     }
            //                 }
            //             }

            //             Timer {
            //                 interval: 3000
            //                 repeat: true
            //                 running: true
            //                 onTriggered: {
            //                     swipeViewActivities.currentIndex =
            //                             (swipeViewActivities.currentIndex + 1) % HomeActivitiesModel.rowCount();
            //                 }
            //             }
            //         }


            //         Rectangle {
            //             width: parent.width
            //             height: 40 * dpi
            //             color: "#C81E222E"
            //             anchors.bottom: parent.bottom
            //             visible: HomePage.bannerModelIsReady
            //             Row {
            //                 anchors.centerIn: parent
            //                 spacing: 80 * dpi
            //                 Repeater {
            //                     model: HomeActivitiesModel
            //                     delegate: Text {
            //                         text: activitiesBannerName
            //                         width: 120 * dpi
            //                         elide: Text.ElideRight
            //                         font.pixelSize: 14 * dpi
            //                         color: index === swipeViewActivities.currentIndex ? "white" : "#A4A6AB"
            //                         horizontalAlignment: Text.AlignHCenter
            //                         MouseArea {
            //                             anchors.fill: parent
            //                             hoverEnabled: true
            //                             cursorShape: Qt.PointingHandCursor
            //                             onClicked: {
            //                                 showSearchResult = false
            //                                 swipeViewActivities.currentIndex = index
            //                             }

            //                             onEntered: {
            //                                 parent.color = "white"
            //                             }

            //                             onExited: {
            //                                 parent.color = "#A4A6AB"
            //                             }
            //                         }
            //                     }
            //                 }
            //             }
            //         }

            //     }

            //     Rectangle {
            //         id:rectLinks
            //         width: 370 * dpi
            //         height: parent.height
            //         color: "#1D222E"
            //         radius: 10
            //         anchors.right: parent.right
            //         anchors.verticalCenter: parent.verticalCenter
            //         Column {
            //             spacing: 10 * dpi
            //             anchors.centerIn: parent

            //             ListModel {
            //                 id:listModelBtns
            //                 ListElement {
            //                     icon_path:"../res/v2/gift.png"
            //                     text_title:"邀请有礼"
            //                     text_desc:"邀请好友，领取免费时长"
            //                 }

            //                 ListElement {
            //                     icon_path:"../res/v2/archive.png"
            //                     text_title:"游戏云存档"
            //                     text_desc:"点击查看云存档游戏"
            //                 }

            //                 ListElement {
            //                     icon_path:"../res/v2/q&a.png"
            //                     text_title:"常见问题Q&A"
            //                     text_desc:"点击查看常见问题"
            //                 }
            //             }

            //             Repeater {
            //                 model: listModelBtns
            //                 delegate: Rectangle {
            //                     width: 350 * dpi
            //                     height: 53 * dpi
            //                     color: "#222733"
            //                     border.width: 1
            //                     border.color: "#2B303C"
            //                     radius: 10

            //                     Image {
            //                         id:rectIcon
            //                         source: icon_path
            //                         fillMode: Image.PreserveAspectFit
            //                         scale: dpi
            //                         anchors.verticalCenter: parent.verticalCenter
            //                         anchors.left: parent.left
            //                         anchors.leftMargin: 18 * dpi
            //                     }

            //                     Rectangle {
            //                         width: 250 * dpi
            //                         height: parent.height
            //                         color: "transparent"
            //                         anchors.left: rectIcon.right
            //                         anchors.leftMargin: 20 * dpi
            //                         clip: true
            //                         Column {
            //                             anchors.verticalCenter: parent.verticalCenter
            //                             Text {
            //                                 id:textCaption
            //                                 text:text_title
            //                                 font.pixelSize: 16 * dpi
            //                                 font.bold: true
            //                                 color: "white"
            //                                 clip: true
            //                                 elide: Text.ElideRight
            //                             }

            //                             Text {
            //                                 id:textDescp
            //                                 text:text_desc
            //                                 font.pixelSize: 14 * dpi
            //                                 color: "#A4A6AB"
            //                                 clip: true
            //                                 elide: Text.ElideRight
            //                             }
            //                         }

            //                         MouseArea {
            //                             anchors.fill: parent
            //                             hoverEnabled: true
            //                             cursorShape: Qt.PointingHandCursor
            //                             onClicked: {
            //                                 showSearchResult = false
            //                                 rectLinks.forceActiveFocus()
            //                                 if (index === 0)
            //                                 {
            //                                     if (userLogined)
            //                                     {
            //                                         showPopup('PromoCodePopup.qml')
            //                                     } else {
            //                                         showPopup('LoginPopup.qml')
            //                                     }
            //                                 } else if (index === 1) {
            //                                     if (userLogined)
            //                                     {
            //                                         rectLeft.selectMyPage(1)
            //                                     } else {
            //                                         showPopup('LoginPopup.qml')
            //                                     }

            //                                 } else if (index === 2) {
            //                                     var url = "https://support.qq.com/product/514046"
            //                                     Qt.openUrlExternally(url)
            //                                 }
            //                             }

            //                             onEntered: {
            //                                 textDescp.color = "white"
            //                             }

            //                             onExited: {
            //                                 textDescp.color = "#878F91"
            //                             }
            //                         }
            //                     }

            //                     Image {
            //                         source: "../res/v2/arrow.png"
            //                         fillMode: Image.PreserveAspectFit
            //                         scale: dpi
            //                         anchors.right: parent.right
            //                         anchors.rightMargin: 20 * dpi
            //                         anchors.verticalCenter: parent.verticalCenter
            //                     }
            //                 }
            //             }

            //         }
            //     }
            // }


            //Tab按钮
            TabBar {
                id:rectTabBtns
                width: 960 * dpi
                height: 30 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectPics.bottom
                anchors.topMargin: 20 * dpi
                background: Rectangle {
                    color: "transparent"
                }

                ButtonGroup {
                    id:btnGroup
                    exclusive: true
                }

                Repeater {
                    model: HomeHotGamesTabModel
                    delegate: TabButton {
                        id:tabBtn
                        width: 100 * dpi
                        height: 30 * dpi
                        checkable: true
                        checked: index === 0
                        anchors.verticalCenter: parent.verticalCenter
                        ButtonGroup.group: btnGroup
                        background: Rectangle {
                            color: "transparent"
                        }

                        contentItem: Text {
                            id:caption
                            text:hotGamesTitle
                            width: parent.width
                            elide: Text.ElideRight
                            anchors.left: parent.left
                            font.pixelSize: tabBtn.checked ? 18 * dpi : 16 * dpi
                            color: tabBtn.checked ? "white" : "#A4A6AB"
                            font.bold: tabBtn.checked
                            verticalAlignment: Text.AlignVCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                parent.checked = true
                                //hotGameTabIndex = index
                                showSearchResult = false
                                tabBtn.forceActiveFocus()
                                HomeHotGamesTabModel.selectIndex(index)
                            }
                        }
                    }
                }
            }

            Rectangle {
                id:hotGamesStackLayout
                color: "transparent"
                width: 980 * dpi
                height: 266 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectTabBtns.bottom
                anchors.topMargin: 15 * dpi

                Loading {
                    anchors.centerIn: parent
                    visible: HomeHotGamesTabModel.showLoading
                }

                GridView {
                    model: HomeHotGamesModel
                    anchors.fill: parent
                    cellWidth: hotGamesStackLayout.width / 4
                    cellHeight: 136 * dpi
                    clip: true
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    boundsBehavior: Flickable.StopAtBounds
                    visible: !HomeHotGamesTabModel.showLoading
                    delegate: Rectangle {
                        width: hotGamesStackLayout.width / 4
                        height: 136 * dpi
                        color: "transparent"

                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 225 * dpi
                            height: 126 * dpi
                            color: "transparent"

                            Image {
                                id:itemImage
                                source: hotGameMainImage
                                anchors.fill: parent
                            }

                            Loading {
                                anchors.centerIn: parent
                                visible: itemImage.status != Image.Ready
                            }

                            Rectangle {
                                width: parent.width
                                height: 35 * dpi
                                color: "#C81E222E"
                                anchors.bottom: parent.bottom
                                Text {
                                    id:textGameName1
                                    text:hotGameName
                                    width: parent.width
                                    elide: Text.ElideRight
                                    font.pixelSize: 14 * dpi
                                    color: "#A4A6AB"
                                    anchors.centerIn: parent
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    selIndex = 6
                                    showSearchInput = false
                                    showSearchResult = false
                                    showBackButton = true
                                    hotGamesStackLayout.forceActiveFocus()
                                    GameDetails.getGameDetailsInfo(hotGameId, hotGameGoodsId)
                                }

                                onEntered: {
                                    textGameName1.color = "white"
                                }

                                onExited: {
                                    textGameName1.color = "#A4A6AB"
                                }
                            }
                        }
                    }
                }
            }

            TabBar {
                id:tabBar
                width: 960 * dpi
                height: 30 * dpi
                anchors.top: hotGamesStackLayout.bottom
                anchors.topMargin: 20 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    color: "transparent"
                }

                ButtonGroup {
                    id:btnGroupExc
                    exclusive: true
                }

                Repeater {
                    model: HomeGoodsTabModel
                    delegate: TabButton {
                        id:tabBtns
                        width: 100 * dpi
                        height: 30 * dpi
                        checkable: true
                        checked: index === 0
                        anchors.verticalCenter: parent.verticalCenter
                        ButtonGroup.group: btnGroupExc
                        background: Rectangle {
                            color: "transparent"
                        }

                        contentItem: Text {
                            text:goodsTabTitle
                            width: parent.width
                            elide: Text.ElideRight
                            anchors.left: parent.left
                            font.pixelSize: tabBtns.checked ? 18 * dpi : 16 * dpi
                            color: tabBtns.checked ? "#12C195" : "#A4A6AB"
                            font.bold: tabBtns.checked
                            verticalAlignment: Text.AlignVCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                parent.checked = true
                                goodsTabIndex = index
                                showSearchResult = false
                                tabBar.forceActiveFocus()
                                HomeGoodsTabModel.selectIndex(index)
                            }
                        }
                    }
                }
            }


            Rectangle {
                id:stackLayoutGoods
                visible: false
                width: 980 * dpi
                height: 490 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: tabBar.bottom
                anchors.topMargin: 15 * dpi
                color: "transparent"

                Loading {
                    anchors.centerIn: parent
                    visible: HomeGoodsModel.showLoading
                }

                GridView {
                    anchors.fill: parent
                    model:HomeGoodsModel
                    clip: true
                    cellWidth:stackLayoutGoods.width / 4
                    cellHeight: 200 * dpi
                    boundsBehavior: Flickable.StopAtBounds
                    visible: !HomeGoodsModel.showLoading
                    delegate: Rectangle {
                        width:stackLayoutGoods.width / 4
                        height: 200 * dpi
                        color: "transparent"
                        Rectangle {
                            width: 225 * dpi
                            height: 156 * dpi
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "transparent"

                            Column {
                                anchors.centerIn: parent
                                Rectangle {
                                    width: 225 * dpi
                                    height: 126 * dpi
                                    color: "transparent"
                                    Image {
                                        id:imageIcon
                                        source: goodsMainImage
                                        anchors.fill: parent
                                    }

                                    Loading {
                                        anchors.centerIn: parent
                                        visible: imageIcon.status != Image.Ready
                                    }
                                }

                                Rectangle {
                                    width: 225 * dpi
                                    height: 35 * dpi
                                    color: "transparent"

                                    Text {
                                        text:goodsName
                                        width: 160 *dpi
                                        elide: Text.ElideRight
                                        font.pixelSize: 14 * dpi
                                        color: "white"
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Text {
                                        text:"￥" + goodsPrice
                                        width: 100 * dpi
                                        font.pixelSize: 24 * dpi
                                        elide: Text.ElideRight
                                        horizontalAlignment: Text.AlignRight
                                        color: "#12C195"
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape:Qt.PointingHandCursor
                                onClicked: {
                                    selIndex = 6
                                    showSearchInput = false
                                    showSearchResult = false
                                    showBackButton = true
                                    stackLayoutGoods.forceActiveFocus()
                                    GameDetails.getGameDetailsInfo(goodsId, itemGoodsId)
                                }
                            }
                        }
                    }
                }
            }

        }

    }

}
