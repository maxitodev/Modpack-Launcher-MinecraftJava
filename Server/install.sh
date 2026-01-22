#!/bin/bash

# ============================================
# INSTALADOR DE MODPACK SERVIDOR - NEOFORGE
# Autor: MaxitoDev
# Para servidores Linux (VPS/Dedicado)
# ============================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

# Variables de configuración
MINECRAFT_VERSION="1.21.11"
NEOFORGE_VERSION="21.11.37-beta"
SERVER_DIR="$(pwd)/minecraft-server"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Función para imprimir con color
print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Función para imprimir encabezado
print_header() {
    clear
    print_color "$CYAN" "================================================================"
    print_color "$CYAN" "   INSTALADOR DE MODPACK SERVIDOR MINECRAFT - NEOFORGE"
    print_color "$CYAN" "   Versión: $MINECRAFT_VERSION | NeoForge: $NEOFORGE_VERSION"
    print_color "$CYAN" "================================================================"
    echo ""
}

# Verificar si Java está instalado
check_java() {
    print_color "$YELLOW" "Verificando Java..."
    
    if command -v java &> /dev/null; then
        JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
        
        if [ "$JAVA_VERSION" -ge 17 ]; then
            print_color "$GREEN" "✓ Java $JAVA_VERSION detectado"
            return 0
        else
            print_color "$RED" "✗ Java $JAVA_VERSION es muy antiguo. Se requiere Java 17 o superior."
            return 1
        fi
    else
        print_color "$RED" "✗ Java no está instalado."
        echo ""
        print_color "$YELLOW" "Para instalar Java en Ubuntu/Debian:"
        echo "  sudo apt update"
        echo "  sudo apt install openjdk-17-jre-headless"
        echo ""
        print_color "$YELLOW" "Para instalar Java en CentOS/RHEL:"
        echo "  sudo yum install java-17-openjdk-headless"
        return 1
    fi
}

# Crear directorio del servidor
create_server_dir() {
    print_color "$YELLOW" "Creando directorio del servidor..."
    
    mkdir -p "$SERVER_DIR"
    mkdir -p "$SERVER_DIR/mods"
    mkdir -p "$SERVER_DIR/config"
    
    print_color "$GREEN" "✓ Directorios creados en: $SERVER_DIR"
}

# Instalar NeoForge
install_neoforge() {
    print_color "$YELLOW" "Instalando NeoForge..."
    
    local installer_jar=$(find "$PARENT_DIR/installer" -name "neoforge-*-installer.jar" 2>/dev/null | head -n1)
    
    if [ -z "$installer_jar" ]; then
        print_color "$RED" "✗ No se encontró el instalador de NeoForge"
        print_color "$YELLOW" "  Coloca el archivo neoforge-XXX-installer.jar en la carpeta 'installer/'"
        return 1
    fi
    
    print_color "$CYAN" "  Usando: $(basename "$installer_jar")"
    
    # Ejecutar instalador en modo servidor
    cd "$SERVER_DIR"
    java -jar "$installer_jar" --installServer
    
    if [ $? -eq 0 ]; then
        print_color "$GREEN" "✓ NeoForge instalado correctamente"
        cd "$SCRIPT_DIR"
        return 0
    else
        print_color "$RED" "✗ Error al instalar NeoForge"
        cd "$SCRIPT_DIR"
        return 1
    fi
}

