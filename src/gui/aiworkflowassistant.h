/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#pragma once

#include <QObject>
#include <QString>
#include <QVariantMap>

class AiWorkflowAssistant : public QObject
{
    Q_OBJECT

public:
    explicit AiWorkflowAssistant(QObject *parent = nullptr);
    ~AiWorkflowAssistant() override = default;

    QString aiCardHeadline() const { return m_aiCardHeadline; }
    QString aiCardQuote() const { return m_aiCardQuote; }
    QString aiCardSubtext() const { return m_aiCardSubtext; }
    bool aiBusy() const { return m_aiBusy; }

    void setAiStatus(const QString &headline, const QString &quote, bool busy = false);
    void resetPrompt();
    void describeChange(const QString &prompt);

Q_SIGNALS:
    void aiStateChanged();
    void workflowGenerated(const QVariantMap &workflow);

private:
    QString m_aiCardHeadline = QStringLiteral("¿Qué quieres que haga tu atajo?");
    QString m_aiCardQuote = QStringLiteral("«Organizar mis descargas en carpetas»");
    QString m_aiCardSubtext = QStringLiteral("Describe un atajo abajo para crearlo o personalizarlo con IA local.");
    bool m_aiBusy = false;
};
