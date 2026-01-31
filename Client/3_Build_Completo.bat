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
REM Llamar al script que crea el ZIP con la estructura requerida
call 2_Crear_ZIP.bat

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
echo Archivo listo para distribuir: Modpack-Minecraft_Client.zip
echo.
pause
