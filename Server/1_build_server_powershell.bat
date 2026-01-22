@echo off
title Build del Servidor (PowerShell)
color 0B

echo.
echo ================================================================
echo    BUILD DEL SERVIDOR - CREAR PAQUETE (PowerShell)
echo ================================================================
echo.
echo Este script usa PowerShell puro (no requiere WSL)
echo.
pause

powershell.exe -ExecutionPolicy Bypass -File "%~dp0\1_build_server.ps1"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ================================================================
    echo    PAQUETE CREADO EXITOSAMENTE!
    echo ================================================================
    echo.
) else (
    echo.
    echo ERROR: No se pudo crear el paquete
    echo.
)

pause
