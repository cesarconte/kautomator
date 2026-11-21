/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import CachyOS.UI

ColumnLayout {
    id: root

    required property var backend

    spacing: 0

    // Upper offset so the Liquid Glass prompt card sits in the upper-middle area like Golden Gate
    Item { Layout.preferredHeight: 36 }

    Item {
        id: cardWrapper
        Layout.fillWidth: true
        Layout.leftMargin: 22
        Layout.rightMargin: 22
        implicitHeight: Math.max(196, aiCardCol.implicitHeight + 52)

        // Ambient iridescent halo behind the frosted squircle (adapts to Light & Dark theme)
        Item {
            id: glowPadBox
            anchors.centerIn: aiCard
            width: aiCard.width + 140
            height: aiCard.height + 140
            z: 0

            Item {
                id: glowSource
                anchors.fill: parent
                visible: false
                layer.enabled: true

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: -20
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 16
                    width: aiCard.width * 0.78
                    height: aiCard.height * 0.72
                    radius: height / 2
                    color: "#7C5CFF"
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 22
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 20
                    width: aiCard.width * 0.72
                    height: aiCard.height * 0.68
                    radius: height / 2
                    color: CachyPalette.isDark ? "#62B6FF" : "#C471ED"
                }
            }

            MultiEffect {
                anchors.fill: glowSource
                source: glowSource
                blurEnabled: true
                blur: 1.0
                blurMax: 64
                opacity: {
                    const base = CachyPalette.isDark ? 0.30 : 0.22;
                    if (root.backend && root.backend.aiBusy) return base + 0.14;
                    if (describeField.activeFocus) return base + 0.08;
                    return base;
                }

                Behavior on opacity {
                    NumberAnimation { duration: CachyTheme.animNormal }
                }
            }
        }

        // Liquid Glass squircle card
        Rectangle {
            id: aiCard
            z: 1
            anchors.fill: parent
            radius: 32
            border.width: 1
            border.color: CachyPalette.isDark ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(0, 0, 0, 0.09)

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: CachyPalette.isDark
                        ? Qt.rgba(1.0, 1.0, 1.0, 0.06)
                        : Qt.rgba(1.0, 1.0, 1.0, 0.80)
                }
                GradientStop {
                    position: 1.0
                    color: CachyPalette.isDark
                        ? Qt.rgba(0.20, 0.17, 0.28, 0.40)
                        : Qt.rgba(0.94, 0.93, 0.99, 0.68)
                }
            }

            ColumnLayout {
                id: aiCardCol
                anchors.centerIn: parent
                width: parent.width - 52
                spacing: 10

                CachyBusyIndicator {
                    Layout.alignment: Qt.AlignHCenter
                    visible: root.backend !== null && root.backend.aiBusy
                    running: visible
                    size: 22
                }

                Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    lineHeight: 1.18
                    text: root.backend ? root.backend.aiCardHeadline : qsTr("¿Qué quieres que haga tu atajo?")
                    font.pixelSize: 17
                    font.weight: Font.DemiBold
                    color: CachyPalette.text
                }

                Text {
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    text: root.backend ? root.backend.aiCardQuote : qsTr("«Organizar mis descargas en carpetas»")
                    font.pixelSize: 12
                    color: CachyPalette.textSecondary
                }
            }
        }
    }

    Item { Layout.fillHeight: true }

    // Bottom Pill Input: "Describe un atajo"
    Rectangle {
        Layout.fillWidth: true
        Layout.leftMargin: 18
        Layout.rightMargin: 18
        Layout.bottomMargin: 18
        Layout.preferredHeight: 36
        radius: 18
        color: describeField.activeFocus ? CachyPalette.cardBackgroundHover : CachyPalette.surfacePill
        border.width: describeField.activeFocus ? 1.5 : 1
        border.color: describeField.activeFocus ? CachyTheme.accentColor : CachyPalette.specularBorder

        Behavior on color { ColorAnimation { duration: CachyTheme.animFast } }
        Behavior on border.color { ColorAnimation { duration: CachyTheme.animFast } }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 6
            spacing: 6

            TextInput {
                id: describeField
                Layout.fillWidth: true
                font.pixelSize: 13
                color: CachyPalette.text
                selectionColor: CachyTheme.accentColor
                selectedTextColor: "#FFFFFF"
                clip: true
                verticalAlignment: TextInput.AlignVCenter
                onAccepted: {
                    if (text.trim().length > 0 && root.backend) {
                        root.backend.describeChange(text.trim());
                        text = "";
                    }
                }

                Keys.onEscapePressed: {
                    text = "";
                    focus = false;
                }

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Describe un atajo")
                    font.pixelSize: 13
                    color: CachyPalette.textMuted
                    visible: describeField.text.length === 0
                    elide: Text.ElideRight
                }
            }

            Rectangle {
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                radius: 12
                visible: describeField.text.trim().length > 0
                color: sendHover.hovered ? Qt.darker(CachyTheme.accentColor, 1.1) : CachyTheme.accentColor

                CachyIcon {
                    anchors.centerIn: parent
                    name: "chevron-right"
                    size: 13
                    color: "#FFFFFF"
                }

                HoverHandler {
                    id: sendHover
                    cursorShape: Qt.PointingHandCursor
                }
                TapHandler {
                    onTapped: {
                        if (describeField.text.trim().length > 0 && root.backend) {
                            root.backend.describeChange(describeField.text.trim());
                            describeField.text = "";
                        }
                    }
                }
            }
        }
    }
}
