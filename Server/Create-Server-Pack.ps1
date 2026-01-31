# ==========================================
# 📦 GENERADOR DE SERVER PACK INTELLIGENT
# ==========================================
# Este script crea un paquete ZIP optimizado para servidores,
# eliminando automáticamente los mods que son "Solo Cliente".

$Version = "1.0.0"
$GameFiles = "$PSScriptRoot/../GameFiles"
$OutputDir = "$PSScriptRoot/Build"
$TempDir = "$OutputDir/Temp_Server"

# Lista de patrones de Mods "CLIENT-ONLY" a EXCLUIR
# Agrega aquí cualquier mod que crashee el servidor o sea solo visual
$ClientOnlyMods = @(
    # OPTIMIZACION GRAFICA & SHADERS (Solo Cliente)
    "sodium", "rubidium", "embeddium", "magnesium",
    "iris", "oculus", "shader",
    "entity_texture_features", "entity_model_features", "etf", "emf",
    "entityculling", "immediatelyfast", "moreculling",

    # INTERFAZ Y MENUS
    "modmenu", "catalogue", "configured",
    "toast", "advancementinfo", "paginatedadvancements",
    "appleskin", "inventoryprofiles", "inventoryhud",
    "controlling", "searchables", "betterf3",
    "shulkerboxtooltip", "legendarytooltips", "tooltip",
    "blur", "dark", "loading", "smoothswapping",
    "status-effect-bars", "overflowingbars",

    # VISUAL Y COSMETICO
    "3dskinlayers", "skinlayers3d", "waveycapes", "capes", "auth",
    "notenoughanimations", "animation", "playeranimation",
    "visuality", "explosiveenhancement", "particles",
    "fallingleaves", "illuminations", "effective",
    "coolrain", "freshanimations",
    "firstperson", "shoulderstrufing", "betterthirdperson", "camera",

    # SONIDO Y AMBIENTE
    "sound", "ambience", "music", "auditory", "presence",

    # MAPAS (Usualmente client-side, aunque algunos tienen modulos server)
    "minimap", "xaero", "journeymap", "map", "worldmap",

    # UTILIDADES DE ENTRADA
    "mouse", "keyboard", "control", "zoom", "logic-zoom", "okzoomer", "zoomify", "justzoom",
    "invmove", "itemscroller", "litematica", "tweakeroo"
)

# ==========================================

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  GENERADOR DE SERVER PACK v$Version" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Preparar Directorios y Estructura Limpia
if (Test-Path $OutputDir) { Remove-Item $OutputDir -Recurse -Force }
# Carpeta raíz del ZIP
$RootName = "MaxitoDev-Server-Pack"
$ZipRoot = "$TempDir/$RootName"
# Subcarpeta para archivos técnicos (para no ensuciar la raíz)
$ServerFiles = "$ZipRoot/server_files"

New-Item -ItemType Directory -Path $ServerFiles -Force | Out-Null

# 2. Copiar Configs (Dentro de server_files)
Write-Host "[1/4] Copiando Configuraciones..." -ForegroundColor Yellow
Copy-Item "$GameFiles/config" -Destination "$ServerFiles/" -Recurse
Copy-Item "$GameFiles/defaultconfigs" -Destination "$ServerFiles/" -Recurse -ErrorAction SilentlyContinue

# 3. Copiar e Inyectar Mods (Filtrado Inteligente)
Write-Host "[2/4] Filtrando y Copiando Mods..." -ForegroundColor Yellow
$ModsDir = "$GameFiles/mods"
$DestMods = "$ServerFiles/mods"
New-Item -ItemType Directory -Path $DestMods -Force | Out-Null

$mods = Get-ChildItem $ModsDir -Filter "*.jar"
$count = 0
$excluded = 0

foreach ($mod in $mods) {
    # Lógica de filtrado (Mismo código de antes)
    $isClient = $false
    foreach ($pattern in $ClientOnlyMods) {
        if ($mod.Name -match $pattern) {
            $isClient = $true
            break
        }
    }

    if ($isClient) {
        Write-Host "  [EXCLUIDO] $($mod.Name)" -ForegroundColor DarkGray
        $excluded++
    }
    else {
        Copy-Item $mod.FullName -Destination $DestMods
        $count++
    }
}

