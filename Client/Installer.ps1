# =============================
# CONFIGURACION DE VERSIONES
# =============================
# Si usas Fabric, puedes definir aqui la version de Minecraft y del loader.
# Si dejas vacio, el instalador preguntara al usuario.
$FabricMinecraftVersion = "1.21.11"
$FabricLoaderVersion = "0.18.4"

# ============================================
# INSTALADOR DE MODPACK MINECRAFT - NEOFORGE
# Autor: MaxitoDev
# ============================================

# Inicializar correctamente $ScriptPath y $GameFilesPath
if ($PSScriptRoot) {
    $ScriptPath = $PSScriptRoot
} elseif ($MyInvocation.MyCommand.Path) {
    $ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
} else {
    $ScriptPath = (Get-Location).Path
}
$GameFilesPath = Join-Path (Split-Path $ScriptPath -Parent) "GameFiles"

# Funcion para escribir texto con color
function Write-ColorText {
    param(
        [string]$Text,
        [ConsoleColor]$Color = "White"
    )
    Write-Host $Text -ForegroundColor $Color
}

$Host.UI.RawUI.WindowTitle = "Instalador de Modpack - MaxitoDev"

function Write-Header {
    Clear-Host
    Write-ColorText "================================================================" -Color Cyan
    Write-ColorText "     INSTALADOR DE MODPACK MINECRAFT - NEOFORGE" -Color Cyan
    Write-ColorText "     Autor: MaxitoDev" -Color Cyan
    Write-ColorText "================================================================" -Color Cyan
    Write-Host ""
}

# ============================================
# SELECCION DE RUTA DE INSTALACION
# ============================================
Write-Header
$defaultMinecraftPath = Join-Path $env:APPDATA ".minecraft"

Write-ColorText "Selecciona la carpeta de destino:" -Color Cyan
Write-ColorText " [1] Instalacion por defecto ($defaultMinecraftPath)" -Color Green
Write-ColorText " [2] Ruta personalizada (Para MultiMC, Prism, o instancias secundarias)" -Color Yellow
Write-Host "Opcion [1]: " -NoNewline

$pathSelection = Read-Host

if ($pathSelection -eq "2") {
    Write-Host "Pega la ruta completa de la carpeta de la instancia:" -ForegroundColor Yellow
    Write-Host "(Ejemplo: C:\Juegos\PrismLauncher\instances\MiModpack\.minecraft)" -ForegroundColor DarkGray
    $inputPath = Read-Host
    # Eliminamos comillas por si el usuario copio la ruta como "C:\Ruta"
    $MinecraftPath = $inputPath -replace '"', ''
} else {
    $MinecraftPath = $defaultMinecraftPath
}

# Validacion basica de la ruta seleccionada
if (-not (Test-Path $MinecraftPath)) {
    Write-ColorText "ADVERTENCIA: La carpeta destino no existe: $MinecraftPath" -Color Yellow
    Write-Host "Deseas crearla? (S/N): " -NoNewline
    $create = Read-Host
    if ($create -match '^[SsYy]') {
        New-Item -ItemType Directory -Path $MinecraftPath -Force | Out-Null
    } else {
        Write-ColorText "Cancelado por el usuario." -Color Red
        exit 1
    }
}

Write-ColorText "Ruta de instalacion configurada: $MinecraftPath" -Color Cyan
Write-Host ""

# ============================================
# VALIDACIONES
# ============================================

if (-not $FabricMinecraftVersion -or [string]::IsNullOrWhiteSpace($FabricMinecraftVersion)) {
    Write-ColorText "ERROR: La version de Minecraft no esta definida." -Color Red
    exit 1
}
if (-not $FabricLoaderVersion -or [string]::IsNullOrWhiteSpace($FabricLoaderVersion)) {
    Write-ColorText "ERROR: La version del loader de Fabric no esta definida." -Color Red
    exit 1
}

$profileJson1 = Join-Path $MinecraftPath "launcher_profiles.json"
$profileJson2 = Join-Path $MinecraftPath "launcher_profiles_microsoft_store.json"

