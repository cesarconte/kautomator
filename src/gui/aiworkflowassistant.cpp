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

void AiWorkflowAssistant::describeChange(const QString &prompt)
{
    const QString trimmed = prompt.trimmed();
    if (trimmed.isEmpty()) {
        return;
    }

    const QString lower = trimmed.toLower();
    // Match the exact Ars Technica screenshot 14_shortcuts.png behavior when asked to download/install apps from the Store/Internet
    if (lower.contains(QLatin1String("app store"))
        || (lower.contains(QLatin1String("download")) && lower.contains(QLatin1String("app")))
        || (lower.contains(QLatin1String("descargar")) && lower.contains(QLatin1String("app")))) {
        m_aiCardHeadline = QStringLiteral("Shortcuts can't download and install apps from the Internet.");
        m_aiCardQuote = QStringLiteral("\"%1\"").arg(trimmed);
        m_aiBusy = false;
        Q_EMIT aiStateChanged();
        return;
    }

    // Build a real workflow from the natural-language description
    QString cmd = QStringLiteral("kautomator run ~/Descargas");
    QString color = QStringLiteral("#0091FF");
    QString glyph = QStringLiteral("✦");
    bool needsFile = false;

    if (lower.contains(QLatin1String("mp3")) || lower.contains(QLatin1String("audio"))) {
        cmd = QStringLiteral("ffmpeg -y -i {file} -vn -acodec libmp3lame -q:a 2 {noext}.mp3");
        color = QStringLiteral("#0084FF");
        glyph = QStringLiteral("🎵");
        needsFile = true;
    } else if (lower.contains(QLatin1String("pdf"))) {
        cmd = QStringLiteral("magick {file} {noext}.pdf");
        color = QStringLiteral("#FF4D62");
        glyph = QStringLiteral("📄");
        needsFile = true;
    } else if (lower.contains(QLatin1String("gif"))) {
        cmd = QStringLiteral("ffmpeg -y -i {file} -vf fps=12,scale=640:-1:flags=lanczos {noext}.gif");
        color = QStringLiteral("#FF64B4");
        glyph = QStringLiteral("🎞");
        needsFile = true;
    } else if (lower.contains(QLatin1String("resize")) || lower.contains(QLatin1String("redimensionar")) || lower.contains(QLatin1String("px"))) {
        cmd = QStringLiteral("magick {file} -resize 1600x {noext}_resized.jpg");
        color = QStringLiteral("#28CD56");
        glyph = QStringLiteral("🖼");
        needsFile = true;
    } else if (lower.contains(QLatin1String("nas")) || lower.contains(QLatin1String("smb")) || lower.contains(QLatin1String("red"))) {
        cmd = QStringLiteral("xdg-open smb://");
        color = QStringLiteral("#B65CE6");
        glyph = QStringLiteral("🌐");
    }

    const QString newId = QStringLiteral("wf_") + QUuid::createUuid().toString(QUuid::WithoutBraces).left(8);
    QVariantMap wf{
        {QStringLiteral("id"), newId},
        {QStringLiteral("title"), trimmed.left(34)},
        {QStringLiteral("subtitle"), QStringLiteral("Generado con IA Local (%1)").arg(cmd)},
        {QStringLiteral("icon"), QStringLiteral("layers")},
        {QStringLiteral("glyph"), glyph},
        {QStringLiteral("color"), color},
        {QStringLiteral("category"), QStringLiteral("quick_actions")},
        {QStringLiteral("isAutomation"), false},
        {QStringLiteral("needsFile"), needsFile},
        {QStringLiteral("command"), cmd}
    };

    m_aiCardHeadline = QStringLiteral("Created shortcut \"%1\".").arg(trimmed.left(34));
    m_aiCardQuote = QStringLiteral("\"%1\"").arg(trimmed);
    m_aiBusy = false;

    Q_EMIT aiStateChanged();
    Q_EMIT workflowGenerated(wf);
}
