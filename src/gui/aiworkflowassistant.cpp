/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#include "aiworkflowassistant.h"

#include <QUuid>

AiWorkflowAssistant::AiWorkflowAssistant(QObject *parent)
    : QObject(parent)
{
}

void AiWorkflowAssistant::setAiStatus(const QString &headline, const QString &quote, bool busy)
{
    m_aiCardHeadline = headline;
    m_aiCardQuote = quote;
    m_aiBusy = busy;
    Q_EMIT aiStateChanged();
}

void AiWorkflowAssistant::resetPrompt()
{
    m_aiCardHeadline = QStringLiteral("¿Qué quieres que haga tu atajo?");
    m_aiCardQuote = QStringLiteral("«Organizar mis descargas en carpetas»");
    m_aiCardSubtext = QStringLiteral("Describe un atajo abajo para crearlo o personalizarlo con IA local.");
    m_aiBusy = false;
    Q_EMIT aiStateChanged();
}

void AiWorkflowAssistant::describeChange(const QString &prompt)
{
    const QString trimmed = prompt.trimmed();
    if (trimmed.isEmpty()) {
        return;
    }

    const QString lower = trimmed.toLower();
    if (lower.contains(QLatin1String("app store"))
        || (lower.contains(QLatin1String("download")) && lower.contains(QLatin1String("app")))
        || (lower.contains(QLatin1String("descargar")) && lower.contains(QLatin1String("app")))) {
        m_aiCardHeadline = QStringLiteral("Atajos no puede descargar ni instalar aplicaciones desde Internet.");
        m_aiCardQuote = QStringLiteral("«%1»").arg(trimmed);
        m_aiBusy = false;
        Q_EMIT aiStateChanged();
        return;
    }

    // Build a real workflow from the natural-language description
    QString cmd = QStringLiteral("kautomator run ~/Descargas");
    QString color = QStringLiteral("#468DF2");
    QString icon = QStringLiteral("glyph-sparkles");
    bool needsFile = false;

    if (lower.contains(QLatin1String("mp3")) || lower.contains(QLatin1String("audio"))) {
        cmd = QStringLiteral("ffmpeg -y -i {file} -vn -acodec libmp3lame -q:a 2 {noext}.mp3");
        color = QStringLiteral("#5465E3");
        icon = QStringLiteral("glyph-music");
        needsFile = true;
    } else if (lower.contains(QLatin1String("pdf"))) {
        cmd = QStringLiteral("magick {file} {noext}.pdf");
        color = QStringLiteral("#468DF2");
        icon = QStringLiteral("glyph-document");
        needsFile = true;
    } else if (lower.contains(QLatin1String("gif"))) {
        cmd = QStringLiteral("ffmpeg -y -i {file} -vf fps=12,scale=640:-1:flags=lanczos {noext}.gif");
        color = QStringLiteral("#E676C4");
        icon = QStringLiteral("glyph-gif");
        needsFile = true;
    } else if (lower.contains(QLatin1String("resize")) || lower.contains(QLatin1String("redimensionar"))
               || lower.contains(QLatin1String("imagen")) || lower.contains(QLatin1String("px"))) {
        cmd = QStringLiteral("magick {file} -resize 1600x {noext}_resized.jpg");
        color = QStringLiteral("#38C962");
        icon = QStringLiteral("glyph-photo");
        needsFile = true;
    } else if (lower.contains(QLatin1String("nas")) || lower.contains(QLatin1String("smb")) || lower.contains(QLatin1String("red"))) {
        cmd = QStringLiteral("xdg-open smb://");
        color = QStringLiteral("#F07C5B");
        icon = QStringLiteral("glyph-globe");
    }

    const QString newId = QStringLiteral("wf_") + QUuid::createUuid().toString(QUuid::WithoutBraces).left(8);
    QVariantMap wf{
        {QStringLiteral("id"), newId},
        {QStringLiteral("title"), trimmed.left(34)},
        {QStringLiteral("subtitle"), QStringLiteral("Generado con IA local (%1)").arg(cmd)},
        {QStringLiteral("icon"), icon},
        {QStringLiteral("color"), color},
        {QStringLiteral("category"), QStringLiteral("quick_actions")},
        {QStringLiteral("isAutomation"), false},
        {QStringLiteral("needsFile"), needsFile},
        {QStringLiteral("goldenGateVersion"), 2},
        {QStringLiteral("command"), cmd}
    };

    m_aiCardHeadline = QStringLiteral("Atajo «%1» creado.").arg(trimmed.left(34));
    m_aiCardQuote = QStringLiteral("«%1»").arg(trimmed);
    m_aiBusy = false;

    Q_EMIT aiStateChanged();
    Q_EMIT workflowGenerated(wf);
}
