import QtQuick 2.6
import QtQuick.Window 2.6
import QtQuick.Controls 2.6
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15

//会员中心页面
Item {

    ScrollView {
        anchors.fill: parent
        contentHeight: rect.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip: true

        Rectangle {
            id:rect
            width: parent.width
            height: 870 * dpi
            color: "transparent"

            Rectangle {
                id:rectLevel
                width: 960 * dpi
                height: 180 * dpi
                color: "#1D222F"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                radius: 10

                Rectangle {
                    width: 90 * dpi
                    height: 25 * dpi
                    color: "transparent"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    Image {
                        source: "../res/v2/lv_bk.png"
                        anchors.fill: parent
                        Text {
                            text:"当前等级"
                            font.pixelSize: 10 * dpi
                            anchors.centerIn: parent
                            color: "#958370"
                        }
                    }
                }


                Column {
                    anchors.left: parent.left
                    anchors.leftMargin: 25 * dpi
                    anchors.top: parent.top
                    anchors.topMargin: 45 * dpi
                    spacing: 10 * dpi
                    Rectangle {
                        width: 500 * dpi
                        height: 40 * dpi
                        color: "transparent"
                        Image {
                            id:iconCrown
                            source: "../res/v2/crown_big.png"
                            fillMode: Image.PreserveAspectFit
                            scale: dpi
                            anchors.left: parent.left
                            //anchors.leftMargin: 10 * dpi
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            id:textLv
                            text:"白银会员"
                            font.pixelSize: 22 * dpi
                            color: "#DFBE99"
                            font.bold: true
                            anchors.left: iconCrown.right
                            anchors.leftMargin: 5 * dpi
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text:"每月1日更新等级"
                            font.pixelSize: 10 * dpi
                            color: "white"
                            anchors.left: textLv.right
                            anchors.leftMargin: 10 * dpi
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 7 * dpi
                        }
                    }

                    Rectangle {
                        width: 750 * dpi
                        height: 40 * dpi
                        color: "transparent"

                        ProgressBar {
                              id:control
                              value: 0.6
                              width: 580 * dpi
                              height: 10 * dpi
                              anchors.left: parent.left
                              anchors.verticalCenter: parent.verticalCenter
                              background: Rectangle {
                                  implicitWidth: control.width
                                  implicitHeight: control.height
                                  color: "#2B3140"
                                  radius: 3
                              }

                              contentItem: Item {
                                  Rectangle {
                                      width: control.visualPosition * control.width
                                      height: control.height
                                      radius: 2
                                      color: "#F0B291"
                                }
                            }
                        }

                        Text {
                            text:"Lv.6"
                            font.pixelSize: 12 * dpi
                            color: "#A4A6AB"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: control.right
                            anchors.leftMargin: 10 * dpi
                        }

                        Rectangle {
                            width: 100 * dpi
                            height: 35 *dpi
                            color: "#E8CEB0"
                            radius: 30
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                text:"加速升级"
                                font.pixelSize: 12 *dpi
                                color: "#1D222E"
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape:Qt.PointingHandCursor
                                onClicked: {
                                    showPopup("UpgradePopup.qml");
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: 500 * dpi
                        height: textDesc.height
                        color: "transparent"
                        Text {
                            id:textDesc
                            text:"当前成长值450,升级Lv2还需180成长值"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#A4A6AB"
                            font.pixelSize: 11 * dpi
                        }
                    }
                }


                Image {
                    source: "../res/v2/star_big.png"
                    fillMode: Image.PreserveAspectFit
                    scale: dpi
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 40 * dpi
                }
            }



            Rectangle {
                id:rectLevelDesc
                width: 960 * dpi
                height: 310 * dpi
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectLevel.bottom
                anchors.topMargin: 20 * dpi

                ListModel {
                    id:listModel
                    ListElement {
                        bk:"../res/v2/mem_05.png"
                        caption:"白银会员"
                        textcolor:"#444169"
                        lv_bk:"../res/v2/lev_bk_05.png"
                        crown_bk:"../res/v2/crown_02.png"
                        star_bk:"../res/v2/star_05.png"
                        spliterbk:"../res/v2/spliter_01.png"
                        desc:"立即送会员时长5小时 每日额外福利会员时长 10分钟 充值9.5折"
                    }
                    ListElement {
                        bk:"../res/v2/mem_01.png"
                        caption:"黄金会员"
                        textcolor:"#E7A45F"
                        lv_bk:"../res/v2/lev_bk_01.png"
                        crown_bk:"../res/v2/crown_05.png"
                        star_bk:"../res/v2/star_01.png"
                        spliterbk:"../res/v2/spliter_02.png"
                        desc:"立即送会员时长10小时一个月每日额外福利会员时长20分钟充值9折、极速排队、限免游戏"
                    }
                    ListElement {
                        bk:"../res/v2/mem_02.png"
                        caption:"铂金会员"
                        textcolor:"#214B62"
                        lv_bk:"../res/v2/lev_bk_02.png"
                        crown_bk:"../res/v2/crown_03.png"
                        star_bk:"../res/v2/star_02.png"
                        spliterbk:"../res/v2/spliter_03.png"
                        desc:"立即送会员时长15小时每日额外福利会员时长30分钟充值8.5折、极速排队、限免游戏、高配机型、超清画质、会员游戏、游戏礼包"
                    }
                    ListElement {
                        bk:"../res/v2/mem_03.png"
                        caption:"钻石会员"
                        textcolor:"#705AC6"
                        lv_bk:"../res/v2/lev_bk_03.png"
                        crown_bk:"../res/v2/crown_01.png"
                        star_bk:"../res/v2/star_03.png"
                        spliterbk:"../res/v2/spliter_04.png"
                        desc:"立即送会员时长45小时 每日额外福利会员时长 45分钟 充值8折、极速排队、限 免游戏、高配机型、超清 画质、会员游戏、游戏礼包"
                    }
                    ListElement {
                        bk:"../res/v2/mem_04.png"
                        caption:"黑钻会员"
                        textcolor:"#E2CCB4"
                        lv_bk:"../res/v2/lev_bk_04.png"
                        crown_bk:"../res/v2/crown_04.png"
                        star_bk:"../res/v2/star_04.png"
                        spliterbk:"../res/v2/spliter_05.png"
                        desc:"立即送会员时长60小时 每日额外福利会员时长 60分钟 充值7折、极速排队、限 免游戏、高配机型、超清 画质、会员游戏、超长待机
网速提升、会员日福利、生日礼包、游戏礼包"
                    }
                }

                Row {
                    spacing: 10 * dpi
                    anchors.centerIn: parent
                    Repeater {
                        model: listModel
                        delegate: Rectangle {
                            id:rectItem
                            width: 184 * dpi
                            height: parent.parent.height
                            color: "transparent"
                            Image {
                                source: bk
                                anchors.fill: parent
                            }

                            Rectangle {
                                width: 63 * dpi
                                height: 19 * dpi
                                color: "transparent"
                                anchors.left: parent.left
                                anchors.top: parent.top
                                Image {
                                    source: lv_bk
                                    anchors.fill: parent
                                }

                                Text {
                                    text: "已解锁"
                                    font.pixelSize: 10 * dpi
                                    color: textcolor
                                    anchors.centerIn: parent
                                }
                            }


                            Column {
                                anchors.centerIn: parent
                                spacing: 8 * dpi
                                Row {
                                    spacing: 5 * dpi
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    Image {
                                        source: crown_bk
                                        fillMode: Image.PreserveAspectFit
                                        scale: dpi
                                        anchors.verticalCenter: parent.verticalCenter
                                    }

                                    Text {
                                        text:caption
                                        font.pixelSize: 12 * dpi
                                        font.bold: true
                                        color: textcolor
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }

                                Image {
                                    source: star_bk
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    fillMode: Image.PreserveAspectFit
                                    scale: dpi
                                }

                                Text {
                                    text:"成长值达到600解锁等级"
                                    font.pixelSize: 10 * dpi
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    color: textcolor
                                }

                                Image {
                                    source: spliterbk
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    fillMode: Image.PreserveAspectFit
                                    scale: dpi
                                }

                                TextArea {
                                    width: 150 * dpi
                                    height: 120 * dpi
                                    color: textcolor
                                    enabled: false
                                    text:desc
                                    wrapMode: Text.WordWrap
                                    font.pixelSize: 10 * dpi
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    background: Rectangle {
                                        color: "transparent"
                                    }
                                }
                            }

                        }
                    }
                }

            }

            Rectangle {
                id:rectTextRights
                width: 960 * dpi
                height: 30 * dpi
                color: "#1D222E"
                anchors.top: rectLevelDesc.bottom
                anchors.topMargin: 20 * dpi
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text: "增值权益"
                    color: "#E0BF9B"
                    font.pixelSize: 12 * dpi
                    anchors.centerIn: parent
                }
            }


            Rectangle {
                id:rectRights
                width: 960 * dpi
                height: 300 * dpi
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectTextRights.bottom
                Column {
                    spacing: 1 * dpi
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 1 * dpi
                    Rectangle {
                        width: 960 * dpi
                        height: 33 * dpi
                        color: "transparent"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Row {
                            spacing: 1.3 * dpi
                            anchors.horizontalCenter: parent.horizontalCenter
                            Repeater {
                                model:["会员等级","会员游戏","会员日福利","极速排队","超长待机","高配机型",
                                "超清画质","限免游戏","游戏礼包","专享设备","网速提升"]
                                delegate: Rectangle {
                                    width: 86 * dpi
                                    height: 33 * dpi
                                    color: "#222733"
                                    Text {
                                        text: modelData
                                        color: "#A4A6AB"
                                        font.pixelSize: 10 * dpi
                                        anchors.centerIn: parent
                                    }
                                }
                            }

                        }

                    }


                    ListModel {
                        id:listModelItem
                        ListElement {
                            caption:"普通会员"
                            rightsNum:0
                        }

                        ListElement {
                            caption:"白银会员"
                            rightsNum:2
                        }

                        ListElement {
                            caption:"黄金会员"
                            rightsNum:4
                        }

                        ListElement {
                            caption:"铂金会员"
                            rightsNum:6
                        }

                        ListElement {
                            caption:"钻石会员"
                            rightsNum:8
                        }

                        ListElement {
                            caption:"黑钻会员"
                            rightsNum:10
                        }
                    }

                    Repeater {
                        model:listModelItem
                        delegate: Rectangle {
                            width: parent.width
                            height: 40 * dpi
                            color: "transparent"
                            Row {
                                spacing: 1.3 * dpi
                                anchors.horizontalCenter: parent.horizontalCenter
                                Rectangle {
                                    width: 86 * dpi
                                    height: 40 * dpi
                                    color: "#222733"
                                    Text {
                                        text: caption
                                        color: "#A4A6AB"
                                        font.pixelSize: 10 * dpi
                                        anchors.centerIn: parent
                                    }
                                }

                                Repeater {
                                    model:10
                                    delegate: Rectangle {
                                        width: 86 * dpi
                                        height: 40 * dpi
                                        color: "#222733"
                                        Text {
                                            text: (index < rightsNum) ? "有" : "/"
                                            color: "#A4A6AB"
                                            font.pixelSize: 10 * dpi
                                            anchors.centerIn: parent
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
