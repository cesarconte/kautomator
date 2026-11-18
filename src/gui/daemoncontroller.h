/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#pragma once

#include <QObject>

class DaemonController : public QObject
{
    Q_OBJECT

public:
    explicit DaemonController(QObject *parent = nullptr);
    ~DaemonController() override = default;

    bool daemonActive() const { return m_daemonActive; }
    void refreshDaemonStatus();
    void toggleDaemon();

    static void openRulesFileInEditor();
    static void openSystemKeyboardShortcuts();

Q_SIGNALS:
    void daemonStateChanged(bool active);

private:
    bool m_daemonActive = false;
};
