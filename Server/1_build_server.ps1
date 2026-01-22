# Build del Servidor - PowerShell
# Autor: MaxitoDev

$Host.UI.RawUI.WindowTitle = "Build del Servidor"

function Write-ColorText {
    param(
        [string]$Text,
        [string]$Color = "White"
    )
    Write-Host $Text -ForegroundColor $Color
}

Write-ColorText "================================================================" -Color Cyan
Write-ColorText " BUILD DEL SERVIDOR - CREAR PAQUETE" -Color Cyan
Write-ColorText "================================================================" -Color Cyan
Write-Host ""

$OutputFile = "Modpack-Server-MaxitoDev-1.21.11.zip"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ParentDir = Split-Path -Parent $ScriptDir

Write-ColorText "Verificando archivos necesarios..." -Color Yellow

$RequiredItems = @(
    "$ScriptDir\install.sh",
    "$ParentDir\installer",
    "$ParentDir\mods",
    "$ParentDir\config",
    "$ParentDir\plugins"
)

$AllPresent = $true
foreach ($item in $RequiredItems) {
    if (-not (Test-Path $item)) {
        Write-ColorText "X No se encontro: $(Split-Path -Leaf $item)" -Color Red
        $AllPresent = $false
    }
}

if (-not $AllPresent) {
    Write-Host ""
    Write-ColorText "ERROR: Faltan archivos necesarios" -Color Red
    exit 1
}

Write-ColorText "OK Todos los archivos estan presentes" -Color Green
Write-Host ""
Write-ColorText "Creando paquete de distribucion..." -Color Yellow
Write-Host ""

$TempDir = Join-Path $env:TEMP "mcpack_server_build"
if (Test-Path $TempDir) {
    Remove-Item $TempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

try {
    Write-ColorText "  Copiando installer/..." -Color Gray
    $installerDest = Join-Path $TempDir "installer"
    Copy-Item -Path "$ParentDir\installer" -Destination $installerDest -Recurse -Force
    
    Write-ColorText "  Copiando mods/..." -Color Gray
    $modsDest = Join-Path $TempDir "mods"
    Copy-Item -Path "$ParentDir\mods" -Destination $modsDest -Recurse -Force
    
    Write-ColorText "  Copiando config/..." -Color Gray
    $configDest = Join-Path $TempDir "config"
    Copy-Item -Path "$ParentDir\config" -Destination $configDest -Recurse -Force
    
    Write-ColorText "  Copiando plugins/..." -Color Gray
    $pluginsDest = Join-Path $TempDir "plugins"
    Copy-Item -Path "$ParentDir\plugins" -Destination $pluginsDest -Recurse -Force
    
    Write-ColorText "  Copiando archivos del servidor..." -Color Gray
    $serverDest = Join-Path $TempDir "Server"
    New-Item -ItemType Directory -Path $serverDest -Force | Out-Null
    Copy-Item -Path "$ScriptDir\install.sh" -Destination $serverDest -Force
    Copy-Item -Path "$ScriptDir\LEEME_SERVIDOR.txt" -Destination $serverDest -Force
    
    Write-ColorText "  Comprimiendo archivos..." -Color Gray
    $FinalFile = Join-Path $ScriptDir $OutputFile
    if (Test-Path $FinalFile) {
        Remove-Item $FinalFile -Force
    }
    
    Compress-Archive -Path "$TempDir\*" -DestinationPath $FinalFile -Force
    
    Remove-Item $TempDir -Recurse -Force
    
    Write-Host ""
    Write-ColorText "================================================================" -Color Green
    Write-ColorText " OK PAQUETE CREADO EXITOSAMENTE!" -Color Green
    Write-ColorText "================================================================" -Color Green
    Write-Host ""
    Write-ColorText "Archivo creado:" -Color Cyan
    Write-ColorText "  $FinalFile" -Color Yellow
    Write-Host ""
    Write-ColorText "NOTA: El archivo es .zip (compatible con Windows y Linux)" -Color Yellow
    Write-Host ""
    Write-ColorText "Para distribuir:" -Color Cyan
    Write-ColorText "  1. Sube el archivo al VPS" -Color Yellow
    Write-ColorText "  2. Descomprime: unzip $OutputFile" -Color Yellow
    Write-ColorText "  3. Ejecuta: cd Server && chmod +x install.sh && ./install.sh" -Color Yellow
    Write-Host ""
    Write-ColorText "================================================================" -Color Cyan
    
} catch {
    Write-Host ""
    Write-ColorText "ERROR: No se pudo crear el paquete" -Color Red
    Write-ColorText "Detalles: $($_.Exception.Message)" -Color Red
    
    if (Test-Path $TempDir) {
        Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    exit 1
}

Write-Host ""
