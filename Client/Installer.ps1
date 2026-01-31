# =============================
# CONFIGURACION DE VERSIONES
# =============================
$FabricMinecraftVersion = "1.21.11"
$FabricLoaderVersion = "0.18.4"

# ============================================
# INSTALADOR DE MODPACK - MAXITODEV
# ============================================

# Inicializar rutas
if ($PSScriptRoot) { $ScriptPath = $PSScriptRoot } 
elseif ($MyInvocation.MyCommand.Path) { $ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path } 
else { $ScriptPath = (Get-Location).Path }
$GameFilesPath = Join-Path (Split-Path $ScriptPath -Parent) "GameFiles"

function Write-ColorText {
    param([string]$Text, [ConsoleColor]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

$Host.UI.RawUI.WindowTitle = "Instalador de Modpack - MaxitoDev"

function Write-Header {
    Clear-Host
    Write-ColorText "================================================================" -Color Cyan
    Write-ColorText "     INSTALADOR DE MODPACK - LIMPIEZA TOTAL" -Color Cyan
    Write-ColorText "================================================================" -Color Cyan
    Write-Host ""
}

# ============================================
# SELECCION DE RUTA
# ============================================
Write-Header
$defaultMinecraftPath = Join-Path $env:APPDATA ".minecraft"

Write-ColorText "Selecciona la carpeta de destino:" -Color Cyan
Write-ColorText " [1] Instalacion por defecto ($defaultMinecraftPath)" -Color Green
Write-ColorText " [2] Ruta personalizada" -Color Yellow
Write-Host "Opcion [1]: " -NoNewline

$pathSelection = Read-Host

if ($pathSelection -eq "2") {
    Write-Host "Pega la ruta completa de la carpeta de la instancia:" -ForegroundColor Yellow
    $inputPath = Read-Host
    $MinecraftPath = $inputPath -replace '"', ''
} else {
    $MinecraftPath = $defaultMinecraftPath
}

if (-not (Test-Path $MinecraftPath)) {
    New-Item -ItemType Directory -Path $MinecraftPath -Force | Out-Null
}

Write-ColorText "Ruta configurada: $MinecraftPath" -Color Cyan
Write-Host ""

# ============================================
# FUNCIONES
# ============================================

function Test-JavaInstalled {
    try { $j = java -version 2>&1 | Select-Object -First 1; return $true } catch { return $false }
}

function Clean-Old-Files {
    Write-ColorText "BORRANDO ARCHIVOS ANTIGUOS..." -Color Red
    # Borramos options.txt del usuario para asegurar que se use el del modpack
    $itemsClean = @("mods", "config", "defaultconfigs", "resourcepacks", "shaderpacks", "options.txt")
    
    foreach ($item in $itemsClean) {
        $target = Join-Path $MinecraftPath $item
        if (Test-Path $target) {
            try { 
                Remove-Item -Path $target -Recurse -Force -ErrorAction SilentlyContinue 
                Write-ColorText "  Eliminado: $item" -Color Gray
            } catch {
                Write-ColorText "  Advertencia: No se pudo borrar $item" -Color Yellow
            }
        }
    }
    Write-ColorText "Limpieza completada." -Color Green
}

function Install-ModLoader {
    Write-ColorText "[1/5] Instalando cargador..." -Color Yellow
    $installerPath = Join-Path $GameFilesPath "installer"
    $neoforgeJar = Get-ChildItem -Path $installerPath -Filter "neoforge-*.jar" -ErrorAction SilentlyContinue | Select-Object -First 1
    $fabricJar = Get-ChildItem -Path $installerPath -Filter "fabric-installer-*.jar" -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($neoforgeJar) {
        try {
            $p = Start-Process -FilePath "java" -ArgumentList "-jar", "`"$($neoforgeJar.FullName)`"" -Wait -PassThru
            return ($p.ExitCode -eq 0)
        } catch { return $false }
    } elseif ($fabricJar) {
        try {
            $args = @("-jar", "`"$($fabricJar.FullName)`"", "client", "-dir", "`"$MinecraftPath`"", "-mcversion", $FabricMinecraftVersion, "-loader", $FabricLoaderVersion)
            $p = Start-Process -FilePath "java" -ArgumentList $args -Wait -PassThru -NoNewWindow
            return ($p.ExitCode -eq 0)
        } catch { return $false }
    }
    return $false
}

function Copy-Files {
    param([string]$FolderName, [string]$StepName)
    Write-ColorText "`n$StepName" -Color Yellow
    $source = Join-Path $GameFilesPath $FolderName
    $dest = Join-Path $MinecraftPath $FolderName
    if (Test-Path $source) {
        if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force | Out-Null }
        Copy-Item -Path "$source\*" -Destination $dest -Recurse -Force
        Write-ColorText "  OK - Archivos instalados." -Color Green
    }
}

function Copy-Options {
    Write-ColorText "`nInstalando configuracion (options.txt)..." -Color Yellow
    $source = Join-Path $GameFilesPath "options.txt"
    $dest = Join-Path $MinecraftPath "options.txt"
    
    if (Test-Path $source) {
        # Copiamos el archivo TAL CUAL, sin editar nada, respetando la config del modpack
        Copy-Item -Path $source -Destination $dest -Force
        Write-ColorText "  OK - Configuracion importada correctamente." -Color Green
    } else {
        Write-ColorText "  NOTA: No se encontro options.txt en el instalador." -Color Gray
    }
}

function Configure-LauncherProfile {
    # Solo cambiamos el nombre y RAM en el launcher, sin tocar archivos del juego
    $file = Join-Path $MinecraftPath "launcher_profiles.json"
    if (Test-Path $file) {
        try {
            $json = Get-Content $file -Raw | ConvertFrom-Json
            foreach ($p in $json.profiles.PSObject.Properties) {
                if ($p.Value.name -match 'neoforge|fabric') {
                    $p.Value.name = "Modpack - MaxitoDev"
                    $p.Value.javaArgs = "-Xmx8G -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC"
                }
            }
            $json | ConvertTo-Json -Depth 10 | Set-Content $file -Encoding UTF8
        } catch {}
    }
}

# ============================================
# EJECUCION
# ============================================

if (-not (Test-JavaInstalled)) {
    Write-ColorText "ERROR: Java no detectado." -Color Red
    $Host.UI.RawUI.FlushInputBuffer()
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

Write-Header
Write-ColorText "ADVERTENCIA: ESTO BORRARA TU CONFIGURACION ACTUAL" -Color Red
Write-Host "Presiona Enter para continuar..."
Read-Host

Clean-Old-Files
$success = Install-ModLoader

if ($success) {
    Copy-Files "mods" "[2/5] Copiando Mods..."
    Copy-Files "resourcepacks" "[3/5] Copiando Resource Packs..."
    Copy-Files "shaderpacks" "[4/5] Copiando Shader Packs..."
    Copy-Files "config" "[5/5] Copiando Configs..."
    Copy-Files "defaultconfigs" "Copiando Default Configs..."
    
    Copy-Options
    Configure-LauncherProfile
    
    Write-Host ""
    Write-ColorText "INSTALACION LIMPIA COMPLETADA." -Color Green
} else {
    Write-ColorText "ERROR EN LA INSTALACION." -Color Red
}

Write-Host ""
$Host.UI.RawUI.FlushInputBuffer()
Write-Host "Presiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")