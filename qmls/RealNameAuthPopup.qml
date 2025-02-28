import QtQuick 2.15
import QtQuick.Window 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

// 实名认证弹窗
Popup {
    id:realNamePopup
    width:820 * dpi
    height:590 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: parent
    background:Rectangle {
        color: "transparent"
    }

    onOpened:{
        errTips.text  = ""
        textInputName.clear()
        textInputIdCard.clear()
    }


    Rectangle {
        id:rectTitle
        width: parent.width
        height: 90 * dpi
        color: "transparent"
        anchors.top: parent.top

        Image {
            source: "../res/v2/realnameauth_bk.png"
            anchors.fill: parent
        }

        Text {
            text:"实名认证"
            font.pixelSize: 18 * dpi
            font.bold: true
            color: "#12C195"
            anchors.centerIn: parent
        }

        Image {
            source: "../res/v2/popup_close.png"
            anchors.right: parent.right
            anchors.rightMargin: 20 * dpi
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    realNamePopup.close()
                }
            }
        }
    }


    Rectangle {
        width: parent.width
        height: parent.height - rectTitle.height
        color: "transparent"
        anchors.bottom: parent.bottom

        Image {
            source: "../res/v2/realnameauth_bk_01.png"
            anchors.fill: parent
        }

        TextArea {
            font.pixelSize: 14 * dpi
            color: "#131A25"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 45 * dpi
            anchors.left: rectRealName.left
            wrapMode: Text.WordWrap
            enabled: false
            text:"为响应落实国家新闻出版署下发的《关于进一步严格管理 切实防止未成年人沉迷网络游戏的通知》酷卡云未实名认证用户的游戏体验将受到限制，请您尽快完成实名认证，畅玩云游戏。"
        }

        //真实姓名
        Rectangle {
            id:rectRealName
            width: 740 * dpi
            height:60 * dpi
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 134 * dpi
            Image {
                source: "../res/v2/realnameauth_edit.png"
                anchors.fill: parent
            }

            Rectangle {
                id:rectNameIcon
                width: 60 * dpi
                height: parent.height
                color: "transparent"

                Image {
                    anchors.centerIn: parent
                    source: "../res/v2/realnameauth_name.png"
                    fillMode: Image.PreserveAspectFit
                }

                Rectangle {
                    id:rectLineName
                    width: 1 * dpi
                    height: 24 * dpi
                    color: "#99A8A6"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                }
            }


            TextField {
                id:textInputName
                clip: true
                width:parent.width - rectNameIcon.width - textInputName.leftPadding
                height:parent.height
                anchors.left: rectNameIcon.right
                anchors.leftMargin: 10 * dpi
                font.pixelSize: 14 * dpi
                selectByMouse:true
                selectedTextColor: "white"
                background: Rectangle {
                    color: "transparent"
                }

                placeholderText: qsTr("请填写您本人的真实姓名")
                placeholderTextColor: "#99A8A6"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        //身份证号
        Rectangle {
            id:rectIdCard
            width: 740 * dpi
            height:60 * dpi
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: rectRealName.bottom
            anchors.topMargin: 15 * dpi
            Image {
                source: "../res/v2/realnameauth_edit.png"
                anchors.fill: parent
            }

            Rectangle {
                id:rectIdCardIcon
                width: 60 * dpi
                height: parent.height
                color: "transparent"

                Image {
                    anchors.centerIn: parent
                    source: "../res/v2/realnameauth_idcard.png"
                    fillMode: Image.PreserveAspectFit
                }

                Rectangle {
                    width: 1 * dpi
                    height: 24 * dpi
                    color: "#99A8A6"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                }
            }

            TextField {
                id:textInputIdCard
                clip: true
                width:parent.width - rectIdCardIcon.width - textInputIdCard.leftPadding
                height:parent.height
                anchors.left: rectIdCardIcon.right
                anchors.leftMargin: 10 * dpi
                font.pixelSize: 14 * dpi
                selectByMouse:true
                selectedTextColor: "white"
                background: Rectangle {
                    color: "transparent"
                }

                placeholderText: qsTr("请填写您本人的身份证号")
                placeholderTextColor: "#99A8A6"
                anchors.verticalCenter: parent.verticalCenter

            }
        }

        Text {
            id:errTips
            text:""
            color: "red"
            font.pixelSize: 12 * dpi
            anchors.left: rectIdCard.left
            anchors.top: rectIdCard.bottom
        }

        Text {
            id:textAttention
            text:"注意事项\n1.您提供的证件信息将严格保护,仅用于实名认证未经本人许可不会用于其他用途\n2.提交表示已了解并同意酷卡云实名认证"
            font.pixelSize: 14 * dpi
            color: "#889593"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: rectIdCard.left
            anchors.top: rectIdCard.bottom
            anchors.topMargin: 30 * dpi
        }


        Row {
            spacing: 80 * dpi
            anchors.top: textAttention.bottom
            anchors.topMargin: 30 * dpi
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                width: 300 * dpi
                height: 60 * dpi
                background: Rectangle {
                    color: "transparent"
                    border.width: 1
                    border.color: "#12C195"
                    radius: 10
                }

                Text {
                    text:"下次再说"
                    font.pixelSize: 14 * dpi
                    color: "#12C195"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        realNamePopup.close()
                    }
                }
            }

            Button {
                width: 300 * dpi
                height: 60 * dpi
                background: Rectangle {
                    color: "#12C195"
                    radius: 10
                }

                Text {
                    text:"提交认证"
                    font.pixelSize: 14 * dpi
                    color: "white"
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (textInputName.text == null ||
                            textInputName.text === '') {

                            errTips.text = "*真实姓名不能为空"
                            return
                        }

                        if (textInputIdCard.text == null ||
                            textInputIdCard.text === '')
                        {
                            errTips.text = "*身份证号不能为空"
                            return;
                        }

                        HttpClient.realNameAuth(textInputName.text, textInputIdCard.text)
                        realNamePopup.close()
                        errTips.text  = ""
                    }
                }
            }
        }

    }


}
