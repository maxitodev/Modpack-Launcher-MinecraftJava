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
    "3dskinlayers", "skinlayers3d", "waveycapes", "capes", "auth", "bettercombat",  
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

# 4. Copiar Instalador y Generar Script de Instalación AUTOMÁTICO
Write-Host "[3/4] Detectando Loader y generando instalador..." -ForegroundColor Yellow
$InstallerDirSource = "$GameFiles/installer"
$InstallerDirDest = "$ServerFiles/installer"

if (Test-Path $InstallerDirSource) {
    Copy-Item $InstallerDirSource -Destination "$ServerFiles/" -Recurse
    
    # Detectar el archivo JAR exacto
    $InstallerJar = Get-ChildItem "$InstallerDirSource" -Filter "*.jar" | Select-Object -First 1
    
    if ($InstallerJar) {
        $JarName = $InstallerJar.Name
        $InstallCommand = ""
        $LoaderType = "Desconocido"

        if ($JarName -match "fabric") {
            $LoaderType = "Fabric"
            # Comando oficial de Fabric para servidor
            $InstallCommand = "java -jar installer/$JarName server -dir . -downloadMinecraft"
        }
        elseif ($JarName -match "neoforge") {
            $LoaderType = "NeoForge"
            # Comando oficial de NeoForge
            $InstallCommand = "java -jar installer/$JarName --installServer"
        }

        if ($InstallCommand) {
            Write-Host "  -> Loader detectado: $LoaderType ($JarName)" -ForegroundColor Cyan
            
            # Script INSTALAR para Windows
            # Archivo renombrado a 1_INSTALAR_SISTEMA.bat (sin emoji)
            $InstallBat = @"
@echo off
title Instalador $LoaderType - MaxitoDev
cls
echo ==========================================
echo    INSTALANDO SISTEMA SERVER ($LoaderType)
echo ==========================================
echo.
echo Detectado: $JarName
echo Instalando en: server_files/
echo.

cd server_files
echo Ejecutando instalador...
$InstallCommand

echo.
echo ==========================================
echo  INSTALACION FINALIZADA
echo ==========================================
echo.
echo AHORA:
echo 1. Si es la primera vez, ejecuta 2_INICIAR_SERVIDOR para generar el EULA.
echo 2. Acepta el eula.txt.
echo 3. Juega!
echo.
pause
"@
            $InstallBat | Out-File "$ZipRoot/1_INSTALAR_SISTEMA.bat" -Encoding ASCII

            # Script INSTALAR para Linux
            $InstallSh = @"
#!/bin/bash
echo "=========================================="
echo "   INSTALANDO SISTEMA SERVER ($LoaderType)"
echo "=========================================="
echo ""

cd server_files
echo "Ejecutando instalador..."
$InstallCommand

echo ""
echo "Listo. Recuerda aceptar el eula.txt generado."
"@
            $InstallSh -replace "`r`n", "`n" | Out-File "$ZipRoot/1_INSTALAR_SISTEMA.sh" -Encoding ascii
        }
    }
}
else {
    Write-Host "Warning: No se encontro carpeta installer." -ForegroundColor Red
}

# 5. Generar Scripts de Inicio Profesional
Write-Host "[3.5/4] Generando scripts de inicio..." -ForegroundColor Yellow

# Script de inicio en la RAÍZ (apunta a server_files)
$StartBat = @"
@echo off
title ModPack Server Console
cls
echo ==========================================
echo    INICIANDO SERVIDOR MODPACK
echo ==========================================
echo.

cd server_files

REM 1. Intentar Fabric
if exist fabric-server-launch.jar goto START_FABRIC

REM 2. Intentar NeoForge (run.bat)
if exist run.bat goto START_NEOFORGE

REM 3. Intentar Vanilla (server.jar) o fallback
if exist server.jar goto START_VANILLA

REM 4. Si no hay nada
goto ERROR_NO_FILE

