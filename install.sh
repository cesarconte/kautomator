#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
# install.sh: Instalador autónomo de KAutomator para KDE Plasma 6 sobre Wayland (instalación estricta en /usr)

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Instalando KAutomator (Smart Folder Rules estilo Hazel para KDE Plasma 6) en /usr..."

# 1. Comprobar dependencias
MISSING_DEPS=()
for dep in python3 notify-send; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        MISSING_DEPS+=("$dep")
    fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo "⚠️  Faltan dependencias: ${MISSING_DEPS[*]}"
    if command -v pacman >/dev/null 2>&1; then
        echo "--> Instálalas con: sudo pacman -S --needed python libnotify glib2"
    fi
fi

# 2. Compilar e instalar en /usr
rm -rf "${SCRIPT_DIR}/build"
cmake -B "${SCRIPT_DIR}/build" -S "${SCRIPT_DIR}" -DCMAKE_INSTALL_PREFIX=/usr
cmake --build "${SCRIPT_DIR}/build" -j"$(nproc)"
sudo -n cmake --install "${SCRIPT_DIR}/build" --prefix /usr

# 3. Inicializar reglas predeterminadas
/usr/bin/kautomator list >/dev/null 2>&1 || true

# 4. Actualizar base de datos de aplicaciones de KDE
if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
fi

echo ""
echo "🎉 ¡Instalación de KAutomator completada con éxito en /usr!"
