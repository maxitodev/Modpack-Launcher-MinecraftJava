# 🎮 Instalador de Modpack Minecraft - MaxitoDev

**Versión:** 1.21.11  
**Mod Loader:** NeoForge 21.11.37-beta / Fabric 0.18.4  
**Autor:** MaxitoDev

Sistema profesional de instalación de modpacks de Minecraft con interfaz gráfica moderna.

---

## 🌟 Características

✨ **Interfaz Gráfica Moderna** - Instalador visual con Electron (próximamente)  
🚀 **Instalación Automática** - Un clic y listo  
🎨 **Resource Packs Incluidos** - Alacrity, FreshAnimations  
✨ **Shaders Preconfigurados** - Bliss, Complementary Reimagined/Unbound  
⚙️ **Configuración Optimizada** - Settings preconfigurados para mejor rendimiento  
📦 **+80 Mods** - Experiencia completa de juego

---

## 📁 Estructura del Proyecto

```
mcpack/
│
├── 📁 GameFiles/              # Archivos del modpack
│   ├── mods/                  # Coloca aquí los .jar de los mods
│   ├── config/                # Configuraciones personalizadas
│   ├── defaultconfigs/        # Configuraciones por defecto
│   ├── installer/             # Instalador de NeoForge/Fabric
│   ├── resourcepacks/         # Resource packs (.zip)
│   ├── shaderpacks/           # Shader packs (.zip)
│   └── options.txt            # Configuración de Minecraft
│
├── 📁 Client/                 # Instalador para Windows
│   ├── Installer.ps1          # Script de instalación (PowerShell)
│   ├── 1_Compilar_Instalador.bat
│   ├── 2_Crear_ZIP.bat
│   └── 3_Build_Completo.bat
│
├── 📁 Server/                 # Instalador para servidores Linux
│   ├── install.sh
│   └── 1_build_server.sh
│
└── README.md                  # Este archivo
```

---

## 🚀 Inicio Rápido

### Para Usuarios (Instalar el Modpack)

