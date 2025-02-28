import QtQuick 2.15
import QtQuick.Window 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import MsgCenter 1.0

// 活动公告弹窗
Popup {
    id:activitiesNoticePopup
    width: 820 * dpi
    height: 600 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent
    property string msgId: ""
    property string msgType: ""

    onOpened: {
        MsgCenter.getMsgDetailsById(msgId)
    }

    onClosed:{
        activitiesNoticePopup.destroy()
    }

    background:Rectangle {
        color: "transparent"
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
            text:msgType
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
                    activitiesNoticePopup.close()
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
            source: "../res/v2/notice_bk.png"
            anchors.fill: parent
        }

        AnimatedImage {
            id:animateLoading
            visible:!MsgCenter.msgReady
            source: "../res/newVersion/ani_loading.gif"
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            anchors.centerIn: parent
            scale: dpi
        }

        Column {
            anchors.fill: parent
            spacing: 10
            visible: MsgCenter.msgReady
            Rectangle {
                width: parent.width
                height: parent.height - rectConfirm.height - 20
                color: "transparent"
                ScrollView {
                    anchors.fill: parent
                    contentHeight: rectContent.height
                    anchors.top: parent.top
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    Rectangle {
                        id:rectContent
                        width:  780 * dpi
                        height: columnContent.implicitHeight
                        color: "transparent"
                        anchors.horizontalCenter: parent.horizontalCenter
                        Column {
                            id:columnContent
                            spacing: 5 * dpi
                            anchors.fill: parent
                            //标题
                            Rectangle {
                                id:rectCaption
                                width: parent.width
                                height: 30 * dpi
                                color: "transparent"
                                visible: MsgCenter.onlyText
                                anchors.horizontalCenter: parent.horizontalCenter
                                Text {
                                    text:MsgCenter.msgTitle
                                    font.pixelSize: 13 * dpi
                                    font.bold: true
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: "#131A25"
                                }
                            }

                            //横线
                            Rectangle {
                                id:rectLine
                                width: parent.width
                                height: 1
                                color: "#BACCCC"
                                visible: MsgCenter.onlyText
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            //消息图片
                            Rectangle {
                                id:rectImage
                                width: MsgCenter.imageWidth * dpi
                                height: MsgCenter.imageHeight * dpi
                                color: "transparent"
                                visible: MsgCenter.onlyImage || MsgCenter.textWithImage
                                anchors.horizontalCenter: parent.horizontalCenter
                                Image {
                                    id:imageMsg
                                    anchors.fill: parent
                                    source: MsgCenter.msgImage
                                    asynchronous: true
                                }

                                AnimatedImage {
                                    visible:imageMsg.status !== Image.Ready
                                    source: "../res/newVersion/ani_loading.gif"
                                    fillMode: Image.PreserveAspectFit
                                    asynchronous: true
                                    anchors.centerIn: parent
                                    scale: dpi
                                }
                            }


                            //消息内容
                            ScrollView {
                                width: parent.width
                                height: rectText.contentHeight * 2
                                visible: MsgCenter.onlyText || MsgCenter.textWithImage
                                clip: true
                                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                                TextArea {
                                    id:rectText
                                    clip: true
                                    text:MsgCenter.msgContent
                                    wrapMode: TextField.WordWrap
                                    font.pixelSize: 12 * dpi
                                    color: "#131A25"
                                    readOnly: true
                                    background: Rectangle {
                                        color: "transparent"
                                    }
                                }
                            }
                        }
                    }
                }

            }

            Button {
                id:rectConfirm
                width: 200 * dpi
                height: MsgCenter.pushLink ? 50 * dpi : 0
                visible:MsgCenter.pushLink
                anchors.horizontalCenter: parent.horizontalCenter
                background: Rectangle {
                    color: "#1ECF9B"
                    radius: 10
                    Text {
                        anchors.centerIn: parent
                        text:"参与活动"
                        font.pixelSize: 12 * dpi
                        color: "white"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape:Qt.PointingHandCursor
                    onClicked: {
                        Qt.openUrlExternally(MsgCenter.msgActivitiesLink)
                    }
                }
            }
        }
    }
}
