# 🎮 Instalador de Modpack Minecraft - MaxitoDev

**Versión:** 1.21.11  
**Mod Loader:** NeoForge 21.11.37-beta / Fabric 0.18.4  
**Autor:** MaxitoDev

Sistema profesional de instalación de modpacks de Minecraft con interfaz gráfica moderna.

---

## 🌟 Características

✨ **Nuevo Instalador Java (Swing)** - GUI nativa, ligera (~15MB RAM) y ultra-rápida.  
🎨 **Diseño Premium** - Interfaz minimalista con fondo cinemático de Minecraft y botones animados.  
🚀 **Instalación Inteligente** - Detecta automáticamente Fabric/NeoForge y perfila el launcher.  
📦 **Todo en Uno** - Instala Mods, Configs, Resource Packs y Shaders en un solo paso.  
🔧 **Logs en Tiempo Real** - Visualiza cada paso del proceso con detalles técnicos claros.

---

## 📁 Estructura del Proyecto

```
mcpack/
│
├── 📁 GameFiles/              # Archivos del modpack (El corazón del instalador)
│   ├── mods/                  # .jar de los mods
│   ├── config/                # Configuraciones (.toml, .json)
│   ├── defaultconfigs/        # Configs por defecto
│   ├── installer/             # El instalador oficial (.jar) de Fabric/NeoForge
│   ├── resourcepacks/         # Resource Packs (.zip)
│   ├── shaderpacks/           # Shaders (.zip)
│   └── options.txt            # Opciones de Minecraft preconfiguradas
│
├── 📁 Client/
│   ├── 📁 java-installer/     # Código fuente del instalador Java
│   │   ├── src/               # Código fuente (.java)
│   │   ├── build.ps1          # Script de compilación
│   │   └── run.bat            # Script de prueba
│   │
│   └── (Archivos Legacy PowerShell...)
│
├── 📁 Server/                 # Scripts para servidor Linux
└── README.md                  # Documentación
```

---

## 🚀 Inicio Rápido (Para Usuarios)

### Requisitos:
- ✅ **Windows 10/11**
- ✅ **Java 17+** instalado
- ✅ **Minecraft Launcher** instalado y ejecutado al menos una vez.

### Instalación:
1.  **Descarga** y extrae el ZIP del Modpack.
2.  **Ejecuta** el archivo `Instalador.exe` (o el JAR generado).
3.  Selecciona tu carpeta `.minecraft` (se detecta sola).
4.  Haz clic en **"INSTALAR"**.
5.  Abre el Launcher y selecciona el perfil **"Fabric Loader"** (o el que se haya creado).

---

## 🛠️ Para Creadores: Compilar el Instalador

El instalador es una aplicación Java nativa. Para modificarla y compilarla:

### Requisitos de Desarrollo:
- **JDK 17** o superior.
- **PowerShell** (ya viene en Windows).

### Pasos para Compilar:

1.  Ve a la carpeta del código:
    ```powershell
    cd Client/java-installer
    ```

2.  Ejecuta el script de construcción:
    ```powershell
    ./build.ps1
    ```

3.  El instalador compilado aparecerá en `Client/java-installer/build/MaxitoDev-Modpack-Installer.jar`.

---

## 🛠️ Para Creadores: Generar Server Pack

Hemos incluido un sistema inteligente para crear **Paquetes de Servidor** listos para producción.

### ¿Qué hace el generador?
*   ✅ **Filtrado Inteligente:** Detecta y elimina automáticamente mods "Solo Cliente" (Sodium, Iris, Mapas, Shaders, etc.) para evitar crashes y ahorrar espacio.
*   ✅ **Estructura Limpia:** Organiza todos los archivos técnicos en una subcarpeta `server_files`.
*   ✅ **Multiplataforma:** Genera scripts de inicio para **Windows** (`.bat`) y **Linux** (`.sh`).
*   ✅ **Listo para usar:** Crea un ZIP final que solo tienes que subir a tu hosting y descomprimir.

### Pasos para generar:
1.  Asegúrate de que `GameFiles/mods` tenga todos los mods (el script sabrá cuáles quitar).
2.  Abre PowerShell y ve a la carpeta `Server`:
    ```powershell
    cd Server
    ```
3.  Ejecuta el script maestro:
    ```powershell
    ./Create-Server-Pack.ps1
    ```
4.  ¡Listo! Encontrarás tu ZIP en `Server/Build/`.

---

## ⚙️ Personalización y Versiones

### Cambiar Versiones (Minecraft / Fabric)

Todo se controla desde el código para máxima precisión.

1.  Abre el archivo: `Client/java-installer/src/com/maxitodev/installer/Main.java`
2.  Edita las líneas de configuración:
    ```java
    public static final String MC_VERSION = "1.21.11";    // Tu versión de MC
    public static final String LOADER_VERSION = "0.18.4"; // Tu versión de Loader
    ```
3.  **IMPORTANTE:** Reemplaza el archivo `.jar` en `GameFiles/installer/` con el instalador oficial de Fabric correspondiente a la versión que pusiste.
4.  Recompila con `build.ps1`.

### Cambiar Imagen de Fondo

1.  Reemplaza la imagen en: `Client/java-installer/src/resources/bg.png`
2.  Recompila.

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
