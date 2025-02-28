import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import OrderListTableModel 1.0
import GameDetails 1.0

Item {
    id: control
    property int modelIndex: 0
    //行高
    property int rowHeight: 40 * dpi
    //列表头-横向的
    property int horHeaderHeight: 30 * dpi
    //列宽
    property variant columnWidthArr: []
    property variant models: [orderListmodel, redeemModel, durationTableModel, gameOrderTableModel]
    property int currIndex: -1

    Rectangle {
        anchors.fill: parent
        color: "#1D222E"
        radius: 10

        //表头
        Row {
            id: header_horizontal_row
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            height: 40 * dpi
            clip: true
            spacing: 0

            Repeater {
                model: table_view.columns > 0 ? table_view.columns : 0
                Rectangle {
                    id: header_horizontal_item
                    //width: table_view.columnWidthProvider(index) + table_view.columnSpacing
                    width: control.columnWidthArr[index] * dpi + 1
                    height: horHeaderHeight
                    anchors.bottom: parent.bottom
                    color: "#222733"
                    clip: true
                    Text {
                        anchors.centerIn: parent
                        text: models[modelIndex].headerData(index, Qt.Horizontal)
                        clip: true
                        color: "#A4A6AB"
                        font.pixelSize: 13 * dpi
                    }

                    Rectangle{
                        width: 1
                        height: parent.height
                        anchors.right: parent.right
                        color: "#1B1E23"
                    }

                }
            }
        }

        //表格内容
        TableView {
            id: table_view
            width: contentWidth
            height: parent.height - header_horizontal_row.height - 10
            anchors.horizontalCenter: header_horizontal_row.horizontalCenter
            anchors.top: header_horizontal_row.bottom
            anchors.topMargin: 1
            anchors.left: header_horizontal_row.left

            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar{}
            columnSpacing: 1
            rowSpacing: 1
            //返回行高
            rowHeightProvider: function (row) {
                return control.rowHeight;
            }

            //返回列宽
            columnWidthProvider: function (column) {
                return control.columnWidthArr[column] * dpi;
            }

            model: models[modelIndex]
            delegate: Rectangle {
                id:rectCurrentRow
                color: model.row === currIndex ? "#3D414B" : "#272B34"
                clip: true
                Text {
                    id:textContent
                    anchors.centerIn: parent
                    width: parent.width * 0.95
                    elide: Text.ElideMiddle
                    horizontalAlignment: Text.AlignHCenter
                    color: model.row === currIndex ? "white" : "white"
                    text: model.value
                    clip: true
                    font.pixelSize: 13 * dpi
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        currIndex = row
                        if (textContent.text === '查看详情')
                        {
                            cursorShape = Qt.PointingHandCursor
                            textContent.font.underline = true
                        }
                    }

                    onExited: {
                        currIndex = -1
                        if (textContent.text === '查看详情')
                        {
                            cursorShape = Qt.ArrowCursor
                            textContent.font.underline = false
                        }
                    }

                    onClicked: {
                        if (textContent.text === '查看详情')
                        {
                            var orderSn = models[modelIndex].getData(row, column)
                            gameOrderPopup.orderSn = orderSn
                            gameOrderPopup.open()
                        }
                    }
                }
            }

        }

    }
}