# Copiar mods
copy_mods() {
    print_color "$YELLOW" "Copiando mods al servidor..."
    
    local mod_count=$(find "$PARENT_DIR/mods" -name "*.jar" 2>/dev/null | wc -l)
    
    if [ "$mod_count" -eq 0 ]; then
        print_color "$YELLOW" "! No se encontraron mods para copiar"
        return 0
    fi
    
    # Copiar todos los mods
    cp "$PARENT_DIR/mods"/*.jar "$SERVER_DIR/mods/" 2>/dev/null || true
    
    # Contar mods copiados
    local copied=$(find "$SERVER_DIR/mods" -name "*.jar" | wc -l)
    
    print_color "$GREEN" "✓ $copied mods copiados correctamente"
    return 0
}

# Copiar configuraciones
copy_configs() {
    print_color "$YELLOW" "Copiando configuraciones..."
    
    if [ -d "$PARENT_DIR/config" ] && [ "$(ls -A "$PARENT_DIR/config" 2>/dev/null)" ]; then
        cp -r "$PARENT_DIR/config"/* "$SERVER_DIR/config/" 2>/dev/null || true
        print_color "$GREEN" "✓ Configuraciones copiadas"
    else
        print_color "$YELLOW" "! No hay configuraciones personalizadas para copiar"
    fi
    
    return 0
}

# Crear archivo server.properties básico
create_server_properties() {
    print_color "$YELLOW" "Creando server.properties..."
    
    cat > "$SERVER_DIR/server.properties" << 'EOF'
#Minecraft server properties
server-port=25565
gamemode=survival
difficulty=normal
max-players=20
online-mode=true
white-list=false
enable-command-block=false
spawn-protection=16
max-world-size=29999984
view-distance=10
simulation-distance=10
motd=Modpack Server - by MaxitoDev
level-name=world
level-type=minecraft\:normal
enable-status=true
enable-query=false
enable-rcon=false
EOF
    
    print_color "$GREEN" "✓ server.properties creado"
}

# Aceptar EULA automáticamente
accept_eula() {
    print_color "$YELLOW" "Aceptando EULA de Minecraft..."
    
    echo "eula=true" > "$SERVER_DIR/eula.txt"
    
    print_color "$GREEN" "✓ EULA aceptado"
}

# Crear script de inicio
create_start_script() {
    print_color "$YELLOW" "Creando script de inicio..."
    
    # Detectar el archivo .jar del servidor
    local server_jar=$(find "$SERVER_DIR" -maxdepth 1 -name "neoforge-*.jar" -o -name "forge-*.jar" | head -n1)
    
    if [ -z "$server_jar" ]; then
        # Si no se encuentra, buscar run.sh o run.bat creados por el instalador
        if [ -f "$SERVER_DIR/run.sh" ]; then
            print_color "$GREEN" "✓ Script run.sh ya existe (creado por NeoForge)"
            chmod +x "$SERVER_DIR/run.sh"
            return 0
        fi
        server_jar="server.jar"
    else
        server_jar=$(basename "$server_jar")
    fi
    
    cat > "$SERVER_DIR/start.sh" << EOF
#!/bin/bash

# Script de inicio del servidor Minecraft con NeoForge
# Configuración de RAM: 2GB min, 4GB max (ajustar según tu VPS)

java -Xms2G -Xmx4G \\
     -XX:+UseG1GC \\
     -XX:+ParallelRefProcEnabled \\
     -XX:MaxGCPauseMillis=200 \\
     -XX:+UnlockExperimentalVMOptions \\
     -XX:+DisableExplicitGC \\
     -XX:+AlwaysPreTouch \\
     -XX:G1NewSizePercent=30 \\
     -XX:G1MaxNewSizePercent=40 \\
     -XX:G1HeapRegionSize=8M \\
     -XX:G1ReservePercent=20 \\
     -XX:G1HeapWastePercent=5 \\
     -XX:G1MixedGCCountTarget=4 \\
     -XX:InitiatingHeapOccupancyPercent=15 \\
     -XX:G1MixedGCLiveThresholdPercent=90 \\
     -XX:G1RSetUpdatingPauseTimePercent=5 \\
     -XX:SurvivorRatio=32 \\
     -XX:+PerfDisableSharedMem \\
     -XX:MaxTenuringThreshold=1 \\
     -Dusing.aikars.flags=https://mcflags.emc.gs \\
     -Daikars.new.flags=true \\
     -jar $server_jar nogui
EOF
    
    chmod +x "$SERVER_DIR/start.sh"
    
    print_color "$GREEN" "✓ Script start.sh creado"
    print_color "$CYAN" "  Ubicación: $SERVER_DIR/start.sh"
}

# Crear script de stop
create_stop_script() {
    cat > "$SERVER_DIR/stop.sh" << 'EOF'
#!/bin/bash

# Script para detener el servidor de forma segura

if [ -f server.pid ]; then
    PID=$(cat server.pid)
    echo "Deteniendo servidor (PID: $PID)..."
    kill -SIGTERM $PID
    rm -f server.pid
    echo "Servidor detenido"
else
    echo "No se encontró el archivo PID. Buscando proceso..."
    pkill -f "neoforge.*\.jar"
    echo "Proceso detenido"
fi
EOF
    
    chmod +x "$SERVER_DIR/stop.sh"
}

# Crear archivo README para el servidor
create_server_readme() {
    cat > "$SERVER_DIR/README_SERVER.txt" << 'EOF'
═══════════════════════════════════════════════════════════════════
  SERVIDOR MINECRAFT - MODPACK NEOFORGE
  Por MaxitoDev
═══════════════════════════════════════════════════════════════════

INICIAR EL SERVIDOR:
═══════════════════════════════════════════════════════════════════

1. Asegúrate de tener Java 17 o superior instalado:
   java -version

2. Ajusta la RAM en start.sh si es necesario:
   nano start.sh
   
   Busca las líneas:
   -Xms2G -Xmx4G
   
   Donde:
   - Xms = RAM mínima (ej: 2G = 2 GB)
   - Xmx = RAM máxima (ej: 4G = 4 GB)

3. Inicia el servidor:
   ./start.sh

4. Para detener el servidor:
   ./stop.sh
   O presiona Ctrl+C en la terminal

═══════════════════════════════════════════════════════════════════
CONFIGURACIÓN DEL SERVIDOR:
═══════════════════════════════════════════════════════════════════

Archivo: server.properties

Configuraciones importantes:
- server-port=25565          # Puerto del servidor
- max-players=20             # Jugadores máximos
- view-distance=10           # Distancia de visión (chunks)
- difficulty=normal          # Dificultad
- gamemode=survival          # Modo de juego
- online-mode=true           # Verificación de cuentas premium

═══════════════════════════════════════════════════════════════════
FIREWALL / PUERTOS:
═══════════════════════════════════════════════════════════════════

Debes abrir el puerto 25565 en tu firewall:

Ubuntu/Debian (UFW):
  sudo ufw allow 25565/tcp
  sudo ufw reload

CentOS/RHEL (firewalld):
  sudo firewall-cmd --permanent --add-port=25565/tcp
  sudo firewall-cmd --reload

iptables:
  sudo iptables -A INPUT -p tcp --dport 25565 -j ACCEPT
  sudo iptables-save

═══════════════════════════════════════════════════════════════════
CREAR SERVICIO SYSTEMD (Opcional):
═══════════════════════════════════════════════════════════════════

Para que el servidor inicie automáticamente al reiniciar el VPS:

1. Crea el archivo de servicio:
   sudo nano /etc/systemd/system/minecraft.service

2. Pega este contenido (ajusta las rutas):

[Unit]
Description=Minecraft Server - Modpack NeoForge
After=network.target

[Service]
Type=simple
User=TU_USUARIO
WorkingDirectory=/ruta/a/minecraft-server
ExecStart=/ruta/a/minecraft-server/start.sh
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target

3. Habilita y arranca el servicio:
   sudo systemctl daemon-reload
   sudo systemctl enable minecraft
   sudo systemctl start minecraft

4. Comandos útiles:
   sudo systemctl status minecraft    # Ver estado
   sudo systemctl stop minecraft      # Detener
   sudo systemctl restart minecraft   # Reiniciar
   sudo journalctl -u minecraft -f    # Ver logs en tiempo real

═══════════════════════════════════════════════════════════════════
BACKUP:
═══════════════════════════════════════════════════════════════════

Para hacer backup del mundo y configuraciones:

  tar -czf backup-$(date +%Y%m%d-%H%M%S).tar.gz world world_nether world_the_end server.properties

Para restaurar:
  tar -xzf backup-FECHA.tar.gz

═══════════════════════════════════════════════════════════════════
PROBLEMAS COMUNES:
═══════════════════════════════════════════════════════════════════

Problema: "Cannot allocate memory"
Solución: Reduce la RAM en start.sh (-Xmx2G en vez de -Xmx4G)

Problema: Puerto ya en uso
Solución: Cambia server-port en server.properties

Problema: Lag en el servidor
Solución: 
  - Reduce view-distance en server.properties
  - Aumenta RAM en start.sh (si tienes disponible)
  - Reduce simulation-distance

═══════════════════════════════════════════════════════════════════

¡Que disfrutes tu servidor!

═══════════════════════════════════════════════════════════════════
EOF
}

# ============================================
# PROGRAMA PRINCIPAL
# ============================================

print_header

print_color "$CYAN" "Bienvenido al instalador del servidor de modpack"
print_color "$CYAN" "Este instalador configurará NeoForge, mods y configuraciones\n"

# Verificar Java
if ! check_java; then
    echo ""
    print_color "$RED" "Por favor instala Java 17 o superior y vuelve a ejecutar este script."
    exit 1
fi

echo ""
print_color "$CYAN" "Directorio del servidor: $SERVER_DIR"
echo ""
read -p "¿Desea continuar con la instalación? (s/N): " response

if [[ ! "$response" =~ ^[SsYy]$ ]]; then
    print_color "$YELLOW" "Instalación cancelada por el usuario"
    exit 0
fi

echo ""
print_color "$CYAN" "================================================================"
print_color "$CYAN" " INICIANDO INSTALACIÓN DEL SERVIDOR"
print_color "$CYAN" "================================================================"
echo ""

# Proceso de instalación
SUCCESS=true

# Crear directorios
if ! create_server_dir; then
    SUCCESS=false
fi

# Instalar NeoForge
if [ "$SUCCESS" = true ]; then
    if ! install_neoforge; then
        SUCCESS=false
    fi
fi

# Copiar mods
if [ "$SUCCESS" = true ]; then
    if ! copy_mods; then
        SUCCESS=false
    fi
fi

# Copiar configuraciones
if [ "$SUCCESS" = true ]; then
    copy_configs
fi

# Crear archivos de configuración
if [ "$SUCCESS" = true ]; then
    create_server_properties
    accept_eula
    create_start_script
    create_stop_script
    create_server_readme
fi

# Resultado final
echo ""
print_color "$CYAN" "================================================================"

if [ "$SUCCESS" = true ]; then
    print_color "$GREEN" " ✓ INSTALACIÓN COMPLETADA EXITOSAMENTE!"
    print_color "$CYAN" "================================================================"
    echo ""
    print_color "$CYAN" "Directorio del servidor:"
    print_color "$YELLOW" "  $SERVER_DIR"
    echo ""
    print_color "$CYAN" "Para iniciar el servidor:"
    print_color "$YELLOW" "  cd $SERVER_DIR"
    print_color "$YELLOW" "  ./start.sh"
    echo ""
    print_color "$CYAN" "Para detener el servidor:"
    print_color "$YELLOW" "  ./stop.sh"
    echo ""
    print_color "$CYAN" "Lee el archivo README_SERVER.txt para más información:"
    print_color "$YELLOW" "  cat $SERVER_DIR/README_SERVER.txt"
    echo ""
    print_color "$YELLOW" "⚠ IMPORTANTE: No olvides abrir el puerto 25565 en tu firewall!"
    echo ""
else
    print_color "$RED" " ✗ ERROR EN LA INSTALACIÓN"
    print_color "$CYAN" "================================================================"
    echo ""
    print_color "$RED" "Revisa los mensajes de error anteriores"
    exit 1
fi

print_color "$CYAN" "================================================================"
echo ""
