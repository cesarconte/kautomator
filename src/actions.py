#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
"""
actions.py: Catálogo de acciones de automatización de KAutomator.
"""

import os
import shutil
import subprocess
from pathlib import Path
from typing import Optional

TAG_COLOR_MAP = {
    "rojo": "red", "red": "red",
    "naranja": "orange", "orange": "orange",
    "amarillo": "yellow", "yellow": "yellow",
    "verde": "green", "green": "green",
    "azul": "blue", "blue": "blue",
    "morado": "purple", "purple": "purple",
    "gris": "gray", "gray": "gray"
}


def get_unique_destination(dest_dir: Path, filename: str) -> Path:
    """Evita colisiones renombrando: 'archivo (1).ext', 'archivo (2).ext'."""
    target = dest_dir / filename
    if not target.exists():
        return target

    base = target.stem
    suffix = target.suffix
    counter = 1
    while target.exists():
        target = dest_dir / f"{base} ({counter}){suffix}"
        counter += 1
    return target


def execute_move(src_path: Path, dest_dir: Path, tag: Optional[str] = None) -> Path:
    """Mueve un archivo a la carpeta de destino de forma segura."""
    dest_dir.mkdir(parents=True, exist_ok=True)
    target_path = get_unique_destination(dest_dir, src_path.name)
    shutil.move(str(src_path), str(target_path))

    if tag:
        execute_tag(target_path, tag)

    return target_path


def execute_trash(src_path: Path) -> bool:
    """Envía un archivo a la Papelera nativa de KDE Plasma / FreeDesktop."""
    abs_str = str(src_path.resolve())
    try:
        res = subprocess.run(["gio", "trash", abs_str], capture_output=True, text=True)
        if res.returncode == 0:
            return True
    except FileNotFoundError:
        pass

    try:
        res = subprocess.run(["kioclient", "move", abs_str, "trash:/"], capture_output=True, text=True)
        if res.returncode == 0:
            return True
    except FileNotFoundError:
        pass

    return False


def execute_unpack(src_path: Path, clean_original: bool = True) -> bool:
    """Descomprime inteligentemente delegando en kunpack."""
    cmd = ["kunpack"]
    if not clean_original:
        cmd.append("--keep")
    cmd.extend(["-q", str(src_path)])

    try:
        res = subprocess.run(cmd, capture_output=True, text=True)
        return res.returncode == 0
    except FileNotFoundError:
        # Respaldo si kunpack no estuviera en PATH
        kunpack_local = Path.home() / ".local/bin/kunpack"
        if kunpack_local.is_file():
            res = subprocess.run([str(kunpack_local), "-q", str(src_path)], capture_output=True)
            return res.returncode == 0
        return False


def execute_tag(src_path: Path, tag_name: str) -> bool:
    """Aplica una etiqueta de color XDG usando ktag o atributos extendidos."""
    color = TAG_COLOR_MAP.get(tag_name.lower(), tag_name.lower())
    try:
        res = subprocess.run(["ktag", "set", color, str(src_path)], capture_output=True, text=True)
        if res.returncode == 0:
            return True
    except FileNotFoundError:
        pass

    # Respaldo escribiendo directamente user.color.tag en atributos extendidos
    try:
        import os
        os.setxattr(str(src_path), "user.color.tag", color.encode("utf-8"))
        os.setxattr(str(src_path), "user.xdg.tags", color.encode("utf-8"))
        return True
    except (AttributeError, OSError):
        return False


def execute_custom_script(src_path: Path, command: str) -> bool:
    """Ejecuta un script personalizado con variables de sustitución."""
    formatted = command.replace("{file}", f"'{src_path.resolve()}'").replace("{dir}", f"'{src_path.parent.resolve()}'")
    try:
        res = subprocess.run(formatted, shell=True, capture_output=True, text=True)
        return res.returncode == 0
    except Exception:
        return False


def notify_user(title: str, message: str, open_path: Optional[Path] = None):
    """Envía una notificación al centro de notificaciones de KDE Plasma."""
    cmd = [
        "notify-send",
        "-a", "KAutomator",
        "-i", "folder-sync",
        title,
        message
    ]
    try:
        proc = subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, close_fds=True)
    except Exception:
        pass
