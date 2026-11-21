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
    signal exportedNotification(string title)

    spacing: 8

    function gradientForColor(hexColor) {
        const key = (hexColor || "#468DF2").toUpperCase();
        const presets = {
            "#8A56F0": { top: "#9D6CF7", bottom: "#6845E0" },
            "#F2CA38": { top: "#FBE05E", bottom: "#E0B420" },
            "#F07C5B": { top: "#F89570", bottom: "#E16247" },
            "#76C4F0": { top: "#95DCFE", bottom: "#5AB0E3" },
            "#F0AA4B": { top: "#F8C06A", bottom: "#E19132" },
            "#5465E3": { top: "#6D7EF2", bottom: "#3D4ECB" },
            "#468DF2": { top: "#64AAFC", bottom: "#3173E0" },
            "#E66460": { top: "#F2807B", bottom: "#D04A47" },
            "#E676C4": { top: "#F393D6", bottom: "#D259AE" },
            "#3ECFA9": { top: "#5CE3C1", bottom: "#27B590" },
            "#38C962": { top: "#56DF7B", bottom: "#23AE4B" }
        };
        if (presets[key]) {
            return presets[key];
        }
        return {
            top: Qt.lighter(key, 1.13),
            bottom: Qt.darker(key, 1.12)
        };
    }

    function resolveCardIcon(item) {
        const raw = item && item.icon ? String(item.icon) : "";
        if (raw.indexOf("glyph-") === 0) {
            return "qrc:/icons/" + raw + ".svg";
        }
        const legacyMap = {
            "layers": "glyph-layers",
            "network-workgroup": "glyph-globe",
            "computer-laptop": "glyph-laptop",
            "audio-x-generic": "glyph-music",
            "application-pdf": "glyph-document",
            "image-x-generic": "glyph-photo",
            "video-x-generic": "glyph-gif",
            "folder-documents": "glyph-folder",
            "package-x-generic": "glyph-archive",
            "folder-pictures": "glyph-photo"
        };
        const mapped = legacyMap[raw] || "glyph-layers";
        return "qrc:/icons/" + mapped + ".svg";
    }

    readonly property var currentList: root.backend ? root.backend.filteredWorkflows : []

    // Shared context menu for both Grid cards and List rows
    CachyMenu {
        id: sharedContextMenu

        property var targetWorkflow: ({})

        function openFor(wf) {
            targetWorkflow = wf || ({});
            if (root.backend && targetWorkflow.id) {
                root.backend.selectedWorkflowId = targetWorkflow.id;
            }
            popup();
        }

        CachyMenuItem {
            iconName: "play"
            text: qsTr("Ejecutar ahora")
            onTriggered: {
                if (root.backend && sharedContextMenu.targetWorkflow.id) {
                    root.backend.runWorkflow(sharedContextMenu.targetWorkflow.id);
                }
            }
        }

        CachyMenuItem {
            iconName: "settings"
            text: qsTr("Editar atajo…")
            onTriggered: {
                if (root.backend && sharedContextMenu.targetWorkflow.id) {
                    root.backend.selectedWorkflowId = sharedContextMenu.targetWorkflow.id;
                    root.editRequested(sharedContextMenu.targetWorkflow.id);
                }
            }
        }

        CachyMenuItem {
            iconName: "add"
            text: qsTr("Duplicar atajo")
            onTriggered: {
                if (root.backend && sharedContextMenu.targetWorkflow.id) {
                    root.backend.duplicateWorkflow(sharedContextMenu.targetWorkflow.id);
                }
            }
        }

        CachyMenuItem {
            iconName: "share"
            text: qsTr("Exportar JSON")
            onTriggered: {
                if (root.backend && sharedContextMenu.targetWorkflow.id) {
                    root.backend.exportWorkflow(sharedContextMenu.targetWorkflow.id);
                    root.exportedNotification(sharedContextMenu.targetWorkflow.title || qsTr("Atajo"));
                }
            }
        }

        CachyMenuSeparator {}

        CachyMenuItem {
            text: qsTr("Sin carpeta")
            checkable: true
            checked: !sharedContextMenu.targetWorkflow.folderId
                || sharedContextMenu.targetWorkflow.folderId === ""
            onTriggered: {
                if (root.backend && sharedContextMenu.targetWorkflow.id) {
                    root.backend.assignWorkflowToFolder(sharedContextMenu.targetWorkflow.id, "");
                }
            }
        }

        Repeater {
            model: root.backend ? root.backend.folders : []

            CachyMenuItem {
                id: folderMenuChoice
                required property var modelData
                text: qsTr("Carpeta: %1").arg(folderMenuChoice.modelData.name || "")
                checkable: true
                checked: (sharedContextMenu.targetWorkflow.folderId || "") === folderMenuChoice.modelData.id
                onTriggered: {
                    if (root.backend && sharedContextMenu.targetWorkflow.id) {
                        root.backend.assignWorkflowToFolder(
                            sharedContextMenu.targetWorkflow.id,
                            folderMenuChoice.modelData.id
                        );
                    }
                }
            }
        }

        CachyMenuSeparator {}

        CachyMenuItem {
            iconName: "trash"
            text: qsTr("Eliminar atajo")
            destructive: true
            onTriggered: {
                if (root.backend && sharedContextMenu.targetWorkflow.id) {
                    root.backend.deleteWorkflow(sharedContextMenu.targetWorkflow.id);
                }
            }
        }
    }

    // Smart Folder Daemon Status & System Integration Bar (shown only in "Automatización")
    Rectangle {
        visible: root.backend !== null && root.backend.currentCategory === "automation"
        Layout.fillWidth: true
        Layout.leftMargin: 14
        Layout.rightMargin: 14
        Layout.topMargin: 12
        implicitHeight: autoBarCol.implicitHeight + 16
        radius: 12
        color: CachyPalette.cardBackground
        border.width: 1
        border.color: CachyPalette.specularBorder

        ColumnLayout {
            id: autoBarCol
            anchors.fill: parent
            anchors.margins: 8
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    Layout.preferredWidth: 8
                    Layout.preferredHeight: 8
                    radius: 4
                    color: (root.backend && root.backend.daemonActive) ? "#34C759" : "#8E8E93"
                }

                Text {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: CachyPalette.text
                    text: (root.backend && root.backend.daemonActive)
                        ? qsTr("Demonio inotify activo (~/Descargas)")
                        : qsTr("Demonio inotify detenido")
                }

                CachySwitch {
                    implicitWidth: 38
                    implicitHeight: 22
                    checked: root.backend !== null && root.backend.daemonActive
                    onToggled: if (root.backend) root.backend.toggleDaemon()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                CachyButton {
                    implicitHeight: 26
                    iconName: "play"
                    text: qsTr("Ejecutar")
                    onClicked: if (root.backend) root.backend.runAllFolderRulesNow()
                }

                CachyButton {
                    implicitHeight: 26
                    iconName: "file"
                    text: "rules.toml"
                    onClicked: if (root.backend) root.backend.openRulesFileInEditor()
                }

                CachyButton {
                    Layout.fillWidth: true
                    implicitHeight: 26
                    iconName: "settings"
                    text: qsTr("Atajos del Sistema")
                    onClicked: if (root.backend) root.backend.openSystemKeyboardShortcuts()
                }
            }
        }
    }

    // Empty state when folder/filter/search has zero results
    Item {
        visible: root.currentList.length === 0
        Layout.fillWidth: true
        Layout.fillHeight: true

        CachyPlaceholderMessage {
            anchors.centerIn: parent
            width: Math.min(parent.width - 32, 280)
            iconName: (root.backend && root.backend.searchQuery.length > 0) ? "search" : "folder"
            iconSize: 44
            text: (root.backend && root.backend.searchQuery.length > 0)
                ? qsTr("Sin atajos para «%1»").arg(root.backend.searchQuery)
                : qsTr("No hay atajos en esta vista")
            helpfulAction: (root.backend && root.backend.searchQuery.length > 0)
                ? {
                    text: qsTr("Limpiar búsqueda"),
                    onTriggered: function() { if (root.backend) root.backend.searchQuery = ""; }
                }
                : {
                    text: qsTr("Nuevo atajo"),
                    onTriggered: function() { if (root.backend) root.backend.createNewWorkflow(); }
                }
        }
    }

    // Main Scrollable Grid / List Area
    Flickable {
        id: wfScroll
        visible: root.currentList.length > 0
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        contentWidth: width
        contentHeight: root.backend && root.backend.viewMode === "list"
            ? (wfListCol.implicitHeight + 28)
            : (wfGrid.implicitHeight + 28)
        boundsBehavior: Flickable.StopAtBounds

        QQC2.ScrollBar.vertical: QQC2.ScrollBar {
            id: vScroll
            policy: QQC2.ScrollBar.AsNeeded
            width: 10
            padding: 2
            background: Item {}
            contentItem: Rectangle {
                implicitWidth: 6
                radius: 3
                color: CachyPalette.isDark ? Qt.rgba(1, 1, 1, 0.34) : Qt.rgba(0, 0, 0, 0.26)
                opacity: vScroll.active || vScroll.hovered ? 0.95 : 0.65
                Behavior on opacity { NumberAnimation { duration: CachyTheme.animFast } }
            }
        }

        // ---------------------------------------------------------------------
        // 1. GOLDEN GATE 2-COLUMN VIBRANT GRADIENT CARDS GRID
        // ---------------------------------------------------------------------
        GridLayout {
            id: wfGrid
            visible: !root.backend || root.backend.viewMode !== "list"
            x: 14
            y: 12
            width: Math.max(120, wfScroll.width - 32)
            columns: 2
            columnSpacing: 10
            rowSpacing: 10

            Repeater {
                model: (!root.backend || root.backend.viewMode !== "list") ? root.currentList : []

                Rectangle {
                    id: wfCard
                    required property var modelData
                    required property int index

                    readonly property bool isSelected: root.backend !== null
                        && wfCard.modelData.id === root.backend.selectedWorkflowId
                    readonly property bool isRunning: root.backend !== null
                        && wfCard.modelData.id === root.backend.runningWorkflowId
                    readonly property var gradPair: root.gradientForColor(wfCard.modelData.color)
                    readonly property real cardWidth: Math.max(110, Math.floor((wfGrid.width - wfGrid.columnSpacing) / 2))

                    Layout.fillWidth: true
                    Layout.preferredWidth: cardWidth
                    Layout.maximumWidth: cardWidth
                    implicitHeight: 100
                    radius: 19
                    clip: true

                    gradient: Gradient {
                        GradientStop { position: 0.0; color: wfCard.gradPair.top }
                        GradientStop { position: 1.0; color: wfCard.gradPair.bottom }
                    }

                    border.width: wfCard.isSelected ? 2 : 1
                    border.color: wfCard.isSelected ? Qt.rgba(1, 1, 1, 0.92) : Qt.rgba(1, 1, 1, 0.22)

                    scale: wfCardHover.hovered ? 1.012 : 1.0
                    Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutQuad } }

                    // Subtle top specular glass sheen
                    Rectangle {
                        anchors.fill: parent
                        radius: 19
                        color: "transparent"
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.14) }
                            GradientStop { position: 0.45; color: "transparent" }
                        }
                    }

                    HoverHandler {
                        id: wfCardHover
                        cursorShape: Qt.PointingHandCursor
                    }

                    // Card click / double-click / right-click layer (below runBtn)
                    Item {
                        anchors.fill: parent

                        TapHandler {
                            acceptedButtons: Qt.LeftButton
                            onTapped: {
                                if (root.backend) {
                                    root.backend.selectedWorkflowId = wfCard.modelData.id;
                                }
                            }
                            onDoubleTapped: {
                                if (root.backend) {
                                    root.backend.selectedWorkflowId = wfCard.modelData.id;
                                    root.editRequested(wfCard.modelData.id);
                                }
                            }
                        }

                        TapHandler {
                            acceptedButtons: Qt.RightButton
                            onTapped: sharedContextMenu.openFor(wfCard.modelData)
                        }
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 13
                        anchors.rightMargin: 11
                        anchors.topMargin: 12
                        anchors.bottomMargin: 11
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true

                            // Clean white SF-style glyph directly over the gradient (no grey circle)
                            CachyIcon {
                                name: root.resolveCardIcon(wfCard.modelData)
                                size: 22
                                color: "#FFFFFF"
                            }

                            Item { Layout.fillWidth: true }

                            // Solid white circular Play button (matches Golden Gate top-right circle)
                            Rectangle {
                                id: runBtn
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                radius: 12
                                color: "#FFFFFF"
                                opacity: (wfCard.isSelected || wfCardHover.hovered || wfCard.isRunning)
                                    ? (runBtnMouse.containsMouse ? 1.0 : 0.94)
                                    : 0.0
                                scale: runBtnMouse.pressed ? 0.90 : 1.0

                                Behavior on opacity { NumberAnimation { duration: 120 } }
                                Behavior on scale { NumberAnimation { duration: 100 } }

                                CachyBusyIndicator {
                                    anchors.centerIn: parent
                                    visible: wfCard.isRunning
                                    running: visible
                                    size: 14
                                    color: wfCard.gradPair.bottom
                                }

                                CachyIcon {
                                    anchors.centerIn: parent
                                    anchors.horizontalCenterOffset: 1
                                    visible: !wfCard.isRunning
                                    name: "play"
                                    size: 11
                                    color: wfCard.gradPair.bottom
                                }

                                MouseArea {
                                    id: runBtnMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (root.backend) {
                                            root.backend.selectedWorkflowId = wfCard.modelData.id;
                                            root.backend.runWorkflow(wfCard.modelData.id);
                                        }
                                    }
                                }
                            }
                        }

                        Item { Layout.fillHeight: true }

                        Text {
                            Layout.fillWidth: true
                            Layout.maximumWidth: wfCard.cardWidth - 24
                            text: wfCard.modelData.title || qsTr("Atajo")
                            color: "#FFFFFF"
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            lineHeight: 1.15
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                        }
                    }
                }
            }
        }

        // ---------------------------------------------------------------------
        // 2. GOLDEN GATE COMPACT LIST VIEW
        // ---------------------------------------------------------------------
        ColumnLayout {
            id: wfListCol
            visible: root.backend !== null && root.backend.viewMode === "list"
            x: 14
            y: 12
            width: Math.max(120, wfScroll.width - 32)
            spacing: 6

            Repeater {
                model: (root.backend && root.backend.viewMode === "list") ? root.currentList : []

                Rectangle {
                    id: wfRow
                    required property var modelData
                    required property int index

                    readonly property bool isSelected: root.backend !== null
                        && wfRow.modelData.id === root.backend.selectedWorkflowId
                    readonly property bool isRunning: root.backend !== null
                        && wfRow.modelData.id === root.backend.runningWorkflowId
                    readonly property var gradPair: root.gradientForColor(wfRow.modelData.color)

                    Layout.fillWidth: true
                    implicitHeight: 46
                    radius: 10
                    color: wfRow.isSelected
                        ? (CachyPalette.isDark ? Qt.rgba(1, 1, 1, 0.12) : Qt.rgba(0, 0, 0, 0.07))
                        : (wfRowHover.hovered ? CachyPalette.cardBackgroundHover : CachyPalette.cardBackground)
                    border.width: 1
                    border.color: wfRow.isSelected ? CachyTheme.accentColor : CachyPalette.specularBorder

                    Behavior on color { ColorAnimation { duration: CachyTheme.animFast } }

                    HoverHandler {
                        id: wfRowHover
                        cursorShape: Qt.PointingHandCursor
                    }

                    Item {
                        anchors.fill: parent

                        TapHandler {
                            acceptedButtons: Qt.LeftButton
                            onTapped: {
                                if (root.backend) {
                                    root.backend.selectedWorkflowId = wfRow.modelData.id;
                                }
                            }
                            onDoubleTapped: {
                                if (root.backend) {
                                    root.backend.selectedWorkflowId = wfRow.modelData.id;
                                    root.editRequested(wfRow.modelData.id);
                                }
                            }
                        }

                        TapHandler {
                            acceptedButtons: Qt.RightButton
                            onTapped: sharedContextMenu.openFor(wfRow.modelData)
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 10

                        // Mini gradient squircle icon
                        Rectangle {
                            Layout.preferredWidth: 28
                            Layout.preferredHeight: 28
                            radius: 8

                            gradient: Gradient {
                                GradientStop { position: 0.0; color: wfRow.gradPair.top }
                                GradientStop { position: 1.0; color: wfRow.gradPair.bottom }
                            }

                            CachyIcon {
                                anchors.centerIn: parent
                                name: root.resolveCardIcon(wfRow.modelData)
                                size: 15
                                color: "#FFFFFF"
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            Text {
                                Layout.fillWidth: true
                                text: wfRow.modelData.title || qsTr("Atajo")
                                font.pixelSize: 13
                                font.weight: Font.DemiBold
                                color: CachyPalette.text
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text.length > 0
                                text: wfRow.modelData.subtitle || ""
                                font.pixelSize: 11
                                color: CachyPalette.textSecondary
                                elide: Text.ElideRight
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            radius: 12
                            color: "#FFFFFF"
                            border.width: CachyPalette.isDark ? 0 : 1
                            border.color: Qt.rgba(0, 0, 0, 0.08)
                            opacity: (wfRow.isSelected || wfRowHover.hovered || wfRow.isRunning) ? 1.0 : 0.0

                            Behavior on opacity { NumberAnimation { duration: 120 } }

                            CachyBusyIndicator {
                                anchors.centerIn: parent
                                visible: wfRow.isRunning
                                running: visible
                                size: 14
                                color: wfRow.gradPair.bottom
                            }

                            CachyIcon {
                                anchors.centerIn: parent
                                anchors.horizontalCenterOffset: 1
                                visible: !wfRow.isRunning
                                name: "play"
                                size: 11
                                color: wfRow.gradPair.bottom
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (root.backend) {
                                        root.backend.selectedWorkflowId = wfRow.modelData.id;
                                        root.backend.runWorkflow(wfRow.modelData.id);
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
