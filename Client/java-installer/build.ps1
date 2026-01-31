# Script PowerShell para compilar el instalador
# Usa la herramienta jar del JDK

Write-Host "========================================"  -ForegroundColor Cyan
Write-Host "  MaxitoDev Modpack Installer - BUILD"  -ForegroundColor Cyan
Write-Host "========================================"  -ForegroundColor Cyan
Write-Host ""

# Crear carpetas
Write-Host "[1/4] Creando directorios..." -ForegroundColor Yellow
if (!(Test-Path "build")) { New-Item -ItemType Directory -Path "build" | Out-Null }
if (!(Test-Path "build\classes")) { New-Item -ItemType Directory -Path "build\classes" | Out-Null }

# Compilar
Write-Host "[2/4] Compilando codigo Java..." -ForegroundColor Yellow
javac -d build\classes -encoding UTF-8 src\com\maxitodev\installer\*.java

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: La compilacion fallo." -ForegroundColor Red
    Write-Host "Verifica que Java JDK este instalado correctamente." -ForegroundColor Red
    pause
    exit 1
}

# Copiar recursos
Write-Host "[2.5/4] Copiando recursos..." -ForegroundColor Yellow
if (Test-Path "src\resources") {
    $resDest = "build\classes\resources"
    if (-not (Test-Path $resDest)) { New-Item -ItemType Directory -Path $resDest | Out-Null }
    Copy-Item "src\resources\*" -Destination $resDest -Recurse -Force
}

# Crear manifest
Write-Host "[3/4] Creando manifest..." -ForegroundColor Yellow
if (!(Test-Path "build\classes\META-INF")) { New-Item -ItemType Directory -Path "build\classes\META-INF" | Out-Null }
@"
Manifest-Version: 1.0
Main-Class: com.maxitodev.installer.Main

"@ | Out-File -FilePath "build\classes\META-INF\MANIFEST.MF" -Encoding ASCII -NoNewline

# Crear JAR
Write-Host "[4/4] Creando archivo JAR..." -ForegroundColor Yellow

$jarPath = "build\MaxitoDev-Modpack-Installer.jar"
if (Test-Path $jarPath) { Remove-Item $jarPath }

# Buscar jar.exe
$jarExe = Get-ChildItem "C:\Program Files\Java" -Recurse -Filter "jar.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName

if (-not $jarExe) {
    Write-Host ""
    Write-Host "ERROR: No se encontro jar.exe" -ForegroundColor Red
    Write-Host "Asegurate de tener el JDK instalado." -ForegroundColor Red
    pause
    exit 1
}

Write-Host "Usando: $jarExe" -ForegroundColor Gray

# Cambiar al directorio de clases para crear el JAR
Push-Location build\classes

# Usar jar del JDK
& $jarExe cfm ..\MaxitoDev-Modpack-Installer.jar META-INF\MANIFEST.MF .

Pop-Location

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: No se pudo crear el JAR." -ForegroundColor Red
    Write-Host "Verifica que el JDK este instalado correctamente." -ForegroundColor Red
    pause
    exit 1
}

if (Test-Path $jarPath) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  BUILD COMPLETADO EXITOSAMENTE!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Archivo generado: $jarPath" -ForegroundColor Cyan
    $size = (Get-Item $jarPath).Length / 1KB
    Write-Host ("Tamaño: {0:N2} KB" -f $size) -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Para probar el instalador, ejecuta: .\run.bat" -ForegroundColor Yellow
    Write-Host ""
}
else {
    Write-Host ""
    Write-Host "ERROR: No se pudo crear el JAR." -ForegroundColor Red
    pause
    exit 1
}

# Limpiar
Remove-Item -Recurse -Force "build\classes"

pause
