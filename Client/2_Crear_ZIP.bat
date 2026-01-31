@echo off
title Crear ZIP del Modpack
color 0B

echo.
echo ================================================================
echo    CREANDO ARCHIVO ZIP PARA DISTRIBUCION
echo ================================================================
echo.
REM Crear el archivo ZIP incluyendo directamente la carpeta GameFiles
REM y dejando Modpack.exe y LEEME.txt en la raíz del ZIP
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-Location ..; Compress-Archive -Path 'GameFiles','Client\\Modpack.exe','Client\\LEEME.txt' -DestinationPath 'Client\\Modpack-Minecraft_Client.zip' -Force"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ================================================================
    echo    ZIP CREADO EXITOSAMENTE!
    echo ================================================================
    echo.
    echo Archivo creado: Modpack-Minecraft_Client.zip
    echo.
) else (
    echo.
    echo ================================================================
    echo    ERROR AL CREAR EL ZIP
    echo ================================================================
    echo.
)

pause
