import QtQuick 2.6
import QtQuick.Window 2.6
import QtQuick.Controls 2.6
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15

//积分中心页面
Item {

    Rectangle {
        width: parent.width
        height: parent.height
        anchors.margins: 10 * dpi
        color: "transparent"

        Rectangle {
            id:rectTask
            width: 960 * dpi
            height: 120 * dpi
            color: "#222733"
            radius: 10
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.top: parent.top

            ListModel {
                id:listModel
                ListElement {
                    name:"积分明细"
                    icon_path:"../res/v2/val_02.png"
                }

                ListElement {
                    name:"兑换记录"
                    icon_path:"../res/v2/val_03.png"
                }

                ListElement {
                    name:"积分规则"
                    icon_path:"../res/v2/val_04.png"
                }
            }

            Row {
                anchors.centerIn: parent
                spacing: 130 * dpi

                Column {
                    spacing: 5 * dpi
                    //anchors.left: parent.left
                    //anchors.leftMargin: 45 * dpi
                    //anchors.verticalCenter: parent.verticalCenter
                    Text {
                        text:"67566"
                        font.pixelSize: 18 * dpi
                        font.bold: true
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        text:"可用积分"
                        font.pixelSize: 12 * dpi
                        color: "#A4A6AB"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Repeater {
                    model: listModel
                    delegate: Row {
                        spacing: 10 * dpi
                        Image {
                            source: icon_path
                            fillMode: Image.PreserveAspectFit
                            scale: dpi
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text:name
                            font.pixelSize: 13 * dpi
                            color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {

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


            }
        }

        Rectangle {
            id:rectCaption
            width: 960 * dpi
            height: 30 * dpi
            color: "transparent"
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.top: rectTask.bottom
            anchors.topMargin: 10 * dpi
            Text {
                text:"成长任务"
                font.pixelSize: 14 * dpi
                color: "white"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Rectangle {
            id:rectTaskEntry
            width: 960 * dpi
            height: 70 * dpi
            color: "transparent"
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.top: rectCaption.bottom
            anchors.topMargin: 10 * dpi

            Rectangle {
                width: 470 * dpi
                height: parent.height
                color: "#222733"
                anchors.left: parent.left
                radius: 10
                border.width:1
                border.color:"#2B303C"
                Row {
                    spacing: 10 * dpi
                    anchors.centerIn: parent
                    Image {
                        source: "../res/v2/val_06.png"
                        fillMode: Image.PreserveAspectFit
                        scale: dpi
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Column {
                        width: 260 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text:"每日签到"
                            font.pixelSize: 13 * dpi
                            color: "white"
                        }

                        Text {
                            text:"签到成功+1成长值,+1积分"
                            font.pixelSize: 13 * dpi
                            color: "white"
                        }
                    }

                    Rectangle {
                        width: 100 * dpi
                        height: 40 * dpi
                        color: "#2D3443"
                        radius: 30
                        Text {
                            text:"去完成"
                            font.pixelSize: 12 * dpi
                            color: "#A4A6AB"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {

                            }
                        }
                    }
                }
            }

            Rectangle {
                width: 470 * dpi
                height: parent.height
                color: "#222733"
                anchors.right: parent.right
                radius: 10
                border.width:1
                border.color:"#2B303C"
                Row {
                    spacing: 10 * dpi
                    anchors.centerIn: parent
                    Image {
                        source: "../res/v2/val_05.png"
                        fillMode: Image.PreserveAspectFit
                        scale: dpi
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Column {
                        width: 260 * dpi
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text:"交易"
                            font.pixelSize: 13 * dpi
                            color: "white"
                        }

                        Text {
                            text:"金额满1元+1成长值,+1积分"
                            font.pixelSize: 13 * dpi
                            color: "white"
                        }
                    }

                    Rectangle {
                        width: 100 * dpi
                        height: 40 * dpi
                        color: "#2D3443"
                        radius: 30
                        Text {
                            text:"点击查看"
                            font.pixelSize: 12 * dpi
                            color: "#A4A6AB"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {

                            }
                        }
                    }
                }
            }
        }


        Rectangle {
            id:rectCaptionShop
            width: 960 * dpi
            height: 30 * dpi
            color: "transparent"
            anchors.horizontalCenter:parent.horizontalCenter
            anchors.top: rectTaskEntry.bottom
            anchors.topMargin: 10 * dpi
            Text {
                text:"积分商城"
                font.pixelSize: 14 * dpi
                color: "white"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
        }



        Rectangle {
            id:rectDurationCard
            width: 960 * dpi
            height:410 * dpi
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: rectCaptionShop.bottom
            anchors.topMargin: 10 * dpi
            TabBar {
                id:tabTitle
                width: parent.width
                anchors.left: parent.left
                anchors.top: parent.top
                background: Rectangle {
                    color: "transparent"
                }

                TabButton {
                    id:tabbtnTime
                    width: 70 * dpi
                    background: Rectangle {
                        color: "transparent"
                        Rectangle {
                            visible: tabbtnTime.checked
                            width: caption.contentWidth
                            height: 2
                            color: "#1ECE99"
                            anchors.bottom: parent.bottom
                        }
                    }

                    contentItem: Text {
                        id:caption
                        text:"电器类"
                        anchors.fill: parent
                        font.pixelSize: 12 * dpi
                        font.bold: true
                        color: tabbtnTime.checked ? "#1ECE99" : "#818D9D"
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            tabbtnTime.checked = true
                        }
                    }

                }

                TabButton {
                    id:tabbtnCycle
                    width: 70 * dpi
                    background: Rectangle {
                        color: "transparent"

                        Rectangle {
                            visible: tabbtnCycle.checked
                            width: caption.contentWidth
                            height: 2
                            color: "#1ECE99"
                            anchors.bottom: parent.bottom
                        }
                    }

                    contentItem: Text {
                        text:"美妆类"
                        anchors.fill: parent
                        font.pixelSize: 12 * dpi
                        font.bold: true
                        color: tabbtnCycle.checked ? "#1ECE99" : "#818D9D"
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            tabbtnCycle.checked = true
                        }
                    }
                }

                TabButton {
                    id:tabbtnTimeSlot
                    width: 70 * dpi
                    background: Rectangle {
                        color: "transparent"

                        Rectangle {
                            visible: tabbtnTimeSlot.checked
                            width: caption.contentWidth
                            height: 2
                            color: "#1ECE99"
                            anchors.bottom: parent.bottom
                        }
                    }

                    contentItem: Text {
                        text:"日用类"
                        anchors.fill: parent
                        font.pixelSize: 12 * dpi
                        font.bold: true
                        color: tabbtnTimeSlot.checked ? "#1ECE99" : "#818D9D"
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            tabbtnTimeSlot.checked = true
                        }
                    }
                }

                TabButton {
                    id:tabbtnTimeCard
                    width: 70 * dpi
                    background: Rectangle {
                        color: "transparent"

                        Rectangle {
                            visible: tabbtnTimeCard.checked
                            width: caption.contentWidth
                            height: 2
                            color: "#1ECE99"
                            anchors.bottom: parent.bottom
                        }
                    }

                    contentItem: Text {
                        text:"时长卡"
                        anchors.fill: parent
                        font.pixelSize: 12 * dpi
                        font.bold: true
                        color: tabbtnTimeCard.checked ? "#1ECE99" : "#818D9D"
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.checked = true
                        }
                    }
                }
            }


            StackLayout {
                width: parent.width
                height:parent.height - tabTitle.height
                anchors.top: tabTitle.bottom
                anchors.topMargin: 15 * dpi
                currentIndex: tabTitle.currentIndex

                ListModel {
                    id:listModelItem
                    ListElement {
                        itemCount:3
                    }

                    ListElement {
                        itemCount:8
                    }

                    ListElement {
                        itemCount:2
                    }

                    ListElement {
                        itemCount:5
                    }
                }

                Repeater {
                    model: listModelItem
                    delegate: Item {
                        ScrollView {
                            anchors.fill: parent

                            GridView {
                                anchors.fill: parent
                                model: itemCount
                                clip: true
                                cellWidth:width / 4
                                cellHeight: 300 * dpi
                                delegate: Rectangle {
                                    width: 225 * dpi
                                    height: 290 * dpi
                                    color: "#222733"
                                    radius: 10 * dpi
                                    Column {
                                        anchors.centerIn: parent
                                        Rectangle {
                                            id:rectImage
                                            width: 225 * dpi
                                            height: 180 * dpi
                                            color: "transparent"
                                            Image {
                                                source: ""
                                                anchors.fill: parent
                                            }
                                        }

                                        Rectangle {
                                            width: 225 * dpi
                                            height: parent.parent.height - rectImage.height
                                            color: "transparent"
                                            Column {
                                                anchors.verticalCenter: parent.verticalCenter
                                                Rectangle {
                                                    width: parent.parent.width
                                                    height: textName.height
                                                    color: "transparent"
                                                    clip: true
                                                    Text {
                                                        id:textName
                                                        text:"遗迹4终极版"
                                                        width: parent.width
                                                        elide: Text.ElideRight
                                                        font.pixelSize: 13 * dpi
                                                        font.bold: true
                                                        color: "white"
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 10 * dpi
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                }


                                                Rectangle {
                                                    width: parent.parent.width
                                                    height: textDesc.height
                                                    color: "transparent"
                                                    Text {
                                                        id:textDesc
                                                        text:"第一射击 动作 剧情"
                                                        width: parent.width
                                                        elide: Text.ElideRight
                                                        font.pixelSize: 11 * dpi
                                                        color: "white"
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 10 * dpi
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                }


                                                Rectangle {
                                                    width: parent.parent.width
                                                    height: 60 * dpi
                                                    color: "transparent"


                                                    Rectangle {
                                                        width: 120 * dpi
                                                        height: 30 * dpi
                                                        color: "transparent"
                                                        anchors.left: parent.left
                                                        anchors.leftMargin: 10 * dpi
                                                        anchors.bottom: parent.bottom
                                                        anchors.bottomMargin: 10 * dpi
                                                        Text {
                                                            id:textVal
                                                            text :"2000"
                                                            font.pixelSize: 18 * dpi
                                                            font.bold: true
                                                            color: "#00D9B2"
                                                            anchors.bottom: parent.bottom
                                                            anchors.left: parent.left
                                                        }

                                                        Text {
                                                            text :"积分"
                                                            font.pixelSize: 10 * dpi
                                                            color: "#00D9B2"
                                                            anchors.bottom: textVal.bottom
                                                            anchors.bottomMargin: 3 * dpi
                                                            anchors.left: textVal.right
                                                            anchors.leftMargin: 5 * dpi
                                                        }
                                                    }



                                                    Rectangle {
                                                        width: 60 * dpi
                                                        height: 30 * dpi
                                                        radius: 20 * dpi
                                                        color: "#214546"
                                                        border.width: 1
                                                        border.color: "#00D9B2"
                                                        anchors.right: parent.right
                                                        anchors.rightMargin: 10 * dpi
                                                        anchors.bottom: parent.bottom
                                                        anchors.bottomMargin: 10 * dpi
                                                        Text {
                                                            text:"兑换"
                                                            font.pixelSize: 12 * dpi
                                                            color: "white"
                                                            anchors.centerIn: parent
                                                        }

                                                        MouseArea {
                                                            anchors.fill: parent
                                                            hoverEnabled: true
                                                            cursorShape: Qt.PointingHandCursor
                                                            onClicked: {

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
                }

            }

        }


    }


}
