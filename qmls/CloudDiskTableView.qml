import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml.Models 2.3

import FtpClient 1.0
import AllFilesListModel 1.0

Item {
    //表格内容（不包含表头）
    id:controls
    property int modelIndex: 0
    //列宽
    property variant columnWidthArr: [50,260,230,200,150]
    property int selIndex: -1
    property int rowCount: listView.count
    property bool  showGridView: true

    property int cell_Width: controls.width / 7
    property int cell_height: controls.width / 7

    //行高
    property int rowHeight: 35 * dpi
    //列表头高度
    property int headerHeight: 30 * dpi
    property int currIndex: 0

    function selectAllItem(selAll)
    {
        //网格全选
        for (var i = 0; i < allFileGridView.contentItem.children.length; ++i)
        {

            var item = allFileGridView.contentItem.children[i];
            item.color = "transparent"
            item.children[2].visible = false
            item.children[2].checked = selAll
        }

        //列表全选
        for (var k = 0; k < listView.contentItem.children.length; ++k)
        {
            var listItem = listView.contentItem.children[k];
            for (var j = 0; j < listItem.children.length; ++j)
            {
                listItem.children[0].children[0].children[0].checked = selAll

            }
        }
    }

    AllFilesListModel {
        id:allFileListModel
    }


    GridView {
        id:allFileGridView
        anchors.fill: parent
        cellWidth: cell_Width
        cellHeight: cell_height
        focus: true
        clip: true
        visible: showGridView
        model: allFileListModel
        anchors.topMargin: 5
        delegate: Rectangle {
            id:rectBk
            width: cell_Width - 5
            height: cell_height - 5
            color: "transparent"
            radius: 10

            Column {
                spacing: 5 * dpi
                anchors.centerIn: parent
                clip: true

                Image {
                    source: fileIcon
                    fillMode: Image.PreserveAspectFit
                    //anchors.centerIn: parent
                    scale: dpi * 0.8
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text:fileName
                    font.pixelSize: 14 * dpi
                    color: "white"
                    width: parent.parent.width - 10
                    height: contentHeight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    clip: true
                }

            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    toolTips.y = mouseY
                    toolTips.visible = true
                    if (!btnCheckBox.checked)
                    {
                        rectBk.color = "#3D414B"
                        if (!isFolder)
                        {
                            btnCheckBox.visible = true
                        }
                    }
                }

                onExited: {
                    toolTips.y = mouseY
                    toolTips.visible = false
                    if (!btnCheckBox.checked)
                    {
                        rectBk.color = "transparent"
                        if (!isFolder)
                        {
                            btnCheckBox.visible = false
                        }
                    }
                }

                onDoubleClicked: {
                    parent.forceActiveFocus()
                    if (!isFolder)
                    {
                        return
                    }

                    FtpClient.browseFolder(fileName)
                }

                ToolTip {
                    id:toolTips
                    timeout: 3000
                    delay: 1500
                    contentItem: Text {
                        text:fileName+"\n文件大小: "+fileSize+"\n修改时间: "+fileTime
                        font.pixelSize: 14 * dpi
                        color: "#6C707B"
                    }

                    background: Rectangle {
                        color: "#2A2E35"
                        radius: 5
                        border.width: 1
                        border.color: "white"
                    }
                }
            }

            Button {
                id:btnCheckBox
                width: 20 * dpi
                height: 20 * dpi
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 5
                anchors.topMargin: 5
                checkable:true
                checked: false
                visible: false
                background: Rectangle {
                    color: "transparent"
                    Image {
                        id:imageCheckIcon
                        source: btnCheckBox.checked ?  "../res/newVersion/icon_check_sel.png" :
                                                    "../res/newVersion/icon_check_unsel.png"
                        anchors.fill: parent
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        if (!btnCheckBox.checked)
                        {
                            rectBk.color = "#3D414B"
                            if (!isFolder)
                            {
                                btnCheckBox.visible = true
                            }
                        }
                    }

                    onExited: {
                        if (!btnCheckBox.checked)
                        {
                            rectBk.color = "transparent"
                            if (!isFolder)
                            {
                                btnCheckBox.visible = false
                            }
                        }
                    }

                    onClicked: {
                        // btnCheckBox.checked = !btnCheckBox.checked
                        // //allFileListModel.selectAll(btnCheckBox.checked)
                        // //界面全选
                        // //selectAllItem(btnCheckBox.checked)

                        parent.forceActiveFocus()
                        if (isFolder)
                        {
                            showErrorMsgPopup(true, "文件夹不支持下载或删除")
                            return
                        }

                        btnCheckBox.checked = !btnCheckBox.checked
                        allFileListModel.addToSelectedList(btnCheckBox.checked, index)
                    }
                }
            }
        }
    }


    //列表表头
    Rectangle {
        id:rectHeader
        width: parent.width
        height: headerHeight
        anchors.top: parent.top
        anchors.left: parent.left
        color: "transparent"
        clip: true
        visible: !showGridView
        Row {
            spacing: 1
            anchors.centerIn: parent
            Rectangle {
                id:rectCheckBox
                width: 80 * dpi
                height: headerHeight
                color: "#222733"
                Button {
                    id:btnListCheckBox
                    width: imageCheckBoxIcon.implicitWidth
                    height: imageCheckBoxIcon.implicitHeight
                    anchors.centerIn:parent
                    checkable:true
                    checked: false
                    background: Rectangle {
                        color: "transparent"
                        Image {
                            id:imageCheckBoxIcon
                            source: btnListCheckBox.checked ?  "../res/newVersion/icon_check_sel.png" :
                                                        "../res/newVersion/icon_check_unsel.png"
                            fillMode: Image.PreserveAspectFit
                            scale: dpi
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            parent.forceActiveFocus()
                            btnListCheckBox.checked = !btnListCheckBox.checked
                            allFileListModel.selectAll(btnListCheckBox.checked)
                            //界面全选
                            selectAllItem(btnListCheckBox.checked)
                        }
                    }
                }

            }

            Rectangle {
                width: rectHeader.width - rectCheckBox.width - rectHeadFileSize.width -
                       rectHeadCreateTime.width - rectHeadFileType.width
                height:headerHeight
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
                id:rectHeadCreateTime
                width: 230 * dpi
                height: headerHeight
                color: "#222733"
                Text {
                    text:"修改时间"
                    font.pixelSize: 14 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 5 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                id:rectHeadFileType
                width: 150 * dpi
                height: headerHeight
                color: "#222733"
                Text {
                    text:"类型"
                    font.pixelSize: 14 * dpi
                    color: "#818D9D"
                    anchors.left: parent.left
                    anchors.leftMargin: 5 * dpi
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle {
                id:rectHeadFileSize
                width: 120 * dpi
                height: headerHeight
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
        visible: !showGridView
        currentIndex: -2
        model: allFileListModel
        delegate: Rectangle {
            width: listView.width
            height: rowHeight
            color: "transparent"
            Row {
                visible: true
                spacing: 1
                anchors.centerIn: parent
                Rectangle {
                    id:rectCheckAll
                    width: 80 * dpi
                    height: rowHeight
                    color: currIndex === index ? "#3D414B" : "#222733"
                    Button {
                        id:btnCheck
                        width: imageIcon.implicitWidth
                        height: imageIcon.implicitHeight
                        anchors.centerIn:parent
                        checkable:true
                        checked: fileChecked
                        visible: !isFolder
                        background: Rectangle {
                            color: "transparent"
                            Image {
                                id:imageIcon
                                source: btnCheck.checked ?  "../res/newVersion/icon_check_sel.png" :
                                                            "../res/newVersion/icon_check_unsel.png"
                                fillMode: Image.PreserveAspectFit
                                scale: dpi
                            }
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            parent.forceActiveFocus()
                            if (isFolder)
                            {
                                showErrorMsgPopup(true, "文件夹不支持下载或删除")
                                return
                            }

                            btnCheck.checked = !btnCheck.checked
                            allFileListModel.addToSelectedList(btnCheck.checked, index)
                        }

                        onEntered:{
                            currIndex = index
                        }

                        onExited: {
                            currIndex = -1
                        }
                    }
                }

                Rectangle {
                    id:rectFileName
                    width: listView.width - rectCreateTime.width - rectFileSize.width -
                           rectFileType.width - rectCheckAll.width
                    height: rowHeight
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
                            scale: 0.3  * dpi
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
                            id:toolTipsFileName
                            delay: 700
                            timeout: 3000
                            visible: false
                            text: textFileName.text
                            font.pixelSize: 14 * dpi
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
                            toolTipsFileName.visible = true
                        }

                        onExited: {
                            currIndex = -1
                            toolTipsFileName.visible = false
                        }
                    }
                }

                Rectangle {
                    id:rectCreateTime
                    width: 230 * dpi
                    height: rowHeight
                    color: currIndex === index ? "#3D414B" : "#222733"
                    clip: true
                    Text {
                        text:fileTime
                        font.pixelSize: 14 * dpi
                        color: "white"
                        anchors.left: parent.left
                        anchors.leftMargin: 5 * dpi
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
                    id:rectFileType
                    width: 150 * dpi
                    height: rowHeight
                    color: currIndex === index ? "#3D414B" : "#222733"
                    clip: true
                    Text {
                        text:fileDesc
                        font.pixelSize: 14 * dpi
                        color: "white"
                        anchors.left: parent.left
                        anchors.leftMargin: 5 * dpi
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
                    id:rectFileSize
                    width: 120 * dpi
                    height: rowHeight
                    color: currIndex === index ? "#3D414B" : "#222733"
                    clip: true

                    Text {
                        text:fileSize
                        font.pixelSize: 14 * dpi
                        color: "white"
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 5 * dpi
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

            }
        }
    }

}



