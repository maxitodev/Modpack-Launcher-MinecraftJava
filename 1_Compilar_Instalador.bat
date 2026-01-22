@echo off
title Compilar Instalador del Modpack
color 0B

echo.
echo ================================================================
echo    COMPILANDO INSTALADOR DEL MODPACK
echo ================================================================
echo.

REM Compilar el script a .exe usando PS2EXE
powershell.exe -ExecutionPolicy Bypass -Command "Invoke-PS2EXE -inputFile '.\Installer.ps1' -outputFile '.\Modpack.exe' -title 'Modpack' -version '1.0.4.0' -company 'MaxitoDev'"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ================================================================
    echo    COMPILACION EXITOSA!
    echo ================================================================
    echo.
    echo El archivo Modpack.exe ha sido creado correctamente.
    echo.
) else (
    echo.
    echo ================================================================
    echo    ERROR EN LA COMPILACION
    echo ================================================================
    echo.
    echo Asegurate de tener ps2exe instalado:
    echo Install-Module -Name ps2exe -Scope CurrentUser
    echo.
)

pause