if (-not (Test-Path $profileJson1) -and -not (Test-Path $profileJson2)) {
    if ($pathSelection -eq "2") {
        Write-ColorText "ADVERTENCIA: No se detecto launcher_profiles.json." -Color Yellow
        Write-ColorText "Normal en launchers externos, pero no se configurara el perfil automaticamente." -Color Gray
    } else {
        Write-ColorText "ERROR: No se encontro un perfil de lanzador valido." -Color Red
        Write-ColorText "Asegurate de haber abierto Minecraft al menos una vez." -Color Yellow
        exit 1
    }
}

$testPaths = @("installer", "mods", "resourcepacks", "shaderpacks", "config")
foreach ($testPath in $testPaths) {
    if (-not (Test-Path (Join-Path $GameFilesPath $testPath))) {
        Write-ColorText "ADVERTENCIA: No se encontro la carpeta '$testPath' en GameFiles." -Color Yellow
    }
}

# ============================================
# FUNCIONES
# ============================================

function Test-JavaInstalled {
    try {
        $javaVersion = java -version 2>&1 | Select-Object -First 1
        return $true
    } catch {
        return $false
    }
}

function Install-ModLoader {
    Write-ColorText "[1/5] Instalando modloader..." -Color Yellow
    $installerPath = Join-Path $GameFilesPath "installer"
    
    if (-not (Test-Path $installerPath)) {
        Write-ColorText "ERROR: No se encuentra la carpeta 'installer'" -Color Red
        return $false
    }

    $neoforgeJar = Get-ChildItem -Path $installerPath -Filter "neoforge-*.jar" -ErrorAction SilentlyContinue | Select-Object -First 1
    $fabricJar = Get-ChildItem -Path $installerPath -Filter "fabric-installer-*.jar" -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($neoforgeJar) {
        Write-ColorText "  Encontrado: $($neoforgeJar.Name) (NeoForge)" -Color Green
        Write-ColorText "  Abriendo instalador de NeoForge..." -Color Gray
        try {
            $process = Start-Process -FilePath "java" -ArgumentList "-jar", "`"$($neoforgeJar.FullName)`"" -Wait -PassThru
            if ($process.ExitCode -eq 0) {
                Write-ColorText "  OK - NeoForge instalado correctamente" -Color Green
                Start-Sleep -Seconds 2
                return $true
            } else {
                Write-ColorText "  ERROR: El instalador de NeoForge finalizo con errores" -Color Red
                return $false
            }
        } catch {
            Write-ColorText "  ERROR ejecuntando Java: $_" -Color Red
            return $false
        }
    } elseif ($fabricJar) {
        Write-ColorText "  Encontrado: $($fabricJar.Name) (Fabric)" -Color Green
        Write-ColorText "  Instalando Fabric en modo terminal..." -Color Yellow
        try {
            $args = @("-jar", "`"$($fabricJar.FullName)`"", "client", "-dir", "`"$MinecraftPath`"", "-mcversion", $FabricMinecraftVersion, "-loader", $FabricLoaderVersion)
            $process = Start-Process -FilePath "java" -ArgumentList $args -Wait -PassThru -NoNewWindow
            if ($process.ExitCode -eq 0) {
                Write-ColorText "  OK - Fabric instalado correctamente" -Color Green
                Start-Sleep -Seconds 2
                return $true
            } else {
                Write-ColorText "  ERROR: El instalador de Fabric finalizo con errores" -Color Red
                return $false
            }
        } catch {
            Write-ColorText "  ERROR ejecuntando Java: $_" -Color Red
            return $false
        }
    } else {
        Write-ColorText "ERROR: No se encontro instalador .jar en la carpeta 'installer'" -Color Red
        return $false
    }
}

function Copy-Mods {
    Write-ColorText "`n[2/5] Copiando mods..." -Color Yellow
    $modsSource = Join-Path $GameFilesPath "mods"
    $modsDestination = Join-Path $MinecraftPath "mods"
    
    if (-not (Test-Path $modsDestination)) {
        New-Item -ItemType Directory -Path $modsDestination -Force | Out-Null
    }
    
    Get-ChildItem -Path $modsDestination -Include "*.jar" -Recurse | Remove-Item -Force
    
    $mods = Get-ChildItem -Path $modsSource -Filter "*.jar" -ErrorAction SilentlyContinue
    if ($mods.Count -eq 0) {
        Write-ColorText "  Advertencia: No hay mods para copiar." -Color Yellow
        return $true
    }

    foreach ($mod in $mods) {
        Copy-Item -LiteralPath $mod.FullName -Destination $modsDestination -Force
    }
    Write-ColorText "  OK - $($mods.Count) mods copiados." -Color Green
    return $true
}

