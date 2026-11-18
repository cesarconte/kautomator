/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import QtQuick.Dialogs as QtDialogs
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
    readonly property var backend: typeof automator !== "undefined" ? automator : null

    QtDialogs.FileDialog {
        id: workflowFileDialog
        title: "Seleccionar archivo para el flujo de KAutomator"
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
                onClicked: if (root.backend) root.backend.openRulesFileInEditor()
            }
        }
    ]

    sidebar: [
        AutomatorSidebar {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.bottomMargin: 12
            backend: root.backend
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
                    if (!root.backend) return "All Shortcuts";
                    if (root.backend.currentCategory === "gallery") return "Gallery";
                    if (root.backend.currentCategory === "automation") return "Automation";
                    if (root.backend.currentCategory === "share_sheet") return "Share Sheet";
                    if (root.backend.currentCategory === "quick_actions") return "Quick Actions";
                    if (root.backend.currentCategory === "menu_bar") return "Menu Bar";
                    return "All Shortcuts";
                }
                font.pixelSize: 15
                font.weight: Font.Bold
                color: CachyTheme.textPrimary
            }

            // Grid / List segmented pill
            Rectangle {
                Layout.preferredHeight: 26
                Layout.preferredWidth: 58
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
                        color: (root.backend && root.backend.viewMode === "grid") ? CachyTheme.cardBackgroundHover : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "⊞"
                            font.pixelSize: 13
                            color: CachyTheme.textPrimary
                        }

                        TapHandler { onTapped: if (root.backend) root.backend.viewMode = "grid" }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 11
                        color: (root.backend && root.backend.viewMode === "list") ? CachyTheme.cardBackgroundHover : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "☰"
                            font.pixelSize: 12
                            color: CachyTheme.textPrimary
                        }

                        TapHandler { onTapped: if (root.backend) root.backend.viewMode = "list" }
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
                onClicked: if (root.backend) root.backend.createNewWorkflow()
            }

            CachyToolbarButton {
                iconName: "document-share"
                text: "⤴"
                tooltipText: "Copiar flujo seleccionado al portapapeles (JSON)"
                onClicked: if (root.backend) root.backend.exportWorkflow(root.backend.selectedWorkflowId)
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
                Layout.preferredHeight: 28
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
                        text: root.backend ? root.backend.searchQuery : ""
                        onTextChanged: if (root.backend) root.backend.searchQuery = text
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
            // CENTER PANE: Scrollable 2-Column Grid of Vibrant Cards
            // -----------------------------------------------------------------
            WorkflowCardGrid {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: 14
                backend: root.backend
                onEditRequested: function(wfId) {
                    root.showEditInspector = true;
                }
            }

            // 1px Hard Vertical Divider
            Rectangle {
                Layout.fillHeight: true
                Layout.preferredWidth: 1
                color: CachyTheme.hardDividerColor
            }

            // -----------------------------------------------------------------
            // RIGHT PANE: Apple Intelligence Card OR Workflow Editor Inspector
            // -----------------------------------------------------------------
            ColumnLayout {
                Layout.preferredWidth: 316
                Layout.minimumWidth: 280
                Layout.maximumWidth: 340
                Layout.fillHeight: true
                Layout.margins: 16
                spacing: 12

                AiIntelligenceCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    backend: root.backend
                    visible: !root.showEditInspector
                }

                WorkflowEditorInspector {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    backend: root.backend
                    visible: root.showEditInspector
                    onCloseRequested: root.showEditInspector = false
                }
            }
        }
    ]
}
