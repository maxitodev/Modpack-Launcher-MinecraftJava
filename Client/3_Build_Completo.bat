@echo off
title Build Completo del Modpack
color 0B

echo.
echo ================================================================
echo    BUILD COMPLETO DEL MODPACK
echo ================================================================
echo.
echo Este script compilara el instalador y creara el ZIP automaticamente.
echo.
pause

echo.
echo [1/2] Compilando instalador...
echo.

REM Compilar el instalador
powershell.exe -ExecutionPolicy Bypass -Command "Invoke-PS2EXE -inputFile '.\Installer.ps1' -outputFile '.\Modpack.exe' -title 'Modpack' -version '1.0.4.0' -company 'MaxitoDev'"

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: No se pudo compilar el instalador
    pause
    exit /b 1
)

echo OK - Instalador compilado correctamente
echo.
echo [2/2] Creando archivo ZIP...
echo.

REM Crear el ZIP
powershell.exe -ExecutionPolicy Bypass -Command "Compress-Archive -Path 'Modpack.exe', '..\GameFiles\installer', '..\GameFiles\mods', '..\GameFiles\resourcepacks', '..\GameFiles\shaderpacks', '..\GameFiles\config', 'LEEME.txt' -DestinationPath '.\Modpack-MinecraftServer.zip' -Force"

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: No se pudo crear el ZIP
    pause
    exit /b 1
)

echo OK - ZIP creado correctamente
echo.
echo ================================================================
echo    BUILD COMPLETADO EXITOSAMENTE!
echo ================================================================
echo.
echo Archivo listo para distribuir: Modpack-MinecraftServer.zip
echo.
pause
