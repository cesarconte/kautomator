/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#include "workflowrunner.h"

#include <QFileInfo>
#include <QProcess>
#include <QUrl>

WorkflowRunner::WorkflowRunner(QObject *parent)
    : QObject(parent)
{
}

void WorkflowRunner::runWorkflow(const QVariantMap &workflow, const QString &fileUrl)
{
    if (workflow.isEmpty()) {
        return;
    }

    const QString id = workflow.value(QStringLiteral("id")).toString();
    const QString title = workflow.value(QStringLiteral("title")).toString();
    const bool needsFile = workflow.value(QStringLiteral("needsFile")).toBool();

    if (needsFile && fileUrl.trimmed().isEmpty()) {
        Q_EMIT fileSelectionRequested(id, title);
        return;
    }

    QString cmd = workflow.value(QStringLiteral("command")).toString();
    if (!fileUrl.trimmed().isEmpty()) {
        QString localPath = fileUrl;
        if (localPath.startsWith(QLatin1String("file://"))) {
            localPath = QUrl(localPath).toLocalFile();
        }
        const QFileInfo fi(localPath);
        const QString noExt = fi.absolutePath() + QLatin1Char('/') + fi.completeBaseName();
        const QString quotedFile = QLatin1Char('\'') + localPath + QLatin1Char('\'');
        const QString quotedNoExt = QLatin1Char('\'') + noExt + QLatin1Char('\'');
        cmd.replace(QStringLiteral("{file}"), quotedFile);
        cmd.replace(QStringLiteral("{noext}"), quotedNoExt);
    }

    Q_EMIT executionStarted(id, title, cmd);

    auto *proc = new QProcess(this);
    connect(proc, &QProcess::finished, this, [this, proc, id, title](int exitCode, QProcess::ExitStatus) {
        const QString out = QString::fromUtf8(proc->readAllStandardOutput()).trimmed();
        const QString err = QString::fromUtf8(proc->readAllStandardError()).trimmed();
        proc->deleteLater();

        if (exitCode == 0) {
            notifyDesktop(QStringLiteral("KAutomator — %1").arg(title),
                          out.isEmpty() ? QStringLiteral("Flujo ejecutado correctamente.") : out.left(140));
        }

        Q_EMIT executionFinished(id, title, exitCode, out, err);
    });

    proc->start(QStringLiteral("/bin/sh"), {QStringLiteral("-c"), cmd});
}

void WorkflowRunner::notifyDesktop(const QString &title, const QString &body)
{
    QProcess::startDetached(QStringLiteral("notify-send"),
                            {QStringLiteral("-a"), QStringLiteral("KAutomator"),
                             QStringLiteral("-i"), QStringLiteral("folder-sync"),
                             title, body});
}
