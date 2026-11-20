/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import CachyOS.UI

ColumnLayout {
    id: root

    required property var backend
    signal editRequested(string workflowId)

    spacing: 10

    // Optional Smart Folder Daemon status bar when in "Automation" category
    Rectangle {
        visible: root.backend.currentCategory === "automation"
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
                Layout.preferredWidth: 10
                Layout.preferredHeight: 10
                radius: 5
                color: root.backend.daemonActive ? "#34C759" : "#8E8E93"
            }

            Text {
                Layout.fillWidth: true
                elide: Text.ElideRight
                font.pixelSize: 12
                font.weight: Font.Medium
                color: CachyTheme.textPrimary
                text: root.backend.daemonActive
                    ? "Demonio inotify activo (vigilando ~/Descargas en segundo plano)"
                    : "Demonio inotify detenido"
            }

            CachyButton {
                text: "Ejecutar ahora"
                onClicked: root.backend.runAllFolderRulesNow()
            }

            CachySwitch {
                checked: root.backend.daemonActive
                onToggled: root.backend.toggleDaemon()
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
            columns: root.backend.viewMode === "grid" ? 2 : 1
            columnSpacing: 12
            rowSpacing: 12

            Repeater {
                model: root.backend.filteredWorkflows

                Rectangle {
                    id: wfCard
                    required property var modelData
                    required property int index

                    readonly property bool isSelected: modelData.id === root.backend.selectedWorkflowId
                    readonly property real cardWidth: root.backend.viewMode === "grid"
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
                        onTapped: root.backend.selectedWorkflowId = wfCard.modelData.id
                    }

                    TapHandler {
                        acceptedButtons: Qt.RightButton
                        onTapped: {
                            root.backend.selectedWorkflowId = wfCard.modelData.id;
                            wfContextMenu.popup();
                        }
                    }

                    QQC2.Menu {
                        id: wfContextMenu

                        QQC2.MenuItem {
                            icon.name: "media-playback-start"
                            text: "Ejecutar flujo ahora"
                            onTriggered: root.backend.runWorkflow(wfCard.modelData.id)
                        }

                        QQC2.MenuItem {
                            icon.name: "document-edit"
                            text: "Editar flujo…"
                            onTriggered: {
                                root.backend.selectedWorkflowId = wfCard.modelData.id;
                                root.editRequested(wfCard.modelData.id);
                            }
                        }

                        QQC2.MenuItem {
                            icon.name: "edit-copy"
                            text: "Duplicar flujo"
                            onTriggered: root.backend.duplicateWorkflow(wfCard.modelData.id)
                        }

                        QQC2.MenuSeparator {}

                        QQC2.MenuItem {
                            icon.name: "edit-delete"
                            text: "Eliminar flujo"
                            onTriggered: root.backend.deleteWorkflow(wfCard.modelData.id)
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
                                Layout.preferredWidth: 28
                                Layout.preferredHeight: 28
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
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                radius: 12
                                color: runBtnHover.hovered ? Qt.rgba(1, 1, 1, 0.95) : Qt.rgba(1, 1, 1, 0.26)

                                HoverHandler { id: runBtnHover; cursorShape: Qt.PointingHandCursor }
                                TapHandler {
                                    onTapped: root.backend.runWorkflow(wfCard.modelData.id)
                                }

                                CachyIcon {
                                    anchors.centerIn: parent
                                    name: wfCard.isSelected ? "list-add" : "media-playback-start"
                                    size: wfCard.isSelected ? 12 : 10
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
