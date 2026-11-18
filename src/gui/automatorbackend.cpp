/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#include "automatorbackend.h"
#include "aiworkflowassistant.h"
#include "daemoncontroller.h"
#include "workflowrepository.h"
#include "workflowrunner.h"

#include <QClipboard>
#include <QGuiApplication>

AutomatorBackend::AutomatorBackend(QObject *parent)
    : QObject(parent)
    , m_repo(new WorkflowRepository(this))
    , m_runner(new WorkflowRunner(this))
    , m_daemonController(new DaemonController(this))
    , m_aiAssistant(new AiWorkflowAssistant(this))
{
    // Repository signals
    connect(m_repo, &WorkflowRepository::workflowsChanged, this, &AutomatorBackend::workflowsChanged);
    connect(m_repo, &WorkflowRepository::filteredWorkflowsChanged, this, &AutomatorBackend::filteredWorkflowsChanged);
    connect(m_repo, &WorkflowRepository::currentCategoryChanged, this, &AutomatorBackend::currentCategoryChanged);
    connect(m_repo, &WorkflowRepository::searchQueryChanged, this, &AutomatorBackend::searchQueryChanged);
    connect(m_repo, &WorkflowRepository::selectedWorkflowIdChanged, this, &AutomatorBackend::selectedWorkflowIdChanged);

    // Runner signals
    connect(m_runner, &WorkflowRunner::executionStarted, this, [this](const QString &, const QString &title, const QString &cmd) {
        m_aiAssistant->setAiStatus(QStringLiteral("Running \"%1\"…").arg(title), QStringLiteral("\"%1\"").arg(cmd), true);
    });
    connect(m_runner, &WorkflowRunner::executionFinished, this, [this](const QString &, const QString &title, int exitCode, const QString &out, const QString &err) {
        if (exitCode == 0) {
            m_aiAssistant->setAiStatus(
                QStringLiteral("✓ \"%1\" completed successfully.").arg(title),
                out.isEmpty() ? QStringLiteral("\"Workflow finished with exit code 0\"") : QStringLiteral("\"%1\"").arg(out.left(180)),
                false);
        } else {
            m_aiAssistant->setAiStatus(
                QStringLiteral("⚠️ \"%1\" finished with a warning.").arg(title),
                err.isEmpty() ? QStringLiteral("\"Exit code %1\"").arg(exitCode) : QStringLiteral("\"%1\"").arg(err.left(180)),
                false);
        }
    });
    connect(m_runner, &WorkflowRunner::fileSelectionRequested, this, &AutomatorBackend::fileSelectionRequested);

    // Daemon controller signals
    connect(m_daemonController, &DaemonController::daemonStateChanged, this, &AutomatorBackend::daemonStateChanged);

    // AI assistant signals
    connect(m_aiAssistant, &AiWorkflowAssistant::aiStateChanged, this, &AutomatorBackend::aiStateChanged);
    connect(m_aiAssistant, &AiWorkflowAssistant::workflowGenerated, m_repo, &WorkflowRepository::addWorkflow);
}

AutomatorBackend::~AutomatorBackend()
{
}

QVariantList AutomatorBackend::workflows() const
{
    return m_repo->workflows();
}

QVariantList AutomatorBackend::filteredWorkflows() const
{
    return m_repo->filteredWorkflows();
}

QString AutomatorBackend::currentCategory() const
{
    return m_repo->currentCategory();
}

void AutomatorBackend::setCurrentCategory(const QString &cat)
{
    m_repo->setCurrentCategory(cat);
}

QString AutomatorBackend::searchQuery() const
{
    return m_repo->searchQuery();
}

void AutomatorBackend::setSearchQuery(const QString &q)
{
    m_repo->setSearchQuery(q);
}

void AutomatorBackend::setViewMode(const QString &mode)
{
    if (m_viewMode != mode) {
        m_viewMode = mode;
        Q_EMIT viewModeChanged();
    }
}

QString AutomatorBackend::selectedWorkflowId() const
{
    return m_repo->selectedWorkflowId();
}

void AutomatorBackend::setSelectedWorkflowId(const QString &id)
{
    m_repo->setSelectedWorkflowId(id);
}

QVariantMap AutomatorBackend::selectedWorkflow() const
{
    return m_repo->selectedWorkflow();
}

int AutomatorBackend::allShortcutsCount() const
{
    return m_repo->allShortcutsCount();
}

int AutomatorBackend::shareSheetCount() const
{
    return m_repo->shareSheetCount();
}

int AutomatorBackend::quickActionsCount() const
{
    return m_repo->quickActionsCount();
}

int AutomatorBackend::menuBarCount() const
{
    return m_repo->menuBarCount();
}

int AutomatorBackend::automationCount() const
{
    return m_repo->automationCount();
}

QString AutomatorBackend::aiCardHeadline() const
{
    return m_aiAssistant->aiCardHeadline();
}

QString AutomatorBackend::aiCardQuote() const
{
    return m_aiAssistant->aiCardQuote();
}

QString AutomatorBackend::aiCardSubtext() const
{
    return m_aiAssistant->aiCardSubtext();
}

bool AutomatorBackend::aiBusy() const
{
    return m_aiAssistant->aiBusy();
}

bool AutomatorBackend::daemonActive() const
{
    return m_daemonController->daemonActive();
}

void AutomatorBackend::runWorkflow(const QString &id, const QString &fileUrl)
{
    const QVariantMap wf = m_repo->findWorkflow(id);
    m_runner->runWorkflow(wf, fileUrl);
}

bool AutomatorBackend::workflowNeedsFile(const QString &id) const
{
    return m_repo->workflowNeedsFile(id);
}

void AutomatorBackend::createNewWorkflow()
{
    m_repo->createNewWorkflow();
}

void AutomatorBackend::updateWorkflow(const QString &id,
                                      const QString &title,
                                      const QString &subtitle,
                                      const QString &category,
                                      const QString &color,
                                      const QString &command)
{
    m_repo->updateWorkflow(id, title, subtitle, category, color, command);
}

void AutomatorBackend::deleteWorkflow(const QString &id)
{
    m_repo->deleteWorkflow(id);
}

void AutomatorBackend::duplicateWorkflow(const QString &id)
{
    m_repo->duplicateWorkflow(id);
}

void AutomatorBackend::exportWorkflow(const QString &id)
{
    const QString jsonStr = m_repo->exportWorkflow(id);
    if (!jsonStr.isEmpty()) {
        if (auto *clip = QGuiApplication::clipboard()) {
            clip->setText(jsonStr);
        }
        const QVariantMap wf = m_repo->findWorkflow(id);
        m_aiAssistant->setAiStatus(
            QStringLiteral("Workflow \"%1\" copied to clipboard.").arg(wf.value(QStringLiteral("title")).toString()),
            QStringLiteral("\"Ready to share or paste as JSON\""),
            false);
    }
}

void AutomatorBackend::describeChange(const QString &prompt)
{
    m_aiAssistant->describeChange(prompt);
}

void AutomatorBackend::toggleDaemon()
{
    m_daemonController->toggleDaemon();
}

void AutomatorBackend::runAllFolderRulesNow()
{
    runWorkflow(QStringLiteral("wf_new_1"));
}

void AutomatorBackend::openRulesFileInEditor()
{
    DaemonController::openRulesFileInEditor();
}

void AutomatorBackend::openSystemKeyboardShortcuts()
{
    DaemonController::openSystemKeyboardShortcuts();
}
