#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
# uninstall.sh: Desinstalador limpio de KAutomator

set -eo pipefail

BIN_DIR="${HOME}/.local/bin"
SHARE_DIR="${HOME}/.local/share/kautomator"
APPS_DIR="${HOME}/.local/share/applications"
SERVICEMENUS_DIR="${HOME}/.local/share/kio/servicemenus"
SYSTEMD_DIR="${HOME}/.config/systemd/user"

echo "==> Desinstalando KAutomator..."

if command -v systemctl >/dev/null 2>&1; then
    systemctl --user disable --now kautomator.service 2>/dev/null || true
fi

rm -f "${BIN_DIR}/kautomator"
rm -rf "${SHARE_DIR}"
rm -f "${SERVICEMENUS_DIR}/org.cesar.kautomator.desktop"
rm -f "${APPS_DIR}/org.cesar.kautomator.desktop"
rm -f "${SYSTEMD_DIR}/kautomator.service"

if command -v systemctl >/dev/null 2>&1; then
    systemctl --user daemon-reload 2>/dev/null || true
fi

if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
fi

echo "✓ Desinstalación completada."
