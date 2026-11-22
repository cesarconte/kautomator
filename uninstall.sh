#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
# uninstall.sh: Desinstalador limpio de KAutomator en /usr

set -eo pipefail

echo "==> Desinstalando KAutomator de /usr..."

if command -v systemctl >/dev/null 2>&1; then
    systemctl --user disable --now kautomator.service 2>/dev/null || true
fi

sudo -n rm -f /usr/bin/kautomator /usr/bin/kautomator-gui
sudo -n rm -rf /usr/share/kautomator
sudo -n rm -f /usr/share/kio/servicemenus/kautomator_servicemenu.desktop
sudo -n rm -f /usr/share/applications/org.cesar.kautomator.desktop
sudo -n rm -f /usr/lib/systemd/user/kautomator.service
rm -f "${HOME}/.config/systemd/user/kautomator.service"

if command -v systemctl >/dev/null 2>&1; then
    systemctl --user daemon-reload 2>/dev/null || true
fi

if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
fi

echo "✓ Desinstalación completada de /usr."
