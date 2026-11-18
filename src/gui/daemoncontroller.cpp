/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#include "daemoncontroller.h"

#include <QProcess>
#include <QStandardPaths>

DaemonController::DaemonController(QObject *parent)
    : QObject(parent)
{
    refreshDaemonStatus();
}

void DaemonController::refreshDaemonStatus()
{
    QProcess proc;
    proc.start(QStringLiteral("systemctl"), {QStringLiteral("--user"), QStringLiteral("is-active"), QStringLiteral("kautomator.service")});
    proc.waitForFinished(1500);
    const QString out = QString::fromUtf8(proc.readAllStandardOutput()).trimmed();
    const bool active = (out == QLatin1String("active"));
    if (m_daemonActive != active) {
        m_daemonActive = active;
        Q_EMIT daemonStateChanged(m_daemonActive);
    }
}

void DaemonController::toggleDaemon()
{
    const QString action = m_daemonActive ? QStringLiteral("stop") : QStringLiteral("start");
    QProcess::execute(QStringLiteral("systemctl"), {QStringLiteral("--user"), action, QStringLiteral("kautomator.service")});
    refreshDaemonStatus();
}

void DaemonController::openRulesFileInEditor()
{
    const QString rulesPath = QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation)
        + QStringLiteral("/kautomator/rules.toml");
    QProcess::startDetached(QStringLiteral("xdg-open"), {rulesPath});
}

void DaemonController::openSystemKeyboardShortcuts()
{
    // Delegate keyboard shortcuts exclusively to KDE System Settings -> Keyboard -> Shortcuts (kcm_keys)
    QProcess::startDetached(QStringLiteral("systemsettings"), {QStringLiteral("kcm_keys")});
}
