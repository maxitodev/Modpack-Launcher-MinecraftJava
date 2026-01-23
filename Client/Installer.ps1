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
    # Primero intentar con el directorio actual de trabajo (donde se ejecutó el exe)
    $ScriptPath = (Get-Location).Path
    
    # Verificar si las carpetas necesarias existen en esta ubicación
    $testPaths = @("installer", "mods", "resourcepacks", "shaderpacks", "config")
    $foundAll = $true
    foreach ($testPath in $testPaths) {
        if (-not (Test-Path (Join-Path $ScriptPath $testPath))) {
            $foundAll = $false
            break
        }
    }
    
    # Si no se encuentran en el directorio actual, intentar con la ubicación del exe
    if (-not $foundAll) {
        try {
            $exePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
            $ScriptPath = Split-Path -Parent $exePath
        } catch {
            # Si todo falla, usar el directorio actual
            $ScriptPath = (Get-Location).Path
        }
    }
}

# Detectar la ruta base (donde están mods, installer, etc.)
# Cuando se distribuye en ZIP, las carpetas están al mismo nivel que el ejecutable
# En desarrollo, las carpetas están en el directorio padre
$ParentPath = $ScriptPath

# Verificar si las carpetas existen en el directorio actual
$testPaths = @("installer", "mods", "resourcepacks", "shaderpacks", "config")
$foundInCurrent = $true
foreach ($testPath in $testPaths) {
    if (-not (Test-Path (Join-Path $ParentPath $testPath))) {
        $foundInCurrent = $false
        break
    }
}