Write-Host "  -> Mods incluidos: $count" -ForegroundColor Green
Write-Host "  -> Mods excluidos (Cliente): $excluded" -ForegroundColor Red

# 4. Copiar Instalador
Write-Host "[3/4] Copiando Instalador del Loader..." -ForegroundColor Yellow
if (Test-Path "$GameFiles/installer") {
    Copy-Item "$GameFiles/installer" -Destination "$ServerFiles/" -Recurse
}

# 5. Generar Scripts de Inicio Profesional
Write-Host "[3.5/4] Generando scripts de inicio..." -ForegroundColor Yellow

# Script de inicio en la RAÍZ (apunta a server_files)
$StartBat = @"
@echo off
title MaxitoDev Server Console
cls
echo ==========================================
echo    INICIANDO SERVIDOR MAXITODEV
echo ==========================================
echo.

cd server_files

REM Verificar si existe el jar del servidor (fabric-server-launch.jar o similar)
if exist server.jar (
    echo Iniciando Java...
    java -Xmx4G -jar server.jar nogui
) else (
    echo [ERROR] No se encuentra server.jar.
    echo Por favor lee las instrucciones en LEEME.txt para instalar el Loader primero.
    echo.
)

pause
"@
$StartBat | Out-File "$ZipRoot/🚀_INICIAR_SERVIDOR.bat" -Encoding ASCII

# Script de inicio en la RAÍZ (Linux / Mac)
$StartSh = @"
#!/bin/bash
echo "=========================================="
echo "   INICIANDO SERVIDOR MAXITODEV (Linux)"
echo "=========================================="
echo ""

cd server_files

# Verificar si existe server.jar
if [ -f "server.jar" ]; then
    echo "Iniciando Java..."
    java -Xmx4G -jar server.jar nogui
else
    echo "[ERROR] No se encuentra server.jar."
    echo "Por favor lee las instrucciones en LEEME.txt"
    echo ""
fi
"@
# Guardar con finales de línea Unix (LF) para evitar errores en Linux
$StartSh -replace "`r`n", "`n" | Out-File "$ZipRoot/🚀_INICIAR_SERVIDOR.sh" -Encoding ascii


# Instrucciones
$InstallTxt = @"
GUIA DE INSTALACION DEL SERVIDOR
================================

Hola! Gracias por usar el Server Pack de MaxitoDev.
Hemos organizado todo en la carpeta 'server_files' para mantener esto limpio.

PASO 1: INSTALAR EL MOTOR (Fabric/NeoForge)
-------------------------------------------
1. Entra a la carpeta 'server_files/installer'.
2. Ejecuta el instalador .jar que hay dentro:
   
   Comando: java -jar fabric-installer-x.x.x.jar server -dir .. -downloadMinecraft

   (Asegurate de que se instale en la carpeta 'server_files', NO en 'installer')

3. Renombra el jar que se cree (ej. fabric-server-launch.jar) a "server.jar" 
   (o edita el script de inicio si prefieres mantener el nombre).

PASO 2: ACEPTAR EULA
--------------------
1. Intenta iniciar el servidor una vez (ejecuta 🚀_INICIAR_SERVIDOR.bat).
2. Fallará y creará un archivo 'eula.txt' en 'server_files'.
3. Abre 'server_files/eula.txt' y cambia eula=false a eula=true.

PASO 3: JUGAR
-------------
En Windows:
   Ejecuta 🚀_INICIAR_SERVIDOR.bat

En Linux:
   Primero da permisos: chmod +x 🚀_INICIAR_SERVIDOR.sh
   Luego ejecuta: ./🚀_INICIAR_SERVIDOR.sh

"@
$InstallTxt | Out-File "$ZipRoot/📄_LEEME_PRIMERO.txt" -Encoding UTF8

# 6. Comprimir la carpeta raíz
Write-Host "[4/4] Creando ZIP final..." -ForegroundColor Yellow
$ZipPath = "$OutputDir/Server-Pack-v$Version.zip"

# Comprimimos desde dentro de Temp para que el ZIP contenga la carpeta raíz 'MaxitoDev-Server-Pack'
Push-Location $TempDir
Compress-Archive -Path "$RootName" -DestinationPath $ZipPath -Force
Pop-Location

Write-Host ""
Write-Host "✅ LISTO! Archivo generado:" -ForegroundColor Green
Write-Host "   $ZipPath" -ForegroundColor White
Write-Host ""
pause
