import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15

import QtQuick.Dialogs 1.2
import FtpClient 1.0


//云盘全部文件
Item {

    Connections {
        target: HttpClient
        //登录成功
        function onLoginSuccess()
        {
            FtpClient.loginSrv()
        }
    }


    FileDialog {
        id: fileDialog
        title: "选择文件"
        selectFolder:false
        selectMultiple: true
        folder: shortcuts.desktop
        nameFilters: ["所有文件 (*.*)"]
        onAccepted: {
            fileDialog.close()
            var fileList = []
            for (var i in fileDialog.fileUrls) {
                fileList.push(fileDialog.fileUrls[i])
            }

            FtpClient.transferFiles(false, fileList)
        }

        onRejected: {
            fileDialog.close()
        }
    }

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
                text:"我的文件"
                font.pixelSize: 16 * dpi
                color: "white"
                anchors.left: parent.left
                anchors.top:parent.top
            }


            //工具按钮
            Rectangle {
                id:rectBtns
                width: parent.width
                height: 40 * dpi
                color: "transparent"
                anchors.left: parent.left
                anchors.top: textTitle.bottom
                anchors.topMargin: 10 * dpi
                Row {
                    spacing: 15 * dpi
                    anchors.fill: parent
                    Button {
                        width: 100 * dpi
                        height: parent.height
                        background: Rectangle {
                            color: "#222733"
                            radius: 5
                            border.width: 1
                            border.color: "#2B303C"
                            Row {
                                spacing: 10 * dpi
                                anchors.centerIn: parent
                                Image {
                                    source: "../res/newVersion/icon_min_upload.png"
                                    fillMode: Image.PreserveAspectFit
                                    anchors.verticalCenter: parent.verticalCenter
                                    scale: dpi
                                }

                                Text {
                                    text:"上传"
                                    font.pixelSize: 16 * dpi
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: "#6C707B"
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                parent.forceActiveFocus()
                                fileDialog.open()
                            }
                        }
                    }


                    //新建文件夹
                    Button {
                        width: 150 * dpi
                        height: parent.height
                        background: Rectangle {
                            color: "#222733"
                            radius: 5
                            border.width: 1
                            border.color: "#2B303C"
                            Row {
                                spacing: 10 * dpi
                                anchors.centerIn: parent
                                Image {
                                    source: "../res/newVersion/icon_add_folder.png"
                                    fillMode: Image.PreserveAspectFit
                                    anchors.verticalCenter: parent.verticalCenter
                                    scale: dpi
                                }

                                Text {
                                    text:"新建文件夹"
                                    font.pixelSize: 16 * dpi
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: "#6C707B"
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                parent.forceActiveFocus()
                                showPopup('AddFolderPopup.qml')
                            }
                        }
                    }

                    //下载
                    Button {
                        width: 100 * dpi
                        height: parent.height
                        background: Rectangle {
                            color: "#222733"
                            radius: 5
                            border.width: 1
                            border.color: "#2B303C"
                            Row {
                                spacing: 10 * dpi
                                anchors.centerIn: parent
                                Image {
                                    source: "../res/newVersion/icon_min_down.png"
                                    fillMode: Image.PreserveAspectFit
                                    anchors.verticalCenter: parent.verticalCenter
                                    scale: dpi
                                }

                                Text {
                                    text:"下载"
                                    font.pixelSize: 16 * dpi
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: "#6C707B"
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                parent.forceActiveFocus()
                                var fileList = []
                                FtpClient.transferFiles(true, fileList)
                                allFilesListView.selectAllItem(false)
                            }
                        }
                    }

                    //删除
                    Button {
                        width: 100 * dpi
                        height: parent.height
                        background: Rectangle {
                            color: "#222733"
                            radius: 5
                            border.width: 1
                            border.color: "#2B303C"
                            Row {
                                spacing: 10 * dpi
                                anchors.centerIn: parent
                                Image {
                                    source: "../res/newVersion/icon_min_del.png"
                                    fillMode: Image.PreserveAspectFit
                                    anchors.verticalCenter: parent.verticalCenter
                                    scale: dpi
                                }

                                Text {
                                    text:"删除"
                                    font.pixelSize: 16 * dpi
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: "#6C707B"
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                parent.forceActiveFocus()
                                FtpClient.deleteFiles()
                                allFilesListView.selectAllItem(false)
                            }
                        }
                    }
                }
            }

            Rectangle {
                id:rectMinBtns
                width: parent.width
                height: 35 * dpi
                anchors.left: parent.left
                anchors.top: rectBtns.bottom
                anchors.topMargin: 10 * dpi
                color: "#222733"
                border.width: 1
                border.color: "#2B303C"
                //后退
                Button {
                    id:btnBack
                    anchors.left: parent.left
                    anchors.leftMargin: 20 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    background: Image {
                        source: "../res/newVersion/icon_left_arrow.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.forceActiveFocus()
                            FtpClient.backFolder()
                        }
                    }
                }

                //刷新
                Button {
                    id:btnRefresh
                    anchors.left: btnBack.right
                    anchors.leftMargin: 20 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    background: Image {
                        source: "../res/newVersion/icon_min_refresh.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.forceActiveFocus()
                            FtpClient.refreshFolder()
                        }
                    }
                }

                Button {
                    id:btnSwitchList
                    checkable: true
                    checked: false
                    anchors.right: parent.right
                    anchors.rightMargin: 20 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                    background: Image {
                        source: btnSwitchList.checked ? "../res/newVersion/icon_grid.png" :
                                                        "../res/newVersion/icon_list.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.forceActiveFocus()
                            btnSwitchList.checked = !btnSwitchList.checked
                            allFilesListView.showGridView = !btnSwitchList.checked
                        }
                    }
                }
            }


            ScrollView {
                width: parent.width
                height: parent.height
                anchors.top: rectMinBtns.bottom
                anchors.bottom: parent.bottom

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.width: 1
                    border.color: "#3D414B"
                    visible: allFilesListView.rowCount > 0 && !allFilesListView.showGridView
                }

                CloudDiskTableView {
                    id:allFilesListView
                    anchors.fill: parent
                }

            }

        }
    }
}