function Copy-ResourcePacks {
    Write-ColorText "`n[3/5] Copiando resource packs..." -Color Yellow
    $source = Join-Path $GameFilesPath "resourcepacks"
    $dest = Join-Path $MinecraftPath "resourcepacks"
    
    if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force | Out-Null }
    
    $files = Get-ChildItem -Path $source -Filter "*.zip" -ErrorAction SilentlyContinue
    if ($files.Count -gt 0) {
        foreach ($file in $files) {
            Copy-Item -LiteralPath $file.FullName -Destination $dest -Force
        }
        Write-ColorText "  OK - $($files.Count) resource packs copiados." -Color Green
    } else {
        Write-ColorText "  No hay resource packs para copiar." -Color Gray
    }
    return $true
}

function Copy-ShaderPacks {
    Write-ColorText "`n[4/5] Copiando shader packs..." -Color Yellow
    $source = Join-Path $GameFilesPath "shaderpacks"
    $dest = Join-Path $MinecraftPath "shaderpacks"
    
    if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force | Out-Null }
    
    $files = Get-ChildItem -Path $source -Filter "*.zip" -ErrorAction SilentlyContinue
    if ($files.Count -gt 0) {
        foreach ($file in $files) {
            Copy-Item -LiteralPath $file.FullName -Destination $dest -Force
        }
        Write-ColorText "  OK - $($files.Count) shader packs copiados." -Color Green
    } else {
        Write-ColorText "  No hay shader packs para copiar." -Color Gray
    }
    return $true
}

function Copy-Configs {
    Write-ColorText "`n[5/5] Copiando configuraciones (config)..." -Color Yellow
    $source = Join-Path $GameFilesPath "config"
    $dest = Join-Path $MinecraftPath "config"
    
    if (-not (Test-Path $source)) {
        Write-ColorText "  No hay carpeta config en origen." -Color Gray
        return $true
    }
    if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force | Out-Null }
    
    Copy-Item -Path "$source\*" -Destination $dest -Recurse -Force
    Write-ColorText "  OK - Archivos de configuracion copiados." -Color Green
    return $true
}

function Copy-DefaultConfigs {
    Write-ColorText "`nCopiando defaultconfigs..." -Color Yellow
    $source = Join-Path $GameFilesPath "defaultconfigs"
    $dest = Join-Path $MinecraftPath "defaultconfigs"
    
    if (-not (Test-Path $source)) {
        Write-ColorText "  No hay carpeta defaultconfigs en origen (opcional)." -Color Gray
        return $true
    }
    if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force | Out-Null }
    
    Copy-Item -Path "$source\*" -Destination $dest -Recurse -Force
    Write-ColorText "  OK - Defaultconfigs copiados." -Color Green
    return $true
}

