@echo off
REM Script de Windows para crear el paquete del servidor
REM (Ejecutar en Windows para crear el .tar.gz)

title Build del Servidor
color 0B

echo.
echo ================================================================
echo    BUILD DEL SERVIDOR - CREAR PAQUETE
echo ================================================================
echo.

REM Verificar si WSL está disponible
where wsl >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Usando WSL para crear el paquete...
    echo.
    
    REM Convertir ruta de Windows a WSL
    cd /d "%~dp0"
    wsl bash ./1_build_server.sh
    
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo ================================================================
        echo    PAQUETE CREADO EXITOSAMENTE!
        echo ================================================================
        echo.
        echo Archivo: Modpack-Server-MaxitoDev-1.21.11.tar.gz
        echo.
    ) else (
        echo.
        echo ERROR: No se pudo crear el paquete
        echo.
    )
) else (
    echo WSL no esta disponible.
    echo.
    echo OPCION 1 - Instalar WSL (Recomendado):
    echo   1. Abre PowerShell como Administrador
    echo   2. Ejecuta: wsl --install
    echo   3. Reinicia el PC
    echo   4. Vuelve a ejecutar este script
    echo.
    echo OPCION 2 - Crear paquete manualmente con PowerShell:
    echo   Ejecuta: .\1_build_server_powershell.bat
    echo.
    echo OPCION 3 - Crear en el servidor Linux:
    echo   1. Sube la carpeta completa al servidor
    echo   2. En el servidor ejecuta: cd Server ^&^& ./1_build_server.sh
    echo.
)

pause
