import QtQuick 2.12
import QtQuick.Window 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

// 智能客服
Popup {
    id:servicePopup
    width:520 * dpi
    height:470 * dpi
    modal:true
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape
    anchors.centerIn: parent

    onClosed: {
        servicePopup.destroy()
    }

    background:Rectangle {
        color: "transparent"

        Rectangle {
            id:rectTitle
            width: parent.width
            height: 90 * dpi
            color: "transparent"
            anchors.top: parent.top

            Image {
                source: "../res/v2/contact_bk.png"
                anchors.fill: parent
            }

            Text {
                text:"智能客服"
                font.pixelSize: 18 * dpi
                font.bold: true
                color: "#12C195"
                anchors.centerIn: parent
            }

            Image {
                source: "../res/v2/popup_close.png"
                fillMode: Image.PreserveAspectFit
                anchors.right: parent.right
                anchors.rightMargin: 20 * dpi
                anchors.verticalCenter: parent.verticalCenter
                scale: dpi

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        servicePopup.close()

                    }
                }
            }
        }


        Rectangle {
            width: parent.width
            height: parent.height - rectTitle.height
            anchors.bottom: parent.bottom
            color: "transparent"
            Image {
                source: "../res/v2/contact_bk_01.png"
                anchors.fill: parent
            }

            Image {
                anchors.centerIn: parent
                source: "../res/v2/service_ocr.jpg"
                fillMode: Image.PreserveAspectFit
            }

        }
    }
}
