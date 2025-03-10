import QtQuick 2.5
import QtQuick.Controls 2.5

Rectangle {
    width: 286 * dpi
    height:180 * dpi
    color: "transparent"
    property string goods_id: ""
    property string goods_name: ""
    property string original_Price: ""
    property string pay_Amount: ""
    property string order_Amount: ""
    property string goods_desc: ""
    property string remark: ""
    property int meal_Type: 1  //1时长卡 2周期卡
    property int limit_Time: 0
    property int total_Time: 0
    property string label_tips: ""
    property bool showLabel: false
    property bool showBuyBtn: true

    radius: 10
    Image {
        source: "../res/v2/card_bk.png"
        anchors.fill: parent
    }

    Column {
        spacing: 5 * dpi
        anchors.left: parent.left
        anchors.leftMargin: 15 * dpi
        anchors.top: parent.top
        anchors.topMargin: 15 * dpi
        Text {
            width: 175 * dpi
            text:goods_name
            font.pixelSize: 16 * dpi
            font.bold: true
            color: "white"
            elide: Text.ElideRight
            ToolTip.text: goods_name
            ToolTip.visible: mouseTextName.containsMouse
            MouseArea {
                id:mouseTextName
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        Text {
            width: 240 * dpi
            text:goods_desc
            font.pixelSize: 14 * dpi
            color: "#ACAFB4"
            elide: Text.ElideRight
            ToolTip.text: goods_desc
            ToolTip.visible: mouseTextDesc.containsMouse
            MouseArea {
                id:mouseTextDesc
                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }

    Rectangle {
        width: 90 * dpi
        height: 28 * dpi
        color: "transparent"
        radius: 20
        anchors.right: parent.right
        anchors.rightMargin: 10 * dpi
        anchors.top: parent.top
        anchors.topMargin: 10 * dpi
        visible: showLabel
        Image {
            source: "../res/v2/lable_bk.png"
            anchors.fill: parent
        }

        Text {
            text:label_tips
            font.pixelSize: 12 * dpi
            font.bold: true
            font.italic: true
            color: "white"
            width: parent.width
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
            ToolTip.text: remark
            ToolTip.visible: mouseTextTips.containsMouse
            MouseArea {
                id:mouseTextTips
                anchors.fill: parent
                hoverEnabled: true
            }
        }
    }


    Image {
        source: "../res/v2/spliter_line.png"
        fillMode: Image.PreserveAspectFit
        anchors.horizontalCenter: parent.horizontalCenter
        scale: dpi
        anchors.top: parent.top
        anchors.topMargin: 75 * dpi
    }

    Rectangle {
        width: 190 * dpi
        height: 70 * dpi
        anchors.left: parent.left
        anchors.leftMargin: 15 * dpi
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20 * dpi
        color: "transparent"
        Column {
            width: parent.width
            spacing: 15 * dpi
            anchors.verticalCenter: parent.verticalCenter
            Row {
                spacing: 5 * dpi
                width: parent.width
                Text {
                    id:textPrice
                    text:"￥" + pay_Amount
                    font.pixelSize: 24 * dpi
                    color: "#00D9B2"
                    clip: true
                    elide: Text.ElideRight
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text:"￥" + original_Price
                    width:100 * dpi
                    font.pixelSize: 16 * dpi
                    font.strikeout: true
                    color: "#ACAFB4"
                    clip: true
                    elide: Text.ElideRight
                    anchors.bottom: parent.bottom
                }
            }

            Text {
                text:remark
                font.pixelSize: 14 * dpi
                color: "#ACAFB4"
                visible: remark !== ''
                width: parent.width
                clip: true
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                ToolTip.text: remark
                ToolTip.visible: mouseTextRemark.containsMouse
                MouseArea {
                    id:mouseTextRemark
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }
        }

    }

    Rectangle {
        width: 60 * dpi
        height: 30 * dpi
        color: "#294E4E"
        border.width: 1
        border.color: "#00D9B2"
        anchors.right: parent.right
        anchors.rightMargin: 15 * dpi
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 33 * dpi
        radius: 20
        visible: showBuyBtn
        Text {
            text:"购买"
            font.pixelSize: 12 * dpi
            color: "white"
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape:Qt.PointingHandCursor
            onClicked: {
                parent.forceActiveFocus()
                showSearchResult = false

                HttpClient.createOrder(goods_id, pay_Amount)
                payPop.name = goods_name
                payPop.payAmount = pay_Amount
                payPop.orderAmount = order_Amount
                payPop.origPrice = original_Price
                payPop.show_Label = showLabel
                payPop.labelTips = label_tips
                payPop.limTime =  limit_Time
                payPop.desc = goods_desc
                payPop.goodsRemark = remark
                payPop.isBuyVIP = false
                payPop.open()
            }
        }
    }
}
