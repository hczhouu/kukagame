import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import FtpClient 1.0


//云盘正在上传
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
                text:"我的上传"
                font.pixelSize: 16 * dpi
                color: "white"
                anchors.left: parent.left
                anchors.top:parent.top
            }

            Rectangle {
                id: rectHeaderBtns
                width: parent.width
                height: 40 * dpi
                color: "#222733"
                anchors.left: parent.left
                anchors.top: textTitle.bottom
                anchors.topMargin: 10 * dpi
                border.width: 1
                border.color: "#2B303C"
                Text {
                    id:textPorgress
                    text:"上传速度"
                    font.pixelSize: 16 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id:textSpeed
                    text:FtpClient.uploadSpeed
                    font.pixelSize: 16 * dpi
                    color: "#E5BF97"
                    anchors.left: textPorgress.right
                    anchors.leftMargin: 10 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }

            }

            ScrollView {
                width: parent.width
                height: parent.height
                anchors.top: rectHeaderBtns.bottom
                anchors.bottom: parent.bottom
                CloudDiskUploadTableView {
                    id:uploadTable
                    anchors.fill: parent
                }
            }
        }
    }
}
