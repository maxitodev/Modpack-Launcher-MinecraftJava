@echo off
title Instalador de Modpack - Minecraft
color 0B

echo.
echo ════════════════════════════════════════════════════════
echo    INSTALADOR DE MODPACK MINECRAFT - NEOFORGE
echo ════════════════════════════════════════════════════════
echo.
echo Iniciando instalador...
echo.

REM Ejecutar el script de PowerShell
powershell.exe -ExecutionPolicy Bypass -File "%~dp0Installer.ps1"

pause
