/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#pragma once

#include <QObject>
#include <QString>
#include <QVariantMap>

class WorkflowRunner : public QObject
{
    Q_OBJECT

public:
    explicit WorkflowRunner(QObject *parent = nullptr);
    ~WorkflowRunner() override = default;

    void runWorkflow(const QVariantMap &workflow, const QString &fileUrl = QString());
    static void notifyDesktop(const QString &title, const QString &body);

Q_SIGNALS:
    void executionStarted(const QString &id, const QString &title, const QString &command);
    void executionFinished(const QString &id, const QString &title, int exitCode, const QString &output, const QString &error);
    void fileSelectionRequested(const QString &id, const QString &title);
};
