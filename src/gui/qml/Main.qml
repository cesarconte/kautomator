/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import QtQuick.Dialogs as QtDialogs

import org.kde.kirigami as Kirigami
import CachyOS.UI

CachyWindow {
    id: root

    title: "Shortcuts — KAutomator"
    width: 960
    height: 640
    minimumWidth: 780
    minimumHeight: 480

    showTrafficLights: true
    showTitleBarDivider: true
    showWindowFrame: true
    sidebarVisible: true
    sidebarWidth: 204
    cornerRadius: CachyTheme.radiusWindow

    property bool showEditInspector: false
    property string pendingFileWorkflowId: ""

    QtDialogs.FileDialog {
        id: workflowFileDialog
        title: "Seleccionar archivo para el flujo de KAutomator"
        fileMode: QtDialogs.FileDialog.OpenFile
        onAccepted: {
            if (root.pendingFileWorkflowId !== "") {
                automator.runWorkflow(root.pendingFileWorkflowId, selectedFile.toString());
                root.pendingFileWorkflowId = "";
            }
        }
    }

    Connections {
        target: automator
        function onFileSelectionRequested(wfId, wfTitle) {
            root.pendingFileWorkflowId = wfId;
            workflowFileDialog.title = "Seleccionar archivo para «" + wfTitle + "»";
            workflowFileDialog.open();
        }
    }

    // =========================================================================
    // 1. LEFT EDGE-TO-EDGE SIDEBAR (Replicating 14_shortcuts.png)
    // =========================================================================
    sidebarHeaderActions: [
        Row {
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter

            CachyToolbarButton {
                iconName: "folder-symbolic"
                text: "📁"
                tooltipText: "Editar reglas Smart Folder (~/.config/kautomator/rules.toml)"
                onClicked: automator.openRulesFileInEditor()
            }
        }
    ]

    sidebar: [
        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 12
            spacing: 4

            CachySidebarItem {
                Layout.fillWidth: true
                text: "Gallery"
                iconGlyph: "⊞"
                iconColor: "#007AFF"
                selected: automator.currentCategory === "gallery"
                onClicked: automator.currentCategory = "gallery"
            }

            CachySidebarItem {
                Layout.fillWidth: true
                text: "Automation"
                iconGlyph: "⏱"
                iconColor: "#34C759"
                badgeText: automator.daemonActive ? "ON" : "OFF"
                selected: automator.currentCategory === "automation"
                onClicked: automator.currentCategory = "automation"
            }

            Item { Layout.preferredHeight: 8 }

            Text {
                Layout.leftMargin: 10
                text: "Library"
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: CachyTheme.textMuted
            }

            CachySidebarItem {
                Layout.fillWidth: true
                text: "All Shortcuts"
                iconGlyph: "❖"
                iconColor: "#007AFF"
                badgeText: automator.allShortcutsCount.toString()
                selected: automator.currentCategory === "all"
                onClicked: automator.currentCategory = "all"
            }

            CachySidebarItem {
                Layout.fillWidth: true
                text: "Share Sheet"
                iconGlyph: "⤴"
                iconColor: "#5E5CE6"
                badgeText: automator.shareSheetCount.toString()
                selected: automator.currentCategory === "share_sheet"
                onClicked: automator.currentCategory = "share_sheet"
            }

            CachySidebarItem {
                Layout.fillWidth: true
                text: "Quick Actions"
                iconGlyph: "⚡"
                iconColor: "#FF9F0A"
                badgeText: automator.quickActionsCount.toString()
                selected: automator.currentCategory === "quick_actions"
                onClicked: automator.currentCategory = "quick_actions"
            }

            CachySidebarItem {
                Layout.fillWidth: true
                text: "Menu Bar"
                iconGlyph: "⌘"
                iconColor: "#AF52DE"
                badgeText: automator.menuBarCount.toString()
                selected: automator.currentCategory === "menu_bar"
                onClicked: automator.currentCategory = "menu_bar"
            }

            Item { Layout.fillHeight: true }

            CachyDivider { Layout.fillWidth: true }

            // Direct link to KDE System Settings -> Keyboard -> Shortcuts (Zero shortcut duplication!)
            CachyToolbarButton {
                Layout.fillWidth: true
                iconName: "preferences-desktop-keyboard"
                text: "⌨ Atajos del Sistema"
                tooltipText: "Abrir Preferencias del Sistema → Teclado → Atajos (sin duplicidades)"
                onClicked: automator.openSystemKeyboardShortcuts()
            }
        }
    ]

    // =========================================================================
    // 2. HEADER TOOLBAR (Matching 14_shortcuts.png)
    // =========================================================================
    headerLeading: [
        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12

            Text {
                text: {
                    if (automator.currentCategory === "gallery") return "Gallery";
                    if (automator.currentCategory === "automation") return "Automation";
                    if (automator.currentCategory === "share_sheet") return "Share Sheet";
                    if (automator.currentCategory === "quick_actions") return "Quick Actions";
                    if (automator.currentCategory === "menu_bar") return "Menu Bar";
                    return "All Shortcuts";
                }
                font.pixelSize: 15
                font.weight: Font.Bold
                color: CachyTheme.textPrimary
            }

            // Grid / List segmented pill
            Rectangle {
                height: 26
                width: 58
                radius: 13
                color: CachyTheme.surfacePill
                border.width: 1
                border.color: CachyTheme.specularBorder

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 2
                    spacing: 0

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 11
                        color: automator.viewMode === "grid" ? CachyTheme.cardBackgroundHover : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "⊞"
                            font.pixelSize: 13
                            color: CachyTheme.textPrimary
                        }

                        TapHandler { onTapped: automator.viewMode = "grid" }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 11
                        color: automator.viewMode === "list" ? CachyTheme.cardBackgroundHover : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "☰"
                            font.pixelSize: 12
                            color: CachyTheme.textPrimary
                        }

                        TapHandler { onTapped: automator.viewMode = "list" }
                    }
                }
            }
        }
    ]

    headerCenter: [
        Item { width: 1; height: 1 }
    ]

    headerActions: [
        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            CachyToolbarButton {
                text: "+"
                tooltipText: "Crear nuevo flujo de trabajo"
                onClicked: automator.createNewWorkflow()
            }

            CachyToolbarButton {
                iconName: "document-share"
                text: "⤴"
                tooltipText: "Copiar flujo seleccionado al portapapeles (JSON)"
                onClicked: automator.exportWorkflow(automator.selectedWorkflowId)
            }

            CachyToolbarButton {
                text: "Edit"
                implicitWidth: 46
                checkable: true
                checked: root.showEditInspector
                tooltipText: "Editar propiedades y comando del flujo seleccionado"
                onClicked: root.showEditInspector = !root.showEditInspector
            }

            // Rounded Search Pill ("Q Search" in 14_shortcuts.png)
            Rectangle {
                Layout.preferredWidth: 168
                height: 28
                radius: 14
                color: CachyTheme.surfacePill
                border.width: 1
                border.color: searchField.activeFocus ? CachyTheme.accentColor : CachyTheme.specularBorder

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 8
                    spacing: 6

                    Text {
                        text: "🔍"
                        font.pixelSize: 11
                        color: CachyTheme.textMuted
                    }

                    QQC2.TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: "Search"
                        placeholderTextColor: CachyTheme.textMuted
                        color: CachyTheme.textPrimary
                        font.pixelSize: 12
                        background: null
                        text: automator.searchQuery
                        onTextChanged: automator.searchQuery = text
                    }
                }
            }
        }
    ]

    // =========================================================================
    // 3. MAIN 2-COLUMN BODY (Center Colored Cards Grid + Right Intelligence Pane)
    // =========================================================================
    contentData: [
        RowLayout {
            anchors.fill: parent
            spacing: 0

            // -----------------------------------------------------------------
            // CENTER PANE: Scrollable 2-Column Grid of Vibrant Cards (14_shortcuts.png)
            // -----------------------------------------------------------------
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 14
                spacing: 10

                // Optional Smart Folder Daemon status bar when in "Automation" category
                Rectangle {
                    visible: automator.currentCategory === "automation"
                    Layout.fillWidth: true
                    implicitHeight: 42
                    radius: 12
                    color: CachyTheme.cardBackground
                    border.width: 1
                    border.color: CachyTheme.specularBorder

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 10

                        Rectangle {
                            width: 10
                            height: 10
                            radius: 5
                            color: automator.daemonActive ? "#34C759" : "#8E8E93"
                        }

                        Text {
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            color: CachyTheme.textPrimary
                            text: automator.daemonActive
                                ? "Demonio inotify activo (vigilando ~/Descargas en segundo plano)"
                                : "Demonio inotify detenido"
                        }

                        CachyButton {
                            text: "Ejecutar ahora"
                            onClicked: automator.runAllFolderRulesNow()
                        }

                        CachySwitch {
                            checked: automator.daemonActive
                            onToggled: automator.toggleDaemon()
                        }
                    }
                }

                QQC2.ScrollView {
                    id: wfScroll
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    rightPadding: 14
                    contentWidth: availableWidth
                    QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AlwaysOff
                    clip: true

                    GridLayout {
                        width: wfScroll.availableWidth
                        columns: automator.viewMode === "grid" ? 2 : 1
                        columnSpacing: 12
                        rowSpacing: 12

                        Repeater {
                            model: automator.filteredWorkflows

                            Rectangle {
                                id: wfCard
                                required property var modelData
                                required property int index

                                readonly property bool isSelected: modelData.id === automator.selectedWorkflowId
                                readonly property real cardWidth: automator.viewMode === "grid"
                                    ? Math.max(120, Math.floor((wfScroll.availableWidth - 22) / 2))
                                    : (wfScroll.availableWidth - 10)

                                Layout.fillWidth: true
                                Layout.preferredWidth: cardWidth
                                Layout.maximumWidth: cardWidth
                                implicitHeight: 96
                                radius: 16
                                color: modelData.color || "#0091FF"
                                border.width: isSelected ? 2.5 : 1
                                border.color: isSelected ? "#FFFFFF" : Qt.rgba(1, 1, 1, 0.24)
                                clip: true

                                scale: wfCardHover.hovered ? 1.01 : 1.0
                                Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutQuad } }

                                HoverHandler { id: wfCardHover; cursorShape: Qt.PointingHandCursor }

                                TapHandler {
                                    acceptedButtons: Qt.LeftButton
                                    onTapped: automator.selectedWorkflowId = wfCard.modelData.id
                                }

                                TapHandler {
                                    acceptedButtons: Qt.RightButton
                                    onTapped: {
                                        automator.selectedWorkflowId = wfCard.modelData.id;
                                        wfContextMenu.popup();
                                    }
                                }

                                QQC2.Menu {
                                    id: wfContextMenu

                                    QQC2.MenuItem {
                                        icon.name: "media-playback-start"
                                        text: "Ejecutar flujo ahora"
                                        onTriggered: automator.runWorkflow(wfCard.modelData.id)
                                    }

                                    QQC2.MenuItem {
                                        icon.name: "document-edit"
                                        text: "Editar flujo…"
                                        onTriggered: {
                                            automator.selectedWorkflowId = wfCard.modelData.id;
                                            root.showEditInspector = true;
                                        }
                                    }

                                    QQC2.MenuItem {
                                        icon.name: "edit-copy"
                                        text: "Duplicar flujo"
                                        onTriggered: automator.duplicateWorkflow(wfCard.modelData.id)
                                    }

                                    QQC2.MenuSeparator {}

                                    QQC2.MenuItem {
                                        icon.name: "edit-delete"
                                        text: "Eliminar flujo"
                                        onTriggered: automator.deleteWorkflow(wfCard.modelData.id)
                                    }
                                }

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 6

                                    // Top Row: Workflow Icon Circle (left) + Run/Add Circle (right)
                                    RowLayout {
                                        Layout.fillWidth: true

                                        Rectangle {
                                            width: 28
                                            height: 28
                                            radius: 14
                                            color: Qt.rgba(1, 1, 1, 0.22)

                                            Text {
                                                anchors.centerIn: parent
                                                text: wfCard.modelData.glyph || "❖"
                                                font.pixelSize: 13
                                                color: "#FFFFFF"
                                            }
                                        }

                                        Item { Layout.fillWidth: true }

                                        // Run / Action Button in top-right corner of the card
                                        Rectangle {
                                            width: 24
                                            height: 24
                                            radius: 12
                                            color: runBtnHover.hovered ? Qt.rgba(1, 1, 1, 0.95) : Qt.rgba(1, 1, 1, 0.26)

                                            HoverHandler { id: runBtnHover; cursorShape: Qt.PointingHandCursor }
                                            TapHandler {
                                                onTapped: automator.runWorkflow(wfCard.modelData.id)
                                            }

                                            Text {
                                                anchors.centerIn: parent
                                                text: wfCard.isSelected ? "+" : "▶"
                                                font.pixelSize: wfCard.isSelected ? 14 : 10
                                                font.bold: true
                                                color: runBtnHover.hovered ? (wfCard.modelData.color || "#0091FF") : "#FFFFFF"
                                            }
                                        }
                                    }

                                    Item { Layout.fillHeight: true }

                                    // Bottom Title (Strictly wrapped and elided — zero overflow!)
                                    Text {
                                        Layout.fillWidth: true
                                        Layout.maximumWidth: wfCard.cardWidth - 24
                                        text: wfCard.modelData.title || "Shortcut"
                                        color: "#FFFFFF"
                                        font.pixelSize: 13
                                        font.weight: Font.Bold
                                        wrapMode: Text.WordWrap
                                        maximumLineCount: 2
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // 1px Hard Vertical Divider
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                color: CachyTheme.hardDividerColor
            }

            // -----------------------------------------------------------------
            // RIGHT PANE: Apple Intelligence in Shortcuts ("Describe a change" - 14_shortcuts.png)
            // OR Workflow Editor when "Edit" is active
            // -----------------------------------------------------------------
            ColumnLayout {
                Layout.preferredWidth: 316
                Layout.minimumWidth: 280
                Layout.maximumWidth: 340
                Layout.fillHeight: true
                Layout.margins: 16
                spacing: 12

                // MODE A: Apple Intelligence in Shortcuts (Exact match to 14_shortcuts.png)
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 14
                    visible: !root.showEditInspector

                    Item { Layout.fillHeight: true }

                    // Glowing Iridescent Frosted Glass Intelligence Card (14_shortcuts.png)
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: aiCardCol.implicitHeight + 44
                        radius: 22
                        color: CachyTheme.isDark ? Qt.rgba(0.14, 0.17, 0.22, 0.72) : Qt.rgba(0.95, 0.98, 1.0, 0.90)
                        border.width: 1.5
                        border.color: CachyTheme.isDark ? Qt.rgba(0.39, 0.82, 1.0, 0.45) : Qt.rgba(0.25, 0.72, 0.98, 0.55)

                        ColumnLayout {
                            id: aiCardCol
                            anchors.fill: parent
                            anchors.margins: 22
                            spacing: 12

                            // Apple Intelligence / Kity AI Gradient Glyph
                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter
                                width: 32
                                height: 32
                                radius: 10
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: "#FF6482" }
                                    GradientStop { position: 0.5; color: "#BF5AF2" }
                                    GradientStop { position: 1.0; color: "#5AC8FA" }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: "✦"
                                    font.pixelSize: 17
                                    font.bold: true
                                    color: "#FFFFFF"
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                                text: automator.aiCardHeadline
                                font.pixelSize: 15
                                font.weight: Font.Bold
                                color: CachyTheme.textPrimary
                            }

                            Text {
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                                text: automator.aiCardQuote
                                font.pixelSize: 12
                                color: CachyTheme.textSecondary
                            }
                        }
                    }

                    // Subtle "(!) Report a Concern" row below the card (14_shortcuts.png)
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 5

                        Text {
                            text: "ⓘ"
                            font.pixelSize: 11
                            color: CachyTheme.textMuted
                        }

                        Text {
                            text: "Report a Concern"
                            font.pixelSize: 11
                            color: CachyTheme.textMuted
                        }
                    }

                    Item { Layout.fillHeight: true }

                    // Bottom Pill Input: "Describe a change" (14_shortcuts.png)
                    Rectangle {
                        Layout.fillWidth: true
                        height: 36
                        radius: 18
                        color: CachyTheme.surfacePill
                        border.width: describeField.activeFocus ? 1.5 : 1
                        border.color: describeField.activeFocus ? CachyTheme.accentColor : CachyTheme.specularBorder

                        QQC2.TextField {
                            id: describeField
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 14
                            placeholderText: "Describe a change"
                            placeholderTextColor: CachyTheme.textMuted
                            color: CachyTheme.textPrimary
                            font.pixelSize: 13
                            background: null
                            onAccepted: {
                                if (text.trim().length > 0) {
                                    automator.describeChange(text.trim());
                                    text = "";
                                }
                            }
                        }
                    }
                }

                // MODE B: Selected Workflow Inspector & Editor (when "Edit" is clicked)
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 10
                    visible: root.showEditInspector

                    Text {
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: "Editar flujo seleccionado"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        color: CachyTheme.textPrimary
                    }

                    Text {
                        text: "Nombre del flujo:"
                        font.pixelSize: 11
                        color: CachyTheme.textSecondary
                    }
                    CachyTextField {
                        id: editTitleField
                        Layout.fillWidth: true
                        text: automator.selectedWorkflow.title || ""
                    }

                    Text {
                        text: "Descripción:"
                        font.pixelSize: 11
                        color: CachyTheme.textSecondary
                    }
                    CachyTextField {
                        id: editSubtitleField
                        Layout.fillWidth: true
                        text: automator.selectedWorkflow.subtitle || ""
                    }

                    Text {
                        text: "Categoría:"
                        font.pixelSize: 11
                        color: CachyTheme.textSecondary
                    }
                    QQC2.ComboBox {
                        id: editCategoryCombo
                        Layout.fillWidth: true
                        model: ["quick_actions", "share_sheet", "menu_bar", "automation"]
                        currentIndex: Math.max(0, model.indexOf(automator.selectedWorkflow.category || "quick_actions"))
                    }

                    Text {
                        text: "Color de tarjeta:"
                        font.pixelSize: 11
                        color: CachyTheme.textSecondary
                    }
                    RowLayout {
                        spacing: 8
                        Repeater {
                            model: ["#0091FF", "#B65CE6", "#28CD56", "#FF4D62", "#FF64B4", "#7D828C"]
                            Rectangle {
                                required property string modelData
                                width: 22
                                height: 22
                                radius: 11
                                color: modelData
                                border.width: editColorDummy.text === modelData ? 2 : 0
                                border.color: "#FFFFFF"
                                TapHandler { onTapped: editColorDummy.text = modelData }
                            }
                        }
                    }
                    Text {
                        id: editColorDummy
                        visible: false
                        text: automator.selectedWorkflow.color || "#0091FF"
                    }

                    Text {
                        text: "Comando ejecutable ({file}, {noext}):"
                        font.pixelSize: 11
                        color: CachyTheme.textSecondary
                    }
                    CachyTextField {
                        id: editCommandField
                        Layout.fillWidth: true
                        text: automator.selectedWorkflow.command || ""
                    }

                    Item { Layout.fillHeight: true }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        CachyButton {
                            Layout.fillWidth: true
                            text: "▶ Ejecutar"
                            onClicked: automator.runWorkflow(automator.selectedWorkflowId)
                        }

                        CachyButton {
                            Layout.fillWidth: true
                            primary: true
                            text: "Guardar"
                            onClicked: {
                                automator.updateWorkflow(
                                    automator.selectedWorkflowId,
                                    editTitleField.text,
                                    editSubtitleField.text,
                                    editCategoryCombo.currentText,
                                    editColorDummy.text,
                                    editCommandField.text
                                );
                                root.showEditInspector = false;
                            }
                        }
                    }
                }
            }
        }
    ]
}
