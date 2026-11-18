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

    spacing: 10

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
        text: root.backend.selectedWorkflow.title || ""
    }

    Text {
        text: "Descripción:"
        font.pixelSize: 11
        color: CachyTheme.textSecondary
    }
    CachyTextField {
        id: editSubtitleField
        Layout.fillWidth: true
        text: root.backend.selectedWorkflow.subtitle || ""
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
        currentIndex: Math.max(0, model.indexOf(root.backend.selectedWorkflow.category || "quick_actions"))
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

    Text {
        text: "Comando ejecutable ({file}, {noext}):"
        font.pixelSize: 11
        color: CachyTheme.textSecondary
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
            text: "▶ Ejecutar"
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
                    editCategoryCombo.currentText,
                    editColorDummy.text,
                    editCommandField.text
                );
                root.closeRequested();
            }
        }
    }
}
