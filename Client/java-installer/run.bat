@echo off
echo ========================================
echo   Ejecutando Instalador (Modo Prueba)
echo ========================================
echo.

if not exist "build\MaxitoDev-Modpack-Installer.jar" (
    echo ERROR: El instalador no esta compilado.
    echo Ejecuta build.bat primero.
    echo.
    pause
    exit /b 1
)

echo Iniciando instalador...
echo.
java -jar build\MaxitoDev-Modpack-Installer.jar

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: El instalador termino con errores.
    echo.
    pause
    exit /b 1
)

echo.
echo Instalador cerrado.
pause
