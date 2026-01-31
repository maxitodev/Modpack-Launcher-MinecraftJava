@echo off
title Crear ZIP del Modpack
color 0B

echo.
echo ================================================================
echo    CREANDO ARCHIVO ZIP PARA DISTRIBUCION
echo ================================================================
echo.

REM Crear el archivo ZIP con la estructura solicitada: GameFiles/ (con carpetas y options.txt), Modpack.exe y LEEME.txt en la raíz
powershell.exe -ExecutionPolicy Bypass -Command "Compress-Archive -Path 'Modpack.exe', 'LEEME.txt', '..\GameFiles\options.txt', '..\GameFiles\config', '..\GameFiles\installer', '..\GameFiles\mods', '..\GameFiles\resourcepacks', '..\GameFiles\shaderpacks' -DestinationPath '.\Modpack-Minecraft.zip' -Update" 

REM Mover las carpetas y options.txt dentro de GameFiles en el ZIP
powershell.exe -ExecutionPolicy Bypass -Command "Add-Type -A 'System.IO.Compression.FileSystem'; $zip = [IO.Compression.ZipFile]::Open('.\Modpack-MinecraftServer.zip', 'Update'); foreach ($item in @('options.txt','config','installer','mods','resourcepacks','shaderpacks')) { $entry = $zip.Entries | Where-Object { $_.FullName -eq $item -or $_.FullName -like ($item + '/*') }; foreach ($e in $entry) { $e.FullName = 'GameFiles/' + $e.FullName } }; $zip.Dispose()"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ================================================================
    echo    ZIP CREADO EXITOSAMENTE!
    echo ================================================================
    echo.
    echo Archivo creado: Modpack-MinecraftServer.zip
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
