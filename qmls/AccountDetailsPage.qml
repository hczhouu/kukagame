import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15

//个人信息详情页
Item {

    function updateTextPass()
    {
        HttpClient.userCurrentPass="*********"
    }

    Rectangle {
        anchors.fill: parent
        color: "#1D222E"
        radius: 10
        Text {
            id:textInfo
            text:"基础信息"
            font.pixelSize: 16 * dpi
            color: "white"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 16 * dpi
            anchors.topMargin: 10 * dpi
        }

        Column {
            id:columnInfo
            spacing: 10 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16 * dpi
            anchors.top: textInfo.bottom
            anchors.topMargin: 5 * dpi

            Rectangle {
                id:rectUserLogo
                width: 930 * dpi
                height:70 * dpi
                color: "#222733"
                radius: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:"头像"
                    font.pixelSize: 16 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 30 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }


                //头像
                Rectangle {
                    id:rectHead
                    width:50 * dpi
                    height:50 * dpi
                    color: "transparent"
                    border.color: "#82999F"
                    radius: 100
                    anchors.centerIn: parent
                    MouseArea {
                        id: imageRect
                        width: 50 * dpi
                        height: 50 * dpi
                        anchors.centerIn: parent
                        //头像
                        Image {
                            id: nameIamge
                            anchors.fill: parent
                            source: HttpClient.headLogoUrl
                            visible: false
                            cache: false
                            asynchronous: true
                            scale: dpi
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

            Rectangle {
                width: 930 * dpi
                height:70 * dpi
                color: "#222733"
                radius: 10
                anchors.horizontalCenter:parent.horizontalCenter
                Text {
                    text:"昵称"
                    font.pixelSize: 16 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 30 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }


                Text {
                    text: HttpClient.nickName
                    font.pixelSize: 16 * dpi
                    color: "white"
                    anchors.centerIn:parent
                }

            }

            Rectangle {
                width: 930 * dpi
                height:70 * dpi
                color: "#222733"
                radius: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:"实名认证"
                    font.pixelSize: 16 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 30 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: HttpClient.userRealStatus ? "已认证" : "未认证"
                    font.pixelSize: 16 * dpi
                    color: "white"
                    anchors.centerIn: parent
                }


                Text {
                    visible: !HttpClient.userRealStatus
                    text: "去认证"
                    font.pixelSize: 16 * dpi
                    color: "#1ECF9D"
                    anchors.right: parent.right
                    anchors.rightMargin: 30 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.forceActiveFocus()
                            showPopup('RealNameAuthPopup.qml')
                        }
                    }
                }

            }

            Rectangle {
                width: 930 * dpi
                height:70 * dpi
                color: "#222733"
                radius: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:"青少年模式"
                    font.pixelSize: 16 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 30 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }


                Text {
                    text: HttpClient.userJuniorStatus ? "已开启":"未开启"
                    font.pixelSize: 16 * dpi
                    color: "white"
                    anchors.centerIn: parent
                }


                Text {
                    text: "查看"
                    font.pixelSize: 16 * dpi
                    color: "#1ECF9D"
                    anchors.right: parent.right
                    anchors.rightMargin: 30 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.forceActiveFocus()
                            showPopup('YoungModePopup.qml')
                        }
                    }
                }

            }

        }

        Text {
            id:textLoginInfo
            text:"登录信息"
            font.pixelSize: 16 * dpi
            color: "white"
            anchors.left: parent.left
            anchors.top: columnInfo.bottom
            anchors.leftMargin: 16 * dpi
            anchors.topMargin: 15 * dpi
        }

        Column {
            id:columnLoginInfo
            spacing: 10 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: parent.left
            anchors.leftMargin: 16 * dpi
            anchors.top: textLoginInfo.bottom
            anchors.topMargin: 5 * dpi


            Rectangle {
                width: 930 * dpi
                height:70 * dpi
                color: "#222733"
                radius: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:"手机号"
                    font.pixelSize: 16 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 30 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }


                Text {
                    text: HttpClient.userAccount
                    font.pixelSize: 16 * dpi
                    color: "white"
                    anchors.centerIn: parent
                }

            }

            Rectangle {
                width: 930 * dpi
                height:70 * dpi
                color: "#222733"
                radius: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:"登录密码"
                    font.pixelSize: 16 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 30 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }


                Text {
                    id:textPass
                    text: HttpClient.userCurrentPass
                    font.pixelSize: 16 * dpi
                    color: "white"
                    anchors.centerIn: parent
                }


                Text {
                    text: "查看"
                    font.pixelSize: 16 * dpi
                    color: "#1ECF9D"
                    anchors.right: textModify.left
                    anchors.rightMargin: 15 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.forceActiveFocus()
                            showPopup('ViewPassPopup.qml')
                        }
                    }
                }


                Text {
                    id:textModify
                    text: "修改"
                    font.pixelSize: 16 * dpi
                    color: "#1ECF9D"
                    anchors.right: parent.right
                    anchors.rightMargin: 30 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.forceActiveFocus()
                            modifyPassPopup.youthModeModify = false
                            modifyPassPopup.open()
                        }
                    }
                }

            }

        }

    }
}
