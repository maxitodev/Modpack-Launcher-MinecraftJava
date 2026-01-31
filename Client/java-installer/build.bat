@echo off
echo ========================================
echo   MaxitoDev Modpack Installer - BUILD
echo ========================================
echo.

REM Crear carpeta de salida
if not exist "build" mkdir build
if not exist "build\classes" mkdir build\classes

echo [1/4] Compilando codigo Java...
javac -d build\classes -encoding UTF-8 src\com\maxitodev\installer\*.java

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: La compilacion fallo.
    echo Verifica que Java JDK este instalado correctamente.
    pause
    exit /b 1
)

echo [2/4] Creando manifest...
echo Main-Class: com.maxitodev.installer.Main > build\classes\MANIFEST.MF
echo. >> build\classes\MANIFEST.MF

echo [3/4] Creando archivo JAR...
cd build\classes

REM Intentar encontrar jar.exe
set JAR_CMD=jar
where jar >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    REM Buscar en JAVA_HOME
    if defined JAVA_HOME (
        set JAR_CMD="%JAVA_HOME%\bin\jar.exe"
    ) else (
        REM Buscar jar.exe en la ruta de javac
        for /f "tokens=*" %%i in ('where javac') do set JAVAC_PATH=%%i
        for %%i in ("!JAVAC_PATH!") do set JAVA_BIN=%%~dpi
        set JAR_CMD="!JAVA_BIN!jar.exe"
    )
)

%JAR_CMD% cfm ..\MaxitoDev-Modpack-Installer.jar MANIFEST.MF com\maxitodev\installer\*.class

cd ..\..

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: No se pudo crear el JAR.
    echo Asegurate de tener el JDK completo instalado (no solo JRE).
    pause
    exit /b 1
)

echo [4/4] Limpiando archivos temporales...
rmdir /s /q build\classes

echo.
echo ========================================
echo   BUILD COMPLETADO EXITOSAMENTE!
echo ========================================
echo.
echo Archivo generado: build\MaxitoDev-Modpack-Installer.jar
echo Tamaño: 
dir build\MaxitoDev-Modpack-Installer.jar | find ".jar"
echo.
echo Para probar el instalador, ejecuta: run.bat
echo.
pause
