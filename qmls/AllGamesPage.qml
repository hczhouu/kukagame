import QtQuick 2.6
import QtQuick.Window 2.6
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import HomePage 1.0
import GameLabelModel 1.0
import GameLabelListModel 1.0
import GameDetails 1.0

Item {
    Connections {
        target: GameLabelModel
        function onGetDataSuccess()
        {
            loadingLabel.visible = false
            loaderLabelList.sourceComponent = compLabelList
        }
    }

    Connections {
        target: GameLabelListModel
        function onGetDataSuccess()
        {
            loadingGameList.visible = false
            if (GameLabelListModel.rowCount() > 0)
            {
                textNoResult.visible = false
                loaderGameList.sourceComponent = compGameList
            } else {
                textNoResult.visible = true
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        contentHeight: rect.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        clip: true

        Rectangle {
            id:rect
            width: parent.width
            height: 720 * dpi
            color: "transparent"

            Rectangle {
                id:rectGameLables
                width: 980 * dpi
                height: 130 * dpi
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top

                Loading {
                    id:loadingLabel
                    anchors.centerIn: parent
                    visible: true
                }

                ButtonGroup {
                    id:btnGroup
                    exclusive: true
                }

                Loader {
                    id:loaderLabelList
                    anchors.fill: parent
                }

                Component {
                    id:compLabelList
                    GridView {
                        id:gridViewLabel
                        anchors.fill: parent
                        model:GameLabelModel
                        cellWidth: parent.width / 7
                        cellHeight:56 * dpi
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        delegate: Rectangle {
                            width: gridViewLabel.width / 7
                            height:56 * dpi
                            color: "transparent"
                            Button {
                                id:btnLable
                                width: 120 * dpi
                                height: 46 * dpi
                                checkable:true
                                checked: index === 0
                                ButtonGroup.group: btnGroup
                                anchors.horizontalCenter: parent.horizontalCenter
                                background: Rectangle {
                                    border.width: 1
                                    border.color: "#222939"
                                    color: btnLable.checked ? "#252D3E" : "transparent"

                                    Row {
                                        spacing: 5 * dpi
                                        anchors.centerIn: parent
                                        Image {
                                            visible: labelText === '全部游戏'
                                            source: "../res/v2/all_icon.png"
                                            fillMode: Image.PreserveAspectFit
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        Text {
                                            text:labelText
                                            font.pixelSize: 15 * dpi
                                            color: "#A4A6AB"
                                            elide: Text.ElideRight
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        parent.checked = true
                                        parent.forceActiveFocus()
                                        HomePage.getGameListByLabel(GameLabelListModel, labelId)
                                    }
                                }

                            }

                        }
                    }
                }

            }

            Button {
                id:imageExpand
                width: 20 * dpi
                height: 10 * dpi
                checkable: true
                checked: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectGameLables.bottom
                anchors.topMargin: 20 * dpi
                background: Rectangle {
                    color: "transparent"
                    Image {
                        source: imageExpand.checked ? "../res/v2/expand_icon.png" :
                                                      "../res/v2/expand_icon_up.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape:Qt.PointingHandCursor
                    onClicked: {
                        parent.forceActiveFocus()
                        if(imageExpand.checked)
                        {
                            rectGameLables.height = 220
                        } else {
                            rectGameLables.height = 130
                        }

                        imageExpand.checked = !imageExpand.checked
                    }
                }
            }



            Rectangle {
                id:rectSearch
                width: 960 * dpi
                height: 40 * dpi
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: imageExpand.bottom
                anchors.topMargin: 20 * dpi
                Rectangle {
                    width: 300 * dpi
                    height: 40 * dpi
                    color: "#313744"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    radius:10
                    border.width: 1
                    border.color: "#222939"

                    Rectangle {
                        id:rectSearchBtn
                        width: 40 * dpi
                        height: 23 * dpi
                        color: "transparent"
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        Image {
                            source: "../res/v2/search.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
                            scale: dpi * 0.8
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                parent.forceActiveFocus()
                                if (textKeyWords.text.length === 0 || textKeyWords.text === null)
                                {
                                    textKeyWords.text = textKeyWords.placeholderText
                                    HomePage.gameSearch(textKeyWords.placeholderText)
                                } else {
                                    HomePage.gameSearch(textKeyWords.text)
                                }
                            }
                        }
                    }

                    TextField {
                        id:textKeyWords
                        width: parent.width - rectSearchBtn.width - 10 * dpi
                        height: parent.height
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        selectByMouse:true
                        selectedTextColor: "white"
                        placeholderText: qsTr("双人成行")
                        placeholderTextColor: "#64FFFFFF"
                        color: "white"
                        font.pixelSize: 16 * dpi
                        background: Rectangle {
                            color:"transparent"
                        }
                    }
                }
            }

            Rectangle {
                width: 980 * dpi
                height: 465 * dpi
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: rectSearch.bottom
                anchors.topMargin: 20 * dpi

                Text {
                    id:textNoResult
                    anchors.centerIn: parent
                    text:"暂无结果"
                    font.pixelSize: 14 * dpi
                    color: "#A4A6AB"
                    visible: false
                }

                Loading {
                    id:loadingGameList
                    anchors.centerIn: parent
                    visible: true
                }

                Loader {
                    id:loaderGameList
                    anchors.fill: parent
                }


                Component {
                    id:compGameList
                    GridView {
                        id:gameListView
                        model:GameLabelListModel
                        anchors.fill: parent
                        cellHeight: 168 * dpi
                        cellWidth: parent.width / 4
                        clip: true
                        boundsBehavior: Flickable.StopAtBounds
                        delegate: Rectangle {
                            height: 168 * dpi
                            width: gameListView.width / 4
                            color: "transparent"

                            Rectangle {
                                width: 225 * dpi
                                height: 126 * dpi
                                color: "transparent"
                                anchors.horizontalCenter: parent.horizontalCenter

                                Image {
                                    id:imageItem
                                    source: gameMainImage
                                    anchors.fill: parent
                                }

                                Loading {
                                    anchors.centerIn: parent
                                    visible: imageItem.status !== Image.Ready
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 35 * dpi
                                    anchors.bottom: parent.bottom
                                    color: "#C81E222E"
                                    Text {
                                        id:textName
                                        text:gameName
                                        font.pixelSize: 14 * dpi
                                        anchors.centerIn: parent
                                        width: parent.width
                                        elide: Text.ElideRight
                                        color: "#A4A6AB"
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        //跳转到游戏详情
                                        parent.forceActiveFocus()
                                        selIndex = 6
                                        showSearchInput = false
                                        showBackButton = true
                                        isAllGamesPageEntry = true
                                        GameDetails.getGameDetailsInfo(gameId, "")
                                    }

                                    onEntered: {
                                        textName.color = "white"
                                    }

                                    onExited: {
                                        textName.color = "#A4A6AB"
                                    }
                                }
                            }

                        }
                    }
                }
            }
        }
    }
}
