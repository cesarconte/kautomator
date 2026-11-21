/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs as QtDialogs
import QtQuick.Layouts
import CachyOS.UI

CachyWindow {
    id: root

    title: qsTr("Atajos — KAutomator")
    width: 980
    height: 640
    minimumWidth: 800
    minimumHeight: 500

    showTrafficLights: true
    showTitle: false
    showTitleBarDivider: true
    showWindowFrame: true
    sidebarVisible: true
    sidebarWidthExpanded: 224
    cornerRadius: CachyTheme.radiusWindow

    // Acyclic synchronized width for both the right content pane and its aligned header section
    readonly property int rightPaneWidth: Math.round(
        Math.max(324, Math.min(400, (root.width - (root.hasSidebar ? root.sidebarWidth : 0)) * 0.48))
    )

    property bool showEditInspector: false
    property string pendingFileWorkflowId: ""
    readonly property var backend: typeof automator !== "undefined" ? automator : null

    Shortcut {
        sequences: [StandardKey.New]
        onActivated: if (root.backend) root.backend.createNewWorkflow()
    }

    Shortcut {
        sequences: [StandardKey.Find]
        onActivated: searchInput.forceActiveFocus()
    }

    Shortcut {
        sequence: "Ctrl+E"
        onActivated: root.showEditInspector = !root.showEditInspector
    }

    Shortcut {
        sequence: "Ctrl+1"
        onActivated: if (root.backend) root.backend.viewMode = "grid"
    }

    Shortcut {
        sequence: "Ctrl+2"
        onActivated: if (root.backend) root.backend.viewMode = "list"
    }

    QtDialogs.FileDialog {
        id: workflowFileDialog
        title: qsTr("Seleccionar archivo para el flujo de KAutomator")
        fileMode: QtDialogs.FileDialog.OpenFile
        onAccepted: {
            if (root.pendingFileWorkflowId !== "" && root.backend) {
                root.backend.runWorkflow(root.pendingFileWorkflowId, selectedFile.toString());
                root.pendingFileWorkflowId = "";
            }
        }
    }

    Connections {
        target: root.backend
        function onFileSelectionRequested(wfId, wfTitle) {
            root.pendingFileWorkflowId = wfId;
            workflowFileDialog.title = qsTr("Seleccionar archivo para «%1»").arg(wfTitle);
            workflowFileDialog.open();
        }
        function onSearchQueryChanged() {
            if (root.backend && searchInput.text !== root.backend.searchQuery) {
                searchInput.text = root.backend.searchQuery;
            }
        }
    }

    // =========================================================================
    // 1. SIDEBAR TOP BAR ACTIONS (New Folder + Toggle Sidebar)
    // =========================================================================
    sidebarHeaderActions: [
        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            // New Folder Circular Glass Button
            Rectangle {
                width: 28
                height: 28
                radius: 14
                color: newFolderTap.pressed
                    ? CachyPalette.pressedOverlay
                    : (newFolderHover.hovered ? CachyPalette.cardBackgroundHover : CachyPalette.surfacePill)
                border.width: 1
                border.color: CachyPalette.specularBorder

                Behavior on color { ColorAnimation { duration: CachyTheme.animFast } }

                CachyIcon {
                    anchors.centerIn: parent
                    name: "qrc:/icons/folder-add.svg"
                    size: 15
                    color: CachyPalette.text
                }

                HoverHandler {
                    id: newFolderHover
                    cursorShape: Qt.PointingHandCursor
                }
                TapHandler {
                    id: newFolderTap
                    onTapped: newFolderDialog.openDialog()
                }
                QQC2.ToolTip.visible: newFolderHover.hovered
                QQC2.ToolTip.text: qsTr("Nueva carpeta")
                QQC2.ToolTip.delay: 450
            }

            // Toggle Sidebar Circular Glass Button
            Rectangle {
                width: 28
                height: 28
                radius: 14
                color: toggleSideTap.pressed
                    ? CachyPalette.pressedOverlay
                    : (toggleSideHover.hovered ? CachyPalette.cardBackgroundHover : CachyPalette.surfacePill)
                border.width: 1
                border.color: CachyPalette.specularBorder

                Behavior on color { ColorAnimation { duration: CachyTheme.animFast } }

                CachyIcon {
                    anchors.centerIn: parent
                    name: "sidebar"
                    size: 14
                    color: CachyPalette.text
                }

                HoverHandler {
                    id: toggleSideHover
                    cursorShape: Qt.PointingHandCursor
                }
                TapHandler {
                    id: toggleSideTap
                    onTapped: root.toggleSidebar()
                }
                QQC2.ToolTip.visible: toggleSideHover.hovered
                QQC2.ToolTip.text: qsTr("Ocultar barra lateral")
                QQC2.ToolTip.delay: 450
            }
        }
    ]

    // =========================================================================
    // 2. EDGE-TO-EDGE LIQUID GLASS SIDEBAR
    // =========================================================================
    sidebar: [
        AutomatorSidebar {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 12
            backend: root.backend
            onRenameFolderRequested: (folderId, currentName) => renameFolderDialog.openDialog(folderId, currentName)
        }
    ]

    // =========================================================================
    // 3. HEADER TOOLBAR (Aligned across middle + right panes with continuous 1px divider)
    // =========================================================================
    headerLeading: [
        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Rectangle {
                visible: !root.sidebarVisible
                Layout.preferredWidth: 28
                Layout.preferredHeight: 28
                radius: 14
                color: showSideTap.pressed
                    ? CachyPalette.pressedOverlay
                    : (showSideHover.hovered ? CachyPalette.cardBackgroundHover : CachyPalette.surfacePill)
                border.width: 1
                border.color: CachyPalette.specularBorder

                CachyIcon {
                    anchors.centerIn: parent
                    name: "sidebar"
                    size: 14
                    color: CachyPalette.text
                }

                HoverHandler {
                    id: showSideHover
                    cursorShape: Qt.PointingHandCursor
                }
                TapHandler {
                    id: showSideTap
                    onTapped: root.toggleSidebar()
                }
                QQC2.ToolTip.visible: showSideHover.hovered
                QQC2.ToolTip.text: qsTr("Mostrar barra lateral")
                QQC2.ToolTip.delay: 450
            }

            Text {
                Layout.maximumWidth: Math.max(
                    80,
                    root.width - (root.hasSidebar ? root.sidebarWidth : 0) - root.rightPaneWidth - (!root.sidebarVisible ? 150 : 114)
                )
                text: root.backend ? root.backend.currentViewTitle : qsTr("Todos los atajos")
                font.pixelSize: 15
                font.weight: Font.DemiBold
                color: CachyPalette.text
                elide: Text.ElideRight
            }
        }
    ]

    headerCenter: [
        // Grid / List segmented pill anchored 12px left of the continuous vertical divider
        Rectangle {
            id: viewModePill
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            width: 66
            height: 28
            radius: 14
            color: CachyPalette.surfacePill
            border.width: 1
            border.color: CachyPalette.specularBorder

            // Animated inner selection pill
            Rectangle {
                y: 3
                width: 30
                height: parent.height - 6
                x: (root.backend && root.backend.viewMode === "list") ? (parent.width - width - 3) : 3
                radius: 11
                color: CachyPalette.isDark ? Qt.rgba(1, 1, 1, 0.18) : Qt.rgba(0, 0, 0, 0.09)

                Behavior on x {
                    NumberAnimation { duration: CachyTheme.animFast; easing.type: Easing.OutCubic }
                }
            }

            Row {
                anchors.fill: parent
                anchors.margins: 3
                spacing: 0

                Item {
                    width: 30
                    height: parent.height

                    CachyIcon {
                        anchors.centerIn: parent
                        name: "grid"
                        size: 13
                        color: (!root.backend || root.backend.viewMode === "grid")
                            ? CachyPalette.text
                            : CachyPalette.textSecondary
                    }

                    HoverHandler {
                        id: gridHover
                        cursorShape: Qt.PointingHandCursor
                    }
                    TapHandler {
                        onTapped: if (root.backend) root.backend.viewMode = "grid"
                    }
                    QQC2.ToolTip.visible: gridHover.hovered
                    QQC2.ToolTip.text: qsTr("Vista en cuadrícula (Ctrl+1)")
                    QQC2.ToolTip.delay: 450
                }

                Item {
                    width: 30
                    height: parent.height

                    CachyIcon {
                        anchors.centerIn: parent
                        name: "list"
                        size: 13
                        color: (root.backend && root.backend.viewMode === "list")
                            ? CachyPalette.text
                            : CachyPalette.textSecondary
                    }

                    HoverHandler {
                        id: listHover
                        cursorShape: Qt.PointingHandCursor
                    }
                    TapHandler {
                        onTapped: if (root.backend) root.backend.viewMode = "list"
                    }
                    QQC2.ToolTip.visible: listHover.hovered
                    QQC2.ToolTip.text: qsTr("Vista en lista (Ctrl+2)")
                    QQC2.ToolTip.delay: 450
                }
            }
        }
    ]

    headerActions: [
        Item {
            width: Math.max(260, root.rightPaneWidth + 1 - root.contentMargin)
            height: CachyTheme.titleBarHeight
            anchors.verticalCenter: parent.verticalCenter

            // Top segment of the continuous 1px vertical divider (connects seamlessly to content divider)
            Rectangle {
                x: 0
                y: 0
                width: 1
                height: parent.height
                color: CachyPalette.hardDividerColor
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 13
                anchors.rightMargin: 0
                spacing: 7

                // Add Shortcut (+) Circular Glass Button
                Rectangle {
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 28
                    radius: 14
                    color: addTap.pressed
                        ? CachyPalette.pressedOverlay
                        : (addHover.hovered ? CachyPalette.cardBackgroundHover : CachyPalette.surfacePill)
                    border.width: 1
                    border.color: CachyPalette.specularBorder

                    Behavior on color { ColorAnimation { duration: CachyTheme.animFast } }

                    CachyIcon {
                        anchors.centerIn: parent
                        name: "add"
                        size: 14
                        color: CachyPalette.text
                    }

                    HoverHandler {
                        id: addHover
                        cursorShape: Qt.PointingHandCursor
                    }
                    TapHandler {
                        id: addTap
                        onTapped: if (root.backend) root.backend.createNewWorkflow()
                    }
                    QQC2.ToolTip.visible: addHover.hovered
                    QQC2.ToolTip.text: qsTr("Nuevo atajo (Ctrl+N)")
                    QQC2.ToolTip.delay: 450
                }

                // Share / Export JSON Circular Glass Button
                Rectangle {
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 28
                    radius: 14
                    color: shareTap.pressed
                        ? CachyPalette.pressedOverlay
                        : (shareHover.hovered ? CachyPalette.cardBackgroundHover : CachyPalette.surfacePill)
                    border.width: 1
                    border.color: CachyPalette.specularBorder

                    Behavior on color { ColorAnimation { duration: CachyTheme.animFast } }

                    CachyIcon {
                        anchors.centerIn: parent
                        name: "share"
                        size: 14
                        color: CachyPalette.text
                    }

                    HoverHandler {
                        id: shareHover
                        cursorShape: Qt.PointingHandCursor
                    }
                    TapHandler {
                        id: shareTap
                        onTapped: {
                            if (root.backend && root.backend.selectedWorkflowId) {
                                root.backend.exportWorkflow(root.backend.selectedWorkflowId);
                                statusToast.show(qsTr("Atajo copiado al portapapeles"), "success", 2200);
                            }
                        }
                    }
                    QQC2.ToolTip.visible: shareHover.hovered
                    QQC2.ToolTip.text: qsTr("Exportar atajo al portapapeles (JSON)")
                    QQC2.ToolTip.delay: 450
                }

                // Edit Inspector Capsule Glass Button
                Rectangle {
                    Layout.preferredWidth: editLabel.implicitWidth + 22
                    Layout.preferredHeight: 28
                    radius: 14
                    color: {
                        if (root.showEditInspector) {
                            return Qt.rgba(CachyTheme.accentColor.r, CachyTheme.accentColor.g, CachyTheme.accentColor.b, 0.22);
                        }
                        if (editTap.pressed) return CachyPalette.pressedOverlay;
                        if (editHover.hovered) return CachyPalette.cardBackgroundHover;
                        return CachyPalette.surfacePill;
                    }
                    border.width: 1
                    border.color: root.showEditInspector ? CachyTheme.accentColor : CachyPalette.specularBorder

                    Behavior on color { ColorAnimation { duration: CachyTheme.animFast } }
                    Behavior on border.color { ColorAnimation { duration: CachyTheme.animFast } }

                    Text {
                        id: editLabel
                        anchors.centerIn: parent
                        text: qsTr("Editar")
                        font.pixelSize: 13
                        font.weight: Font.Medium
                        color: root.showEditInspector ? CachyPalette.accentText : CachyPalette.text
                    }

                    HoverHandler {
                        id: editHover
                        cursorShape: Qt.PointingHandCursor
                    }
                    TapHandler {
                        id: editTap
                        onTapped: root.showEditInspector = !root.showEditInspector
                    }
                    QQC2.ToolTip.visible: editHover.hovered
                    QQC2.ToolTip.text: qsTr("Editar atajo seleccionado (Ctrl+E)")
                    QQC2.ToolTip.delay: 450
                }

                // Search Capsule (Golden Gate Top-Right Search)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.minimumWidth: 110
                    Layout.preferredHeight: 28
                    radius: 14
                    color: searchInput.activeFocus ? CachyPalette.cardBackgroundHover : CachyPalette.surfacePill
                    border.width: searchInput.activeFocus ? 1.5 : 1
                    border.color: searchInput.activeFocus ? CachyTheme.accentColor : CachyPalette.specularBorder

                    Behavior on color { ColorAnimation { duration: CachyTheme.animFast } }
                    Behavior on border.color { ColorAnimation { duration: CachyTheme.animFast } }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 8
                        spacing: 6

                        CachyIcon {
                            name: "search"
                            size: 13
                            color: CachyPalette.textSecondary
                        }

                        TextInput {
                            id: searchInput
                            Layout.fillWidth: true
                            font.pixelSize: 13
                            color: CachyPalette.text
                            selectionColor: CachyTheme.accentColor
                            selectedTextColor: "#FFFFFF"
                            clip: true
                            verticalAlignment: TextInput.AlignVCenter
                            onTextChanged: if (root.backend) root.backend.searchQuery = text

                            Keys.onEscapePressed: {
                                text = "";
                                focus = false;
                            }

                            Text {
                                anchors.fill: parent
                                verticalAlignment: TextInput.AlignVCenter
                                text: qsTr("Buscar")
                                color: CachyPalette.textSecondary
                                visible: !searchInput.text && !searchInput.activeFocus
                                font.pixelSize: 13
                                elide: Text.ElideRight
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 15
                            Layout.preferredHeight: 15
                            radius: 7.5
                            visible: searchInput.text.length > 0
                            color: clearSearchHover.hovered ? CachyPalette.pressedOverlay : CachyPalette.hoverOverlay

                            CachyIcon {
                                anchors.centerIn: parent
                                name: "close"
                                size: 9
                                color: CachyPalette.textSecondary
                            }

                            HoverHandler {
                                id: clearSearchHover
                                cursorShape: Qt.PointingHandCursor
                            }
                            TapHandler {
                                onTapped: searchInput.text = ""
                            }
                        }
                    }
                }
            }
        }
    ]

    // =========================================================================
    // 4. MAIN 2-PANE BODY (Center Cards Grid/List + Right Intelligence/Editor Pane)
    // =========================================================================
    contentData: [
        RowLayout {
            anchors.fill: parent
            spacing: 0

            WorkflowCardGrid {
                Layout.fillWidth: true
                Layout.fillHeight: true
                backend: root.backend
                onEditRequested: root.showEditInspector = true
                onExportedNotification: title => {
                    statusToast.show(qsTr("Atajo «%1» copiado al portapapeles").arg(title), "success", 2200);
                }
            }

            // Continuous 1px Hard Vertical Divider
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                color: CachyPalette.hardDividerColor
            }

            Item {
                Layout.preferredWidth: root.rightPaneWidth
                Layout.minimumWidth: root.rightPaneWidth
                Layout.maximumWidth: root.rightPaneWidth
                Layout.fillHeight: true
                clip: true

                AiIntelligenceCard {
                    anchors.fill: parent
                    backend: root.backend
                    visible: !root.showEditInspector
                }

                WorkflowEditorInspector {
                    anchors.fill: parent
                    backend: root.backend
                    visible: root.showEditInspector
                    onCloseRequested: root.showEditInspector = false
                    onSavedNotification: title => {
                        statusToast.show(qsTr("Atajo «%1» guardado").arg(title), "success", 2000);
                    }
                }
            }
        }
    ]

    // =========================================================================
    // 5. OVERLAYS (Folder Dialogs + Floating Toast)
    // =========================================================================
    overlay: [
        CachyDialog {
            id: newFolderDialog
            title: qsTr("Nueva carpeta")
            subtitle: qsTr("Elige un nombre y un icono para organizar tus atajos.")
            preferredWidth: 340
            cancelText: qsTr("Cancelar")

            property string selectedIcon: "folder"

            function openDialog() {
                folderNameInput.text = "";
                selectedIcon = "folder";
                open();
                folderNameInput.forceActiveFocus();
            }

            function confirmCreate() {
                if (folderNameInput.text.trim().length > 0 && root.backend) {
                    root.backend.createFolder(folderNameInput.text.trim(), newFolderDialog.selectedIcon);
                    folderNameInput.text = "";
                    newFolderDialog.close();
                }
            }

            customFooterActions: [
                QQC2.Action {
                    text: qsTr("Crear")
                    enabled: folderNameInput.text.trim().length > 0
                    onTriggered: newFolderDialog.confirmCreate()
                }
            ]

            CachyTextField {
                id: folderNameInput
                Layout.fillWidth: true
                placeholderText: qsTr("Nombre de la carpeta")
                onAccepted: newFolderDialog.confirmCreate()
            }

            Text {
                text: qsTr("Icono de la carpeta:")
                font.pixelSize: 12
                color: CachyPalette.textSecondary
            }

            RowLayout {
                spacing: 8
                Repeater {
                    model: ["folder", "warning", "sparkles", "clock", "tag", "alarm", "file"]

                    Rectangle {
                        id: folderIconChoice
                        required property string modelData
                        readonly property bool isSelected: newFolderDialog.selectedIcon === folderIconChoice.modelData

                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                        radius: 8
                        color: isSelected
                            ? CachyTheme.accentColor
                            : (folderIconHover.hovered ? CachyPalette.cardBackgroundHover : CachyPalette.cardBackground)
                        border.width: 1
                        border.color: isSelected ? CachyTheme.accentColor : CachyPalette.specularBorder

                        CachyIcon {
                            anchors.centerIn: parent
                            name: folderIconChoice.modelData
                            size: 16
                            color: folderIconChoice.isSelected ? "#FFFFFF" : CachyPalette.text
                        }

                        HoverHandler {
                            id: folderIconHover
                            cursorShape: Qt.PointingHandCursor
                        }
                        TapHandler {
                            onTapped: newFolderDialog.selectedIcon = folderIconChoice.modelData
                        }
                    }
                }
            }
        },

        CachyDialog {
            id: renameFolderDialog
            title: qsTr("Renombrar carpeta")
            preferredWidth: 320
            cancelText: qsTr("Cancelar")

            property string targetFolderId: ""

            function openDialog(folderId, currentName) {
                targetFolderId = folderId;
                renameFolderInput.text = currentName;
                open();
                renameFolderInput.forceActiveFocus();
                renameFolderInput.selectAll();
            }

            function confirmRename() {
                if (renameFolderInput.text.trim().length > 0 && root.backend && targetFolderId !== "") {
                    root.backend.renameFolder(targetFolderId, renameFolderInput.text.trim());
                    renameFolderDialog.close();
                }
            }

            customFooterActions: [
                QQC2.Action {
                    text: qsTr("Guardar")
                    enabled: renameFolderInput.text.trim().length > 0
                    onTriggered: renameFolderDialog.confirmRename()
                }
            ]

            CachyTextField {
                id: renameFolderInput
                Layout.fillWidth: true
                placeholderText: qsTr("Nombre de la carpeta")
                onAccepted: renameFolderDialog.confirmRename()
            }
        },

        CachyToast {
            id: statusToast
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 18
        }
    ]
}
