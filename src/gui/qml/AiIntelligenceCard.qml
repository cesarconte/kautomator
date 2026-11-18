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

    spacing: 14

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
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
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
                text: root.backend.aiCardHeadline
                font.pixelSize: 15
                font.weight: Font.Bold
                color: CachyTheme.textPrimary
            }

            Text {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: root.backend.aiCardQuote
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
        Layout.preferredHeight: 36
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
                    root.backend.describeChange(text.trim());
                    text = "";
                }
            }
        }
    }
}
