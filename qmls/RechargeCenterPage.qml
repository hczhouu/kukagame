import QtQuick 2.6
import QtQuick.Window 2.6
import QtQuick.Controls 2.6
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

//import GoodsListModel 1.0
import PeriodListModel 1.0
import TimeCardListModel 1.0

//充值中心页面
Item {
    property bool payTimeCard: true

    MouseArea {
        anchors.fill: parent
        onClicked: {
            showSearchResult = false
            parent.forceActiveFocus()
        }
    }

    Rectangle {
        id:rectTime
        width: parent.width
        height: 158 * dpi
        color: "transparent"
        anchors.top: parent.top
        Rectangle {
            width: 960 * dpi
            height: parent.height
            color: "#1D222E"
            anchors.centerIn: parent
            radius: 10

            Text {
                id:textType
                anchors.left: parent.left
                anchors.leftMargin: 25 * dpi
                anchors.top: parent.top
                anchors.topMargin: 25 * dpi
                text:payTimeCard ? "剩余尊享时长" : "剩余体验时长"
                font.pixelSize: 16 * dpi
                color: "white"
            }

            Text {
                anchors.left: textType.right
                anchors.leftMargin: 10 * dpi
                text:payTimeCard ? HttpClient.remainPayTime : HttpClient.remainFreeTime
                font.pixelSize: 16 * dpi
                anchors.verticalCenter: textType.verticalCenter
                color: "#A4A6AB"
            }



            ButtonGroup {
                id:btnGroup
                exclusive: true
            }

            Button {
                id:btnTime
                width: 90 * dpi
                height: 40 * dpi
                anchors.right: btnFreeTime.left
                anchors.verticalCenter:textType.verticalCenter
                checkable: true
                checked: true
                ButtonGroup.group: btnGroup
                background: Rectangle {
                    color: "transparent"
                    Image {
                        source:btnTime.checked ? "../res/v2/left_sel.png" :
                                                 "../res/v2/left_unsel.png"
                        anchors.fill: parent
                    }
                }

                Text {
                    text:"尊享时长"
                    font.pixelSize: 16 * dpi
                    anchors.centerIn: parent
                    color: btnTime.checked ? "white" : "#A4A6AB"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape:Qt.PointingHandCursor
                    onClicked: {
                        payTimeCard = true
                        btnTime.checked = true
                        showSearchResult = false
                        parent.forceActiveFocus()
                    }
                }
            }

            Button {
                id:btnFreeTime
                width: 90 * dpi
                height: 40 * dpi
                anchors.right: parent.right
                anchors.rightMargin: 25 * dpi
                anchors.verticalCenter:textType.verticalCenter
                checkable: true
                checked: false
                ButtonGroup.group: btnGroup
                background: Rectangle {
                    color: "transparent"
                    Image {
                        source:btnFreeTime.checked ? "../res/v2/right_sel.png" :
                                                 "../res/v2/right_unsel.png"
                        anchors.fill: parent
                    }
                }

                Text {
                    text:"体验时长"
                    font.pixelSize: 16 * dpi
                    anchors.centerIn: parent
                    color: btnFreeTime.checked ? " white" : "#A4A6AB"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape:Qt.PointingHandCursor
                    onClicked: {
                        payTimeCard = false
                        btnFreeTime.checked = true
                        showSearchResult = false
                        parent.forceActiveFocus()
                    }
                }
            }


            //时长
            Rectangle {
                width: 230 * dpi
                height: 70 * dpi
                color: "#222733"
                anchors.left: parent.left
                anchors.leftMargin: 23 * dpi
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 25 * dpi
                radius: 10
                border.width: 1
                border.color: "#2B303C"

                Rectangle {
                    width: parent.width / 2
                    height: parent.height
                    color: "transparent"
                    anchors.left: parent.left

                    Image {
                        source: "../res/v2/time_card.png"
                        fillMode: Image.PreserveAspectFit
                        scale: dpi
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 20 * dpi
                    }
                }

                Rectangle {
                    width: parent.width / 2
                    height: parent.height
                    color: "transparent"
                    anchors.right: parent.right

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        width: parent.width
                        Text {
                            text:"时长"
                            font.pixelSize: 16 * dpi
                            color: "white"
                        }

                        Text {
                            text:payTimeCard ? HttpClient.timecardDuration : HttpClient.freeTimecardDuration
                            font.pixelSize: 16 * dpi
                            color: "#A4A6AB"
                            width: parent.width
                            elide: Text.ElideRight
                        }
                    }
                }
            }

            //会员时长
            Rectangle {
                width: 230 * dpi
                height: 70 * dpi
                color: "#222733"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 23 * dpi
                radius: 10
                border.width: 1
                border.color: "#2B303C"

                Rectangle {
                    width: parent.width / 2
                    height: parent.height
                    color: "transparent"
                    anchors.left: parent.left

                    Image {
                        source: "../res/v2/weeks_card.png"
                        fillMode: Image.PreserveAspectFit
                        scale: dpi
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 20 * dpi
                    }
                }

                Rectangle {
                    width: parent.width / 2
                    height: parent.height
                    color: "transparent"
                    anchors.right: parent.right

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        width: parent.width
                        Text {
                            text:"会员时长"
                            font.pixelSize: 16 * dpi
                            color: "white"
                        }

                        Text {
                            text:payTimeCard ? HttpClient.timecardPeriod : HttpClient.freeTimecardPeriod
                            font.pixelSize: 16 * dpi
                            color: "#A4A6AB"
                            width: parent.width
                            elide: Text.ElideRight
                        }
                    }
                }

            }

            //时段卡
            // Rectangle {
            //     width: 230 * dpi
            //     height: 70 * dpi
            //     color: "#222733"
            //     anchors.right: parent.right
            //     anchors.rightMargin: 25 * dpi
            //     anchors.bottom: parent.bottom
            //     anchors.bottomMargin: 23 * dpi
            //     radius: 10
            //     border.width: 1
            //     border.color: "#2B303C"

            //     Rectangle {
            //         width: parent.width / 2
            //         height: parent.height
            //         color: "transparent"
            //         anchors.left: parent.left

            //         Image {
            //             source: "../res/v2/duration_card.png"
            //             fillMode: Image.PreserveAspectFit
            //             scale: dpi
            //             anchors.verticalCenter: parent.verticalCenter
            //             anchors.right: parent.right
            //             anchors.rightMargin: 20 * dpi
            //         }
            //     }

            //     Rectangle {
            //         width: parent.width / 2
            //         height: parent.height
            //         color: "transparent"
            //         anchors.right: parent.right

            //         Column {
            //             anchors.verticalCenter: parent.verticalCenter
            //             width: parent.width
            //             anchors.left: parent.left
            //             Text {
            //                 text:"时段卡"
            //                 font.pixelSize: 16 * dpi
            //                 color: "white"
            //             }

            //             Text {
            //                 text:payTimeCard ? HttpClient.timecardFree : HttpClient.freeTimecardFree
            //                 font.pixelSize: 16 * dpi
            //                 color: "#A4A6AB"
            //                 width: parent.width
            //                 elide: Text.ElideRight
            //             }
            //         }
            //     }
            // }

        }
    }


    Rectangle {
        id:rectTab
        width: parent.width
        height: 30 * dpi
        color: "transparent"
        anchors.top: rectTime.bottom
        anchors.topMargin: 20 * dpi
        Rectangle {
            width: 960 * dpi
            height: parent.height
            color: "transparent"
            anchors.centerIn: parent

            TabBar {
                id:tabTitle
                width: parent.width
                anchors.left: parent.left
                anchors.top: parent.top
                background: Rectangle {
                    color: "transparent"
                }

                Repeater {
                    model:["时长","会员"]
                    delegate: TabButton {
                        id:tabbtnTime
                        width: 70 * dpi
                        background: Rectangle {
                            color: "transparent"

                            Rectangle {
                                visible: tabbtnTime.checked
                                width: caption.contentWidth
                                height: 2
                                color: "#1ECE99"
                                anchors.bottom: parent.bottom
                            }
                        }

                        contentItem: Text {
                            id:caption
                            text:modelData
                            anchors.fill: parent
                            font.pixelSize: 16 * dpi
                            font.bold: true
                            color: tabbtnTime.checked ? "#1ECE99" : "#818D9D"
                            verticalAlignment: Text.AlignVCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
//                                tabbtnTime.checked = true
//                                showSearchResult = false
//                                parent.forceActiveFocus()
//                                if (index === 0)
//                                {
//                                    HttpClient.getGoodsList(1001)
//                                } else if(index === 1) {
//                                    HttpClient.getGoodsList(1002)
//                                }
                            }
                        }

                    }
                }
            }
        }
    }


    Rectangle {
        width: parent.width
        height: 510 * dpi
        color: "transparent"
        anchors.top: rectTab.bottom
        anchors.topMargin: 10 * dpi
        Rectangle {
            id:rectTimeCard
            width:  parent.width * 0.99
            height: parent.height
            color: "transparent"
            anchors.centerIn: parent
            radius: 10

            StackLayout {
                id:timecardStackLayout
                anchors.fill: parent
                currentIndex: tabTitle.currentIndex

                //时长
                Item {
//                    Loading {
//                        anchors.centerIn: parent
//                        visible: !GoodsListModel.isDataReady
//                    }

//                    GridView {
//                        anchors.fill: parent
//                        model: GoodsListModel
//                        clip: true
//                        cellWidth: parent.width / 3
//                        cellHeight: 214 * dpi
//                        boundsBehavior: Flickable.StopAtBounds
//                        delegate: Rectangle {
//                            width: timecardStackLayout.width / 3
//                            height: 214 * dpi
//                            color: "transparent"
//                            PackageItem {
//                                anchors.horizontalCenter: parent.horizontalCenter
//                                goods_id: goodsId
//                                goods_name: goodsName
//                                pay_Amount: payAmount
//                                order_Amount: orderAmount
//                                original_Price: originalPrice
//                                limit_Time: timeLimit
//                                total_Time: totalTime
//                                meal_Type: mealType
//                                showLabel: goodsLabel !== ''
//                                label_tips: goodsLabel
//                                goods_desc: goodsDesc
//                                remark: goodsRemark
//                            }

//                        }
//                    }

                }


                //会员
                Item {
                    Loading {
                        anchors.centerIn: parent
                        visible: !PeriodListModel.isDataReady
                    }

                    GridView {
                        anchors.fill: parent
                        model: PeriodListModel
                        clip: true
                        cellWidth: 390 * dpi
                        cellHeight: 240 * dpi
                        boundsBehavior: Flickable.StopAtBounds
                        anchors.leftMargin: 22 * dpi
                        delegate: Rectangle {
                            width: 320 * dpi
                            height: 240 * dpi
                            color: "transparent"
                            VipPackageItem {
                                anchors.horizontalCenter: parent.horizontalCenter
                                goods_id: goodsId
                                goods_name: goodsName
                                pay_Amount: payAmount
                                order_Amount: orderAmount
                                original_Price: originalPrice
                                limit_Time: timeLimit
                                total_Time: totalTime
                                meal_Type: mealType
                                showLabel: goodsLabel !== ''
                                label_tips: goodsLabel
                                goods_desc: goodsDesc
                                remark: goodsRemark
                                bkImage:goodsBkimage
                                fontColor:goodsFontColor
                            }

                        }
                    }

                }


                // Repeater {
                //     visible: GoodsListModel.isDataReady
                //     model: [GoodsListModel, PeriodListModel, TimeCardListModel]
                //     delegate: Item {

                //         Loading {
                //             anchors.centerIn: parent
                //             visible: !modelData.isDataReady
                //         }

                //         GridView {
                //             anchors.fill: parent
                //             model: modelData
                //             clip: true
                //             cellWidth: parent.width / 3
                //             cellHeight: 214 * dpi
                //             boundsBehavior: Flickable.StopAtBounds
                //             delegate: Rectangle {
                //                 width: timecardStackLayout.width / 3
                //                 height: 214 * dpi
                //                 color: "transparent"
                //                 PackageItem {
                //                     anchors.horizontalCenter: parent.horizontalCenter
                //                     goods_id: goodsId
                //                     goods_name: goodsName
                //                     pay_Amount: payAmount
                //                     order_Amount: orderAmount
                //                     original_Price: originalPrice
                //                     limit_Time: timeLimit
                //                     total_Time: totalTime
                //                     meal_Type: mealType
                //                     showLabel: goodsLabel !== ''
                //                     label_tips: goodsLabel
                //                     goods_desc: goodsDesc
                //                     remark: goodsRemark
                //                 }

                //             }
                //         }
                //     }
                // }
            }
        }
    }
}
