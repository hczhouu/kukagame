import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

//import FtpClient 1.0
import Qt.labs.platform 1.1
//import TransferCompleteListModel 1.0

//我的云盘页面
Item {

//    TransferCompleteListModel{
//        id:transferCompleteListModel
//    }

    Rectangle {
        id:rectTabBtn
        width: parent.width
        height: 30 * dpi
        color: "transparent"
        anchors.top: parent.top
        anchors.left: parent.left
        Rectangle {
            width: 960 * dpi
            height: parent.height
            color: "transparent"
            anchors.centerIn: parent

            TabBar {
                width: parent.width
                height: 30 * dpi
                anchors.top: parent.top
                background: Rectangle {
                    color: "transparent"
                }

                ListModel {
                    id:listModelTabBtn
                    ListElement {
                        name:"全部文件"
                        icon_path:"../res/v2/icon_files.png"
                        icon_path_sel:"../res/v2/icon_files_sel.png"
                    }

                    ListElement {
                        name:"正在下载"
                        icon_path:"../res/v2/icon_download.png"
                        icon_path_sel:"../res/v2/icon_download_sel.png"
                    }

                    ListElement {
                        name:"正在上传"
                        icon_path:"../res/v2/icon_upload.png"
                        icon_path_sel:"../res/v2/icon_upload_sel.png"
                    }

                    ListElement {
                        name:"传输完成"
                        icon_path:"../res/v2/icon_finished.png"
                        icon_path_sel:"../res/v2/icon_finished_sel.png"
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
                        width: 120 * dpi
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
                        }


                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                parent.checked = true
                                parent.forceActiveFocus()
                                stackLayout.currentIndex = index
                            }
                        }
                    }
                }
            }

        }
    }

    Rectangle {
        width: parent.width
        height: parent.height - rectTabBtn.height - 30 * dpi
        color: "transparent"
        anchors.top: rectTabBtn.bottom
        anchors.topMargin: 10 * dpi
        Rectangle {
            width: 960 * dpi
            height: parent.height
            color: "transparent"
            anchors.centerIn: parent
            StackLayout {
                id:stackLayout
                anchors.fill: parent
                currentIndex: 0

                //全部文件
                CloudDiskAllFile{

                }

                //正在下载
                CloudDiskDownload {

                }

                //正在上传
                CloudDiskUpload {

                }

                //传输完成
                CloudDiskTransferFinished {

                }

            }
        }
    }

}
