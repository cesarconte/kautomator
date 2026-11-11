/*
    SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
    SPDX-License-Identifier: GPL-3.0-or-later
*/

#include "automatorbackend.h"

#include <QApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QUrl>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("kautomator"));
    app.setApplicationDisplayName(QStringLiteral("KAutomator — Shortcuts"));
    app.setOrganizationName(QStringLiteral("Cesar"));
    app.setOrganizationDomain(QStringLiteral("cesar.org"));
    app.setDesktopFileName(QStringLiteral("org.cesar.kautomator"));
    app.setWindowIcon(QIcon::fromTheme(QStringLiteral("folder-sync")));

    QQuickStyle::setStyle(QStringLiteral("org.kde.desktop"));

    AutomatorBackend backend;

    QQmlApplicationEngine engine;
    engine.addImportPath(QStringLiteral("/home/cesar/.local/lib/qt6/qml"));
    engine.rootContext()->setContextProperty(QStringLiteral("automator"), &backend);

    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
