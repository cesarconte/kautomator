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
    signal closeRequested()

    spacing: 10

    CachyLabel {
        Layout.fillWidth: true
        elide: Text.ElideRight
        text: "Editar flujo seleccionado"
        font.pixelSize: 14
        font.weight: Font.Bold
        color: CachyPalette.text
    }

    CachyLabel {
        text: "Nombre del flujo:"
        font.pixelSize: 11
        color: CachyPalette.textSecondary
    }
    CachyTextField {
        id: editTitleField
        Layout.fillWidth: true
        text: root.backend.selectedWorkflow.title || ""
    }

    CachyLabel {
        text: "Descripción:"
        font.pixelSize: 11
        color: CachyPalette.textSecondary
    }
    CachyTextField {
        id: editSubtitleField
        Layout.fillWidth: true
        text: root.backend.selectedWorkflow.subtitle || ""
    }

    CachyLabel {
        text: "Categoría:"
        font.pixelSize: 11
        color: CachyPalette.textSecondary
    }
    CachyComboBox {
        id: editCategoryCombo
        Layout.fillWidth: true
        model: ["quick_actions", "share_sheet", "menu_bar", "automation"]
        currentIndex: Math.max(0, model.indexOf(root.backend.selectedWorkflow.category || "quick_actions"))
    }

    CachyLabel {
        text: "Color de tarjeta:"
        font.pixelSize: 11
        color: CachyPalette.textSecondary
    }
    RowLayout {
        spacing: 8
        Repeater {
            model: ["#0091FF", "#B65CE6", "#28CD56", "#FF4D62", "#FF64B4", "#7D828C"]
            Rectangle {
                id: colorRect
                required property string modelData
                width: 22
                height: 22
                radius: 11
                color: modelData
                border.width: editColorDummy.text === modelData ? 2 : 0
                border.color: "#FFFFFF"
                TapHandler { onTapped: editColorDummy.text = colorRect.modelData }
            }
        }
    }
    Text {
        id: editColorDummy
        visible: false
        text: root.backend.selectedWorkflow.color || "#0091FF"
    }

    CachyLabel {
        text: "Comando ejecutable ({file}, {noext}):"
        font.pixelSize: 11
        color: CachyPalette.textSecondary
    }
    CachyTextField {
        id: editCommandField
        Layout.fillWidth: true
        text: root.backend.selectedWorkflow.command || ""
    }

    Item { Layout.fillHeight: true }

    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        CachyButton {
            Layout.fillWidth: true
            iconName: "media-playback-start"
            text: "Ejecutar"
            onClicked: root.backend.runWorkflow(root.backend.selectedWorkflowId)
        }

        CachyButton {
            Layout.fillWidth: true
            primary: true
            text: "Guardar"
            onClicked: {
                root.backend.updateWorkflow(
                    root.backend.selectedWorkflowId,
                    editTitleField.text,
                    editSubtitleField.text,
                    editCategoryCombo.displayText,
                    editColorDummy.text,
                    editCommandField.text
                );
                root.closeRequested();
            }
        }
    }
}
