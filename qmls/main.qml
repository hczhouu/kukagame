import QtQuick 2.5
import QtQuick.Window 2.3
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
//import FtpClient 1.0
import Qt.labs.platform 1.1
import SearchResultModel 1.0
import GameDetails 1.0


Window {
    id:mainWindow
    width: 1280 * dpi
    height: 800 * dpi
    minimumWidth: 1280 * dpi
    minimumHeight: 800 * dpi
    visible: true
    title: qsTr("酷卡云游戏")
    x:Qt.application.screens[0].
      desktopAvailableWidth / 2 - width / 2
    y:Qt.application.screens[0].
      desktopAvailableHeight / 2 - height / 2
    flags: Qt.Window | Qt.FramelessWindowHint | Qt.MSWindowsFixedSizeDialogHint
    property int selectIndex: 0
    property int lastSelIndex: 0
    property bool isAllGamesPageEntry: false
    property bool showSearchInput: true
    property var dpi: HttpClient.dpi
    property var screenWidth: HttpClient.screenWidth
    property var screenHeight: HttpClient.screenHeight
    color: "transparent"

    property int selIndex: 0
    property bool showSearchResult: false
    property bool showBackButton: false
    property bool userLogined: HttpClient.userLogined
    //property bool userLogined: true

    //错误信息弹窗
    function showErrorMsgPopup(msgType, msgData)
    {
        messagePop.showMessage(msgType, msgData)
    }

    //弹窗
    function showPopup(popName)
    {
        var component = Qt.createComponent(popName);
        var dynamicObject = component.createObject(mainWindow);
        dynamicObject.open()
    }

    Connections{
        target: HttpClient
        onShowMsgPopup: {
            messagePop.showMessage(msgType, msgData)
        }

        //关闭支付页面弹窗
        onClosePayPopup: {
            payPop.close()
        }


        //强制更新弹窗
        onShowForceUpdate: {
            showPopup('ForceUpdatePopup.qml')
        }

        //公告消息弹窗
        onShowNoticeMessage: {
            noticeMessagePop.noticeId = noticeId
            noticeMessagePop.open()
        }
    }

//    Connections{
//        target: FtpClient
//        onShowMsgPopup: {
//            messagePop.showMessage(msgType, msgData)
//        }
//    }

    Connections {
        target: SearchResultModel
        onShowSearchResult: {
            showSearchResult = true
        }
    }

    // 支持窗体拖拽
    MouseArea {
        anchors.fill:parent
        property point clickPos:"0,0"
        onPressed: {
            clickPos = Qt.point(mouse.x,mouse.y)
        }

        onPositionChanged: {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            mainWindow.setX(mainWindow.x + delta.x)
            mainWindow.setY(mainWindow.y + delta.y)
        }

        onClicked: {
            showSearchResult = false
        }
     }

    GamePaySuccessPopup {
        id:gamePaySuccPop
    }


    //关闭提示
    ExitAppTips{
        id:exitAppPop
    }

    //主窗口布局  左侧区域
    LeftRectPage {
        id:rectLeft
        width: 260 * dpi
        height: parent.height
        color: "#1D222E"
        anchors.left: parent.left
        anchors.top: parent.top
    }

    //右侧区域
    Rectangle {
        width: mainWindow.width - rectLeft.width
        height: mainWindow.height
        color: "#131A25"
        anchors.right: parent.right
        anchors.top: parent.top
        //标题栏
        TitleBar {
            id:rectTitle
            width: 960 * dpi
            height: 60 * dpi
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        //内容页
        Rectangle {
            width: parent.width
            height: parent.height - rectTitle.height
            color: "transparent"
            anchors.top: rectTitle.bottom
            anchors.left: parent.left
            StackLayout {
                anchors.fill: parent
                currentIndex: selIndex

                //首页
                HomePage {

                }

                //游戏商店
                // GameShopPage {

                // }

                //所有游戏
                AllGamesPage {

                }

                //个人中心
                UserCenterPage {

                }

                //我的云盘
//                CloudDiskPage {

//                }

                //消息中心
                MsgCenterPage {

                }

                //充值中心
//                RechargeCenterPage {

//                }

                //游戏详情页面
                GameDetailsPage {

                }

                //游戏SKU页面
                GameSkuDetailsPage {

                }
            }
        }

        //搜索结果
        Rectangle {
            visible: showSearchResult
            width: 740 * dpi
            height: 220 * dpi
            color: "#232733"
            radius: 10
            border.width: 1
            border.color: "#2C303C"
            anchors.left: rectTitle.left
            anchors.top: rectTitle.bottom

            Text {
                id:textResult
                text:"搜索结果"
                font.pixelSize: 10 * dpi
                color: "white"
                anchors.left: parent.left
                anchors.leftMargin: 20 * dpi
                anchors.topMargin: 10 * dpi
                anchors.top: parent.top
                visible: !SearchResultModel.noResult
            }


            Text {
                text:"暂无结果"
                anchors.centerIn: parent
                font.pixelSize: 14 * dpi
                color: "#A4A6AB"
                visible: SearchResultModel.noResult
            }

            GridView {
                visible: !SearchResultModel.noResult
                width: 720 * dpi
                height: 180 * dpi
                model: SearchResultModel
                cellWidth: 215 * dpi
                cellHeight: 135 * dpi
                clip: true
                anchors.left: parent.left
                anchors.leftMargin: 20 * dpi
                anchors.topMargin: 5 * dpi
                anchors.top: textResult.bottom
                delegate: Rectangle {
                    width: 205 * dpi
                    height: 125 * dpi
                    color: "transparent"
                    Image {
                        id:imageIcon
                        source: itemGameIcon
                        anchors.fill: parent
                    }

                    Loading {
                        anchors.centerIn: parent
                        visible: imageIcon.status !== Image.Ready
                    }

                    Rectangle {
                        width: 205 * dpi
                        height: 35 * dpi
                        color: "#C81E222E"
                        anchors.bottom: parent.bottom
                        Text {
                            text:itemGameName
                            font.pixelSize: 14 * dpi
                            color: "white"
                            anchors.centerIn: parent
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked:  {
                            selIndex = 4
                            showSearchInput = false
                            showSearchResult = false
                            showBackButton = true
                            GameDetails.getGameDetailsInfo(itemGameId, itemGoodsId)
                        }
                    }
                }

            }

        }
    }

    //修改密码弹窗
    ModifyPassPopup {
        id:modifyPassPopup
    }

    //支付页面弹窗
    PayPopup {
        id:payPop
    }

    //消息提示弹窗
    MessagePopup {
        id:messagePop
    }

    //游戏商品支付弹窗
    GamePayPopup {
        id:gamePayPopup
    }

    //游戏商品订单弹窗
    GameOrderPopup {
        id:gameOrderPopup
    }

    //系统托盘
   SystemTrayIcon {
        visible: true
        tooltip: "酷卡云游戏"
        icon.source: "../res/newVersion/main.ico"
        menu:Menu {
             MenuItem {
                 text: qsTr("主界面")
                 onTriggered: {
                     mainWindow.requestActivate();
                     mainWindow.show();
                 }
             }

             MenuItem {
                 text: qsTr("退出")
                 onTriggered: Qt.quit()
             }
        }
        onActivated: {
            if (reason === SystemTrayIcon.Context)
            {
                menu.open()
            } else if(reason === SystemTrayIcon.DoubleClick) {
                mainWindow.requestActivate()
                mainWindow.show()
            }
        }
   }
}
