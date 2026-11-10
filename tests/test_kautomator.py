#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
"""
test_kautomator.py: Suite de pruebas unitarias para KAutomator.
"""

import sys
import unittest
import tempfile
import time
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(PROJECT_ROOT / "src"))

from rules import normalize_rule, load_rules
from engine import matches_rule, process_directory
from actions import execute_move, get_unique_destination


class TestKAutomator(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.root = Path(self.temp_dir.name)
        self.watch_dir = self.root / "Descargas"
        self.dest_dir = self.root / "Documentos"
        self.watch_dir.mkdir()
        self.dest_dir.mkdir()

    def tearDown(self):
        self.temp_dir.cleanup()

    def test_extension_matching(self):
        rule = {
            "name": "Docs",
            "watch": self.watch_dir,
            "extensions": ["pdf", "docx"],
            "min_age_seconds": 0
        }

        pdf = self.watch_dir / "reporte.pdf"
        pdf.touch()
        txt = self.watch_dir / "notas.txt"
        txt.touch()
        crdownload = self.watch_dir / "descarga.pdf.crdownload"
        crdownload.touch()

        self.assertTrue(matches_rule(pdf, rule))
        self.assertFalse(matches_rule(txt, rule))
        # Debe ignorar descargas en curso de navegador
        self.assertFalse(matches_rule(crdownload, rule))

    def test_pattern_matching(self):
        rule = {
            "name": "Facturas",
            "watch": self.watch_dir,
            "pattern": "*Factura*",
            "extensions": ["pdf"]
        }

        f1 = self.watch_dir / "Factura_Noviembre.pdf"
        f1.touch()
        f2 = self.watch_dir / "Informe_General.pdf"
        f2.touch()

        self.assertTrue(matches_rule(f1, rule))
        self.assertFalse(matches_rule(f2, rule))

    def test_collision_avoidance_move(self):
        # Crear archivo ya existente en destino
        existing = self.dest_dir / "documento.pdf"
        existing.write_text("v1")

        src = self.watch_dir / "documento.pdf"
        src.write_text("v2")

        moved = execute_move(src, self.dest_dir)
        self.assertEqual(moved.name, "documento (1).pdf")
        self.assertTrue(existing.exists())
        self.assertEqual(existing.read_text(), "v1")
        self.assertEqual(moved.read_text(), "v2")

    def test_batch_process_directory(self):
        rule = {
            "name": "Mover PDFs",
            "watch": self.watch_dir,
            "extensions": ["pdf"],
            "action": "move",
            "destination": self.dest_dir,
            "min_age_seconds": 0
        }

        f1 = self.watch_dir / "doc1.pdf"
        f1.touch()
        f2 = self.watch_dir / "doc2.pdf"
        f2.touch()
        f3 = self.watch_dir / "foto.png"
        f3.touch()

        count = process_directory(self.watch_dir, [rule])
        self.assertEqual(count, 2)
        self.assertTrue((self.dest_dir / "doc1.pdf").exists())
        self.assertTrue((self.dest_dir / "doc2.pdf").exists())
        self.assertTrue((self.watch_dir / "foto.png").exists())


if __name__ == "__main__":
    unittest.main()
