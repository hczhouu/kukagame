import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

//云盘下载完成
Item {
    Rectangle {
        anchors.fill: parent
        color: "#1D222E"
        radius: 10
        Rectangle {
            anchors.fill: parent
            anchors.margins: 14 * dpi
            color: "transparent"

            Text {
                id:textTitle
                text:"传输完成"
                font.pixelSize: 16 * dpi
                color: "white"
                anchors.left: parent.left
                anchors.top:parent.top
            }

            Rectangle {
                id:rectHeaders
                width: parent.width
                height: 40 * dpi
                color: "#222733"
                anchors.left: parent.left
                anchors.top: textTitle.bottom
                anchors.topMargin: 10 * dpi
                border.width: 1
                border.color: "#2B303C"
                Row {
                    spacing: 10 * dpi
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        text:"传输完成"
                        font.pixelSize: 16 * dpi
                        color: "#818D9D"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text:transferCompTable.rowCount.toString()
                        font.pixelSize: 16 * dpi
                        color: "#E5BF97"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text:"个文件"
                        font.pixelSize: 16 * dpi
                        color: "#818D9D"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            ScrollView {
                width: parent.width
                height: parent.height
                anchors.top: rectHeaders.bottom
                anchors.bottom: parent.bottom
                TransferCompleteTableView {
                    id:transferCompTable
                    anchors.fill: parent
                }
            }
        }
    }
}
