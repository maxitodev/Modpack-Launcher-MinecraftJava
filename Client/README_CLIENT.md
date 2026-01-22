# 🖥️ Cliente Windows - Modpack Minecraft 1.21.11

Esta carpeta contiene todos los archivos necesarios para crear el instalador del cliente de Windows.

## 📋 Contenido

- `Installer.ps1` - Script de instalación principal
- `1_Compilar_Instalador.bat` - Compila el script a .exe
- `2_Crear_ZIP.bat` - Crea el paquete de distribución
- `3_Build_Completo.bat` - Hace todo automáticamente
- `Ejecutar_Instalador.bat` - Ejecuta el instalador sin compilar
- `INSTRUCCIONES.txt` - Guía completa
- `LEEME.txt` - Manual para usuarios finales

## 🚀 Uso Rápido

### Para Crear el Instalador

1. **Asegúrate de tener los archivos en las carpetas padre:**
   - `../installer/` - NeoForge installer
   - `../mods/` - Mods
   - `../resourcepacks/` - Resource packs
   - `../shaderpacks/` - Shader packs
   - `../config/` - Configuraciones (opcional)

2. **Ejecuta:** `3_Build_Completo.bat`

3. **Distribuye:** El archivo `Modpack-MaxitoDev-1.21.11.zip` generado

### Para Probar el Instalador

Ejecuta: `Ejecutar_Instalador.bat`

## 📦 Salida

- `Modpack.exe` - Instalador compilado
- `Modpack-MaxitoDev-1.21.11.zip` - Paquete de distribución

## ⚙️ Requisitos Previos

- PowerShell 5.1+
- Módulo PS2EXE: `Install-Module -Name ps2exe -Scope CurrentUser`

## 📖 Documentación Completa

Ver: `INSTRUCCIONES.txt` y `../README.md`
