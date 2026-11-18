/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#include "workflowrepository.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QUuid>

WorkflowRepository::WorkflowRepository(QObject *parent)
    : QObject(parent)
{
    loadWorkflows();
}

QVariantList WorkflowRepository::defaultGoldenGateWorkflows()
{
    return QVariantList{
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_new_2")},
            {QStringLiteral("title"), QStringLiteral("New Shortcut 2")},
            {QStringLiteral("subtitle"), QStringLiteral("Organizar ~/Descargas (Smart Rules)")},
            {QStringLiteral("icon"), QStringLiteral("layers")},
            {QStringLiteral("glyph"), QStringLiteral("❖")},
            {QStringLiteral("color"), QStringLiteral("#7D828C")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("command"), QStringLiteral("kautomator run ~/Descargas")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_new_1")},
            {QStringLiteral("title"), QStringLiteral("New Shortcut")},
            {QStringLiteral("subtitle"), QStringLiteral("Ejecutar todas las reglas de KAutomator")},
            {QStringLiteral("icon"), QStringLiteral("layers")},
            {QStringLiteral("glyph"), QStringLiteral("❖")},
            {QStringLiteral("color"), QStringLiteral("#0091FF")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("command"), QStringLiteral("kautomator run")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_nas")},
            {QStringLiteral("title"), QStringLiteral("Connect to NAS")},
            {QStringLiteral("subtitle"), QStringLiteral("Abrir recursos de red SMB/NAS en Dolphin")},
            {QStringLiteral("icon"), QStringLiteral("network-workgroup")},
            {QStringLiteral("glyph"), QStringLiteral("🌐")},
            {QStringLiteral("color"), QStringLiteral("#B65CE6")},
            {QStringLiteral("category"), QStringLiteral("menu_bar")},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("command"), QStringLiteral("xdg-open smb://")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_setup_intel")},
            {QStringLiteral("title"), QStringLiteral("New Mac setup (Intel)")},
            {QStringLiteral("subtitle"), QStringLiteral("Verificar paquetes y servicios base")},
            {QStringLiteral("icon"), QStringLiteral("computer-laptop")},
            {QStringLiteral("glyph"), QStringLiteral("💻")},
            {QStringLiteral("color"), QStringLiteral("#7D828C")},
            {QStringLiteral("category"), QStringLiteral("menu_bar")},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("command"), QStringLiteral("kautomator status")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_setup_silicon")},
            {QStringLiteral("title"), QStringLiteral("New Mac setup (Apple Silicon)")},
            {QStringLiteral("subtitle"), QStringLiteral("Optimizar caché y estado de CachyOS")},
            {QStringLiteral("icon"), QStringLiteral("computer-laptop")},
            {QStringLiteral("glyph"), QStringLiteral("💻")},
            {QStringLiteral("color"), QStringLiteral("#7D828C")},
            {QStringLiteral("category"), QStringLiteral("menu_bar")},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("command"), QStringLiteral("kautomator list")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_mp3")},
            {QStringLiteral("title"), QStringLiteral("Convert to MP3")},
            {QStringLiteral("subtitle"), QStringLiteral("Extraer audio MP3 192kbps con FFmpeg")},
            {QStringLiteral("icon"), QStringLiteral("audio-x-generic")},
            {QStringLiteral("glyph"), QStringLiteral("🎵")},
            {QStringLiteral("color"), QStringLiteral("#0084FF")},
            {QStringLiteral("category"), QStringLiteral("share_sheet")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("command"), QStringLiteral("ffmpeg -y -i {file} -vn -acodec libmp3lame -q:a 2 {noext}.mp3")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_make_pdf")},
            {QStringLiteral("title"), QStringLiteral("Make PDF")},
            {QStringLiteral("subtitle"), QStringLiteral("Convertir imagen o documento a PDF")},
            {QStringLiteral("icon"), QStringLiteral("application-pdf")},
            {QStringLiteral("glyph"), QStringLiteral("📄")},
            {QStringLiteral("color"), QStringLiteral("#FF4D62")},
            {QStringLiteral("category"), QStringLiteral("share_sheet")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("command"), QStringLiteral("magick {file} {noext}.pdf")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_resize_2560")},
            {QStringLiteral("title"), QStringLiteral("Resize image (2560px)")},
            {QStringLiteral("subtitle"), QStringLiteral("Escalar imagen a 2560px de ancho")},
            {QStringLiteral("icon"), QStringLiteral("image-x-generic")},
            {QStringLiteral("glyph"), QStringLiteral("🖼")},
            {QStringLiteral("color"), QStringLiteral("#28CD56")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("command"), QStringLiteral("magick {file} -resize 2560x {noext}_2560px.jpg")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_make_gif")},
            {QStringLiteral("title"), QStringLiteral("Make GIF")},
            {QStringLiteral("subtitle"), QStringLiteral("Convertir clip de vídeo a GIF animado")},
            {QStringLiteral("icon"), QStringLiteral("video-x-generic")},
            {QStringLiteral("glyph"), QStringLiteral("🎞")},
            {QStringLiteral("color"), QStringLiteral("#FF64B4")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("command"), QStringLiteral("ffmpeg -y -i {file} -vf fps=12,scale=640:-1:flags=lanczos {noext}.gif")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_resize_1280")},
            {QStringLiteral("title"), QStringLiteral("Resize image (1280px)")},
            {QStringLiteral("subtitle"), QStringLiteral("Escalar imagen a 1280px de ancho")},
            {QStringLiteral("icon"), QStringLiteral("image-x-generic")},
            {QStringLiteral("glyph"), QStringLiteral("🖼")},
            {QStringLiteral("color"), QStringLiteral("#28CD56")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("command"), QStringLiteral("magick {file} -resize 1280x {noext}_1280px.jpg")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_resize_1920")},
            {QStringLiteral("title"), QStringLiteral("Resize image (1920px)")},
            {QStringLiteral("subtitle"), QStringLiteral("Escalar imagen a 1920px de ancho")},
            {QStringLiteral("icon"), QStringLiteral("image-x-generic")},
            {QStringLiteral("glyph"), QStringLiteral("🖼")},
            {QStringLiteral("color"), QStringLiteral("#28CD56")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("command"), QStringLiteral("magick {file} -resize 1920x {noext}_1920px.jpg")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_pdf_png")},
            {QStringLiteral("title"), QStringLiteral("PDF to PNG")},
            {QStringLiteral("subtitle"), QStringLiteral("Exportar páginas de PDF a imágenes PNG")},
            {QStringLiteral("icon"), QStringLiteral("image-x-generic")},
            {QStringLiteral("glyph"), QStringLiteral("📑")},
            {QStringLiteral("color"), QStringLiteral("#FF4D62")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("command"), QStringLiteral("pdftoppm -png {file} {noext}_page")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_auto_docs")},
            {QStringLiteral("title"), QStringLiteral("Organizar Documentos y Facturas")},
            {QStringLiteral("subtitle"), QStringLiteral("Regla inotify: PDF/DOCX en ~/Descargas → ~/Documentos")},
            {QStringLiteral("icon"), QStringLiteral("folder-documents")},
            {QStringLiteral("glyph"), QStringLiteral("📁")},
            {QStringLiteral("color"), QStringLiteral("#0084FF")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("isAutomation"), true},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("command"), QStringLiteral("kautomator run ~/Descargas")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_auto_unpack")},
            {QStringLiteral("title"), QStringLiteral("Auto-Descomprimir Archivos")},
            {QStringLiteral("subtitle"), QStringLiteral("Regla inotify: ZIP/TAR/7Z en ~/Descargas → kunpack")},
            {QStringLiteral("icon"), QStringLiteral("package-x-generic")},
            {QStringLiteral("glyph"), QStringLiteral("📦")},
            {QStringLiteral("color"), QStringLiteral("#AF52DE")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("isAutomation"), true},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("command"), QStringLiteral("kautomator run ~/Descargas")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_auto_imgs")},
            {QStringLiteral("title"), QStringLiteral("Organizar Imágenes y Fotos")},
            {QStringLiteral("subtitle"), QStringLiteral("Regla inotify: PNG/JPG/WEBP en ~/Descargas → ~/Imágenes")},
            {QStringLiteral("icon"), QStringLiteral("folder-pictures")},
            {QStringLiteral("glyph"), QStringLiteral("🌄")},
            {QStringLiteral("color"), QStringLiteral("#28CD56")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("isAutomation"), true},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("command"), QStringLiteral("kautomator run ~/Descargas")}
        }
    };
}

void WorkflowRepository::loadWorkflows()
{
    const QString cfgDir = QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) + QStringLiteral("/kautomator");
    QDir().mkpath(cfgDir);
    const QString wfPath = cfgDir + QStringLiteral("/workflows.json");

    QFile f(wfPath);
    if (f.exists() && f.open(QIODevice::ReadOnly)) {
        const QJsonDocument doc = QJsonDocument::fromJson(f.readAll());
        f.close();
        if (doc.isArray() && !doc.array().isEmpty()) {
            m_workflows = doc.array().toVariantList();
            Q_EMIT workflowsChanged();
            Q_EMIT filteredWorkflowsChanged();
            return;
        }
    }

    m_workflows = defaultGoldenGateWorkflows();
    saveWorkflows();
    Q_EMIT workflowsChanged();
    Q_EMIT filteredWorkflowsChanged();
}

void WorkflowRepository::saveWorkflows()
{
    const QString cfgDir = QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) + QStringLiteral("/kautomator");
    QDir().mkpath(cfgDir);
    const QString wfPath = cfgDir + QStringLiteral("/workflows.json");

    QFile f(wfPath);
    if (f.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        const QJsonArray arr = QJsonArray::fromVariantList(m_workflows);
        f.write(QJsonDocument(arr).toJson(QJsonDocument::Indented));
        f.close();
    }
}

QVariantList WorkflowRepository::filteredWorkflows() const
{
    QVariantList result;
    const QString q = m_searchQuery.trimmed().toLower();

    if (m_currentCategory == QLatin1String("gallery")) {
        const QVariantList galleryItems = defaultGoldenGateWorkflows();
        for (const QVariant &v : galleryItems) {
            const QVariantMap map = v.toMap();
            if (q.isEmpty()
                || map.value(QStringLiteral("title")).toString().toLower().contains(q)
                || map.value(QStringLiteral("subtitle")).toString().toLower().contains(q)) {
                result.append(map);
            }
        }
        return result;
    }

    for (const QVariant &v : m_workflows) {
        const QVariantMap map = v.toMap();
        bool catMatch = false;
        if (m_currentCategory == QLatin1String("all")) {
            catMatch = true;
        } else if (m_currentCategory == QLatin1String("automation")) {
            catMatch = map.value(QStringLiteral("isAutomation")).toBool()
                || map.value(QStringLiteral("category")).toString() == QLatin1String("automation");
        } else {
            catMatch = (map.value(QStringLiteral("category")).toString() == m_currentCategory);
        }

        if (!catMatch) {
            continue;
        }

        if (!q.isEmpty()) {
            const QString title = map.value(QStringLiteral("title")).toString().toLower();
            const QString sub = map.value(QStringLiteral("subtitle")).toString().toLower();
            if (!title.contains(q) && !sub.contains(q)) {
                continue;
            }
        }
        result.append(map);
    }
    return result;
}

void WorkflowRepository::setCurrentCategory(const QString &cat)
{
    if (m_currentCategory != cat) {
        m_currentCategory = cat;
        Q_EMIT currentCategoryChanged();
        Q_EMIT filteredWorkflowsChanged();
    }
}

void WorkflowRepository::setSearchQuery(const QString &q)
{
    if (m_searchQuery != q) {
        m_searchQuery = q;
        Q_EMIT searchQueryChanged();
        Q_EMIT filteredWorkflowsChanged();
    }
}

void WorkflowRepository::setSelectedWorkflowId(const QString &id)
{
    if (m_selectedWorkflowId != id) {
        m_selectedWorkflowId = id;
        Q_EMIT selectedWorkflowIdChanged();
    }
}

QVariantMap WorkflowRepository::selectedWorkflow() const
{
    for (const QVariant &v : m_workflows) {
        const QVariantMap map = v.toMap();
        if (map.value(QStringLiteral("id")).toString() == m_selectedWorkflowId) {
            return map;
        }
    }
    return m_workflows.isEmpty() ? QVariantMap() : m_workflows.first().toMap();
}

int WorkflowRepository::allShortcutsCount() const
{
    return m_workflows.size();
}

int WorkflowRepository::shareSheetCount() const
{
    int c = 0;
    for (const QVariant &v : m_workflows) {
        if (v.toMap().value(QStringLiteral("category")).toString() == QLatin1String("share_sheet")) {
            ++c;
        }
    }
    return c;
}

int WorkflowRepository::quickActionsCount() const
{
    int c = 0;
    for (const QVariant &v : m_workflows) {
        if (v.toMap().value(QStringLiteral("category")).toString() == QLatin1String("quick_actions")) {
            ++c;
        }
    }
    return c;
}

int WorkflowRepository::menuBarCount() const
{
    int c = 0;
    for (const QVariant &v : m_workflows) {
        if (v.toMap().value(QStringLiteral("category")).toString() == QLatin1String("menu_bar")) {
            ++c;
        }
    }
    return c;
}

int WorkflowRepository::automationCount() const
{
    int c = 0;
    for (const QVariant &v : m_workflows) {
        const QVariantMap m = v.toMap();
        if (m.value(QStringLiteral("isAutomation")).toBool()
            || m.value(QStringLiteral("category")).toString() == QLatin1String("automation")) {
            ++c;
        }
    }
    return c;
}

bool WorkflowRepository::workflowNeedsFile(const QString &id) const
{
    for (const QVariant &v : m_workflows) {
        const QVariantMap m = v.toMap();
        if (m.value(QStringLiteral("id")).toString() == id) {
            return m.value(QStringLiteral("needsFile")).toBool();
        }
    }
    return false;
}

QVariantMap WorkflowRepository::findWorkflow(const QString &id) const
{
    for (const QVariant &v : m_workflows) {
        const QVariantMap m = v.toMap();
        if (m.value(QStringLiteral("id")).toString() == id) {
            return m;
        }
    }
    return QVariantMap();
}

void WorkflowRepository::createNewWorkflow()
{
    const QString newId = QStringLiteral("wf_") + QUuid::createUuid().toString(QUuid::WithoutBraces).left(8);
    const QStringList palette = {
        QStringLiteral("#0091FF"),
        QStringLiteral("#B65CE6"),
        QStringLiteral("#28CD56"),
        QStringLiteral("#FF4D62"),
        QStringLiteral("#FF9F0A"),
        QStringLiteral("#00C7BE")
    };
    const QString color = palette.at(m_workflows.size() % palette.size());

    QVariantMap wf{
        {QStringLiteral("id"), newId},
        {QStringLiteral("title"), QStringLiteral("New Shortcut %1").arg(m_workflows.size() + 1)},
        {QStringLiteral("subtitle"), QStringLiteral("Flujo personalizado de KAutomator")},
        {QStringLiteral("icon"), QStringLiteral("layers")},
        {QStringLiteral("glyph"), QStringLiteral("❖")},
        {QStringLiteral("color"), color},
        {QStringLiteral("category"), (m_currentCategory == QLatin1String("all") || m_currentCategory == QLatin1String("gallery"))
            ? QStringLiteral("quick_actions")
            : m_currentCategory},
        {QStringLiteral("isAutomation"), m_currentCategory == QLatin1String("automation")},
        {QStringLiteral("needsFile"), false},
        {QStringLiteral("command"), QStringLiteral("kautomator run ~/Descargas")}
    };

    addWorkflow(wf);
}

void WorkflowRepository::addWorkflow(const QVariantMap &wf)
{
    const QString id = wf.value(QStringLiteral("id")).toString();
    m_workflows.prepend(wf);
    m_selectedWorkflowId = id;
    saveWorkflows();
    Q_EMIT workflowsChanged();
    Q_EMIT filteredWorkflowsChanged();
    Q_EMIT selectedWorkflowIdChanged();
}

void WorkflowRepository::updateWorkflow(const QString &id,
                                        const QString &title,
                                        const QString &subtitle,
                                        const QString &category,
                                        const QString &color,
                                        const QString &command)
{
    for (int i = 0; i < m_workflows.size(); ++i) {
        QVariantMap map = m_workflows[i].toMap();
        if (map.value(QStringLiteral("id")).toString() == id) {
            map[QStringLiteral("title")] = title.trimmed().isEmpty() ? QStringLiteral("Shortcut") : title.trimmed();
            map[QStringLiteral("subtitle")] = subtitle.trimmed();
            map[QStringLiteral("category")] = category;
            map[QStringLiteral("color")] = color;
            map[QStringLiteral("command")] = command.trimmed();
            map[QStringLiteral("needsFile")] = command.contains(QLatin1String("{file}"));
            m_workflows[i] = map;
            saveWorkflows();
            Q_EMIT workflowsChanged();
            Q_EMIT filteredWorkflowsChanged();
            Q_EMIT selectedWorkflowIdChanged();
            return;
        }
    }
}

void WorkflowRepository::deleteWorkflow(const QString &id)
{
    for (int i = 0; i < m_workflows.size(); ++i) {
        if (m_workflows[i].toMap().value(QStringLiteral("id")).toString() == id) {
            m_workflows.removeAt(i);
            saveWorkflows();
            if (m_selectedWorkflowId == id) {
                m_selectedWorkflowId = m_workflows.isEmpty()
                    ? QString()
                    : m_workflows.first().toMap().value(QStringLiteral("id")).toString();
            }
            Q_EMIT workflowsChanged();
            Q_EMIT filteredWorkflowsChanged();
            Q_EMIT selectedWorkflowIdChanged();
            return;
        }
    }
}

void WorkflowRepository::duplicateWorkflow(const QString &id)
{
    for (int i = 0; i < m_workflows.size(); ++i) {
        QVariantMap map = m_workflows[i].toMap();
        if (map.value(QStringLiteral("id")).toString() == id) {
            const QString newId = QStringLiteral("wf_") + QUuid::createUuid().toString(QUuid::WithoutBraces).left(8);
            map[QStringLiteral("id")] = newId;
            map[QStringLiteral("title")] = QString(map.value(QStringLiteral("title")).toString() + QStringLiteral(" Copy"));
            m_workflows.insert(i + 1, map);
            m_selectedWorkflowId = newId;
            saveWorkflows();
            Q_EMIT workflowsChanged();
            Q_EMIT filteredWorkflowsChanged();
            Q_EMIT selectedWorkflowIdChanged();
            return;
        }
    }
}

QString WorkflowRepository::exportWorkflow(const QString &id)
{
    for (const QVariant &v : m_workflows) {
        const QVariantMap map = v.toMap();
        if (map.value(QStringLiteral("id")).toString() == id) {
            return QString::fromUtf8(QJsonDocument(QJsonObject::fromVariantMap(map)).toJson(QJsonDocument::Indented));
        }
    }
    return QString();
}
