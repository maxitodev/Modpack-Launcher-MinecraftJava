@echo off
echo ========================================
echo   PACKAGE - Crear Distribucion Final
echo ========================================
echo.

REM Verificar que el JAR existe
if not exist "build\MaxitoDev-Modpack-Installer.jar" (
    echo ERROR: El instalador no esta compilado.
    echo Ejecuta build.bat primero.
    echo.
    pause
    exit /b 1
)

REM Crear carpeta de distribucion
if not exist "dist" mkdir dist
if exist "dist\MaxitoDev-Modpack" rmdir /s /q "dist\MaxitoDev-Modpack"
mkdir "dist\MaxitoDev-Modpack"

echo [1/4] Copiando instalador...
copy "build\MaxitoDev-Modpack-Installer.jar" "dist\MaxitoDev-Modpack\" > nul

echo [2/4] Copiando GameFiles...
xcopy /E /I /Y "..\..\GameFiles" "dist\MaxitoDev-Modpack\GameFiles" > nul

echo [3/4] Creando archivos de ayuda...
(
echo ========================================
echo   MaxitoDev Modpack Installer
echo ========================================
echo.
echo INSTRUCCIONES:
echo.
echo 1. Asegurate de tener Java 17 o superior instalado
echo 2. Haz doble clic en: MaxitoDev-Modpack-Installer.jar
echo 3. Selecciona la carpeta .minecraft
echo 4. Click en "Instalar"
echo 5. Abre Minecraft Launcher
echo 6. Selecciona el perfil "MaxitoDev Modpack"
echo 7. ^!Juega!
echo.
echo REQUISITOS:
echo - Java 17+
echo - Minecraft Java Edition
echo - 8GB RAM minimo
echo.
echo SOPORTE:
echo Si tienes problemas, contacta a MaxitoDev
echo.
) > "dist\MaxitoDev-Modpack\LEEME.txt"

echo [4/4] Creando archivo ZIP...
cd dist
powershell -Command "Compress-Archive -Path 'MaxitoDev-Modpack\*' -DestinationPath 'MaxitoDev-Modpack-v%date:~-4,4%%date:~-7,2%%date:~-10,2%.zip' -Force"
cd ..

echo.
echo ========================================
echo   PACKAGE COMPLETADO!
echo ========================================
echo.
echo Archivo de distribucion creado en:
echo dist\MaxitoDev-Modpack-v%date:~-4,4%%date:~-7,2%%date:~-10,2%.zip
echo.
echo Este archivo contiene:
echo - MaxitoDev-Modpack-Installer.jar
echo - GameFiles/ (mods, configs, etc.)
echo - LEEME.txt
echo.
echo ^!Listo para distribuir!
echo.
pause
