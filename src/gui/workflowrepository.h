/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#pragma once

#include <QObject>
#include <QString>
#include <QVariantList>
#include <QVariantMap>

class WorkflowRepository : public QObject
{
    Q_OBJECT

public:
    explicit WorkflowRepository(QObject *parent = nullptr);
    ~WorkflowRepository() override = default;

    QVariantList workflows() const { return m_workflows; }
    QVariantList filteredWorkflows() const;

    QString currentCategory() const { return m_currentCategory; }
    void setCurrentCategory(const QString &cat);

    QString searchQuery() const { return m_searchQuery; }
    void setSearchQuery(const QString &q);

    QString selectedWorkflowId() const { return m_selectedWorkflowId; }
    void setSelectedWorkflowId(const QString &id);
    QVariantMap selectedWorkflow() const;

    int allShortcutsCount() const;
    int shareSheetCount() const;
    int quickActionsCount() const;
    int menuBarCount() const;
    int automationCount() const;

    void createNewWorkflow();
    void updateWorkflow(const QString &id,
                        const QString &title,
                        const QString &subtitle,
                        const QString &category,
                        const QString &color,
                        const QString &command);
    void deleteWorkflow(const QString &id);
    void duplicateWorkflow(const QString &id);
    QString exportWorkflow(const QString &id);
    void addWorkflow(const QVariantMap &wf);

    bool workflowNeedsFile(const QString &id) const;
    QVariantMap findWorkflow(const QString &id) const;

    static QVariantList defaultGoldenGateWorkflows();
    void loadWorkflows();
    void saveWorkflows();

Q_SIGNALS:
    void workflowsChanged();
    void filteredWorkflowsChanged();
    void currentCategoryChanged();
    void searchQueryChanged();
    void selectedWorkflowIdChanged();

private:
    QVariantList m_workflows;
    QString m_currentCategory = QStringLiteral("all");
    QString m_searchQuery;
    QString m_selectedWorkflowId = QStringLiteral("wf_new_1");
};