function Configure-GameSettings {
    Write-ColorText "`nConfigurando options.txt e Iris..." -Color Yellow
    
    $optionsFile = Join-Path $MinecraftPath "options.txt"
    $requiredPacks = @("Alacrity.zip")
    $requiredShader = "Bliss_v2.1.2_(Chocapic13_Shaders_edit).zip"
    
    if (Test-Path $optionsFile) {
        $content = Get-Content $optionsFile
        $customPacks = ($requiredPacks | ForEach-Object { "`"file/$_`"" }) -join ","
        $newLine = "resourcePacks:[`"vanilla`",$customPacks,`"mod_resources`"]"
        
        $replaced = $false
        for ($i = 0; $i -lt $content.Count; $i++) {
            if ($content[$i] -match '^resourcePacks:') {
                $content[$i] = $newLine
                $replaced = $true
                break
            }
        }
        if (-not $replaced) { $content += $newLine }
        $content | Set-Content -Path $optionsFile -Encoding UTF8
        Write-ColorText "  OK - options.txt actualizado." -Color Green
    }

    $shaderPath = Join-Path $MinecraftPath "shaderpacks\$requiredShader"
    if (Test-Path $shaderPath) {
        $irisDir = Join-Path $MinecraftPath "config\iris"
        if (-not (Test-Path $irisDir)) { New-Item -ItemType Directory -Path $irisDir -Force | Out-Null }
        
        $irisConfig = @"
enableShaders=true
shaderPack=$requiredShader
enableDebugOptions=false
maxShadowRenderDistance=12
"@
        $irisConfig | Set-Content -Path (Join-Path $irisDir "iris.properties") -Encoding UTF8
        Write-ColorText "  OK - Iris configurado con $requiredShader" -Color Green
    }
    return $true
}

function Configure-LauncherProfile {
    $launcherProfilesFile = Join-Path $MinecraftPath "launcher_profiles.json"
    if (-not (Test-Path $launcherProfilesFile)) { return $true }
    
    Write-ColorText "`nConfigurando perfil en el Launcher..." -Color Yellow
    try {
        $json = Get-Content $launcherProfilesFile -Raw | ConvertFrom-Json
        $customName = "Modpack - by MaxitoDev"
        
        foreach ($key in $json.profiles.PSObject.Properties.Name) {
            $p = $json.profiles.$key
            if ($p.name -match 'neoforge' -or $p.lastVersionId -match 'neoforge' -or $p.lastVersionId -match 'fabric') {
                $p.name = $customName
                $p.icon = "Grass"
                $p.javaArgs = "-Xmx8G -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC" 
                Write-ColorText "  OK - Perfil actualizado: $customName" -Color Green
                break
            }
        }
        $json | ConvertTo-Json -Depth 10 | Set-Content $launcherProfilesFile -Encoding UTF8
    } catch {
        Write-ColorText "  No se pudo configurar el perfil automaticamente." -Color Gray
    }
    return $true
}

# ============================================
# EJECUCION PRINCIPAL
# ============================================

Write-ColorText "Verificando requisitos..." -Color Yellow
if (-not (Test-JavaInstalled)) {
    Write-ColorText "ERROR: Java no esta instalado o no esta en el PATH" -Color Red
    Write-Host "`nPresiona cualquier tecla para salir..."
    $Host.UI.RawUI.FlushInputBuffer()
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
Write-ColorText "OK - Java detectado" -Color Green

Write-Host "`nDesea continuar con la instalacion en: $MinecraftPath? (S/N): " -NoNewline
$response = Read-Host
if ($response -notmatch '^[SsYy]') {
    Write-ColorText "`nInstalacion cancelada." -Color Yellow
    exit 0
}

Write-Host ""
Write-ColorText "================================================================" -Color Cyan
Write-ColorText "INICIANDO INSTALACION" -Color Cyan
Write-ColorText "================================================================" -Color Cyan
Write-Host ""

if ($pathSelection -ne "2") {
    $foldersToClean = @("mods", "config", "defaultconfigs")
    foreach ($folder in $foldersToClean) {
        $full = Join-Path $MinecraftPath $folder
        if (Test-Path $full) { Remove-Item -Path $full -Recurse -Force -ErrorAction SilentlyContinue }
    }
}

$success = $true

if (-not (Install-ModLoader)) { $success = $false }

if ($success) {
    Copy-Mods
    Copy-ResourcePacks
    Copy-ShaderPacks
    Copy-Configs
    Copy-DefaultConfigs
    
    $optSrc = Join-Path $GameFilesPath "options.txt"
    if (Test-Path $optSrc) { Copy-Item $optSrc (Join-Path $MinecraftPath "options.txt") -Force }

    Configure-GameSettings
    Configure-LauncherProfile
}

Write-Host ""
Write-ColorText "================================================================" -Color Cyan

if ($success) {
    Write-ColorText "OK - INSTALACION COMPLETADA CON EXITO!" -Color Green
    Write-Host ""
    Write-ColorText "IMPORTANTE - RAM:" -Color Yellow
    Write-ColorText "  Se ha configurado un perfil base de 8GB." -Color White
    Write-ColorText "  Como tienes 32GB de RAM en tu PC, te recomiendo subirlo a 10GB o 12GB" -Color Gray
    Write-ColorText "  en la configuracion del perfil del launcher." -Color Gray
} else {
    Write-ColorText "ERROR - LA INSTALACION FINALIZO CON ERRORES" -Color Red
}

Write-ColorText "================================================================" -Color Cyan

Write-Host "Presiona cualquier tecla para salir..." 
$Host.UI.RawUI.FlushInputBuffer()
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
exit 0