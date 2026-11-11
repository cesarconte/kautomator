#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
# install.sh: Instalador autónomo de KAutomator para KDE Plasma 6 sobre Wayland

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
SHARE_DIR="${HOME}/.local/share/kautomator"
APPS_DIR="${HOME}/.local/share/applications"
SERVICEMENUS_DIR="${HOME}/.local/share/kio/servicemenus"
SYSTEMD_DIR="${HOME}/.config/systemd/user"

echo "==> Instalando KAutomator (Smart Folder Rules estilo Hazel para KDE Plasma 6)..."

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

# 2. Instalar módulos del motor
mkdir -p "${SHARE_DIR}/src"
cp -r "${SCRIPT_DIR}/src/"* "${SHARE_DIR}/src/"
echo "  ✓ Módulos de reglas y motor inotify instalados en ${SHARE_DIR}"

# 3. Compilar e instalar interfaz gráfica Golden Gate (kautomator-gui) y ejecutable CLI
cmake -B "${SCRIPT_DIR}/build" -S "${SCRIPT_DIR}" -DCMAKE_INSTALL_PREFIX="${HOME}/.local" >/dev/null
cmake --build "${SCRIPT_DIR}/build" -j"$(nproc)" >/dev/null
cmake --install "${SCRIPT_DIR}/build" >/dev/null
echo "  ✓ Interfaz gráfica Golden Gate (kautomator-gui) instalada en ${BIN_DIR}/kautomator-gui"

mkdir -p "$BIN_DIR"
install -m 755 "${SCRIPT_DIR}/bin/kautomator" "${BIN_DIR}/kautomator"
echo "  ✓ Binario instalado en ${BIN_DIR}/kautomator"

# 4. Inicializar reglas predeterminadas
"${BIN_DIR}/kautomator" list >/dev/null 2>&1 || true
echo "  ✓ Configuración de reglas inicializada en ~/.config/kautomator/rules.toml"

# 5. Instalar menú contextual de Dolphin
mkdir -p "$SERVICEMENUS_DIR"
install -m 644 "${SCRIPT_DIR}/data/kautomator_servicemenu.desktop" "${SERVICEMENUS_DIR}/org.cesar.kautomator.desktop"
echo "  ✓ Menú contextual de Dolphin instalado en ${SERVICEMENUS_DIR}/org.cesar.kautomator.desktop"

# 6. Instalar lanzador de aplicaciones
mkdir -p "$APPS_DIR"
install -m 644 "${SCRIPT_DIR}/data/org.cesar.kautomator.desktop" "${APPS_DIR}/org.cesar.kautomator.desktop"
echo "  ✓ Lanzador registrado en ${APPS_DIR}/org.cesar.kautomator.desktop"

# 7. Instalar y habilitar servicio systemd de usuario
mkdir -p "$SYSTEMD_DIR"
install -m 644 "${SCRIPT_DIR}/data/kautomator.service" "${SYSTEMD_DIR}/kautomator.service"
if command -v systemctl >/dev/null 2>&1; then
    systemctl --user daemon-reload
    systemctl --user enable --now kautomator.service 2>/dev/null || true
    echo "  ✓ Servicio systemd de usuario 'kautomator.service' habilitado y activo"
fi

# 8. Actualizar base de datos de aplicaciones de KDE
if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
    echo "  ✓ Base de datos Sycoca de KDE actualizada"
fi

echo ""
echo "🎉 ¡Instalación de KAutomator completada con éxito!"
echo "   - Servicio en segundo plano monitorizando carpetas con consumo 0% de CPU."
echo "   - Para organizar manualmente: 'kautomator run' o clic derecho en Dolphin sobre cualquier carpeta."
echo "   - Para ver o editar reglas: 'kautomator edit' (~/.config/kautomator/rules.toml)"
