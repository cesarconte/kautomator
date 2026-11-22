/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import CachyOS.UI

Flickable {
    id: root

    required property var backend
    signal renameFolderRequested(string folderId, string currentName)

    clip: true
    contentWidth: width
    contentHeight: sidebarCol.implicitHeight + 16
    boundsBehavior: Flickable.StopAtBounds

    QQC2.ScrollBar.vertical: QQC2.ScrollBar {
        policy: QQC2.ScrollBar.AsNeeded
    }

    ColumnLayout {
        id: sidebarCol
        width: root.width
        spacing: 2

        Item { Layout.preferredHeight: 4 }

        // Top section: Galería & Automatización (monochrome SF-style icons)
        CachySidebarItem {
            Layout.fillWidth: true
            text: qsTr("Galería")
            iconName: "grid"
            accentSelected: true
            iconColor: selected ? "#FFFFFF" : CachyPalette.textSecondary
            selected: root.backend !== null && root.backend.currentCategory === "gallery"
            onClicked: if (root.backend) root.backend.currentCategory = "gallery"
        }

        CachySidebarItem {
            id: automationItem
            Layout.fillWidth: true
            text: qsTr("Automatización")
            iconName: "alarm"
            accentSelected: true
            iconColor: selected ? "#FFFFFF" : CachyPalette.textSecondary
            selected: root.backend !== null && root.backend.currentCategory === "automation"
            onClicked: if (root.backend) root.backend.currentCategory = "automation"

            TapHandler {
                acceptedButtons: Qt.RightButton
                onTapped: automationContextMenu.popup()
            }

            CachyMenu {
                id: automationContextMenu

                CachyMenuItem {
                    text: (root.backend && root.backend.daemonActive)
                        ? qsTr("Detener demonio inotify")
                        : qsTr("Activar demonio inotify")
                    iconName: (root.backend && root.backend.daemonActive) ? "pause" : "play"
                    onTriggered: if (root.backend) root.backend.toggleDaemon()
                }
                CachyMenuItem {
                    text: qsTr("Ejecutar reglas ahora")
                    iconName: "refresh"
                    onTriggered: if (root.backend) root.backend.runAllFolderRulesNow()
                }
                CachyMenuSeparator {}
                CachyMenuItem {
                    text: qsTr("Editar rules.toml…")
                    iconName: "file"
                    onTriggered: if (root.backend) root.backend.openRulesFileInEditor()
                }
                CachyMenuItem {
                    text: qsTr("Atajos del Sistema…")
                    iconName: "settings"
                    onTriggered: if (root.backend) root.backend.openSystemKeyboardShortcuts()
                }
            }
        }

        Item { Layout.preferredHeight: 14 }

        // Section: Biblioteca
        Text {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.bottomMargin: 2
            text: qsTr("Biblioteca")
            font.pixelSize: 11
            font.weight: Font.DemiBold
            color: CachyPalette.textMuted
        }

        CachySidebarItem {
            Layout.fillWidth: true
            text: qsTr("Todos los atajos")
            iconName: "qrc:/icons/shortcuts-stack.svg"
            accentSelected: true
            iconColor: selected ? "#FFFFFF" : CachyPalette.textSecondary
            badgeText: (root.backend && root.backend.allShortcutsCount > 0)
                ? root.backend.allShortcutsCount.toString() : ""
            selected: root.backend !== null && root.backend.currentCategory === "all"
            onClicked: if (root.backend) root.backend.currentCategory = "all"
        }

        CachySidebarItem {
            Layout.fillWidth: true
            text: qsTr("Hoja para compartir")
            iconName: "share"
            accentSelected: true
            iconColor: selected ? "#FFFFFF" : CachyPalette.textSecondary
            badgeText: (root.backend && root.backend.shareSheetCount > 0)
                ? root.backend.shareSheetCount.toString() : ""
            selected: root.backend !== null && root.backend.currentCategory === "share_sheet"
            onClicked: if (root.backend) root.backend.currentCategory = "share_sheet"
        }

        CachySidebarItem {
            Layout.fillWidth: true
            text: qsTr("Acciones rápidas")
            iconName: "settings"
            accentSelected: true
            iconColor: selected ? "#FFFFFF" : CachyPalette.textSecondary
            badgeText: (root.backend && root.backend.quickActionsCount > 0)
                ? root.backend.quickActionsCount.toString() : ""
            selected: root.backend !== null && root.backend.currentCategory === "quick_actions"
            onClicked: if (root.backend) root.backend.currentCategory = "quick_actions"
        }

        CachySidebarItem {
            Layout.fillWidth: true
            text: qsTr("Barra de menús")
            iconName: "qrc:/icons/menubar-window.svg"
            accentSelected: true
            iconColor: selected ? "#FFFFFF" : CachyPalette.textSecondary
            badgeText: (root.backend && root.backend.menuBarCount > 0)
                ? root.backend.menuBarCount.toString() : ""
            selected: root.backend !== null && root.backend.currentCategory === "menu_bar"
            onClicked: if (root.backend) root.backend.currentCategory = "menu_bar"
        }

        Item { Layout.preferredHeight: 14 }

        // Section: Carpetas
        Text {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.bottomMargin: 2
            text: qsTr("Carpetas")
            font.pixelSize: 11
            font.weight: Font.DemiBold
            color: CachyPalette.textMuted
            visible: root.backend !== null && root.backend.folders.length > 0
        }

        Repeater {
            model: root.backend ? root.backend.folders : []

            CachySidebarItem {
                id: folderItem
                required property var modelData

                Layout.fillWidth: true
                text: folderItem.modelData.name || qsTr("Carpeta")
                iconName: folderItem.modelData.icon || "folder"
                accentSelected: true
                iconColor: selected ? "#FFFFFF" : CachyPalette.textSecondary
                badgeText: (folderItem.modelData.count > 0)
                    ? folderItem.modelData.count.toString() : ""
                selected: root.backend !== null
                    && root.backend.currentCategory === ("folder:" + folderItem.modelData.id)
                onClicked: {
                    if (root.backend) {
                        root.backend.currentCategory = "folder:" + folderItem.modelData.id;
                    }
                }

                TapHandler {
                    acceptedButtons: Qt.RightButton
                    onTapped: folderContextMenu.popup()
                }

                CachyMenu {
                    id: folderContextMenu

                    CachyMenuItem {
                        text: qsTr("Renombrar carpeta…")
                        iconName: "tag"
                        onTriggered: root.renameFolderRequested(
                            folderItem.modelData.id,
                            folderItem.modelData.name || ""
                        )
                    }

                    CachyMenuSeparator {}

                    CachyMenuItem {
                        text: qsTr("Eliminar carpeta")
                        iconName: "trash"
                        destructive: true
                        onTriggered: {
                            if (root.backend) {
                                root.backend.deleteFolder(folderItem.modelData.id);
                            }
                        }
                    }
                }
            }
        }
    }
}
