import QtQuick 2.12
import QtQuick.Controls 2.12

// 关于我们弹窗
Popup {
    id:aboutPopup
    width:820 * dpi
    height:590 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape
    anchors.centerIn: parent

    background:Rectangle {
        color: "transparent"
    }

    onClosed: {
        aboutPopup.destroy()
    }

    Rectangle {
        id:rectTitle
        width: parent.width
        height: 90 * dpi
        color: "transparent"
        anchors.top: parent.top
        Image {
            source: "../res/v2/about_bk.png"
            anchors.fill: parent
        }

        Text {
            text:"关于我们"
            font.pixelSize: 18 * dpi
            font.bold: true
            color: "#12C195"
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
                    aboutPopup.close()
                }
            }
        }
    }


    Rectangle {
        width: parent.width
        height: parent.height - rectTitle.height
        color: "transparent"
        anchors.bottom: parent.bottom

        Image {
            source: "../res/v2/about_bk_01.png"
            anchors.fill: parent
        }

        Row {
            spacing: 50 * dpi
            anchors.centerIn: parent

            Image {
                id:imageIcon
                source: "../res/v2/about_icon.png"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
            }

            Column {
                spacing: 30 * dpi
                anchors.verticalCenter: parent.verticalCenter
                ListModel {
                    id:listModel
                    ListElement {
                        icon:"../res/v2/about_icon_pc.png"
                        title:"PC端"
                        desc:"无惧配置 小破本秒玩3A游戏"
                    }

                    ListElement {
                        icon:"../res/v2/about_icon_phone.png"
                        title:"移动端"
                        desc:"随时随地 手机玩转PC游戏"
                    }

                    ListElement {
                        icon:"../res/v2/about_icon_tv.png"
                        title:"TV端"
                        desc:"家庭聚会 电视秒变娱乐中心"
                    }

                }

                Repeater {
                    model:listModel
                    delegate: Row {
                        spacing: 10 * dpi
                        Image {
                            source: icon
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            spacing: 5 * dpi
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                text:title
                                font.pixelSize: 14 * dpi
                                color: "#12C195"
                            }

                            Text {
                                text:desc
                                font.pixelSize: 14 * dpi
                                color: "#131A25"
                            }
                        }
                    }
                }

            }
        }
    }


}
