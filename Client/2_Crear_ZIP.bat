@echo off
title Crear ZIP del Modpack
color 0B

echo.
echo ================================================================
echo    CREANDO ARCHIVO ZIP PARA DISTRIBUCION
echo ================================================================
echo.

REM Crear el archivo ZIP con todos los componentes necesarios
REM Las carpetas deben estar al mismo nivel que Modpack.exe dentro del ZIP
powershell.exe -ExecutionPolicy Bypass -Command "Compress-Archive -Path 'Modpack.exe', '..\installer', '..\mods', '..\resourcepacks', '..\shaderpacks', '..\config', 'LEEME.txt' -DestinationPath '.\Modpack-MaxitoDev-1.21.11.zip' -Force"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ================================================================
    echo    ZIP CREADO EXITOSAMENTE!
    echo ================================================================
    echo.
    echo Archivo creado: Modpack-MaxitoDev-1.21.11.zip
    echo Ya puedes compartir este archivo con tus usuarios.
    echo.
) else (
    echo.
    echo ================================================================
    echo    ERROR AL CREAR EL ZIP
    echo ================================================================
    echo.
)

pause