# Si no están en el directorio actual, buscar en el directorio padre (para desarrollo)
if (-not $foundInCurrent) {
    $ParentPathTest = Split-Path -Parent $ScriptPath
    $foundInParent = $true
    foreach ($testPath in $testPaths) {
        if (-not (Test-Path (Join-Path $ParentPathTest $testPath))) {
            $foundInParent = $false
            break
        }
    }
    
    # Si se encuentran en el directorio padre, usar esa ruta
    if ($foundInParent) {
        $ParentPath = $ParentPathTest
    }
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
    
    $installerPath = Join-Path $ParentPath "installer"
    
    # Verificar que la carpeta installer existe
    if (-not (Test-Path $installerPath)) {
        Write-ColorText "ERROR: No se encuentra la carpeta 'installer'" -Color Red
        Write-ColorText "Ruta esperada: $installerPath" -Color Gray
        Write-ColorText "" -Color White
        Write-ColorText "La estructura esperada es:" -Color Yellow
        Write-ColorText "  Instalador.exe" -Color Gray
        Write-ColorText "  installer\" -Color Gray
        Write-ColorText "  mods\" -Color Gray
        Write-ColorText "  resourcepacks\" -Color Gray
        Write-ColorText "  shaderpacks\" -Color Gray
        Write-ColorText "  config\" -Color Gray
        Write-ColorText "" -Color White
        Write-ColorText "Por favor, asegurate de que todas las carpetas esten al mismo nivel que el instalador" -Color Red
        return $false
    }
    
    $neoforgeJar = Get-ChildItem -Path $installerPath -Filter "neoforge-*.jar" -ErrorAction SilentlyContinue | Select-Object -First 1
    
    if (-not $neoforgeJar) {
        Write-ColorText "ERROR: No se encontro el instalador de NeoForge en la carpeta 'installer'" -Color Red
        Write-ColorText "Ruta buscada: $installerPath" -Color Gray
        Write-ColorText "Por favor, coloca el archivo .jar de NeoForge en la carpeta 'installer'" -Color Red
        return $false
    }
    
    Write-ColorText "  Encontrado: $($neoforgeJar.Name)" -Color Green
    Write-ColorText "  Abriendo instalador de NeoForge..." -Color Gray
    Write-ColorText "" -Color White
    Write-ColorText "  Se abrira la interfaz grafica del instalador de NeoForge." -Color Yellow
    Write-ColorText "  Por favor, completa la instalacion en la ventana que se abrira." -Color Yellow
    Write-ColorText "  Asegurate de seleccionar 'Install client' y finalizar la instalacion." -Color Yellow
    Write-ColorText "  Este instalador esperara a que termines..." -Color Yellow
    Write-ColorText "" -Color White
    
    try {
        # Ejecutar el instalador de NeoForge con interfaz grafica
        $process = Start-Process -FilePath "java" -ArgumentList "-jar", "`"$($neoforgeJar.FullName)`"" -Wait -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-ColorText "  OK - NeoForge instalado correctamente" -Color Green
            Write-ColorText "  Esperando a que se cree el perfil..." -Color Gray
            Start-Sleep -Seconds 5
            return $true
        } else {
            Write-ColorText "  ERROR: El instalador de NeoForge finalizo con errores (Codigo: $($process.ExitCode))" -Color Red
            Write-ColorText "  Si cerraste el instalador sin completar la instalacion, vuelve a ejecutar este instalador" -Color Yellow
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
    
    $modsSource = Join-Path $ParentPath "mods"
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
    
    $resourcepacksSource = Join-Path $ParentPath "resourcepacks"
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
    
    $shaderpacksSource = Join-Path $ParentPath "shaderpacks"
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
    
    $configSource = Join-Path $ParentPath "config"
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
    
    # Resource packs especificos a activar
    $requiredPacks = @("Alacrity.zip")
    
    # Shader especifico a habilitar
    $requiredShader = "Bliss_v2.1.2_(Chocapic13_Shaders_edit).zip"
    $shaderpacksPath = Join-Path $MinecraftPath "shaderpacks"
    $installedShader = $null
    
    # Verificar que el shader requerido este instalado
    $shaderPath = Join-Path $shaderpacksPath $requiredShader
    if (Test-Path $shaderPath) {
        $installedShader = $requiredShader
    } else {
        Write-ColorText "  Advertencia: No se encontro el shader requerido: $requiredShader" -Color Yellow
    }
    
    # Leer options.txt existente o crear nuevo
    $optionsContent = @()
    
    if (Test-Path $optionsFile) {
        $optionsContent = Get-Content $optionsFile
    }
    
    # Activar resource packs especificos
    $customPacks = ($requiredPacks | ForEach-Object { "`"file/$_`"" }) -join ","
    $resourcePacksLine = "resourcePacks:[`"vanilla`",$customPacks,`"mod_resources`"]"
    
    # Buscar y reemplazar la linea de resourcePacks
    $resourcePacksConfigured = $false
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
    
    Write-ColorText "  OK - Resource packs activados:" -Color Green
    foreach ($pack in $requiredPacks) {
        Write-ColorText "     - $pack" -Color Gray
    }
    
    # Guardar options.txt
    try {
        $optionsContent | Set-Content -Path $optionsFile -Encoding UTF8
        Write-ColorText "  OK - Resource packs activados en options.txt" -Color Green
    } catch {
        Write-ColorText "  Advertencia: No se pudo actualizar options.txt: $_" -Color Yellow
    }
    
    # Configurar shader para Iris
    if ($installedShader) {
        $irisConfigDir = Join-Path $MinecraftPath "config\iris"
        $irisConfigFile = Join-Path $irisConfigDir "iris.properties"
        
        # Crear directorio de Iris si no existe
        if (-not (Test-Path $irisConfigDir)) {
            New-Item -ItemType Directory -Path $irisConfigDir -Force | Out-Null
        }
        
        try {
            # Crear o actualizar iris.properties
            $irisConfig = @"
enableShaders=true
shaderPack=$installedShader
enableDebugOptions=false
maxShadowRenderDistance=12
"@
            
            $irisConfig | Set-Content -Path $irisConfigFile -Encoding UTF8
            Write-ColorText "  OK - Shader configurado para Iris: $installedShader" -Color Green
        } catch {
            Write-ColorText "  Advertencia: No se pudo configurar Iris: $_" -Color Yellow
        }
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
            if ($profile.name -match 'neoforge' -or $profile.lastVersionId -match 'neoforge' -or $profile.lastVersionId -match '1\.21\.1') {
                $neoforgeProfile = $profile
                $neoforgeKey = $key
                break
            }
        }
        
        $customName = "Modpack - by MaxitoDev - Minecraft 1.21.11"
        
        if ($neoforgeProfile) {
            # Renombrar el perfil existente
            $neoforgeProfile.name = $customName
            $neoforgeProfile.icon = "Grass"
            
            # Guardar cambios
            $profilesJson | ConvertTo-Json -Depth 10 | Set-Content $launcherProfilesFile -Encoding UTF8
            
            Write-ColorText "  OK - Perfil renombrado a: $customName" -Color Green
        } else {
            # Crear perfil nuevo si no existe
            Write-ColorText "  Creando nuevo perfil del modpack..." -Color Gray
            
            $newProfileId = "modpack_maxitodev_" + (Get-Random)
            $newProfile = @{
                name = $customName
                type = "custom"
                created = (Get-Date -Format "o")
                lastUsed = (Get-Date -Format "o")
                icon = "Grass"
                lastVersionId = "neoforge-21.1.37"
                javaArgs = "-Xmx8G -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M"
            }
            
            # Agregar el nuevo perfil
            $profilesJson.profiles | Add-Member -MemberType NoteProperty -Name $newProfileId -Value ([PSCustomObject]$newProfile)
            
            # Guardar cambios
            $profilesJson | ConvertTo-Json -Depth 10 | Set-Content $launcherProfilesFile -Encoding UTF8
            
            Write-ColorText "  OK - Perfil creado: $customName" -Color Green
        }
    } catch {
        Write-ColorText "  Advertencia: No se pudo modificar el perfil: $_" -Color Yellow
        Write-ColorText "  Error: $_" -Color Red
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

# Mostrar ruta de los archivos del modpack (para debug)
Write-ColorText "`nRuta de los archivos del modpack:" -Color White
Write-ColorText "  $ParentPath" -Color Cyan

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

# No renombramos el perfil, usamos el que crea NeoForge por defecto
# Configure-LauncherProfile

# Resultado final
Write-Host ""
Write-ColorText "================================================================" -Color Cyan

if ($success) {
    Write-ColorText "OK - INSTALACION COMPLETADA CON EXITO!" -Color Green
    Write-Host ""
    Write-ColorText "El modpack ha sido instalado correctamente." -Color White
    Write-ColorText "Ahora abre el Minecraft Launcher y selecciona el perfil de NeoForge" -Color Gray
    Write-ColorText "(busca un perfil que contenga 'neoforge' en el nombre)" -Color Gray
    Write-Host ""
    Write-ColorText "IMPORTANTE - Configuracion de RAM:" -Color Yellow
    Write-ColorText "  El perfil esta configurado con 8GB de RAM" -Color White
    Write-ColorText "  Si tienes 16GB+ de RAM, puedes aumentarla para mejor rendimiento:" -Color Gray
    Write-ColorText "  1. Edita el perfil en el launcher (tres puntos ... → Editar)" -Color Gray
    Write-ColorText "  2. Ve a 'Mas opciones' o 'More Options'" -Color Gray
    Write-ColorText "  3. En 'Argumentos JVM' cambia -Xmx8G por -Xmx10G o -Xmx12G" -Color Gray
    Write-Host ""
    Write-ColorText "NO OLVIDES - Activar Resource Packs:" -Color Yellow
    Write-ColorText "  1. Inicia el juego" -Color Gray
    Write-ColorText "  2. Ve a Opciones → Resource Packs" -Color Gray
    Write-ColorText "  3. Activa: Alacrity" -Color Gray
} else {
    Write-ColorText "ERROR - LA INSTALACION FINALIZO CON ERRORES" -Color Red
    Write-Host ""
    Write-ColorText "Revisa los mensajes anteriores para mas detalles." -Color Yellow
}

Write-ColorText "================================================================" -Color Cyan
Write-Host "`nPresiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
