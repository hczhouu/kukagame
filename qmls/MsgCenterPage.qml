import QtQuick 2.6
import QtQuick.Window 2.6
import QtQuick.Controls 2.6
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import ActivitiesNoticeModel 1.0
import DynamicNoticeModel 1.0
import SystemNoticeModel 1.0
import MsgCenter 1.0

//消息中心页面
Item {

    property variant models: [SystemNoticeModel, ActivitiesNoticeModel, DynamicNoticeModel]

    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.forceActiveFocus()
            showSearchResult = false
        }
    }

    Connections {
        target: HttpClient
        function onLoginSuccess()
        {
            //刷新未读消息数量
            MsgCenter.getUnReadNum(ActivitiesNoticeModel,
                                   DynamicNoticeModel, SystemNoticeModel)
        }
    }

    Connections {
        target: MsgCenter
        function onForcePopupMsg(msgId, msgCaption)
        {
            var component = Qt.createComponent('ActivitiesNoticePopup.qml');
            var dynamicObject = component.createObject(mainWindow,
                 {"msgId":msgId, "msgType":msgCaption});
            dynamicObject.open()
        }
    }

    Rectangle {
        id:rectTabBar
        width: parent.width
        height: 30 * dpi
        color: "transparent"
        anchors.top: parent.top

        TabBar {
            width: 960 * dpi
            height: parent.height
            anchors.centerIn: parent
            background: Rectangle {
                color: "transparent"
            }

            ListModel {
                id:listModelTabBtn
                ListElement {
                    name:"公告"
                    icon_path:"../res/v2/msg_02.png"
                    icon_path_sel:"../res/v2/msg_02_sel.png"
                }

                ListElement {
                    name:"活动"
                    icon_path:"../res/v2/msg_01.png"
                    icon_path_sel:"../res/v2/msg_01_sel.png"
                }

                ListElement {
                    name:"动态"
                    icon_path:"../res/v2/msg_.png"
                    icon_path_sel:"../res/v2/msg_sel.png"
                }
            }

            ButtonGroup {
                id:btnGroup
                exclusive: true
            }

            Repeater {
                model: listModelTabBtn
                delegate: TabButton {
                    id:tabBtn
                    width: 150 * dpi
                    height: 30 * dpi
                    checkable: true
                    checked: index === 0
                    anchors.verticalCenter: parent.verticalCenter
                    ButtonGroup.group: btnGroup
                    background: Rectangle {
                        color: "transparent"
                        Image {
                            id:imageIcon
                            source: tabBtn.checked ? icon_path_sel : icon_path
                            fillMode: Image.PreserveAspectFit
                            anchors.verticalCenter: parent.verticalCenter
                            scale: dpi
                            anchors.left: parent.left
                            anchors.leftMargin: 5 * dpi
                        }

                        Text {
                            id:textBtnName
                            text:name
                            anchors.left: imageIcon.right
                            anchors.leftMargin: 10 * dpi
                            anchors.verticalCenter: imageIcon.verticalCenter
                            font.pixelSize: 16 * dpi
                            color: tabBtn.checked ? "#00D9B2" : "#A4A6AB"
                            font.bold: tabBtn.checked
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            id:textleft
                            text:"("
                            visible: {
                                if (index === 0)
                                {
                                    return MsgCenter.announcementTotal > 0
                                } else if (index === 1) {
                                    return MsgCenter.activityTotal > 0
                                } else if (index === 2) {
                                    return MsgCenter.dynamicTotal > 0
                                }
                            }

                            anchors.left: textBtnName.right
                            anchors.verticalCenter: imageIcon.verticalCenter
                            font.pixelSize: 16 * dpi
                            color: tabBtn.checked ? "#00D9B2" : "#A4A6AB"
                            font.bold: tabBtn.checked
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            id:textUnreadNum
                            text:{
                                if (index === 0)
                                {
                                    return MsgCenter.announcementTotal.toString()
                                } else if (index === 1) {
                                    return MsgCenter.activityTotal.toString()
                                } else if (index === 2) {
                                    return MsgCenter.dynamicTotal.toString()
                                }
                            }

                            visible: {
                                if (index === 0)
                                {
                                    return MsgCenter.announcementTotal > 0
                                } else if (index === 1) {
                                    return MsgCenter.activityTotal > 0
                                } else if (index === 2) {
                                    return MsgCenter.dynamicTotal > 0
                                }
                            }

                            anchors.left: textleft.right
                            anchors.verticalCenter: imageIcon.verticalCenter
                            font.pixelSize: 16 * dpi
                            color: tabBtn.checked ? "#00D9B2" : "#A4A6AB"
                            font.bold: tabBtn.checked
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            text:")"
                            visible: {
                                if (index === 0)
                                {
                                    return MsgCenter.announcementTotal > 0
                                } else if (index === 1) {
                                    return MsgCenter.activityTotal > 0
                                } else if (index === 2) {
                                    return MsgCenter.dynamicTotal > 0
                                }
                            }

                            anchors.left: textUnreadNum.right
                            anchors.verticalCenter: imageIcon.verticalCenter
                            font.pixelSize: 16 * dpi
                            color: tabBtn.checked ? "#00D9B2" : "#A4A6AB"
                            font.bold: tabBtn.checked
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            showSearchResult = false
                            parent.forceActiveFocus()
                            parent.checked = true
                            stackMsgList.currentIndex = index
                            MsgCenter.getMsgListByType(index)
                        }
                    }
                }
            }
        }
    }


    Rectangle {
        id:rectMsg
        width: parent.width
        height: parent.height - rectTabBar.height - 30 * dpi
        color: "transparent"
        anchors.top: rectTabBar.bottom
        anchors.topMargin: 10 * dpi
        Rectangle {
            width: 960 * dpi
            height: parent.height
            color: "#1D222E"
            radius: 10
            anchors.centerIn: parent

            Loading {
                anchors.centerIn: parent
                visible: !MsgCenter.msgDataIsReady
            }

            StackLayout {
                id:stackMsgList
                anchors.fill: parent
                anchors.margins: 20 * dpi
                visible: MsgCenter.msgDataIsReady
                Repeater {
                    model:models
                    delegate: Item {
                        anchors.margins: 20 * dpi

                        Text {
                            text:"暂无消息"
                            font.pixelSize: 14 * dpi
                            anchors.centerIn: parent
                            color: "#999999"
                            visible: MsgCenter.msgDataIsEmpty
                        }

                        ListView {
                            anchors.fill: parent
                            model: modelData
                            clip: true
                            spacing:10
                            visible: !MsgCenter.msgDataIsEmpty
                            delegate: Rectangle {
                                width: stackMsgList.width
                                height: 70 * dpi
                                color: "#222733"
                                radius: 10
                                border.width: 1
                                border.color: "#2B303C"
                                Row {
                                    spacing: 20 * dpi
                                    anchors.centerIn: parent
                                    Image {
                                        source: noticeIcon
                                        fillMode: Image.PreserveAspectFit
                                        scale: dpi
                                        anchors.verticalCenter: parent.verticalCenter

                                        Image {
                                            id:redDot
                                            visible: noticeReadFlag
                                            source: "../res/v2/red_point.png"
                                            fillMode: Image.PreserveAspectFit
                                            anchors.right: parent.right
                                            anchors.rightMargin: 2 * dpi
                                            anchors.top: parent.top
                                        }
                                    }

                                    Column {
                                        width: 650 * dpi
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 5 * dpi
                                        Text {
                                            id:textCaption
                                            text:noticeCaption
                                            font.pixelSize: 15 * dpi
                                            color: "white"

                                            MouseArea {
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape:Qt.PointingHandCursor
                                                onClicked: {
                                                    redDot.visible = false
                                                    showSearchResult = false
                                                    parent.forceActiveFocus()
                                                    var component = Qt.createComponent('ActivitiesNoticePopup.qml');
                                                    var dynamicObject = component.createObject(mainWindow,
                                                         {"msgId":noticeId, "msgType":noticeCaption});
                                                    dynamicObject.open()
                                                }

                                                onEntered: {
                                                    textCaption.font.underline = true
                                                }

                                                onExited: {
                                                    textCaption.font.underline = false
                                                }
                                            }
                                        }

                                        Text {
                                            id:textTitle
                                            width: parent.width
                                            text:noticeTitle
                                            font.pixelSize: 14 * dpi
                                            color: "#A4A6AB"
                                            elide: Text.ElideRight

                                            MouseArea {
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape:Qt.PointingHandCursor
                                                onClicked: {
                                                    redDot.visible = false
                                                    showSearchResult = false
                                                    parent.forceActiveFocus()
                                                    var component = Qt.createComponent('ActivitiesNoticePopup.qml');
                                                    var dynamicObject = component.createObject(mainWindow,
                                                         {"msgId":noticeId, "msgType":noticeCaption});
                                                    dynamicObject.open()
                                                }

                                                onEntered: {
                                                    textTitle.font.underline = true
                                                }

                                                onExited: {
                                                    textTitle.font.underline = false
                                                }
                                            }
                                        }
                                    }

                                    Column {
                                        width: 150 * dpi
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 5 * dpi
                                        Rectangle {
                                            width: 70 * dpi
                                            height: 25 * dpi
                                            color: "#2D3443"
                                            radius: 10
                                            anchors.right: parent.right
                                            Text {
                                                text:"点击查看"
                                                anchors.centerIn: parent
                                                font.pixelSize: 12 * dpi
                                                color: "#A4A6AB"
                                            }

                                            MouseArea {
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape:Qt.PointingHandCursor
                                                onClicked: {
                                                    redDot.visible = false
                                                    showSearchResult = false
                                                    parent.forceActiveFocus()
                                                    var component = Qt.createComponent('ActivitiesNoticePopup.qml');
                                                    var dynamicObject = component.createObject(mainWindow,
                                                         {"msgId":noticeId, "msgType":noticeCaption});
                                                    dynamicObject.open()
                                                }
                                            }
                                        }

                                        Text {
                                            width: parent.width
                                            text:noticeCreateTime
                                            font.pixelSize: 14 * dpi
                                            color: "#A4A6AB"
                                            elide: Text.ElideRight
                                            anchors.right: parent.right
                                            horizontalAlignment: Text.AlignRight
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
