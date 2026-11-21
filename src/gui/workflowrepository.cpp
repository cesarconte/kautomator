/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#include "workflowrepository.h"

#include <QDir>
#include <QFile>
#include <QHash>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QStandardPaths>
#include <QUuid>

namespace {
const QStringList &goldenGateVibrantPalette()
{
    static const QStringList palette{
        QStringLiteral("#8A56F0"),
        QStringLiteral("#F2CA38"),
        QStringLiteral("#F07C5B"),
        QStringLiteral("#76C4F0"),
        QStringLiteral("#F0AA4B"),
        QStringLiteral("#5465E3"),
        QStringLiteral("#468DF2"),
        QStringLiteral("#E66460"),
        QStringLiteral("#E676C4"),
        QStringLiteral("#3ECFA9"),
        QStringLiteral("#38C962")
    };
    return palette;
}
} // namespace

WorkflowRepository::WorkflowRepository(QObject *parent)
    : QObject(parent)
{
    loadFolders();
    loadWorkflows();
}

QVariantList WorkflowRepository::defaultFolders()
{
    return QVariantList{
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("folder_starter")},
            {QStringLiteral("name"), QStringLiteral("Atajos iniciales")},
            {QStringLiteral("icon"), QStringLiteral("folder")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("folder_daily")},
            {QStringLiteral("name"), QStringLiteral("Atajos diarios")},
            {QStringLiteral("icon"), QStringLiteral("warning")}
        }
    };
}

