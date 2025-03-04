import QtQuick 2.12
import QtQuick.Controls 2.12

// 关于我们弹窗
Popup {
    id:upgradePopup
    width:820 * dpi
    height:590 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape
    anchors.centerIn: parent
    background:Rectangle {
        anchors.fill: parent
        color: "transparent"
        Rectangle {
            width: parent.width
            height: 90 * dpi
            color: "transparent"
            anchors.top: parent.top
            Image {
                source: "../res/v2/upgrade_bk.png"
                anchors.fill: parent
            }

            Text {
                text:"升级攻略"
                font.pixelSize: 18 * dpi
                color: "#1ECE9A"
                font.bold: true
                anchors.centerIn: parent
            }

            Image {
                source: "../res/v2/popup_close.png"
                fillMode: Image.PreserveAspectFit
                scale: dpi
                anchors.right: parent.right
                anchors.rightMargin: 20 * dpi
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        upgradePopup.close()
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 500 * dpi
            color: "transparent"
            anchors.bottom: parent.bottom
            Image {
                source: "../res/v2/upgrade_bk_01.png"
                anchors.fill: parent
            }

            Text {
                text:"LV.2加速成长攻略"
                font.pixelSize: 12 * dpi
                color: "black"
                anchors.left: parent.left
                anchors.leftMargin: 25 * dpi
                anchors.top: parent.top
                anchors.topMargin: 25 * dpi
            }


            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 100 * dpi
                spacing: 20 * dpi
                ListModel {
                    id:listModel
                    ListElement {
                        icon:"../res/v2/upgrade_icon_01.png"
                        desc:"每充值1元"
                        desc_ex:"获得5成长值"
                    }

                    ListElement {
                        icon:"../res/v2/upgrade_icon_02.png"
                        desc:"参与活动"
                        desc_ex:"获得10-30成长值不等"
                    }

                    ListElement {
                        icon:"../res/v2/upgrade_icon_04.png"
                        desc:"邀请1位用户"
                        desc_ex:"可获得10成长值"
                    }

                    ListElement {
                        icon:"../res/v2/upgrade_icon_03.png"
                        desc:"每日签到"
                        desc_ex:"获得5成长值"
                    }
                }

                Repeater {
                    model:listModel
                    delegate: Rectangle {
                        width: 150 * dpi
                        height: 190 * dpi
                        color: "transparent"
                        Rectangle {
                            width: 150 * dpi
                            height: 150 * dpi
                            color: "#E4F9F4"
                            anchors.top: parent.top
                            Image {
                                source: icon
                                fillMode: Image.PreserveAspectFit
                                scale: dpi
                                anchors.centerIn: parent
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 40 * dpi
                            color: "transparent"
                            anchors.bottom: parent.bottom

                            Column {
                                anchors.centerIn: parent
                                Text {
                                    text:desc
                                    font.pixelSize: 12 * dpi
                                    color: "black"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Text {
                                    text:desc_ex
                                    font.pixelSize: 12 * dpi
                                    color: "black"
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }

                        }

                    }
                }
            }


            //确认按钮
            Rectangle {
                width: 200 * dpi
                height: 60 * dpi
                color: "#1ED2A6"
                radius: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 49 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text:"确认"
                    font.pixelSize: 14 * dpi
                    color: "white"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        upgradePopup.close()
                    }
                }
            }
        }
    }
}
