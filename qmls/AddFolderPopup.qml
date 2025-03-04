import QtQuick 2.5
import QtQuick.Window 2.5
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import FtpClient 1.0

// 新建文件夹弹窗
Popup {
    id:addFolderPopup
    width:500 * dpi
    height:280 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent

    onOpened: {
        textInput.clear()
        textInput.forceActiveFocus()
    }

    onClosed: {
        addFolderPopup.destroy()
    }

    background: Rectangle {
        color: "transparent"
    }

    Rectangle {
        id:rectTitle
        width: parent.width
        height: 50 * dpi
        color: "#151C27"
        anchors.top: parent.top

        Text {
             text:"新建文件夹"
             font.pixelSize: 18 * dpi
             font.bold: true
             anchors.centerIn: parent
             color: "#1ECE9A"
        }

        Image{
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
                    addFolderPopup.close()
                }
            }
        }
    }


    Rectangle {
        width: parent.width
        height: parent.height - rectTitle.height
        color: "white"
        anchors.bottom: parent.bottom

        Row {
            spacing: 10 * dpi
            anchors.top: parent.top
            anchors.topMargin: 50 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                text:"文件夹名称"
                font.pixelSize: 14 * dpi
                color: "#131A25"
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width:300 * dpi
                height:40 * dpi
                color: "transparent"
                radius: 10
                border.width: 1
                border.color: "#1ECE9A"
                TextField {
                    id:textInput
                    clip: true
                    anchors.fill: parent
                    anchors.margins: 5 * dpi
                    font.pixelSize: 14 * dpi
                    selectByMouse:true
                    selectedTextColor: "white"
                    placeholderText: qsTr("")
                    placeholderTextColor: "#998161"
                    background: Rectangle {
                        color: "transparent"
                    }
                }
            }
        }


        Row {
            spacing: 20 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            height: 60 * dpi
            Button {
                width: 180 * dpi
                height: 60 * dpi
                background: Rectangle {
                    color: "transparent"
                    radius: 10
                    border.width: 1
                    border.color: "#1ECE9B"
                }

                Text {
                    text:"取消"
                    font.pixelSize: 14 * dpi
                    color: "#1ECE9B"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        addFolderPopup.close()
                    }
                }
            }

            Button {
                width: 180 * dpi
                height: 60 * dpi
                background: Rectangle {
                    color: "#1ECE9B"
                    radius: 10
                }

                Text {
                    text:"确认"
                    font.pixelSize: 14 * dpi
                    color: "white"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        var folderName = textInput.text
                        if (folderName === '' ||
                            folderName === null)
                        {
                            return
                        }

                        addFolderPopup.close()
                        FtpClient.addNewFolder(folderName)
                    }
                }
            }
        }

    }
}