QVariantList WorkflowRepository::defaultGoldenGateWorkflows()
{
    return QVariantList{
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_new_2")},
            {QStringLiteral("title"), QStringLiteral("New Shortcut 2")},
            {QStringLiteral("subtitle"), QStringLiteral("Organizar ~/Descargas (Smart Rules)")},
            {QStringLiteral("icon"), QStringLiteral("glyph-layers")},
            {QStringLiteral("color"), QStringLiteral("#8A56F0")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("folderId"), QStringLiteral("folder_starter")},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("kautomator run ~/Descargas")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_new_1")},
            {QStringLiteral("title"), QStringLiteral("New Shortcut")},
            {QStringLiteral("subtitle"), QStringLiteral("Ejecutar todas las reglas de KAutomator")},
            {QStringLiteral("icon"), QStringLiteral("glyph-layers")},
            {QStringLiteral("color"), QStringLiteral("#F2CA38")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("folderId"), QStringLiteral("folder_starter")},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("kautomator run")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_nas")},
            {QStringLiteral("title"), QStringLiteral("Connect to NAS")},
            {QStringLiteral("subtitle"), QStringLiteral("Abrir recursos de red SMB/NAS en Dolphin")},
            {QStringLiteral("icon"), QStringLiteral("glyph-globe")},
            {QStringLiteral("color"), QStringLiteral("#F07C5B")},
            {QStringLiteral("category"), QStringLiteral("menu_bar")},
            {QStringLiteral("folderId"), QStringLiteral("folder_daily")},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("xdg-open smb://")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_setup_intel")},
            {QStringLiteral("title"), QStringLiteral("New Mac setup (Intel)")},
            {QStringLiteral("subtitle"), QStringLiteral("Verificar paquetes y servicios base")},
            {QStringLiteral("icon"), QStringLiteral("glyph-laptop")},
            {QStringLiteral("color"), QStringLiteral("#76C4F0")},
            {QStringLiteral("category"), QStringLiteral("menu_bar")},
            {QStringLiteral("folderId"), QStringLiteral("folder_starter")},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("kautomator status")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_setup_silicon")},
            {QStringLiteral("title"), QStringLiteral("New Mac setup (Apple Silicon)")},
            {QStringLiteral("subtitle"), QStringLiteral("Optimizar caché y estado de CachyOS")},
            {QStringLiteral("icon"), QStringLiteral("glyph-laptop")},
            {QStringLiteral("color"), QStringLiteral("#F0AA4B")},
            {QStringLiteral("category"), QStringLiteral("menu_bar")},
            {QStringLiteral("folderId"), QStringLiteral("folder_starter")},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("kautomator list")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_mp3")},
            {QStringLiteral("title"), QStringLiteral("Convert to MP3")},
            {QStringLiteral("subtitle"), QStringLiteral("Extraer audio MP3 192kbps con FFmpeg")},
            {QStringLiteral("icon"), QStringLiteral("glyph-music")},
            {QStringLiteral("color"), QStringLiteral("#5465E3")},
            {QStringLiteral("category"), QStringLiteral("share_sheet")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("ffmpeg -y -i {file} -vn -acodec libmp3lame -q:a 2 {noext}.mp3")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_make_pdf")},
            {QStringLiteral("title"), QStringLiteral("Make PDF")},
            {QStringLiteral("subtitle"), QStringLiteral("Convertir imagen o documento a PDF")},
            {QStringLiteral("icon"), QStringLiteral("glyph-document")},
            {QStringLiteral("color"), QStringLiteral("#468DF2")},
            {QStringLiteral("category"), QStringLiteral("share_sheet")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("magick {file} {noext}.pdf")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_resize_2560")},
            {QStringLiteral("title"), QStringLiteral("Resize image (2560px)")},
            {QStringLiteral("subtitle"), QStringLiteral("Escalar imagen a 2560px de ancho")},
            {QStringLiteral("icon"), QStringLiteral("glyph-photo")},
            {QStringLiteral("color"), QStringLiteral("#F07C5B")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("magick {file} -resize 2560x {noext}_2560px.jpg")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_make_gif")},
            {QStringLiteral("title"), QStringLiteral("Make GIF")},
            {QStringLiteral("subtitle"), QStringLiteral("Convertir clip de vídeo a GIF animado")},
            {QStringLiteral("icon"), QStringLiteral("glyph-gif")},
            {QStringLiteral("color"), QStringLiteral("#E676C4")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("ffmpeg -y -i {file} -vf fps=12,scale=640:-1:flags=lanczos {noext}.gif")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_resize_1280")},
            {QStringLiteral("title"), QStringLiteral("Resize image (1280px)")},
            {QStringLiteral("subtitle"), QStringLiteral("Escalar imagen a 1280px de ancho")},
            {QStringLiteral("icon"), QStringLiteral("glyph-photo")},
            {QStringLiteral("color"), QStringLiteral("#E66460")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("magick {file} -resize 1280x {noext}_1280px.jpg")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_resize_1920")},
            {QStringLiteral("title"), QStringLiteral("Resize image (1920px)")},
            {QStringLiteral("subtitle"), QStringLiteral("Escalar imagen a 1920px de ancho")},
            {QStringLiteral("icon"), QStringLiteral("glyph-photo")},
            {QStringLiteral("color"), QStringLiteral("#3ECFA9")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("magick {file} -resize 1920x {noext}_1920px.jpg")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_pdf_png")},
            {QStringLiteral("title"), QStringLiteral("PDF to PNG")},
            {QStringLiteral("subtitle"), QStringLiteral("Exportar páginas de PDF a imágenes PNG")},
            {QStringLiteral("icon"), QStringLiteral("glyph-document")},
            {QStringLiteral("color"), QStringLiteral("#F0AA4B")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("needsFile"), true},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("pdftoppm -png {file} {noext}_page")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_auto_docs")},
            {QStringLiteral("title"), QStringLiteral("Organizar Documentos y Facturas")},
            {QStringLiteral("subtitle"), QStringLiteral("Regla inotify: PDF/DOCX en ~/Descargas → ~/Documentos")},
            {QStringLiteral("icon"), QStringLiteral("glyph-folder")},
            {QStringLiteral("color"), QStringLiteral("#468DF2")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("folderId"), QStringLiteral("folder_daily")},
            {QStringLiteral("isAutomation"), true},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("kautomator run ~/Descargas")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_auto_unpack")},
            {QStringLiteral("title"), QStringLiteral("Auto-Descomprimir Archivos")},
            {QStringLiteral("subtitle"), QStringLiteral("Regla inotify: ZIP/TAR/7Z en ~/Descargas → kunpack")},
            {QStringLiteral("icon"), QStringLiteral("glyph-archive")},
            {QStringLiteral("color"), QStringLiteral("#8A56F0")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("folderId"), QStringLiteral("folder_daily")},
            {QStringLiteral("isAutomation"), true},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("kautomator run ~/Descargas")}
        },
        QVariantMap{
            {QStringLiteral("id"), QStringLiteral("wf_auto_imgs")},
            {QStringLiteral("title"), QStringLiteral("Organizar Imágenes y Fotos")},
            {QStringLiteral("subtitle"), QStringLiteral("Regla inotify: PNG/JPG/WEBP en ~/Descargas → ~/Imágenes")},
            {QStringLiteral("icon"), QStringLiteral("glyph-photo")},
            {QStringLiteral("color"), QStringLiteral("#38C962")},
            {QStringLiteral("category"), QStringLiteral("quick_actions")},
            {QStringLiteral("folderId"), QStringLiteral("folder_daily")},
            {QStringLiteral("isAutomation"), true},
            {QStringLiteral("needsFile"), false},
            {QStringLiteral("goldenGateVersion"), 2},
            {QStringLiteral("command"), QStringLiteral("kautomator run ~/Descargas")}
        }
    };
}

void WorkflowRepository::loadFolders()
{
    const QString cfgDir = QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) + QStringLiteral("/kautomator");
    QDir().mkpath(cfgDir);
    const QString foldersPath = cfgDir + QStringLiteral("/folders.json");

    QFile f(foldersPath);
    if (f.exists() && f.open(QIODevice::ReadOnly)) {
        const QJsonDocument doc = QJsonDocument::fromJson(f.readAll());
        f.close();
        if (doc.isArray() && !doc.array().isEmpty()) {
            m_folders = doc.array().toVariantList();
            Q_EMIT foldersChanged();
            return;
        }
    }

    m_folders = defaultFolders();
    saveFolders();
    Q_EMIT foldersChanged();
}

void WorkflowRepository::saveFolders()
{
    const QString cfgDir = QStandardPaths::writableLocation(QStandardPaths::GenericConfigLocation) + QStringLiteral("/kautomator");
    QDir().mkpath(cfgDir);
    const QString foldersPath = cfgDir + QStringLiteral("/folders.json");

    QFile f(foldersPath);
    if (f.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        const QJsonArray arr = QJsonArray::fromVariantList(m_folders);
        f.write(QJsonDocument(arr).toJson(QJsonDocument::Indented));
        f.close();
    }
}

QVariantList WorkflowRepository::folders() const
{
    QHash<QString, int> counts;
    for (const QVariant &v : m_workflows) {
        const QString fid = v.toMap().value(QStringLiteral("folderId")).toString();
        if (!fid.isEmpty()) {
            counts[fid] = counts.value(fid, 0) + 1;
        }
    }

    QVariantList enriched;
    enriched.reserve(m_folders.size());
    for (const QVariant &fv : m_folders) {
        QVariantMap map = fv.toMap();
        const QString fid = map.value(QStringLiteral("id")).toString();
        map[QStringLiteral("count")] = counts.value(fid, 0);
        enriched.append(map);
    }
    return enriched;
}

QString WorkflowRepository::folderName(const QString &folderId) const
{
    for (const QVariant &fv : m_folders) {
        const QVariantMap map = fv.toMap();
        if (map.value(QStringLiteral("id")).toString() == folderId) {
            return map.value(QStringLiteral("name")).toString();
        }
    }
    return QString();
}

bool WorkflowRepository::migrateToGoldenGateVisuals()
{
    struct Preset {
        QString color;
        QString icon;
        QString folderId;
    };

    static const QHash<QString, Preset> presets = {
        {QStringLiteral("wf_new_2"),         {QStringLiteral("#8A56F0"), QStringLiteral("glyph-layers"),   QStringLiteral("folder_starter")}},
        {QStringLiteral("wf_new_1"),         {QStringLiteral("#F2CA38"), QStringLiteral("glyph-layers"),   QStringLiteral("folder_starter")}},
        {QStringLiteral("wf_nas"),           {QStringLiteral("#F07C5B"), QStringLiteral("glyph-globe"),    QStringLiteral("folder_daily")}},
        {QStringLiteral("wf_setup_intel"),   {QStringLiteral("#76C4F0"), QStringLiteral("glyph-laptop"),   QStringLiteral("folder_starter")}},
        {QStringLiteral("wf_setup_silicon"), {QStringLiteral("#F0AA4B"), QStringLiteral("glyph-laptop"),   QStringLiteral("folder_starter")}},
        {QStringLiteral("wf_mp3"),           {QStringLiteral("#5465E3"), QStringLiteral("glyph-music"),    QString()}},
        {QStringLiteral("wf_make_pdf"),      {QStringLiteral("#468DF2"), QStringLiteral("glyph-document"), QString()}},
        {QStringLiteral("wf_resize_2560"),   {QStringLiteral("#F07C5B"), QStringLiteral("glyph-photo"),    QString()}},
        {QStringLiteral("wf_make_gif"),      {QStringLiteral("#E676C4"), QStringLiteral("glyph-gif"),      QString()}},
        {QStringLiteral("wf_resize_1280"),   {QStringLiteral("#E66460"), QStringLiteral("glyph-photo"),    QString()}},
        {QStringLiteral("wf_resize_1920"),   {QStringLiteral("#3ECFA9"), QStringLiteral("glyph-photo"),    QString()}},
        {QStringLiteral("wf_pdf_png"),       {QStringLiteral("#F0AA4B"), QStringLiteral("glyph-document"), QString()}},
        {QStringLiteral("wf_auto_docs"),     {QStringLiteral("#468DF2"), QStringLiteral("glyph-folder"),   QStringLiteral("folder_daily")}},
        {QStringLiteral("wf_auto_unpack"),   {QStringLiteral("#8A56F0"), QStringLiteral("glyph-archive"),  QStringLiteral("folder_daily")}},
        {QStringLiteral("wf_auto_imgs"),     {QStringLiteral("#38C962"), QStringLiteral("glyph-photo"),    QStringLiteral("folder_daily")}},
    };

    static const QHash<QString, QString> iconMap = {
        {QStringLiteral("layers"),            QStringLiteral("glyph-layers")},
        {QStringLiteral("network-workgroup"), QStringLiteral("glyph-globe")},
        {QStringLiteral("computer-laptop"),   QStringLiteral("glyph-laptop")},
        {QStringLiteral("audio-x-generic"),   QStringLiteral("glyph-music")},
        {QStringLiteral("application-pdf"),   QStringLiteral("glyph-document")},
        {QStringLiteral("image-x-generic"),   QStringLiteral("glyph-photo")},
        {QStringLiteral("video-x-generic"),   QStringLiteral("glyph-gif")},
        {QStringLiteral("folder-documents"),  QStringLiteral("glyph-folder")},
        {QStringLiteral("package-x-generic"), QStringLiteral("glyph-archive")},
        {QStringLiteral("folder-pictures"),   QStringLiteral("glyph-photo")},
    };

    const QStringList &palette = goldenGateVibrantPalette();
    bool migrated = false;

    for (int i = 0; i < m_workflows.size(); ++i) {
        QVariantMap map = m_workflows[i].toMap();
        if (map.value(QStringLiteral("goldenGateVersion")).toInt() >= 2) {
            continue;
        }

        const QString id = map.value(QStringLiteral("id")).toString();
        if (presets.contains(id)) {
            const Preset &p = presets[id];
            map[QStringLiteral("color")] = p.color;
            map[QStringLiteral("icon")] = p.icon;
            if (!p.folderId.isEmpty() && map.value(QStringLiteral("folderId")).toString().isEmpty()) {
                map[QStringLiteral("folderId")] = p.folderId;
            }
        } else {
            const QString currentColor = map.value(QStringLiteral("color")).toString();
            if (currentColor.isEmpty() || currentColor.compare(QLatin1String("#7D828C"), Qt::CaseInsensitive) == 0) {
                map[QStringLiteral("color")] = palette.at(i % palette.size());
            }
            const QString currentIcon = map.value(QStringLiteral("icon")).toString();
            if (iconMap.contains(currentIcon)) {
                map[QStringLiteral("icon")] = iconMap.value(currentIcon);
            } else if (!currentIcon.startsWith(QLatin1String("glyph-"))) {
                map[QStringLiteral("icon")] = QStringLiteral("glyph-layers");
            }
        }

        map.remove(QStringLiteral("glyph"));
        map[QStringLiteral("goldenGateVersion")] = 2;
        m_workflows[i] = map;
        migrated = true;
    }

    return migrated;
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
            if (migrateToGoldenGateVisuals()) {
                saveWorkflows();
            }
            if (findWorkflow(m_selectedWorkflowId).isEmpty() && !m_workflows.isEmpty()) {
                m_selectedWorkflowId = m_workflows.first().toMap().value(QStringLiteral("id")).toString();
            }
            Q_EMIT workflowsChanged();
            Q_EMIT filteredWorkflowsChanged();
            Q_EMIT foldersChanged();
            Q_EMIT selectedWorkflowIdChanged();
            return;
        }
    }

    m_workflows = defaultGoldenGateWorkflows();
    saveWorkflows();
    Q_EMIT workflowsChanged();
    Q_EMIT filteredWorkflowsChanged();
    Q_EMIT foldersChanged();
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

    const bool isFolderView = m_currentCategory.startsWith(QLatin1String("folder:"));
    const QString targetFolderId = isFolderView ? m_currentCategory.mid(7) : QString();

    for (const QVariant &v : m_workflows) {
        const QVariantMap map = v.toMap();
        bool catMatch = false;
        if (m_currentCategory == QLatin1String("all")) {
            catMatch = true;
        } else if (isFolderView) {
            catMatch = (map.value(QStringLiteral("folderId")).toString() == targetFolderId);
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
    const QStringList &palette = goldenGateVibrantPalette();
    const QString color = palette.at(m_workflows.size() % palette.size());

    const bool inFolder = m_currentCategory.startsWith(QLatin1String("folder:"));
    const QString folderId = inFolder ? m_currentCategory.mid(7) : QString();
    const QString category = (inFolder || m_currentCategory == QLatin1String("all") || m_currentCategory == QLatin1String("gallery"))
        ? QStringLiteral("quick_actions")
        : m_currentCategory;

    QVariantMap wf{
        {QStringLiteral("id"), newId},
        {QStringLiteral("title"), QStringLiteral("Nuevo atajo %1").arg(m_workflows.size() + 1)},
        {QStringLiteral("subtitle"), QStringLiteral("Flujo personalizado de KAutomator")},
        {QStringLiteral("icon"), QStringLiteral("glyph-layers")},
        {QStringLiteral("color"), color},
        {QStringLiteral("category"), category},
        {QStringLiteral("isAutomation"), m_currentCategory == QLatin1String("automation")},
        {QStringLiteral("needsFile"), false},
        {QStringLiteral("goldenGateVersion"), 2},
        {QStringLiteral("command"), QStringLiteral("kautomator run ~/Descargas")}
    };
    if (!folderId.isEmpty()) {
        wf[QStringLiteral("folderId")] = folderId;
    }

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
    Q_EMIT foldersChanged();
    Q_EMIT selectedWorkflowIdChanged();
}

void WorkflowRepository::updateWorkflow(const QString &id,
                                        const QString &title,
                                        const QString &subtitle,
                                        const QString &category,
                                        const QString &color,
                                        const QString &command,
                                        const QString &folderId,
                                        const QString &icon)
{
    for (int i = 0; i < m_workflows.size(); ++i) {
        QVariantMap map = m_workflows[i].toMap();
        if (map.value(QStringLiteral("id")).toString() == id) {
            const QString oldCategory = map.value(QStringLiteral("category")).toString();
            map[QStringLiteral("title")] = title.trimmed().isEmpty() ? QStringLiteral("Atajo") : title.trimmed();
            map[QStringLiteral("subtitle")] = subtitle.trimmed();
            map[QStringLiteral("category")] = category;
            if (category == QLatin1String("automation")) {
                map[QStringLiteral("isAutomation")] = true;
            } else if (oldCategory == QLatin1String("automation")) {
                map[QStringLiteral("isAutomation")] = false;
            }
            map[QStringLiteral("color")] = color;
            map[QStringLiteral("command")] = command.trimmed();
            map[QStringLiteral("needsFile")] = command.contains(QLatin1String("{file}"));
            if (folderId.isEmpty()) {
                map.remove(QStringLiteral("folderId"));
            } else {
                map[QStringLiteral("folderId")] = folderId;
            }
            if (!icon.isEmpty()) {
                map[QStringLiteral("icon")] = icon;
            }
            map[QStringLiteral("goldenGateVersion")] = 2;
            m_workflows[i] = map;
            saveWorkflows();
            Q_EMIT workflowsChanged();
            Q_EMIT filteredWorkflowsChanged();
            Q_EMIT foldersChanged();
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
            Q_EMIT foldersChanged();
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
            map[QStringLiteral("title")] = QString(map.value(QStringLiteral("title")).toString() + QStringLiteral(" (copia)"));
            m_workflows.insert(i + 1, map);
            m_selectedWorkflowId = newId;
            saveWorkflows();
            Q_EMIT workflowsChanged();
            Q_EMIT filteredWorkflowsChanged();
            Q_EMIT foldersChanged();
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

void WorkflowRepository::createFolder(const QString &name, const QString &icon)
{
    const QString trimmed = name.trimmed();
    if (trimmed.isEmpty()) {
        return;
    }

    const QString newId = QStringLiteral("folder_") + QUuid::createUuid().toString(QUuid::WithoutBraces).left(8);
    const QVariantMap folder{
        {QStringLiteral("id"), newId},
        {QStringLiteral("name"), trimmed},
        {QStringLiteral("icon"), icon.trimmed().isEmpty() ? QStringLiteral("folder") : icon.trimmed()}
    };
    m_folders.append(folder);
    saveFolders();
    Q_EMIT foldersChanged();
    setCurrentCategory(QStringLiteral("folder:") + newId);
}

void WorkflowRepository::renameFolder(const QString &folderId, const QString &newName)
{
    const QString trimmed = newName.trimmed();
    if (trimmed.isEmpty()) {
        return;
    }

    for (int i = 0; i < m_folders.size(); ++i) {
        QVariantMap map = m_folders[i].toMap();
        if (map.value(QStringLiteral("id")).toString() == folderId) {
            map[QStringLiteral("name")] = trimmed;
            m_folders[i] = map;
            saveFolders();
            Q_EMIT foldersChanged();
            return;
        }
    }
}

void WorkflowRepository::deleteFolder(const QString &folderId)
{
    bool removed = false;
    for (int i = 0; i < m_folders.size(); ++i) {
        if (m_folders[i].toMap().value(QStringLiteral("id")).toString() == folderId) {
            m_folders.removeAt(i);
            removed = true;
            break;
        }
    }
    if (!removed) {
        return;
    }

    bool workflowsModified = false;
    for (int i = 0; i < m_workflows.size(); ++i) {
        QVariantMap map = m_workflows[i].toMap();
        if (map.value(QStringLiteral("folderId")).toString() == folderId) {
            map.remove(QStringLiteral("folderId"));
            m_workflows[i] = map;
            workflowsModified = true;
        }
    }

    saveFolders();
    if (workflowsModified) {
        saveWorkflows();
        Q_EMIT workflowsChanged();
        Q_EMIT selectedWorkflowIdChanged();
    }
    if (m_currentCategory == QStringLiteral("folder:") + folderId) {
        setCurrentCategory(QStringLiteral("all"));
    } else if (workflowsModified) {
        Q_EMIT filteredWorkflowsChanged();
    }
    Q_EMIT foldersChanged();
}

void WorkflowRepository::assignWorkflowToFolder(const QString &workflowId, const QString &folderId)
{
    for (int i = 0; i < m_workflows.size(); ++i) {
        QVariantMap map = m_workflows[i].toMap();
        if (map.value(QStringLiteral("id")).toString() == workflowId) {
            if (folderId.isEmpty()) {
                map.remove(QStringLiteral("folderId"));
            } else {
                map[QStringLiteral("folderId")] = folderId;
            }
            m_workflows[i] = map;
            saveWorkflows();
            Q_EMIT workflowsChanged();
            Q_EMIT filteredWorkflowsChanged();
            Q_EMIT foldersChanged();
            if (m_selectedWorkflowId == workflowId) {
                Q_EMIT selectedWorkflowIdChanged();
            }
            return;
        }
    }
}
