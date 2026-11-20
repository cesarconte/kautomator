/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import CachyOS.UI

ColumnLayout {
    id: root

    required property var backend

    spacing: 4

    CachySidebarItem {
        Layout.fillWidth: true
        text: "Gallery"
        iconName: "view-grid"
        iconColor: "#007AFF"
        selected: root.backend.currentCategory === "gallery"
        onClicked: root.backend.currentCategory = "gallery"
    }

    CachySidebarItem {
        Layout.fillWidth: true
        text: "Automation"
        iconName: "chronometer"
        iconColor: "#34C759"
        badgeText: root.backend.daemonActive ? "ON" : "OFF"
        selected: root.backend.currentCategory === "automation"
        onClicked: root.backend.currentCategory = "automation"
    }

    Item { Layout.preferredHeight: 8 }

    CachyLabel {
        Layout.leftMargin: 10
        text: "Library"
        font.pixelSize: 11
        font.weight: Font.DemiBold
        color: CachyPalette.textMuted
    }

    CachySidebarItem {
        Layout.fillWidth: true
        text: "All Shortcuts"
        iconName: "applications-system"
        iconColor: "#007AFF"
        badgeText: root.backend.allShortcutsCount.toString()
        selected: root.backend.currentCategory === "all"
        onClicked: root.backend.currentCategory = "all"
    }

    CachySidebarItem {
        Layout.fillWidth: true
        text: "Share Sheet"
        iconName: "document-share"
        iconColor: "#5E5CE6"
        badgeText: root.backend.shareSheetCount.toString()
        selected: root.backend.currentCategory === "share_sheet"
        onClicked: root.backend.currentCategory = "share_sheet"
    }

    CachySidebarItem {
        Layout.fillWidth: true
        text: "Quick Actions"
        iconName: "quickopen"
        iconColor: "#FF9F0A"
        badgeText: root.backend.quickActionsCount.toString()
        selected: root.backend.currentCategory === "quick_actions"
        onClicked: root.backend.currentCategory = "quick_actions"
    }

    CachySidebarItem {
        Layout.fillWidth: true
        text: "Menu Bar"
        iconName: "preferences-system"
        iconColor: "#AF52DE"
        badgeText: root.backend.menuBarCount.toString()
        selected: root.backend.currentCategory === "menu_bar"
        onClicked: root.backend.currentCategory = "menu_bar"
    }

    Item { Layout.fillHeight: true }

    CachyDivider { Layout.fillWidth: true }

    // Direct link to KDE System Settings -> Keyboard -> Shortcuts (Zero shortcut duplication!)
    CachyToolbarButton {
        Layout.fillWidth: true
        iconName: "preferences-desktop-keyboard"
        text: "Atajos del Sistema"
        tooltipText: "Abrir Preferencias del Sistema → Teclado → Atajos (sin duplicidades)"
        onClicked: root.backend.openSystemKeyboardShortcuts()
    }
}
