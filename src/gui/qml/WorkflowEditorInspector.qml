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
    signal closeRequested()
    signal savedNotification(string title)

    readonly property var categoryOptions: [
        { key: "quick_actions", label: qsTr("Acciones rápidas") },
        { key: "share_sheet",   label: qsTr("Hoja para compartir") },
        { key: "menu_bar",      label: qsTr("Barra de menús") },
        { key: "automation",    label: qsTr("Automatización") }
    ]

    readonly property var paletteColors: [
        "#8A56F0", "#F2CA38", "#F07C5B", "#76C4F0",
        "#F0AA4B", "#5465E3", "#468DF2", "#E66460",
        "#E676C4", "#3ECFA9", "#38C962"
    ]

    readonly property var iconOptions: [
        "glyph-layers", "glyph-globe", "glyph-laptop", "glyph-music",
        "glyph-document", "glyph-photo", "glyph-gif", "glyph-folder",
        "glyph-archive", "glyph-sparkles", "glyph-terminal", "glyph-camera",
        "glyph-share-arrow", "glyph-sun", "glyph-phone"
    ]

    readonly property var folderOptions: {
        var opts = [{ id: "", name: qsTr("Sin carpeta") }];
        if (root.backend && root.backend.folders) {
            for (var i = 0; i < root.backend.folders.length; ++i) {
                var f = root.backend.folders[i];
                opts.push({ id: f.id, name: f.name });
            }
        }
        return opts;
    }

    property string editColor: "#468DF2"
    property string editIcon: "glyph-layers"

    function syncFromSelected() {
        if (!root.backend) return;
        const wf = root.backend.selectedWorkflow;
        if (!wf) return;

        editTitleField.text = wf.title || "";
        editSubtitleField.text = wf.subtitle || "";
        editCommandField.text = wf.command || "";
        root.editColor = wf.color || "#468DF2";
        root.editIcon = (wf.icon && wf.icon.indexOf("glyph-") === 0) ? wf.icon : "glyph-layers";

        const cat = wf.category || "quick_actions";
        var catIdx = 0;
        for (var i = 0; i < root.categoryOptions.length; ++i) {
            if (root.categoryOptions[i].key === cat) {
                catIdx = i;
                break;
            }
        }
        editCategoryCombo.currentIndex = catIdx;

        const fid = wf.folderId || "";
        var fIdx = 0;
        for (var j = 0; j < root.folderOptions.length; ++j) {
            if (root.folderOptions[j].id === fid) {
                fIdx = j;
                break;
            }
        }
        editFolderCombo.currentIndex = fIdx;
    }

    onVisibleChanged: if (visible) syncFromSelected()
    Component.onCompleted: syncFromSelected()

    Connections {
        target: root.backend
        function onSelectedWorkflowIdChanged() {
            root.syncFromSelected();
        }
        function onFoldersChanged() {
            root.syncFromSelected();
        }
    }

    spacing: 0

    // Header row
    RowLayout {
        Layout.fillWidth: true
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.topMargin: 14
        Layout.bottomMargin: 10
        spacing: 10

        Rectangle {
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            radius: 8
            color: root.editColor

            CachyIcon {
                anchors.centerIn: parent
                name: "qrc:/icons/" + root.editIcon + ".svg"
                size: 16
                color: "#FFFFFF"
            }
        }

        CachyLabel {
            Layout.fillWidth: true
            elide: Text.ElideRight
            text: qsTr("Editar atajo")
            font.pixelSize: 15
            font.weight: Font.DemiBold
            color: CachyPalette.text
        }

        Rectangle {
            Layout.preferredWidth: 26
            Layout.preferredHeight: 26
            radius: 13
            color: closeHover.hovered ? CachyPalette.cardBackgroundHover : CachyPalette.surfacePill
            border.width: 1
            border.color: CachyPalette.specularBorder

            CachyIcon {
                anchors.centerIn: parent
                name: "close"
                size: 12
                color: CachyPalette.textSecondary
            }

            HoverHandler {
                id: closeHover
                cursorShape: Qt.PointingHandCursor
            }
            TapHandler {
                onTapped: root.closeRequested()
            }
            QQC2.ToolTip.visible: closeHover.hovered
            QQC2.ToolTip.text: qsTr("Cerrar inspector")
            QQC2.ToolTip.delay: 450
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: CachyPalette.dividerColor
    }

    // Scrollable Inspector Body
    Flickable {
        id: inspectorScroll
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        contentWidth: width
        contentHeight: formCol.implicitHeight + 28
        boundsBehavior: Flickable.StopAtBounds

        QQC2.ScrollBar.vertical: QQC2.ScrollBar {
            policy: QQC2.ScrollBar.AsNeeded
        }

        ColumnLayout {
            id: formCol
            width: inspectorScroll.width - 32
            x: 16
            y: 14
            spacing: 10

            CachyLabel {
                text: qsTr("Nombre del atajo")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: CachyPalette.textSecondary
            }
            CachyTextField {
                id: editTitleField
                Layout.fillWidth: true
                placeholderText: qsTr("Nombre")
            }

            CachyLabel {
                text: qsTr("Descripción")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: CachyPalette.textSecondary
            }
            CachyTextField {
                id: editSubtitleField
                Layout.fillWidth: true
                placeholderText: qsTr("Descripción breve")
            }

            CachyLabel {
                text: qsTr("Categoría")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: CachyPalette.textSecondary
            }
            CachyComboBox {
                id: editCategoryCombo
                Layout.fillWidth: true
                model: root.categoryOptions
                textRole: "label"
            }

            CachyLabel {
                text: qsTr("Carpeta")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: CachyPalette.textSecondary
            }
            CachyComboBox {
                id: editFolderCombo
                Layout.fillWidth: true
                model: root.folderOptions
                textRole: "name"
            }

            CachyLabel {
                text: qsTr("Color")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: CachyPalette.textSecondary
            }
            Flow {
                Layout.fillWidth: true
                spacing: 8

                Repeater {
                    model: root.paletteColors

                    Rectangle {
                        id: colorSwatch
                        required property string modelData
                        readonly property bool isCurrent: root.editColor.toUpperCase() === colorSwatch.modelData.toUpperCase()

                        width: 24
                        height: 24
                        radius: 12
                        color: colorSwatch.modelData
                        border.width: isCurrent ? 2.5 : 1
                        border.color: isCurrent ? CachyPalette.text : Qt.rgba(1, 1, 1, 0.28)

                        scale: swatchHover.hovered ? 1.08 : 1.0
                        Behavior on scale { NumberAnimation { duration: CachyTheme.animFast } }

                        HoverHandler {
                            id: swatchHover
                            cursorShape: Qt.PointingHandCursor
                        }
                        TapHandler {
                            onTapped: root.editColor = colorSwatch.modelData
                        }
                    }
                }
            }

            CachyLabel {
                text: qsTr("Icono")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: CachyPalette.textSecondary
            }
            Flow {
                Layout.fillWidth: true
                spacing: 6

                Repeater {
                    model: root.iconOptions

                    Rectangle {
                        id: iconTile
                        required property string modelData
                        readonly property bool isCurrent: root.editIcon === iconTile.modelData

                        width: 30
                        height: 30
                        radius: 8
                        color: isCurrent
                            ? root.editColor
                            : (iconHover.hovered ? CachyPalette.cardBackgroundHover : CachyPalette.cardBackground)
                        border.width: 1
                        border.color: isCurrent ? Qt.rgba(1, 1, 1, 0.35) : CachyPalette.specularBorder

                        CachyIcon {
                            anchors.centerIn: parent
                            name: "qrc:/icons/" + iconTile.modelData + ".svg"
                            size: 16
                            color: iconTile.isCurrent ? "#FFFFFF" : CachyPalette.text
                        }

                        HoverHandler {
                            id: iconHover
                            cursorShape: Qt.PointingHandCursor
                        }
                        TapHandler {
                            onTapped: root.editIcon = iconTile.modelData
                        }
                    }
                }
            }

            CachyLabel {
                text: qsTr("Comando ejecutable ({file}, {noext})")
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: CachyPalette.textSecondary
            }
            CachyTextField {
                id: editCommandField
                Layout.fillWidth: true
                placeholderText: qsTr("Comando de terminal")
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: CachyPalette.dividerColor
    }

    // Footer Actions
    RowLayout {
        Layout.fillWidth: true
        Layout.margins: 16
        spacing: 8

        CachyButton {
            Layout.fillWidth: true
            iconName: "play"
            text: qsTr("Ejecutar")
            onClicked: if (root.backend) root.backend.runWorkflow(root.backend.selectedWorkflowId)
        }

        CachyButton {
            Layout.fillWidth: true
            primary: true
            text: qsTr("Guardar")
            onClicked: {
                if (!root.backend) return;
                const catKey = (editCategoryCombo.currentIndex >= 0 && editCategoryCombo.currentIndex < root.categoryOptions.length)
                    ? root.categoryOptions[editCategoryCombo.currentIndex].key
                    : "quick_actions";
                const folderId = (editFolderCombo.currentIndex >= 0 && editFolderCombo.currentIndex < root.folderOptions.length)
                    ? root.folderOptions[editFolderCombo.currentIndex].id
                    : "";
                root.backend.updateWorkflow(
                    root.backend.selectedWorkflowId,
                    editTitleField.text,
                    editSubtitleField.text,
                    catKey,
                    root.editColor,
                    editCommandField.text,
                    folderId,
                    root.editIcon
                );
                root.savedNotification(editTitleField.text.trim() || qsTr("Atajo"));
                root.closeRequested();
            }
        }
    }
}
