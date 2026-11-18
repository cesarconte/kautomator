/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#pragma once

#include <QObject>
#include <QString>
#include <QVariantList>
#include <QVariantMap>

class WorkflowRepository;
class WorkflowRunner;
class DaemonController;
class AiWorkflowAssistant;

class AutomatorBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantList workflows READ workflows NOTIFY workflowsChanged)
    Q_PROPERTY(QVariantList filteredWorkflows READ filteredWorkflows NOTIFY filteredWorkflowsChanged)
    Q_PROPERTY(QString currentCategory READ currentCategory WRITE setCurrentCategory NOTIFY currentCategoryChanged)
    Q_PROPERTY(QString searchQuery READ searchQuery WRITE setSearchQuery NOTIFY searchQueryChanged)
    Q_PROPERTY(QString viewMode READ viewMode WRITE setViewMode NOTIFY viewModeChanged)
    Q_PROPERTY(QString selectedWorkflowId READ selectedWorkflowId WRITE setSelectedWorkflowId NOTIFY selectedWorkflowIdChanged)
    Q_PROPERTY(QVariantMap selectedWorkflow READ selectedWorkflow NOTIFY selectedWorkflowIdChanged)

    // Sidebar counts (matching 14_shortcuts.png)
    Q_PROPERTY(int allShortcutsCount READ allShortcutsCount NOTIFY workflowsChanged)
    Q_PROPERTY(int shareSheetCount READ shareSheetCount NOTIFY workflowsChanged)
    Q_PROPERTY(int quickActionsCount READ quickActionsCount NOTIFY workflowsChanged)
    Q_PROPERTY(int menuBarCount READ menuBarCount NOTIFY workflowsChanged)
    Q_PROPERTY(int automationCount READ automationCount NOTIFY workflowsChanged)

    // Right Pane: Apple Intelligence in Shortcuts ("Describe a change" - 14_shortcuts.png)
    Q_PROPERTY(QString aiCardHeadline READ aiCardHeadline NOTIFY aiStateChanged)
    Q_PROPERTY(QString aiCardQuote READ aiCardQuote NOTIFY aiStateChanged)
    Q_PROPERTY(QString aiCardSubtext READ aiCardSubtext NOTIFY aiStateChanged)
    Q_PROPERTY(bool aiBusy READ aiBusy NOTIFY aiStateChanged)
    Q_PROPERTY(bool daemonActive READ daemonActive NOTIFY daemonStateChanged)

public:
    explicit AutomatorBackend(QObject *parent = nullptr);
    ~AutomatorBackend() override;

    QVariantList workflows() const;
    QVariantList filteredWorkflows() const;

    QString currentCategory() const;
    void setCurrentCategory(const QString &cat);

    QString searchQuery() const;
    void setSearchQuery(const QString &q);

    QString viewMode() const { return m_viewMode; }
    void setViewMode(const QString &mode);

    QString selectedWorkflowId() const;
    void setSelectedWorkflowId(const QString &id);
    QVariantMap selectedWorkflow() const;

    int allShortcutsCount() const;
    int shareSheetCount() const;
    int quickActionsCount() const;
    int menuBarCount() const;
    int automationCount() const;

    QString aiCardHeadline() const;
    QString aiCardQuote() const;
    QString aiCardSubtext() const;
    bool aiBusy() const;
    bool daemonActive() const;

    Q_INVOKABLE void runWorkflow(const QString &id, const QString &fileUrl = QString());
    Q_INVOKABLE bool workflowNeedsFile(const QString &id) const;
    Q_INVOKABLE void createNewWorkflow();
    Q_INVOKABLE void updateWorkflow(const QString &id,
                                    const QString &title,
                                    const QString &subtitle,
                                    const QString &category,
                                    const QString &color,
                                    const QString &command);
    Q_INVOKABLE void deleteWorkflow(const QString &id);
    Q_INVOKABLE void duplicateWorkflow(const QString &id);
    Q_INVOKABLE void exportWorkflow(const QString &id);
    Q_INVOKABLE void describeChange(const QString &prompt);
    Q_INVOKABLE void toggleDaemon();
    Q_INVOKABLE void runAllFolderRulesNow();
    Q_INVOKABLE void openRulesFileInEditor();
    Q_INVOKABLE void openSystemKeyboardShortcuts();

Q_SIGNALS:
    void workflowsChanged();
    void filteredWorkflowsChanged();
    void currentCategoryChanged();
    void searchQueryChanged();
    void viewModeChanged();
    void selectedWorkflowIdChanged();
    void aiStateChanged();
    void daemonStateChanged();
    void fileSelectionRequested(const QString &workflowId, const QString &title);

private:
    WorkflowRepository *m_repo = nullptr;
    WorkflowRunner *m_runner = nullptr;
    DaemonController *m_daemonController = nullptr;
    AiWorkflowAssistant *m_aiAssistant = nullptr;

    QString m_viewMode = QStringLiteral("grid");
};
