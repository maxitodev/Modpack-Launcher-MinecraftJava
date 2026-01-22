# 🐧 Servidor Linux - Modpack Minecraft 1.21.11

Esta carpeta contiene todos los archivos necesarios para crear e instalar el servidor de Linux.

## 📋 Contenido

- `install.sh` - Instalador para servidores Linux
- `1_build_server.sh` - Script de build (Linux)
- `1_build_server.bat` - Script de build (Windows con WSL)
- `LEEME_SERVIDOR.txt` - Manual completo para servidores
- `README_SERVER.md` - Este archivo

## 🚀 Uso Rápido

### Para Crear el Paquete del Servidor

**OPCIÓN 1 - Desde Linux:**
```bash
cd Server
chmod +x 1_build_server.sh
./1_build_server.sh
```

**OPCIÓN 2 - Desde Windows con WSL (Recomendado):**
```bash
cd Server
1_build_server.bat
```

**OPCIÓN 3 - Desde Windows con PowerShell (Sin WSL):**
```bash
cd Server
1_build_server_powershell.bat
```
*Nota: Crea un archivo .zip en lugar de .tar.gz, pero funciona igual en Linux*

### Para Instalar en un VPS Linux

1. Sube el archivo `Modpack-Server-MaxitoDev-1.21.11.tar.gz` al servidor

2. Descomprime:
```bash
tar -xzf Modpack-Server-MaxitoDev-1.21.11.tar.gz
cd Server
```

3. Ejecuta el instalador:
```bash
chmod +x install.sh
./install.sh
```

4. Inicia el servidor:
```bash
cd minecraft-server
./start.sh
```

## 📦 Salida

- `Modpack-Server-MaxitoDev-1.21.11.tar.gz` - Paquete de distribución
- `minecraft-server/` - Directorio del servidor instalado

## ⚙️ Requisitos del VPS

- Ubuntu/Debian/CentOS
- 4GB+ RAM (recomendado 6-8GB)
- Java 17+
- Puerto 25565 abierto

## 📖 Documentación Completa

Ver: `LEEME_SERVIDOR.txt` y `../README.md`

## 🔧 Configuración del Servidor

Después de la instalación, puedes editar:

- `minecraft-server/server.properties` - Configuración del servidor
- `minecraft-server/start.sh` - Ajustar RAM y flags JVM

## 🚀 Control del Servidor

**Iniciar:**
```bash
./start.sh
```

**Detener:**
```bash
./stop.sh
```
O presiona `Ctrl+C`

**Mantener activo (Screen):**
```bash
screen -S minecraft
./start.sh
# Ctrl+A, luego D para desconectar
```

**Reconectar:**
```bash
screen -r minecraft
```

## 🔥 Firewall

No olvides abrir el puerto 25565:

**Ubuntu/Debian:**
```bash
sudo ufw allow 25565/tcp
sudo ufw reload
```

**CentOS/Rocky:**
```bash
sudo firewall-cmd --permanent --add-port=25565/tcp
sudo firewall-cmd --reload
```
