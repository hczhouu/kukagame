import QtQuick 2.5
import QtQuick.Window 2.5
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import HomePage 1.0
import SigninModel 1.0

Popup {
    id:signinPopup
    width:710 * dpi
    height:690 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent
    onOpened: {
        if (SigninModel.rowCount() === 0)
        {
            HomePage.getSigninList(SigninModel)
        }
    }

    onClosed:{
        signinPopup.destroy()
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
                            signinPopup.close()
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
                    text: "签到记录"
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
                    GridView {
                        visible: HomePage.signDataIsReady
                        anchors.fill: parent
                        model:SigninModel
                        cellWidth: 155 * dpi
                        cellHeight : 170 * dpi
                        delegate: Rectangle {
                            width: 140 * dpi
                            height: 160* dpi
                            color: "transparent"
                            Image {
                                source: "../res/v2/day_bk.png"
                                anchors.fill: parent
                            }

                            Text {
                                text:"-第" + signinDays +"天-"
                                font.pixelSize: 14 * dpi
                                color: isSignin ? "#8A8B8B" : "#131A25"
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.top
                                anchors.topMargin: 17 * dpi
                            }

                            Image {
                                source: isSignin ? "../res/v2/icon_sign_01.png" : "../res/v2/icon_sign.png"
                                fillMode: Image.PreserveAspectFit
                                scale: dpi
                                anchors.centerIn: parent
                            }


                            Rectangle {
                                width: 135 * dpi
                                height: 30 * dpi
                                color: "transparent"
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 2 * dpi
                                anchors.horizontalCenter: parent.horizontalCenter
                                Image {
                                    source: isSignin ? "../res/v2/day_bk_sign_01.png" :
                                                       "../res/v2/day_bk_sign.png"
                                    anchors.fill: parent
                                }

                                Text {
                                    text:isSignin ? "已签到" : signinPrize.toString() +  "min体验时长"
                                    font.bold: true
                                    color: isSignin ? "#8A8B8B" : "#131A25"
                                    anchors.centerIn: parent
                                    font.pixelSize: 12 * dpi
                                }
                            }
                        }
                    }
                }

                Text {
                    id:textDesc
                    text:SigninModel.remarkData
                    font.pixelSize: 13 * dpi
                    color: "black"
                    anchors.top: rectGridview.bottom
                    anchors.topMargin: 10 * dpi
                    anchors.left: parent.left
                    anchors.leftMargin: 60 * dpi
                }

                Text {
                    id:textReward
                    text:"我的奖励>>"
                    font.pixelSize: 13 * dpi
                    color: "#12C195"
                    anchors.top: rectGridview.bottom
                    anchors.topMargin: 10 * dpi
                    anchors.right: parent.right
                    anchors.rightMargin: 35 * dpi
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            signinPopup.close()
                            showPopup("SignRewardPopup.qml")
                        }

                        onEntered: {
                            parent.font.underline = true
                        }

                        onExited: {
                            parent.font.underline = false
                        }
                    }
                }

            }
        }


        Rectangle {
            id:rectSign
            width: 200 * dpi
            height: 60 * dpi
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                anchors.fill: parent
                enabled: HomePage.enableSign === '立即签到'
                visible: HomePage.enableSign !== ''
                background: Rectangle {
                    color: "#1ECE9A"
                    radius: 10
                }

                Text {
                    text: HomePage.enableSign
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
                        HomePage.postSignin()
                    }
                }
            }
        }
    }
}