:START_FABRIC
echo [SISTEMA] Detectado Fabric Loader.
echo Iniciando fabric-server-launch.jar...
java -Xmx4G -jar fabric-server-launch.jar nogui
goto END

:START_NEOFORGE
echo [SISTEMA] Detectado NeoForge.
echo Iniciando run.bat...
call run.bat
goto END

:START_VANILLA
echo [SISTEMA] Solo se encontro server.jar (Vanilla).
echo Iniciando server.jar...
java -Xmx4G -jar server.jar nogui
goto END

:ERROR_NO_FILE
echo [ERROR] CRITICO: No se encontraron archivos de servidor.
echo ----------------------------------------------------
echo Posibles causas:
echo 1. No ejecutaste '1_INSTALAR_SISTEMA.bat' (Obligatorio).
echo 2. La instalacion fallo o no tienes internet.
echo ----------------------------------------------------
echo.
pause
exit

:END
echo.
echo Servidor detenido.
pause
"@
$StartBat | Out-File "$ZipRoot/2_INICIAR_SERVIDOR.bat" -Encoding ASCII

# Script de inicio LINUX
$StartSh = @"
#!/bin/bash
echo "=========================================="
echo "   INICIANDO SERVIDOR MAXITODEV (Linux)"
echo "=========================================="
echo ""

cd server_files

SERVER_JAR="server.jar"

if [ -f "fabric-server-launch.jar" ]; then
    echo "[SISTEMA] Detectado Fabric Loader."
    SERVER_JAR="fabric-server-launch.jar"
elif [ -f "run.sh" ]; then
    echo "[SISTEMA] Detectado NeoForge (usando run.sh)."
    chmod +x run.sh
    ./run.sh
    exit 0
fi

# Verificar si existe el jar seleccionado
if [ -f "\$SERVER_JAR" ]; then
    echo "Iniciando \$SERVER_JAR..."
    java -Xmx4G -jar \$SERVER_JAR nogui
else
    echo "[ERROR] No se encuentra \$SERVER_JAR."
    echo "Por favor ejecuta primero 1_INSTALAR_SISTEMA."
    echo ""
fi
"@
$StartSh -replace "`r`n", "`n" | Out-File "$ZipRoot/2_INICIAR_SERVIDOR.sh" -Encoding ascii

# Instrucciones LEEME
$InstallTxt = @"
GUIA DE INSTALACION DEL SERVIDOR
================================

Hola! Gracias por usar el Server Pack de MaxitoDev.
Hemos organizado todo en la carpeta 'server_files' para mantener esto limpio.

PASO 1: INSTALACION AUTOMATICA
------------------------------
1. Ejecuta el script '1_INSTALAR_SISTEMA.bat' (o .sh en Linux).
   Esto descargara e instalara todo lo necesario automaticamente.

PASO 2: ACEPTAR EULA
--------------------
1. Intenta iniciar el servidor (ejecuta 2_INICIAR_SERVIDOR).
2. Fallara y creara un archivo 'server_files/eula.txt'.
3. Abre ese archivo y cambia eula=false a eula=true.

PASO 3: INICIAR
---------------
1. Vuelve a ejecutar 2_INICIAR_SERVIDOR y disfruta!

"@
$InstallTxt | Out-File "$ZipRoot/0_LEEME_PRIMERO.txt" -Encoding UTF8

# 6. Comprimir la carpeta raíz
Write-Host "[4/4] Creando ZIP final..." -ForegroundColor Yellow
$ZipPath = "$OutputDir/Server-Pack-v$Version.zip"

Push-Location $TempDir
Compress-Archive -Path "$RootName" -DestinationPath $ZipPath -Force
Pop-Location

Write-Host ""
Write-Host " [OK] LISTO! Archivo generado:" -ForegroundColor Green
Write-Host "      $ZipPath" -ForegroundColor White
Write-Host ""
pause
