import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml.Models 2.3

import FtpClient 1.0
import UploadListModel 1.0


Item {
    //表格内容（不包含表头）
    id:controls
    property int modelIndex: 0
    //列宽
    property variant columnWidthArr: [360 * dpi,180 * dpi,200 * dpi,150 * dpi]
    property int selIndex: -1
    property int rowCount: listView.count
    property int currIndex: -1


    UploadListModel{
        id:uploadListModel
    }

    Rectangle {
        id:rectHeader
        width: parent.width
        height: 30 * dpi
        anchors.top: parent.top
        anchors.left: parent.left
        color: "transparent"
        clip: true
        Row {
            spacing: 1
            anchors.centerIn: parent
            Rectangle {
                width: rectHeader.width - rectHeadFileSize.width -
                       rectHeadProgress.width - rectHeadOperation.width
                height: 30 * dpi
                color: "#222733"
                Text {
                    text:"文件名称"
                    font.pixelSize: 14 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 9 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                id:rectHeadFileSize
                width: 150 * dpi
                height: 30 * dpi
                color: "#222733"
                Text {
                    text:"大小"
                    font.pixelSize: 14 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 5 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                id:rectHeadProgress
                width: 200 * dpi
                height: 30 * dpi
                color: "#222733"
                Text {
                    text:"进度"
                    font.pixelSize: 14 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 5 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                id:rectHeadOperation
                width: 120 * dpi
                height: 30 * dpi
                color: "#222733"
                Text {
                    text:"操作"
                    font.pixelSize: 14 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 5 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }


    ListView {
        id:listView
        width: parent.width
        height: parent.height - rectHeader.height
        anchors.top: rectHeader.bottom
        anchors.topMargin: 1
        clip: true
        spacing: 1
        focus: true
        currentIndex: -2
        model: uploadListModel
        delegate: Rectangle {
            width: listView.width
            height: 35 * dpi
            color: "transparent"
            Row {
                visible: true
                spacing: 1
                anchors.centerIn: parent
                Rectangle {
                    id:rectFileName
                    width: listView.width - rectProgress.width - rectFileSize.width -
                           rectOperation.width
                    height: 35 * dpi
                    color: currIndex === index ? "#3D414B" : "#222733"
                    clip: true

                    Rectangle {
                        id:rectIcon
                        width: 32 * dpi
                        height: 32 * dpi
                        color: "transparent"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5 * dpi
                        Image {
                            anchors.centerIn: parent
                            source: fileIcon
                            fillMode: Image.PreserveAspectFit
                            scale: 0.3 * dpi
                        }
                    }


                    Text {
                        id:textFileName
                        text:fileName
                        font.pixelSize: 14 * dpi
                        color: "white"
                        anchors.left: rectIcon.right
                        anchors.leftMargin: 5 * dpi

                        anchors.verticalCenter: parent.verticalCenter
                        clip: true
                        elide: Text.ElideRight

                        ToolTip {
                            id:toolTips
                            delay: 700
                            timeout: 3000
                            visible: false
                            text: textFileName.text
                            font.pixelSize: 15 * dpi
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onDoubleClicked: {
                            parent.forceActiveFocus()
                            if (!isFolder)
                            {
                                return
                            }

                            FtpClient.browseFolder(fileName)
                        }

                        onEntered:{
                            currIndex = index
                            toolTips.visible = true
                        }

                        onExited: {
                            currIndex = -1
                            toolTips.visible = false
                        }
                    }
                }

                Rectangle {
                    id:rectFileSize
                    width: 150 * dpi
                    height: 35 * dpi
                    color: currIndex === index ? "#3D414B" : "#222733"
                    clip: true
                    Text {
                        text:fileSize
                        font.pixelSize: 14 * dpi
                        color: "white"
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.verticalCenter: parent.verticalCenter
                        clip: true
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered:{
                            currIndex = index
                        }

                        onExited: {
                            currIndex = -1
                        }
                    }
                }

                Rectangle {
                    id:rectProgress
                    width: 200 * dpi
                    height: 35 * dpi
                    color: currIndex === index ? "#3D414B" : "#222733"
                    clip: true

                    ProgressBar {
                        id:progressBar
                        width: parent.width  - 10
                        height: 12 * dpi
                        from: 0
                        to:totalSize
                        value: uploadSize
                        anchors.centerIn: parent
                        background: Rectangle {
                            implicitHeight: progressBar.height
                            implicitWidth: progressBar.width
                            color: "#AEBBCC"
                            radius: 10
                        }

                        contentItem: Item {
                            Rectangle {
                                implicitHeight: progressBar.height
                                implicitWidth: progressBar.visualPosition * progressBar.width
                                color: "#F67D04"
                                radius: 10
                            }
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered:{
                            currIndex = index
                        }

                        onExited: {
                            currIndex = -1
                        }
                    }
                }

                Rectangle {
                    id:rectOperation
                    width: 120 * dpi
                    height: 35 * dpi
                    color: currIndex === index ? "#3D414B" : "#222733"
                    clip: true


                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered:{
                            currIndex = index
                        }

                        onExited: {
                            currIndex = -1
                        }
                    }

                    Row {
                        spacing: 20 * dpi
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.verticalCenter: parent.verticalCenter
                        Button {
                            width: 20 * dpi
                            height: 20 * dpi
                            anchors.verticalCenter: parent.verticalCenter
                            background: Rectangle {
                                color: "transparent"
                                Image {
                                    anchors.centerIn: parent
                                    source: "../res/newVersion/icon_folder_min.png"
                                    fillMode: Image.PreserveAspectFit
                                    scale: dpi
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    parent.forceActiveFocus()
                                    FtpClient.openUploadDir(filePath)
                                }
                            }

                        }
                    }

                }

            }
        }

    }
}




