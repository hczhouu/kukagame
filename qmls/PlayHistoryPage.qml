import QtQuick 2.6
import QtQuick.Window 2.6
import QtQuick.Controls 2.6
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15


//历史游玩页面
Item {
    Column {
        spacing: 20 * dpi
        anchors.fill: parent
        Rectangle {
            width: parent.width
            height: 120 * dpi
            color: "transparent"

            Rectangle {
                width: 960 * dpi
                height: parent.height
                color: "#1D222E"
                anchors.centerIn: parent
                radius: 10

                //头像
                Rectangle {
                    id:rectHeadLogo
                    width: 70 * dpi
                    height:70 * dpi
                    color: "transparent"
                    anchors.left: parent.left
                    anchors.leftMargin: 15 *dpi
                    anchors.verticalCenter: parent.verticalCenter
                    Rectangle {
                        id:rectHead
                        width:70 * dpi
                        height:70 * dpi
                        color: "transparent"
                        border.color: "#82999F"
                        radius: 100
                        anchors.centerIn: parent
                        MouseArea {
                            id: imageRect
                            width: 70 * dpi
                            height: 70 * dpi
                            anchors.centerIn: parent
                            //头像
                            Image {
                                id: nameIamge
                                anchors.fill: parent
                                scale: dpi
                                source: "../res/v2/head.png"
                                visible: false
                                cache: false
                                asynchronous: true
                            }

                            Rectangle{
                                id: mask
                                anchors.fill: parent
                                radius: 100
                                visible: false
                            }

                            OpacityMask {
                                anchors.fill: parent
                                source: nameIamge
                                maskSource: mask
                            }
                        }
                    }
                }


                //昵称
                Rectangle {
                    width: 110 * dpi
                    height: 70 * dpi
                    color: "transparent"
                    anchors.left: rectHeadLogo.right
                    anchors.leftMargin: 10 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    Column {
                        anchors.centerIn: parent
                        spacing: 5 * dpi
                        Text {
                            width: parent.parent.width
                            text: HttpClient.nickName
                            visible: HttpClient.nickName !== ''
                            font.pixelSize: 14 *dpi
                            color: "white"
                            elide: Text.ElideMiddle
                        }

                        Text {
                            width: parent.parent.width
                            text: HttpClient.userAccount
                            font.pixelSize: 12 *dpi
                            color: "#A4A6AB"
                        }
                    }
                }


                Rectangle {
                    width: 210 * dpi
                    height: 70 * dpi
                    color: "#222733"
                    radius: 10
                    border.width: 1
                    border.color: "#2B303C"
                    anchors.right: rectPlayCount.left
                    anchors.rightMargin: 37 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        id:iconUsed
                        source: "../res/v2/used_history.png"
                        fillMode: Image.PreserveAspectFit
                        scale: dpi
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 25 * dpi
                    }

                    Rectangle {
                        width: 120 * dpi
                        height: parent.height
                        color: "transparent"
                        anchors.left: iconUsed.right
                        anchors.leftMargin: 30 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        Column {
                            anchors.centerIn: parent
                            Text {
                                width: parent.parent.width
                                text:"历史游玩"
                                font.pixelSize: 13 * dpi
                                elide: Text.ElideRight
                                color: "white"
                            }

                            Text {
                                width: parent.parent.width
                                text:"20款应用"
                                font.pixelSize: 10 * dpi
                                elide: Text.ElideRight
                                color: "#A4A6AB"
                            }
                        }
                    }
                }


                Rectangle {
                    id:rectPlayCount
                    width: 210 * dpi
                    height: 70 * dpi
                    color: "#222733"
                    radius: 10
                    border.width: 1
                    border.color: "#2B303C"
                    anchors.right: rectUsed.left
                    anchors.rightMargin: 37 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        id:iconCount
                        source: "../res/v2/user_count.png"
                        fillMode: Image.PreserveAspectFit
                        scale: dpi
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 25 * dpi
                    }

                    Rectangle {
                        width: 120 * dpi
                        height: parent.height
                        color: "transparent"
                        anchors.left: iconCount.right
                        anchors.leftMargin: 30 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        Column {
                            anchors.centerIn: parent
                            Text {
                                width: parent.parent.width
                                text:"历史游玩次数"
                                font.pixelSize: 13 * dpi
                                elide: Text.ElideRight
                                color: "white"
                            }

                            Text {
                                width: parent.parent.width
                                text:"100次登录"
                                font.pixelSize: 10 * dpi
                                elide: Text.ElideRight
                                color: "#A4A6AB"
                            }
                        }
                    }
                }


                Rectangle {
                    id:rectUsed
                    width: 210 * dpi
                    height: 70 * dpi
                    color: "#222733"
                    radius: 10
                    border.width: 1
                    border.color: "#2B303C"
                    anchors.right: parent.right
                    anchors.rightMargin: 37 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        id:iconHistory
                        source: "../res/v2/game_history.png"
                        fillMode: Image.PreserveAspectFit
                        scale: dpi
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 25 * dpi
                    }

                    Rectangle {
                        width: 120 * dpi
                        height: parent.height
                        color: "transparent"
                        anchors.left: iconHistory.right
                        anchors.leftMargin: 30 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        Column {
                            anchors.centerIn: parent
                            Text {
                                width: parent.parent.width
                                text:"历史累计使用"
                                font.pixelSize: 13 * dpi
                                elide: Text.ElideRight
                                color: "white"
                            }

                            Text {
                                width: parent.parent.width
                                text:"45天08小时25分钟"
                                font.pixelSize: 10 * dpi
                                elide: Text.ElideRight
                                color: "#A4A6AB"
                            }
                        }
                    }
                }
            }
        }


        Rectangle {
            width: parent.width
            height: 30 * dpi
            color: "transparent"
            Rectangle {
                width: 960 * dpi
                height: parent.height
                color: "transparent"
                anchors.centerIn: parent
                Text {
                    text:"7天内"
                    font.pixelSize: 14 * dpi
                    color: "white"
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }


        Rectangle {
            width: parent.width
            height: 250 * dpi
            color: "transparent"
            Rectangle {
                width: 960 * dpi
                height: parent.height
                anchors.centerIn: parent
                color: "transparent"
                ScrollView {
                    anchors.fill: parent
                    ScrollBar.horizontal.policy:Qt.ScrollBarAlwaysOff
                    GridView {
                        anchors.fill: parent
                        model: 11
                        clip: true
                        cellWidth:width / 4
                        cellHeight: 100 * dpi
                        delegate: Rectangle {
                            width: 230 * dpi
                            height: 90 * dpi
                            color: "transparent"

                            Rectangle {
                                id:imageGame
                                width: 120 * dpi
                                height: 90 * dpi
                                color: "transparent"
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                Image {
                                    source: ""
                                    anchors.fill: parent
                                }
                            }

                            Rectangle {
                                width: parent.width - imageGame.width
                                height: parent.height
                                color: "transparent"
                                anchors.left: imageGame.right
                                Column {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 5 * dpi
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        id:textName
                                        width: parent.parent.width
                                        text:"极品飞车"
                                        font.pixelSize: 13 * dpi
                                        color: "white"
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        width: parent.parent.width
                                        text:"登录25次"
                                        font.pixelSize: 10 * dpi
                                        color: "#A4A6AB"
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        width: parent.parent.width
                                        text:"累计使用08小时25分钟"
                                        font.pixelSize: 10 * dpi
                                        color: "#A4A6AB"
                                        elide: Text.ElideRight
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: {
                                    //textGameName.color = "white"
                                }

                                onExited: {
                                    //textGameName.color = "#A4A6AB"
                                }
                            }
                        }

                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 30 * dpi
            color: "transparent"
            Rectangle {
                width: 960 * dpi
                height: parent.height
                color: "transparent"
                anchors.centerIn: parent
                Text {
                    text:"更早"
                    font.pixelSize: 14 * dpi
                    color: "white"
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }


        Rectangle {
            width: parent.width
            height: 210 * dpi
            color: "transparent"
            Rectangle {
                width: 960 * dpi
                height: parent.height
                anchors.centerIn: parent
                color: "transparent"

                ScrollView {
                    anchors.fill: parent
                    ScrollBar.horizontal.policy:Qt.ScrollBarAlwaysOff
                    GridView {
                        anchors.fill: parent
                        model: 11
                        clip: true
                        cellWidth:width / 4
                        cellHeight: 100 * dpi
                        delegate: Rectangle {
                            width: 230 * dpi
                            height: 90 * dpi
                            color: "transparent"

                            Rectangle {
                                id:imageGameMore
                                width: 120 * dpi
                                height: 90 * dpi
                                color: "transparent"
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                Image {
                                    source: ""
                                    anchors.fill: parent
                                }
                            }

                            Rectangle {
                                width: parent.width - imageGameMore.width
                                height: parent.height
                                color: "transparent"
                                anchors.left: imageGameMore.right
                                Column {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 5 * dpi
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        width: parent.parent.width
                                        text:"极品飞车"
                                        font.pixelSize: 13 * dpi
                                        color: "white"
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        width: parent.parent.width
                                        text:"登录25次"
                                        font.pixelSize: 10 * dpi
                                        color: "#A4A6AB"
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        width: parent.parent.width
                                        text:"累计使用08小时25分钟"
                                        font.pixelSize: 10 * dpi
                                        color: "#A4A6AB"
                                        elide: Text.ElideRight
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: {
                                    //textGameName.color = "white"
                                }

                                onExited: {
                                    //textGameName.color = "#A4A6AB"
                                }
                            }


                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: {
                                    //textGameName.color = "white"
                                }

                                onExited: {
                                    //textGameName.color = "#A4A6AB"
                                }
                            }
                        }

                    }
                }
            }
        }


    }
}
