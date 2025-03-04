import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import OrderListTableModel 1.0
import GamesOrderTableModel 1.0

Item {
    property int rowHeight: 25 * dpi
    property int headerHeight: 30 * dpi
    //property model columnWidth: [100,200,200,200,200,200]

    ListModel {
        id:listModel
        ListElement {caption:"订单编号"; clowidth:190}
        ListElement {caption:"下单时间"; clowidth:150}
        ListElement {caption:"商品"; clowidth:150}
        ListElement {caption:"数量"; clowidth:60}
        ListElement {caption:"合计消费"; clowidth:100}
        ListElement {caption:"支付方式"; clowidth:100}
        ListElement {caption:"订单状态"; clowidth:100}
        ListElement {caption:"操作"; clowidth:80}
    }

    Row {
        id:rectHead
        height: headerHeight
        width: parent.width
        anchors.top: parent.top
        anchors.left: parent.left
        spacing: 1
        Repeater {
            model: listModel
            delegate: Rectangle {
                width: clowidth * dpi
                height: parent.height
                color: "#222733"
                Text {
                    text:caption
                    font.pixelSize: 12 * dpi
                    anchors.centerIn: parent
                    color: "#A4A6AB"
                }
            }
        }
    }

    ListView {
        id:listView
        width: parent.width
        height: parent.height - rectHead.height
        anchors.top: rectHead.bottom
        anchors.topMargin: 1
        anchors.left: parent.left
        spacing: 1
        model: 15
        clip: true
        delegate: Rectangle {
            id:rectDel
            width: parent.width
            height: rowHeight
            color: "transparent"
            Row {
                height: rowHeight
                spacing: 1
                Repeater {
                    id:repTer
                    model:listModel
                    delegate: Rectangle {
                        width: clowidth * dpi
                        height: rowHeight
                        color: "#222733"
                        Text {
                            anchors.centerIn: parent
                            text:"111"
                            font.pixelSize: 12 * dpi
                            color: "#A4A6AB"
                        }
                    }
                }
            }
        }
    }
}
