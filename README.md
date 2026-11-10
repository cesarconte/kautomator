# KAutomator ⚡📁

> **Smart Folder Rules & Automatización de Archivos al estilo *Hazel* de macOS para KDE Plasma 6 y Dolphin.**

`kautomator` monitoriza tus carpetas clave (como `Descargas` o `Escritorio`) mediante eventos directos del kernel (`inotify`), aplicando reglas inteligentes de organización, clasificación y limpieza con **consumo 0% de CPU** en reposo.

---

## ✨ Características

- 🧠 **Reglas Inteligentes y Flexibles:**
  - **Por tipo / extensión:** Mueve automáticamente documentos (`pdf`, `docx`, `epub`) a `~/Documentos`, fotos a `~/Imágenes`, etc.
  - **Por antigüedad:** Envía instaladores viejos (`.iso`, `.pkg.tar.zst`, `.deb`) con más de 14 días directamente a la Papelera de Plasma (`trash:/`).
  - **Por patrón de nombre / regex:** Clasifica facturas y nóminas automáticamente.
- 📦 **Integración con `kunpack`:** Descomprime automáticamente archivos recién descargados y elimina el archivo original a la papelera.
- 🎨 **Integración con `ktags`:** Asigna etiquetas de colores estilo macOS Finder (rojo, verde, azul...) a los archivos procesados.
- ⚡ **Cero Polling (inotify Nativo):** Duerme consumiendo 0 MB de procesador y despierta de inmediato solo al completarse descargas o movimientos de archivos.
- 🛡️ **Seguridad contra Sobrescrituras:** Si ya existe un archivo con el mismo nombre en destino, renombra automáticamente (`archivo (1).pdf`) para garantizar que nunca se pierda información.
- 🐬 **Integración con Dolphin:** Menú contextual al hacer clic derecho en cualquier carpeta:
  - *Organizar esta carpeta con KAutomator*
  - *Configurar reglas inteligentes (rules.toml)*
- 🔄 **Servicio en Segundo Plano:** Gestionado mediante `systemd` a nivel de usuario (`systemctl --user enable --now kautomator.service`).

---

## 🚀 Instalación Rápida

```bash
git clone https://github.com/cesarconte/kautomator.git
cd kautomator
./install.sh
```

O en CachyOS / Arch Linux:

```bash
makepkg -si
```

---

## ⚙️ Configuración de Reglas (`~/.config/kautomator/rules.toml`)

```toml
[[rules]]
name = "Organizar Documentos"
watch = "~/Descargas"
extensions = ["pdf", "docx", "epub", "xlsx"]
min_age_seconds = 5
action = "move"
destination = "~/Documentos"
tag = "blue"

[[rules]]
name = "Auto-Descomprimir Descargas"
watch = "~/Descargas"
extensions = ["zip", "tar.gz", "7z", "rar"]
min_age_seconds = 3
action = "unpack"
clean_original = true

[[rules]]
name = "Limpiar Instaladores Viejos a la Papelera"
watch = "~/Descargas"
extensions = ["iso", "pkg.tar.zst", "deb", "rpm"]
min_age_days = 14
action = "trash"
```

---

## 💻 Comandos CLI

```bash
# Organizar todas las carpetas vigiladas inmediatamente
kautomator run

# Organizar una carpeta específica
kautomator run ~/Descargas

# Ver reglas activas
kautomator list

# Ver estado del servicio
kautomator status

# Editar archivo de reglas en tu editor predeterminado
kautomator edit
```

---

## 🧪 Pruebas Automatizadas

```bash
python3 ./tests/test_kautomator.py
```

---

## 🗑️ Desinstalación

```bash
./uninstall.sh
```

---

## 📄 Licencia

GPLv3. Desarrollado para KDE Plasma 6 sobre Wayland y CachyOS Linux.
