#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
"""
rules.py: Carga, validación y gestión de reglas de automatización de KAutomator.
"""

import os
import json
import tomllib
from pathlib import Path
from typing import List, Dict, Any

CONFIG_DIR = Path.home() / ".config/kautomator"
RULES_FILE = CONFIG_DIR / "rules.toml"

DEFAULT_RULES_TOML = """# Reglas Inteligentes de KAutomator (Hazel para KDE Plasma 6 y Dolphin)

[[rules]]
name = "Organizar Documentos y Facturas"
watch = "~/Descargas"
extensions = ["pdf", "docx", "doc", "epub", "xlsx", "pptx", "odt"]
min_age_seconds = 5
action = "move"
destination = "~/Documentos"
tag = "blue"

[[rules]]
name = "Auto-Descomprimir Archivos Comprimidos"
watch = "~/Descargas"
extensions = ["zip", "tar.gz", "tgz", "tar.xz", "txz", "tar.zst", "7z", "rar"]
min_age_seconds = 3
action = "unpack"
clean_original = true

[[rules]]
name = "Organizar Imágenes y Fotos"
watch = "~/Descargas"
extensions = ["png", "jpg", "jpeg", "webp", "avif", "heic", "svg"]
min_age_seconds = 5
action = "move"
destination = "~/Imágenes"

[[rules]]
name = "Limpiar Instaladores e Imágenes Antiguas a la Papelera"
watch = "~/Descargas"
extensions = ["iso", "pkg.tar.zst", "deb", "rpm", "AppImage"]
min_age_days = 14
action = "trash"
"""


def ensure_config_exists() -> Path:
    """Crea la configuración inicial si no existe."""
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    if not RULES_FILE.exists():
        with open(RULES_FILE, "w", encoding="utf-8") as f:
            f.write(DEFAULT_RULES_TOML)
    return RULES_FILE


def load_rules(config_path: Path = None) -> List[Dict[str, Any]]:
    """Carga y valida las reglas desde el archivo TOML (o JSON)."""
    target = config_path if config_path else ensure_config_exists()
    if not target.is_file():
        return []

    rules_data = []
    with open(target, "rb") as f:
        try:
            if target.suffix == ".json":
                parsed = json.load(f)
            else:
                parsed = tomllib.load(f)
            rules_data = parsed.get("rules", [])
        except Exception as exc:
            print(f"Error al leer {target.name}: {exc}")
            return []

    validated = []
    for r in rules_data:
        rule = normalize_rule(r)
        if rule:
            validated.append(rule)

    return validated


def normalize_rule(r: Dict[str, Any]) -> Dict[str, Any] | None:
    """Normaliza y expande rutas en una regla."""
    name = r.get("name", "Regla sin nombre")
    watch_path = r.get("watch")
    if not watch_path:
        return None

    watch_expanded = Path(os.path.expanduser(watch_path)).resolve()

    action = r.get("action", "move")
    dest = r.get("destination")
    dest_expanded = Path(os.path.expanduser(dest)).resolve() if dest else None

    # Normalizar extensiones en minúsculas y sin punto inicial
    raw_exts = r.get("extensions", [])
    extensions = [ext.lower().lstrip(".") for ext in raw_exts]

    return {
        "name": name,
        "watch": watch_expanded,
        "extensions": extensions,
        "pattern": r.get("pattern"),
        "min_age_seconds": int(r.get("min_age_seconds", 0)),
        "min_age_days": float(r.get("min_age_days", 0)),
        "min_size_mb": float(r.get("min_size_mb", 0)),
        "max_size_mb": float(r.get("max_size_mb", 0)),
        "action": action,
        "destination": dest_expanded,
        "tag": r.get("tag"),
        "clean_original": bool(r.get("clean_original", True)),
        "command": r.get("command")
    }
