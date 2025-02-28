import QtQuick 2.5
import QtQuick.Window 2.5
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import HomePage 1.0
import SignRewardModel 1.0

Popup {
    id:signRewardPopup
    width:710 * dpi
    height:690 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    onOpened: {
        //加载签到数据
        HomePage.getSignReward(SignRewardModel)
    }

    onClosed: {
        signRewardPopup.destroy()
    }

    background: Rectangle {
        color: "transparent"
    }

    Column {
        spacing: 10 * dpi
        anchors.centerIn: parent
        Rectangle {
            width: 710 * dpi
            height: 648 * dpi
            color: "transparent"

            Image {
                source: "../res/v2/sign_bk.png"
                anchors.fill: parent
            }

            Image {
                source: "../res/v2/sign_close.png"
                fillMode: Image.PreserveAspectFit
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 50
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        signRewardPopup.close()
                    }
                }
            }

            Loading {
                anchors.centerIn: parent
                color: "black"
                visible: !HomePage.signDataIsReady
            }

            Text {
                id:textCaption
                text:"每日签到奖励"
                font.pixelSize: 26 *dpi
                font.bold: true
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 82 * dpi
                anchors.top: parent.top
                anchors.topMargin: 92 * dpi
            }

            Rectangle {
                id:rectGridview
                width: 620 * dpi
                height: 340 * dpi
                anchors.left: parent.left
                anchors.leftMargin: 61 * dpi
                anchors.top: parent.top
                anchors.topMargin: 230 * dpi
                color: "transparent"

                Loading {
                    anchors.centerIn: parent
                    visible: !HomePage.signRewardIsReady
                }

                GridView {
                    visible: HomePage.signRewardIsReady
                    anchors.fill: parent
                    model:SignRewardModel
                    clip: true
                    cellWidth: 155 * dpi
                    cellHeight : 130 * dpi
                    delegate: Rectangle {
                        width: 140 * dpi
                        height: 120* dpi
                        color: "#DFFAF8"

                        Rectangle {
                            width: 135 * dpi
                            height: 30 * dpi
                            color: "transparent"
                            anchors.top: parent.top
                            anchors.topMargin: 2 * dpi
                            anchors.horizontalCenter: parent.horizontalCenter
                            Image {
                                source:"../res/v2/sign_reward_bk.png"
                                anchors.fill: parent
                            }

                            Text {
                                text:"签到奖励"
                                font.bold: true
                                color:"#12C195"
                                anchors.centerIn: parent
                                font.pixelSize: 12 * dpi
                            }
                        }

                        Text {
                            text:rewardTime
                            font.pixelSize: 14 * dpi
                            color:"#131A25"
                            font.bold: true
                            anchors.centerIn: parent
                        }

                        Text {
                            text:signDays
                            color:"#A8A8A8"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 30 * dpi
                            font.pixelSize: 10 * dpi
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }

            Row {
                anchors.top: rectGridview.bottom
                anchors.topMargin: 10 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:"已累计签到 "
                    font.pixelSize: 14 * dpi
                    font.bold: true
                    color: "#131A25"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text:SignRewardModel.totalDays
                    font.pixelSize: 14 * dpi
                    font.bold: true
                    color: "#FF8400"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text:" 天总计获得 "
                    font.pixelSize: 14 * dpi
                    font.bold: true
                    color: "#131A25"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text:SignRewardModel.totalTime
                    font.pixelSize: 14 * dpi
                    font.bold: true
                    color: "#FF8400"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text:" 时长"
                    font.pixelSize: 14 * dpi
                    font.bold: true
                    color: "#131A25"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Rectangle {
            id:backSign
            width: 200 * dpi
            height: 60 * dpi
            color: "#1ECE9A"
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                text:"返回签到"
                font.pixelSize: 18 * dpi
                color: "white"
                anchors.centerIn: parent
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    signRewardPopup.close()
                    showPopup("SigninPopup.qml");
                }
            }
        }
    }
}