#### Requisitos:
- ✅ Windows 7 o superior
- ✅ Java 17+ ([Descargar aquí](https://adoptium.net/))
- ✅ Minecraft Java Edition (comprado y con launcher instalado)

#### Pasos:
1. **Descarga** el archivo `Modpack-MaxitoDev.zip`
2. **Extrae** todo el contenido a una carpeta
3. **Ejecuta** `Modpack.exe`
4. **Sigue** las instrucciones en pantalla
5. **Abre** Minecraft Launcher y selecciona el perfil "Modpack - MaxitoDev"
6. **¡Juega!** 🎮

---

### Para Creadores (Compilar el Instalador)

#### Requisitos:
- PowerShell 5.1+
- Módulo PS2EXE: `Install-Module -Name ps2exe -Scope CurrentUser`

#### Preparación:

1. **Coloca los archivos del modpack** en las carpetas correspondientes:

```
GameFiles/
├── mods/              → Archivos .jar de los mods
├── config/            → Configuraciones (.toml, .json, .cfg)
├── installer/         → neoforge-installer.jar o fabric-installer.jar
├── resourcepacks/     → Archivos .zip de resource packs
├── shaderpacks/       → Archivos .zip de shaders
└── options.txt        → Configuración de Minecraft
```

2. **Compila el instalador:**

```powershell
# Opción 1: Build completo (recomendado)
cd Client
./3_Build_Completo.bat

# Opción 2: Paso a paso
./1_Compilar_Instalador.bat    # Crea el .exe
./2_Crear_ZIP.bat              # Crea el paquete de distribución
```

3. **Distribuye** el archivo `Client/Modpack-MaxitoDev-1.21.11.zip`

---

## 🎯 Roadmap - Próximas Mejoras

### 🚧 En Desarrollo

- [ ] **Interfaz Gráfica con Electron**
  - Diseño moderno con React
  - Barra de progreso animada
  - Selector visual de carpeta de instalación
  - Logs en tiempo real con colores
  - Tema oscuro premium

- [ ] **Características Adicionales**
  - Sistema de actualizaciones automáticas
  - Verificación de integridad de archivos
  - Instalación de múltiples perfiles
  - Soporte para macOS y Linux (cliente)

---

## 🛠️ Cómo Funciona

### Proceso de Instalación:

1. **Verifica Java** - Comprueba que Java 17+ esté instalado
2. **Selecciona Ruta** - Usuario elige dónde instalar (por defecto: `.minecraft`)
3. **Limpia Archivos Antiguos** - Elimina instalaciones previas para evitar conflictos
4. **Instala Mod Loader** - Ejecuta el instalador de NeoForge/Fabric
5. **Copia Archivos** - Transfiere mods, configs, resource packs y shaders
6. **Configura Launcher** - Renombra el perfil y ajusta RAM (8GB)
7. **¡Listo!** - El usuario puede abrir Minecraft y jugar

---

## ⚙️ Personalización

### Cambiar Versión de Minecraft/Fabric

Edita `Client/Installer.ps1`:

```powershell
$FabricMinecraftVersion = "1.21.11"
$FabricLoaderVersion = "0.18.4"
```

### Cambiar Nombre del Perfil

Edita `Client/Installer.ps1`:

```powershell
$p.Value.name = "Tu Nombre Personalizado"
```

### Ajustar RAM Asignada

Edita `Client/Installer.ps1`:

```powershell
$p.Value.javaArgs = "-Xmx8G -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC"
#                           ↑ Cambia 8G por la cantidad deseada (4G, 6G, 10G, etc.)
```

---

## 🐛 Solución de Problemas

### "Java no está instalado"
**Solución:** Descarga e instala Java 17+ desde [Adoptium](https://adoptium.net/)

### El instalador no abre
**Solución:** 
- Ejecuta como Administrador
- Desactiva temporalmente el antivirus
- Usa `Ejecutar_Instalador.bat` para ver errores

### Minecraft crashea al iniciar
**Solución:**
- Aumenta la RAM en el perfil del launcher (6-8GB mínimo)
- Verifica que todos los mods sean compatibles con la versión de Minecraft
- Revisa los logs en `.minecraft/logs/latest.log`

### "No se encontró GameFiles"
**Solución:** Asegúrate de extraer **TODO** el contenido del ZIP, no solo el .exe

---

## 📋 Git y Control de Versiones

### ¿Por qué las carpetas están vacías en GitHub?

Los archivos binarios grandes (`.jar`, `.zip`) **NO se suben a Git** por las siguientes razones:

- ❌ Son muy pesados (cientos de MB)
- ❌ GitHub tiene límites de tamaño
- ❌ No es necesario versionar archivos binarios

**En su lugar:**
- ✅ Se mantiene la **estructura de carpetas** con archivos `.gitkeep`
- ✅ Los **scripts y configuraciones** sí se versionan
- ✅ El README explica qué archivos colocar en cada carpeta

### Para clonar y usar este proyecto:

```bash
# 1. Clona el repositorio
git clone https://github.com/tu-usuario/mcpack.git
cd mcpack

# 2. Descarga los archivos del modpack manualmente
# - Mods desde CurseForge/Modrinth
# - Instalador de NeoForge desde neoforged.net
# - Resource packs y shaders desde sus fuentes oficiales

# 3. Coloca los archivos en las carpetas correspondientes
# (Ver estructura arriba)

# 4. Compila el instalador
cd Client
./3_Build_Completo.bat
```

---

## 📜 Licencia

Este proyecto es de código abierto. Puedes usarlo, modificarlo y distribuirlo libremente.

**IMPORTANTE:** Respeta las licencias individuales de cada mod incluido en tu modpack.

---

## 👤 Autor

**MaxitoDev**

¿Preguntas? ¿Sugerencias? ¡Contáctame!

---

## 🙏 Créditos

- **NeoForge Team** - Mod loader
- **Fabric Team** - Mod loader alternativo
- **Comunidad de Modders** - Por los increíbles mods
- **Aikar** - Flags de optimización para servidores

---

**¡Disfruta tu modpack!** 🎮✨
