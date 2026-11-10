#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
"""
engine.py: Motor de evaluación de reglas y monitorización inotify para KAutomator.
"""

import os
import sys
import time
import fnmatch
import re
import ctypes
import struct
import select
from pathlib import Path
from typing import List, Dict, Any, Optional

from actions import (
    execute_move,
    execute_trash,
    execute_unpack,
    execute_tag,
    execute_custom_script,
    notify_user
)

IGNORED_EXTENSIONS = {".crdownload", ".part", ".tmp", ".download", ".aria2"}


def matches_rule(file_path: Path, rule: Dict[str, Any], current_time: float = None) -> bool:
    """Evalúa si un archivo cumple todas las condiciones de una regla."""
    if not file_path.is_file():
        return False

    name = file_path.name

    # 1. Ignorar descargas en curso y archivos ocultos/temporales
    if any(name.endswith(ext) for ext in IGNORED_EXTENSIONS) or name.startswith("."):
        return False

    # 2. Comprobar extensiones
    exts = rule.get("extensions")
    if exts:
        lower_name = name.lower()
        matched_ext = False
        for ext in exts:
            if lower_name.endswith(f".{ext}"):
                matched_ext = True
                break
        if not matched_ext:
            return False

    # 3. Comprobar patrón de nombre (glob o regex)
    pattern = rule.get("pattern")
    if pattern:
        if pattern.startswith("^") or pattern.endswith("$"):
            if not re.search(pattern, name):
                return False
        else:
            if not fnmatch.fnmatch(name, pattern):
                return False

    try:
        stat = file_path.stat()
    except OSError:
        return False

    now = current_time if current_time is not None else time.time()
    age_seconds = now - stat.st_mtime

    # 4. Comprobar antigüedad mínima en segundos
    min_age_sec = rule.get("min_age_seconds", 0)
    if min_age_sec > 0 and age_seconds < min_age_sec:
        return False

    # 5. Comprobar antigüedad mínima en días
    min_age_days = rule.get("min_age_days", 0)
    if min_age_days > 0 and (age_seconds / 86400.0) < min_age_days:
        return False

    # 6. Comprobar tamaño
    size_mb = stat.st_size / (1024 * 1024)
    min_size = rule.get("min_size_mb", 0)
    if min_size > 0 and size_mb < min_size:
        return False

    max_size = rule.get("max_size_mb", 0)
    if max_size > 0 and size_mb > max_size:
        return False

    return True


def apply_rule(file_path: Path, rule: Dict[str, Any]) -> bool:
    """Ejecuta la acción asignada en la regla sobre el archivo."""
    act_type = rule.get("action", "move")
    name = rule.get("name", "Regla")

    print(f"⚡ [{name}] Procesando '{file_path.name}' -> Acción: {act_type}")

    success = False
    if act_type == "move":
        dest = rule.get("destination")
        if dest:
            tag = rule.get("tag")
            new_path = execute_move(file_path, dest, tag)
            notify_user("KAutomator: Archivo Organizado", f"'{file_path.name}' movido a {dest.name}")
            success = True

    elif act_type == "trash":
        if execute_trash(file_path):
            notify_user("KAutomator: Limpieza a Papelera", f"'{file_path.name}' movido a la Papelera")
            success = True

    elif act_type == "unpack":
        clean = rule.get("clean_original", True)
        if execute_unpack(file_path, clean_original=clean):
            success = True

    elif act_type == "tag":
        tag = rule.get("tag")
        if tag and execute_tag(file_path, tag):
            notify_user("KAutomator: Etiqueta Aplicada", f"Etiqueta '{tag}' añadida a '{file_path.name}'")
            success = True

    elif act_type == "script":
        cmd = rule.get("command")
        if cmd and execute_custom_script(file_path, cmd):
            success = True

    return success


def process_directory(directory: Path, rules: List[Dict[str, Any]]) -> int:
    """Escanea y procesa todos los archivos de un directorio con las reglas pertinentes."""
    dir_resolved = directory.resolve()
    if not dir_resolved.is_dir():
        print(f"⚠️ El directorio no existe: {dir_resolved}")
        return 0

    applicable_rules = [r for r in rules if r["watch"] == dir_resolved]
    if not applicable_rules:
        return 0

    processed_count = 0
    try:
        entries = list(dir_resolved.iterdir())
    except OSError as exc:
        print(f"Error al listar {dir_resolved}: {exc}")
        return 0

    for entry in entries:
        if not entry.is_file():
            continue
        for rule in applicable_rules:
            if matches_rule(entry, rule):
                if apply_rule(entry, rule):
                    processed_count += 1
                break  # Una regla por archivo

    return processed_count


# Constantes inotify Linux
IN_CLOSE_WRITE = 0x00000008
IN_MOVED_TO = 0x00000080
IN_NONBLOCK = 0x00000800


def watch_directories(rules: List[Dict[str, Any]], stop_flag: Optional[List[bool]] = None):
    """Monitor continuo de eventos de archivo mediante inotify en Linux."""
    libc = ctypes.CDLL("libc.so.6")
    inotify_init1 = libc.inotify_init1
    inotify_add_watch = libc.inotify_add_watch

    fd = inotify_init1(IN_NONBLOCK)
    if fd < 0:
        raise OSError("No se pudo inicializar inotify")

    watch_dirs = {}
    wd_to_path = {}

    for rule in rules:
        wdir = rule["watch"]
        if wdir not in watch_dirs:
            if not wdir.exists():
                wdir.mkdir(parents=True, exist_ok=True)
            wd = inotify_add_watch(fd, str(wdir).encode("utf-8"), IN_CLOSE_WRITE | IN_MOVED_TO)
            if wd >= 0:
                watch_dirs[wdir] = wd
                wd_to_path[wd] = wdir
                print(f"👀 KAutomator vigilando: {wdir}")

    print("🚀 Demonio KAutomator activo (consumo 0% en reposo)...")

    poller = select.poll()
    poller.register(fd, select.POLLIN)

    try:
        while stop_flag is None or not stop_flag[0]:
            events = poller.poll(1000)
            if not events:
                continue

            # Leer búfer de eventos inotify
            raw = os.read(fd, 4096)
            offset = 0
            while offset < len(raw):
                wd, mask, cookie, length = struct.unpack_from("iIII", raw, offset)
                offset += 16
                name = raw[offset:offset + length].rstrip(b"\x00").decode("utf-8", errors="ignore")
                offset += length

                if not name:
                    continue

                parent_dir = wd_to_path.get(wd)
                if not parent_dir:
                    continue

                file_path = parent_dir / name

                # Espera breve para verificar que el archivo está cerrado
                time.sleep(0.3)

                for rule in rules:
                    if rule["watch"] == parent_dir and matches_rule(file_path, rule):
                        apply_rule(file_path, rule)
                        break

    finally:
        os.close(fd)
