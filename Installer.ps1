# ============================================
# INSTALADOR DE MODPACK MINECRAFT - NEOFORGE
# Autor: MaxitoDev
# ============================================

param(
    [string]$MinecraftPath = "$env:APPDATA\.minecraft"
)

# Detectar la ruta del ejecutable/script correctamente
if ($PSScriptRoot) {
    # Ejecutando como script .ps1
    $ScriptPath = $PSScriptRoot
} elseif ($MyInvocation.MyCommand.Path) {
    # Ejecutando como script .ps1 (alternativa)
    $ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
} else {
    # Ejecutando como .exe compilado
    $ScriptPath = Split-Path -Parent ([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName)
}

# Colores y formato
$Host.UI.RawUI.WindowTitle = "Instalador de Modpack"

function Write-ColorText {
    param(
        [string]$Text,
        [ConsoleColor]$Color = "White"
    )
    Write-Host $Text -ForegroundColor $Color
}

function Write-Header {
    Clear-Host
    Write-ColorText "================================================================" -Color Cyan
    Write-ColorText "     INSTALADOR DE MODPACK MINECRAFT - NEOFORGE" -Color Cyan
    Write-ColorText "     Autor: MaxitoDev" -Color Cyan
    Write-ColorText "================================================================" -Color Cyan
    Write-Host ""
}

function Test-JavaInstalled {
    try {
        $javaVersion = java -version 2>&1 | Select-Object -First 1
        return $true
    } catch {
        return $false
    }
}

function Install-NeoForge {
    Write-ColorText "[1/4] Instalando NeoForge..." -Color Yellow
    
    $neoforgeJar = Get-ChildItem -Path "$ScriptPath\installer" -Filter "neoforge-*.jar" | Select-Object -First 1
    
    if (-not $neoforgeJar) {
        Write-ColorText "ERROR: No se encontro el instalador de NeoForge en la carpeta 'installer'" -Color Red
        Write-ColorText "Por favor, coloca el archivo .jar de NeoForge en la carpeta 'installer'" -Color Red
        return $false
    }
    
    Write-ColorText "  Encontrado: $($neoforgeJar.Name)" -Color Green
    Write-ColorText "  Ejecutando instalador de NeoForge..." -Color Gray
    
    try {
        # Ejecutar el instalador de NeoForge
        $process = Start-Process -FilePath "java" -ArgumentList "-jar", "`"$($neoforgeJar.FullName)`"" -Wait -PassThru -NoNewWindow
        
        if ($process.ExitCode -eq 0) {
            Write-ColorText "  OK - NeoForge instalado correctamente" -Color Green
            return $true
        } else {
            Write-ColorText "  ERROR: El instalador de NeoForge finalizo con errores" -Color Red
            return $false
        }
    } catch {
        Write-ColorText "  ERROR: No se pudo ejecutar el instalador de NeoForge" -Color Red
        Write-ColorText "  Detalles: $_" -Color Red
        return $false
    }
}

function Copy-Mods {
    Write-ColorText "`n[2/4] Copiando mods..." -Color Yellow
    
    $modsSource = Join-Path $ScriptPath "mods"
    $modsDestination = Join-Path $MinecraftPath "mods"
    
    # Crear carpeta de destino si no existe
    if (-not (Test-Path $modsDestination)) {
        New-Item -ItemType Directory -Path $modsDestination -Force | Out-Null
    }
    
    # Obtener lista de mods
    $mods = Get-ChildItem -Path $modsSource -Filter "*.jar" -ErrorAction SilentlyContinue
    
    if ($mods.Count -eq 0) {
        Write-ColorText "  Advertencia: No se encontraron mods en la carpeta 'mods'" -Color Yellow
        return $true
    }
    
    Write-ColorText "  Encontrados $($mods.Count) mods" -Color Gray
    
    $copied = 0
    foreach ($mod in $mods) {
        try {
            Copy-Item -Path $mod.FullName -Destination $modsDestination -Force
            $copied++
            Write-ColorText "  OK - $($mod.Name)" -Color Green
        } catch {
            Write-ColorText "  ERROR copiando $($mod.Name): $_" -Color Red
        }
    }
    
    Write-ColorText "  OK - $copied de $($mods.Count) mods copiados correctamente" -Color Green
    return $true
}

function Copy-ResourcePacks {
    Write-ColorText "`n[3/4] Copiando resource packs..." -Color Yellow
    
    $resourcepacksSource = Join-Path $ScriptPath "resourcepacks"
    $resourcepacksDestination = Join-Path $MinecraftPath "resourcepacks"
    
    # Crear carpeta de destino si no existe
    if (-not (Test-Path $resourcepacksDestination)) {
        New-Item -ItemType Directory -Path $resourcepacksDestination -Force | Out-Null
    }
    
    # Obtener lista de resource packs
    $resourcepacks = Get-ChildItem -Path $resourcepacksSource -Filter "*.zip" -ErrorAction SilentlyContinue
    
    if ($resourcepacks.Count -eq 0) {
        Write-ColorText "  Advertencia: No se encontraron resource packs en la carpeta 'resourcepacks'" -Color Yellow
        return $true
    }
    
    Write-ColorText "  Encontrados $($resourcepacks.Count) resource packs" -Color Gray
    
    $copied = 0
    foreach ($pack in $resourcepacks) {
        try {
            Copy-Item -Path $pack.FullName -Destination $resourcepacksDestination -Force
            $copied++
            Write-ColorText "  OK - $($pack.Name)" -Color Green
        } catch {
            Write-ColorText "  ERROR copiando $($pack.Name): $_" -Color Red
        }
    }
    
    Write-ColorText "  OK - $copied de $($resourcepacks.Count) resource packs copiados correctamente" -Color Green
    return $true
}

function Copy-ShaderPacks {
    Write-ColorText "`n[4/4] Copiando shader packs..." -Color Yellow
    
    $shaderpacksSource = Join-Path $ScriptPath "shaderpacks"
    $shaderpacksDestination = Join-Path $MinecraftPath "shaderpacks"
    
    # Crear carpeta de destino si no existe
    if (-not (Test-Path $shaderpacksDestination)) {
        New-Item -ItemType Directory -Path $shaderpacksDestination -Force | Out-Null
    }
    
    # Obtener lista de shader packs
    $shaderpacks = Get-ChildItem -Path $shaderpacksSource -Filter "*.zip" -ErrorAction SilentlyContinue
    
    if ($shaderpacks.Count -eq 0) {
        Write-ColorText "  Advertencia: No se encontraron shader packs en la carpeta 'shaderpacks'" -Color Yellow
        return $true
    }
    
    Write-ColorText "  Encontrados $($shaderpacks.Count) shader packs" -Color Gray
    
    $copied = 0
    foreach ($pack in $shaderpacks) {
        try {
            Copy-Item -Path $pack.FullName -Destination $shaderpacksDestination -Force
            $copied++
            Write-ColorText "  OK - $($pack.Name)" -Color Green
        } catch {
            Write-ColorText "  ERROR copiando $($pack.Name): $_" -Color Red
        }
    }
    
    Write-ColorText "  OK - $copied de $($shaderpacks.Count) shader packs copiados correctamente" -Color Green
    return $true
}

function Copy-Configs {
    Write-ColorText "`nCopiando archivos de configuracion..." -Color Yellow
    
    $configSource = Join-Path $ScriptPath "config"
    $configDestination = Join-Path $MinecraftPath "config"
    
    # Verificar si hay archivos de configuracion
    $configs = Get-ChildItem -Path $configSource -Recurse -File -ErrorAction SilentlyContinue
    
    if ($configs.Count -eq 0) {
        Write-ColorText "  No hay archivos de configuracion para copiar" -Color Gray
        return $true
    }
    
    # Crear carpeta de destino si no existe
    if (-not (Test-Path $configDestination)) {
        New-Item -ItemType Directory -Path $configDestination -Force | Out-Null
    }
    
    Write-ColorText "  Encontrados $($configs.Count) archivos de configuracion" -Color Gray
    
    $copied = 0
    foreach ($config in $configs) {
        try {
            $relativePath = $config.FullName.Substring($configSource.Length + 1)
            $destPath = Join-Path $configDestination $relativePath
            $destDir = Split-Path $destPath -Parent
            
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
            
            Copy-Item -Path $config.FullName -Destination $destPath -Force
            $copied++
        } catch {
            Write-ColorText "  ERROR copiando $($config.Name): $_" -Color Red
        }
    }
    
    Write-ColorText "  OK - $copied archivos de configuracion copiados" -Color Green
    return $true
}

function Configure-GameSettings {
    Write-ColorText "`nConfigurando opciones del juego..." -Color Yellow
    
    $optionsFile = Join-Path $MinecraftPath "options.txt"
    
    # Obtener lista de resource packs instalados
    $resourcepacksPath = Join-Path $MinecraftPath "resourcepacks"
    $installedPacks = Get-ChildItem -Path $resourcepacksPath -Filter "*.zip" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
    
    # Obtener shader instalado (usar el primero encontrado)
    $shaderpacksPath = Join-Path $MinecraftPath "shaderpacks"
    $installedShader = Get-ChildItem -Path $shaderpacksPath -Filter "*.zip" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty Name
    
    if ($installedPacks.Count -eq 0 -and -not $installedShader) {
        Write-ColorText "  No hay resource packs o shaders para configurar" -Color Gray
        return $true
    }
    
    # Leer options.txt existente o crear nuevo
    $optionsContent = @()
    $resourcePacksConfigured = $false
    $shaderConfigured = $false
    
    if (Test-Path $optionsFile) {
        $optionsContent = Get-Content $optionsFile
    }
    
    # Construir lista de resource packs en formato JSON
    if ($installedPacks.Count -gt 0) {
        $packsJson = ($installedPacks | ForEach-Object { "`"file/$_`"" }) -join ","
        $resourcePacksLine = "resourcePacks:[$packsJson]"
        
        # Buscar y reemplazar la linea de resourcePacks
        for ($i = 0; $i -lt $optionsContent.Count; $i++) {
            if ($optionsContent[$i] -match '^resourcePacks:') {
                $optionsContent[$i] = $resourcePacksLine
                $resourcePacksConfigured = $true
                break
            }
        }
        
        # Si no existe, agregar
        if (-not $resourcePacksConfigured) {
            $optionsContent += $resourcePacksLine
        }
        
        Write-ColorText "  OK - Resource packs configurados: $($installedPacks.Count)" -Color Green
    }
    
    # Configurar shader (para Iris/Optifine)
    if ($installedShader) {
        $shaderLine = "shaderPack:$installedShader"
        
        # Buscar y reemplazar la linea de shader
        for ($i = 0; $i -lt $optionsContent.Count; $i++) {
            if ($optionsContent[$i] -match '^shaderPack:') {
                $optionsContent[$i] = $shaderLine
                $shaderConfigured = $true
                break
            }
        }
        
        # Si no existe, agregar
        if (-not $shaderConfigured) {
            $optionsContent += $shaderLine
        }
        
        Write-ColorText "  OK - Shader configurado: $installedShader" -Color Green
    }
    
    # Guardar options.txt
    try {
        $optionsContent | Set-Content -Path $optionsFile -Encoding UTF8
        Write-ColorText "  OK - Configuracion del juego actualizada" -Color Green
    } catch {
        Write-ColorText "  Advertencia: No se pudo actualizar options.txt: $_" -Color Yellow
    }
    
    return $true
}

function Configure-LauncherProfile {
    Write-ColorText "`nConfigurando perfil del launcher..." -Color Yellow
    
    $launcherProfilesFile = Join-Path $MinecraftPath "launcher_profiles.json"
    
    if (-not (Test-Path $launcherProfilesFile)) {
        Write-ColorText "  Advertencia: No se encontro launcher_profiles.json" -Color Yellow
        return $true
    }
    
    try {
        # Leer el archivo JSON
        $profilesJson = Get-Content $launcherProfilesFile -Raw | ConvertFrom-Json
        
        # Buscar el perfil de NeoForge (puede tener diferentes nombres)
        $neoforgeProfile = $null
        $neoforgeKey = $null
        
        foreach ($key in $profilesJson.profiles.PSObject.Properties.Name) {
            $profile = $profilesJson.profiles.$key
            if ($profile.name -match 'neoforge' -or $profile.lastVersionId -match 'neoforge') {
                $neoforgeProfile = $profile
                $neoforgeKey = $key
                break
            }
        }
        
        if ($neoforgeProfile) {
            # Renombrar el perfil
            $customName = "Modpack - by MaxitoDev - Minecraft 1.21.11"
            $neoforgeProfile.name = $customName
            
            # Opcional: cambiar el icono (puedes usar otros iconos de Minecraft)
            # Iconos disponibles: Grass, Crafting_Table, Furnace, etc.
            $neoforgeProfile.icon = "Grass"
            
            # Guardar cambios
            $profilesJson | ConvertTo-Json -Depth 10 | Set-Content $launcherProfilesFile -Encoding UTF8
            
            Write-ColorText "  OK - Perfil renombrado a: $customName" -Color Green
        } else {
            Write-ColorText "  Advertencia: No se encontro el perfil de NeoForge" -Color Yellow
        }
    } catch {
        Write-ColorText "  Advertencia: No se pudo modificar el perfil: $_" -Color Yellow
    }
    
    return $true
}

# ============================================
# PROGRAMA PRINCIPAL
# ============================================

Write-Header

Write-ColorText "Bienvenido al instalador del modpack" -Color White
Write-ColorText "Este instalador configurara NeoForge, mods, resource packs y shaders`n" -Color Gray

# Verificar Java
Write-ColorText "Verificando requisitos..." -Color Yellow
if (-not (Test-JavaInstalled)) {
    Write-ColorText "ERROR: Java no esta instalado o no esta en el PATH" -Color Red
    Write-ColorText "Por favor, instala Java 17 o superior antes de continuar" -Color Red
    Write-ColorText "Descarga Java desde: https://adoptium.net/" -Color Cyan
    Write-Host "`nPresiona cualquier tecla para salir..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
Write-ColorText "OK - Java detectado" -Color Green

# Mostrar ruta de instalacion
Write-ColorText "`nRuta de instalacion de Minecraft:" -Color White
Write-ColorText "  $MinecraftPath" -Color Cyan

Write-Host "`nDesea continuar con la instalacion? (S/N): " -NoNewline
$response = Read-Host

if ($response -notmatch '^[SsYy]') {
    Write-ColorText "`nInstalacion cancelada por el usuario" -Color Yellow
    exit 0
}

Write-Host ""
Write-ColorText "================================================================" -Color Cyan
Write-ColorText "INICIANDO INSTALACION" -Color Cyan
Write-ColorText "================================================================" -Color Cyan
Write-Host ""

# Proceso de instalacion
$success = $true

# Instalar NeoForge
if (-not (Install-NeoForge)) {
    $success = $false
}

# Copiar mods
if ($success) {
    if (-not (Copy-Mods)) {
        $success = $false
    }
}

# Copiar resource packs
if ($success) {
    if (-not (Copy-ResourcePacks)) {
        $success = $false
    }
}

# Copiar shader packs
if ($success) {
    if (-not (Copy-ShaderPacks)) {
        $success = $false
    }
}

# Copiar configuraciones
if ($success) {
    Copy-Configs
}

# Configurar opciones del juego (resource packs y shaders)
if ($success) {
    Configure-GameSettings
}

# Configurar perfil del launcher
if ($success) {
    Configure-LauncherProfile
}

# Resultado final
Write-Host ""
Write-ColorText "================================================================" -Color Cyan

if ($success) {
    Write-ColorText "OK - INSTALACION COMPLETADA CON EXITO!" -Color Green
    Write-Host ""
    Write-ColorText "El modpack ha sido instalado correctamente." -Color White
    Write-ColorText "Ahora puedes abrir el Minecraft Launcher y seleccionar el perfil 'Modpack 1.21.11'." -Color Gray
} else {
    Write-ColorText "ERROR - LA INSTALACION FINALIZO CON ERRORES" -Color Red
    Write-Host ""
    Write-ColorText "Revisa los mensajes anteriores para mas detalles." -Color Yellow
}

Write-ColorText "================================================================" -Color Cyan
Write-Host "`nPresiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
