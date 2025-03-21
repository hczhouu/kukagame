import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import GameDetails 1.0
import GameSkuModel 1.0
import GameDetailsImageModel 1.0

//游戏详情页
Item {
    property int itemWidth: 960 * dpi
    property bool showLoading: true
    Connections {
        target: GameDetails
        onGetGameDetailsSuccess:{
            showLoading = false
        }
    }

    Loading {
        anchors.centerIn: parent
        visible: showLoading
    }

    Rectangle {
        id:rectTopBanner
        visible: !showLoading
        width: itemWidth
        height: 280 * dpi
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        Rectangle {
            width: 470 * dpi
            height: 265 * dpi
            color: "transparent"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            Image {
                id:imgLeft
                source: GameDetails.imageLeft
                anchors.fill: parent
            }

            Loading {
                visible: imgLeft.status != Image.Ready
                anchors.centerIn: parent
                color: "#9A9D9C"
            }
        }

        Rectangle {
            width: 470 * dpi
            height: 265 * dpi
            color: "transparent"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            Image {
                id:imgRight
                source: GameDetails.imageRight
                anchors.fill: parent
            }

            Loading {
                visible: imgRight.status != Image.Ready
                anchors.centerIn: parent
                color: "#9A9D9C"
            }
        }
    }


    Rectangle {
        id:rectTitle
        visible: !showLoading
        width: itemWidth
        height: 30 * dpi
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: rectTopBanner.bottom
        anchors.topMargin: 20 * dpi
        Text {
            text:"游戏详情"
            font.pixelSize: 18 * dpi
            font.bold: true
            color: "white"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Rectangle {
        visible: !showLoading
        width: itemWidth
        height: 1
        color: "#222733"
        anchors.top: rectTitle.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        visible: !showLoading
        width: itemWidth
        height: 300 * dpi
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: rectTitle.bottom
        anchors.topMargin: 10 * dpi
        ScrollView {
            anchors.fill: parent
            TextArea {
                text:GameDetails.gameDesc
                font.pixelSize: 15 * dpi
                wrapMode: Text.WordWrap
                color: "#A4A6AB"
                readOnly: true
            }
        }
    }

    Row {
        visible: !showLoading
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30 * dpi
        spacing: 40 * dpi

        //立即购买
        Button {
            width: 200 * dpi
            height: 58 * dpi
            visible: GameDetails.itemIsGoods
            background: Rectangle {
                color: "#1ECE9C"
                radius: 10

                Text {
                    text:"立即购买"
                    font.pixelSize: 24 * dpi
                    font.bold: true
                    color: "white"
                    anchors.centerIn: parent
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape:Qt.PointingHandCursor
                onClicked:  {
                    showSearchResult = false
                    parent.forceActiveFocus()
                    if (userLogined)
                    {
                        selIndex = 8
                        GameDetails.getGameSkuInfo(GameSkuModel)
                    } else {
                        showPopup('LoginPopup.qml')
                    }
                }
            }
        }

        //启动游戏
        Button {
            width: 200 * dpi
            height: 58 * dpi
            visible: textCaption.text !== '暂不支持'
            background: Rectangle {
                color: "transparent"
                radius: 10
                border.width: 1
                border.color: "#1ECE9C"

                Text {
                    id:textCaption
                    text: {
                        if (GameDetails.enablePlay)
                        {
                            if (GameDetails.enableStart)
                            {
                                return "立即启动"
                            }

                            return "暂不支持"
                        }

                        return GameDetails.appointmentStatus
                    }

                    font.pixelSize: 24 * dpi
                    font.bold: true
                    color: "#1ECE9C"
                    anchors.centerIn: parent
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape:Qt.PointingHandCursor
                onClicked:  {
                    showSearchResult = false
                    parent.forceActiveFocus()
                    if (!userLogined)
                    {
                        showPopup('LoginPopup.qml')
                        return
                    }

                    if (GameDetails.enablePlay)
                    {
                        if (!HttpClient.startGameNoTips)
                        {
                            showPopup('StartGamePopup.qml')
                        } else {
                            GameDetails.queryUserRemainTime()
                        }

                        return
                    }

                    GameDetails.appointmentGame()
                }
            }
        }
    }
}
