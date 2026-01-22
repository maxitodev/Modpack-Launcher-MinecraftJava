#!/bin/bash

# ============================================
# BUILD DEL SERVIDOR - CREAR PAQUETE
# Autor: MaxitoDev
# ============================================

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

print_color "$CYAN" "================================================================"
print_color "$CYAN" " BUILD DEL SERVIDOR - CREAR PAQUETE DE DISTRIBUCIÓN"
print_color "$CYAN" "================================================================"
echo ""

# Nombre del archivo de salida
OUTPUT_FILE="Modpack-Server-MaxitoDev-1.21.11.tar.gz"

# Verificar que existan los archivos necesarios
print_color "$YELLOW" "Verificando archivos necesarios..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

REQUIRED_ITEMS=(
    "$SCRIPT_DIR/install.sh"
    "$PARENT_DIR/installer"
    "$PARENT_DIR/mods"
    "$PARENT_DIR/config"
)

for item in "${REQUIRED_ITEMS[@]}"; do
    if [ ! -e "$item" ]; then
        print_color "$RED" "✗ No se encontró: $(basename "$item")"
        exit 1
    fi
done

print_color "$GREEN" "✓ Todos los archivos necesarios están presentes"
echo ""

# Crear el paquete
print_color "$YELLOW" "Creando paquete de distribución..."

cd "$PARENT_DIR"

tar -czf "$SCRIPT_DIR/$OUTPUT_FILE" \
    --exclude='*.log' \
    --exclude='*.exe' \
    --exclude='Client' \
    --exclude='Server/*.tar.gz' \
    --exclude='.git' \
    --exclude='.gitignore' \
    installer/ \
    mods/ \
    config/ \
    Server/install.sh \
    Server/LEEME_SERVIDOR.txt

if [ $? -eq 0 ]; then
    echo ""
    print_color "$GREEN" "================================================================"
    print_color "$GREEN" " ✓ PAQUETE CREADO EXITOSAMENTE!"
    print_color "$GREEN" "================================================================"
    echo ""
    print_color "$CYAN" "Archivo creado:"
    print_color "$YELLOW" "  $SCRIPT_DIR/$OUTPUT_FILE"
    echo ""
    print_color "$CYAN" "Para distribuir:"
    print_color "$YELLOW" "  1. Sube el archivo .tar.gz a tu VPS"
    print_color "$YELLOW" "  2. Descomprime: tar -xzf $OUTPUT_FILE"
    print_color "$YELLOW" "  3. Ejecuta: cd Server && ./install.sh"
    echo ""
else
    print_color "$RED" "✗ Error al crear el paquete"
    exit 1
fi

print_color "$CYAN" "================================================================"
echo ""
