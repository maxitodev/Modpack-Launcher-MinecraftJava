# 🎮 Modpack Minecraft 1.21.11 - NeoForge

**Autor:** MaxitoDev  
**Versión:** 1.21.11  
**NeoForge:** 21.11.37-beta

Sistema profesional de distribución de modpacks de Minecraft con soporte para **Cliente (Windows)** y **Servidor (Linux)**.

---

## 📋 Contenido del Proyecto

Este proyecto incluye:
- ✅ **82+ mods** optimizados para cliente
- ✅ **Resource Packs:** Alacrity, FreshAnimations
- ✅ **Shaders:** Bliss, Complementary Reimagined, Complementary Unbound
- ✅ **Instalador automático para Windows** (Cliente)
- ✅ **Instalador automático para Linux** (Servidor VPS)
- ✅ **Scripts de build** para crear paquetes de distribución
- ✅ **Configuraciones preestablecidas**

---

## 📁 Estructura del Proyecto

```
mcpack/
│
├── 📁 Client/                        # Archivos del cliente (Windows)
│   ├── Installer.ps1                 # Instalador PowerShell
│   ├── 1_Compilar_Instalador.bat     # Compila el .exe
│   ├── 2_Crear_ZIP.bat               # Crea el paquete de distribución
│   ├── 3_Build_Completo.bat          # Build completo automático
│   ├── Ejecutar_Instalador.bat      # Ejecuta el instalador
│   ├── INSTRUCCIONES.txt             # Instrucciones para crear el .exe
│   └── LEEME.txt                     # Manual para usuarios
│
├── 📁 Server/                        # Archivos del servidor (Linux)
│   ├── install.sh                    # Instalador para Linux
│   ├── 1_build_server.sh             # Build del servidor (Linux)
│   ├── 1_build_server.bat            # Build del servidor (Windows)
│   └── LEEME_SERVIDOR.txt            # Manual para servidores
│
├── 📁 installer/                     # Instalador de NeoForge
│   └── neoforge-21.11.37-beta-installer.jar
│
├── 📁 mods/                          # Mods del modpack
│   └── *.jar (82+ mods)
│
├── 📁 resourcepacks/                 # Paquetes de recursos
│   ├── Alacrity.zip
│   └── FreshAnimations_v1.10.3.zip
│
├── 📁 shaderpacks/                   # Paquetes de shaders
│   ├── Bliss_v2.1.2.zip
│   ├── ComplementaryReimagined_r5.6.1.zip
│   └── ComplementaryUnbound_r5.6.1.zip
│
├── 📁 config/                        # Configuraciones personalizadas
│   └── modpack-info.txt
│
├── .gitignore                        # Archivos ignorados por Git
└── README.md                         # Este archivo
```

---

## 🎯 Uso Rápido

### 🖥️ Para Crear el Instalador del Cliente (Windows)

   - `installer/` → NeoForge installer
   - `mods/` → Archivos .jar de mods
   - `resourcepacks/` → Archivos .zip de resource packs
   - `shaderpacks/` → Archivos .zip de shaders
   - `config/` → Configuraciones personalizadas (opcional)

2. **Ejecuta** `Client/3_Build_Completo.bat`

3. **Comparte** el archivo `Client/Modpack-MaxitoDev-1.21.11.zip` con tus usuarios

### 🐧 Para Crear el Paquete del Servidor (Linux)

1. **Asegúrate** de tener los archivos en las carpetas compartidas (installer, mods, config)

2. **Elige tu método de build:**

   **OPCIÓN A - Windows con WSL (Recomendado):**
   ```bash
   cd Server
   1_build_server.bat
   ```
   
   **OPCIÓN B - Windows con PowerShell (Sin WSL):**
   ```bash
   cd Server
   1_build_server_powershell.bat
   ```
   *Crea un .zip en lugar de .tar.gz*
   
   **OPCIÓN C - Desde Linux:**
   ```bash
   cd Server
   chmod +x 1_build_server.sh
   ./1_build_server.sh
   ```

3. **Distribuye** el archivo generado en `Server/`

---

## 📖 Guías Detalladas

### Para Creadores de Modpacks

#### Cliente (Windows)

Ver: `Client/INSTRUCCIONES.txt`

**Pasos rápidos:**
```bash
# 1. Compilar el instalador a .exe
Client/1_Compilar_Instalador.bat

# 2. Crear el archivo ZIP de distribución
Client/2_Crear_ZIP.bat

# O hacer todo en un solo paso:
Client/3_Build_Completo.bat
```

**Requisitos previos:**
- PowerShell 5.1+
- Módulo PS2EXE instalado: `Install-Module -Name ps2exe -Scope CurrentUser`

#### Servidor (Linux)

Ver: `Server/LEEME_SERVIDOR.txt`

**En Linux:**
```bash
cd Server
chmod +x 1_build_server.sh
./1_build_server.sh
```

**En Windows (con WSL):**
```bash
Server\1_build_server.bat
```

### Para Usuarios Finales

#### Instalar el Cliente

Ver: `Client/LEEME.txt`

**Requisitos:**
- Windows 7 o superior
- Java 17+ ([Descargar](https://adoptium.net/))
- Minecraft Java Edition

**Pasos:**
1. Descomprimir el archivo ZIP
2. Ejecutar `Modpack.exe`
3. Seguir las instrucciones
4. Abrir Minecraft Launcher y seleccionar el perfil

#### Instalar el Servidor

Ver: `Server/LEEME_SERVIDOR.txt`

**Requisitos:**
- VPS Linux (Ubuntu/Debian/CentOS)
- 4GB+ RAM (recomendado 6-8GB)
- Java 17+
- Puerto 25565 abierto

**Pasos:**
1. Subir el archivo .tar.gz al VPS
2. Descomprimir: `tar -xzf Modpack-Server-MaxitoDev-1.21.11.tar.gz`
3. Ejecutar: `cd Server && chmod +x install.sh && ./install.sh`
4. Iniciar: `cd minecraft-server && ./start.sh`

---

## ⚙️ Características del Instalador

### Cliente (Windows)

- ✅ Verifica que Java esté instalado
- ✅ Instala NeoForge automáticamente
- ✅ Copia mods a `.minecraft/mods`
- ✅ Copia resource packs a `.minecraft/resourcepacks`
- ✅ Copia shaders a `.minecraft/shaderpacks`
- ✅ **Activa automáticamente los resource packs en el juego**
- ✅ **Activa automáticamente el shader en el juego**
- ✅ **Renombra el perfil del launcher**
- ✅ Interfaz colorida e informativa

### Servidor (Linux)

- ✅ Verifica que Java 17+ esté instalado
- ✅ Instala NeoForge en modo servidor
- ✅ Copia mods compatibles con servidor
- ✅ Copia configuraciones personalizadas
- ✅ Crea `server.properties` preconfigurado
- ✅ Acepta EULA automáticamente
- ✅ Genera scripts de inicio/detención optimizados
- ✅ Incluye flags de optimización (Aikar's flags)
- ✅ Genera documentación completa

---

## 🔧 Personalización

### Cambiar el Nombre del Perfil del Launcher (Cliente)

Edita `Client/Installer.ps1`:

```powershell
$customName = "TU NOMBRE PERSONALIZADO"
```

### Cambiar la Configuración del Servidor

Edita el archivo generado `minecraft-server/server.properties`:

```properties
max-players=20              # Jugadores máximos
view-distance=10            # Distancia de visión
difficulty=normal           # Dificultad
gamemode=survival          # Modo de juego
motd=Tu mensaje MOTD       # Mensaje del servidor
```

### Ajustar RAM del Servidor

Edita el archivo generado `minecraft-server/start.sh`:

```bash
# Para VPS de 4GB
java -Xms2G -Xmx3G ...

# Para VPS de 8GB
java -Xms4G -Xmx6G ...
```

---

## 🚀 Control de Versiones con Git

El proyecto está configurado con `.gitignore` para excluir archivos binarios grandes:

**NO se suben a Git:**
- ❌ Archivos `.jar`, `.zip`, `.exe`
- ❌ Logs y archivos temporales
- ❌ Paquetes compilados

**SÍ se suben a Git:**
- ✅ Scripts (.ps1, .bat, .sh)
- ✅ Documentación (.txt, .md)
- ✅ Configuraciones

**Mantener estructura de carpetas:**
```bash
# Las carpetas vacías se mantienen con .gitkeep
git add mods/.gitkeep
git add resourcepacks/.gitkeep
git add shaderpacks/.gitkeep
git add installer/.gitkeep
```

---

## 🐛 Problemas Comunes

### Cliente (Windows)

**"Java no está instalado"**
- Descargar e instalar desde [Adoptium](https://adoptium.net/)

**El instalador no abre**
- Ejecutar como Administrador
- Permitir en el antivirus temporalmente

**Crash al iniciar Minecraft**
- Aumentar RAM en el perfil del launcher (6-8GB recomendado)

### Servidor (Linux)

**"Cannot allocate memory"**
- Reducir RAM en `start.sh`: `-Xmx2G`

**Puerto en uso**
- Cambiar `server-port` en `server.properties`

**No puedo conectarme**
- Verificar firewall: `sudo ufw allow 25565/tcp`
- Verificar que el servidor esté corriendo: `ps aux | grep java`

---

## 📝 TODO / Roadmap

- [ ] Soporte para macOS
- [ ] Instalador GUI con interfaz gráfica
- [ ] Sistema de actualizaciones automáticas
- [ ] Panel web de administración del servidor
- [ ] Soporte para Docker

---

## 📜 Licencia

Este proyecto es de código abierto. Puedes usarlo, modificarlo y distribuirlo libremente.

---

## 👤 Autor

**MaxitoDev**

¿Problemas? ¿Sugerencias? ¡Contacta!

---

## 🙏 Créditos

- **NeoForge Team** - Por el mod loader
- **Comunidad de modders** - Por los increíbles mods
- **Aikar** - Por las flags de optimización del servidor

---

**¡Disfruta tu modpack!** 🎮✨
   ```powershell
   Invoke-PS2EXE -inputFile ".\Installer.ps1" -outputFile ".\InstaladorModpack.exe" -iconFile ".\icon.ico"
   ```

### Personalizar nombre y versión

```powershell
Invoke-PS2EXE -inputFile ".\Installer.ps1" `
              -outputFile ".\MiModpack_v1.0.exe" `
              -title "Mi Modpack Épico" `
              -version "1.0.0.0" `
              -company "Tu Nombre" `
              -product "Modpack Minecraft"
```

## 🐛 Solución de Problemas

### "Java no está instalado"
- Descarga e instala Java desde [adoptium.net](https://adoptium.net/)
- Asegúrate de seleccionar "Añadir al PATH" durante la instalación

### "No se encontró el instalador de NeoForge"
- Verifica que el archivo .jar de NeoForge esté en la carpeta `installer/`
- El nombre debe

- **Minecraft:** 1.21.11
- **NeoForge:** 21.11.37-beta
- **Mods incluidos:** 82+
- **Resource Packs:** Alacrity, FreshAnimations v1.10.3
- **Shaders:** Bliss v2.1.2, Complementary Reimagined r5.6.1, Complementary Unbound r5.6.1

### Compatibilidad

Este instalador es compatible con todas las versiones de NeoForge. Para usar otra versión:
1. Reemplaza el .jar en la carpeta `installer/`
2. Actualiza los mods para que sean compatibles con esa versión
3. Recompila el instalador
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

### El instalador se cierra inmediatamente
- Usa `Ejecutar_Instalador.bat` en su lugar
- O ejecuta desde PowerShell para ver los mensajes de error

## 📝 Notas Importantes

- **Derechos de autor**: Asegúrate de tener permiso para redistribuir los mods
- **Licencias**: Respeta las licencias de cada mod incluido
- **Actualizaciones**: Actualiza los mods regularmente para correcciones de seguridad

## 🛠️ Versiones de NeoForge

Este instalador es compatible con todas las versiones de NeoForge. Solo asegúrate de:
1. Tener el instalador correcto (.jar) en la carpeta `installer/`
2. Que los mods sean compatibles con la versión de Minecraft/NeoForge
Creado con ❤️ por MaxitoDev
## 🤝 Contribuciones

Si quieres mejorar este instalador:
1. Modifica [Installer.ps1](Installer.ps1)
2. Prueba los cambios
3. Documenta las nuevas características

## 📄 Licencia

Este instalador es de código abierto. Úsalo libremente para tus modpacks.

## 💡 Ejemplos de Uso

### Para streamers/creadores de contenido
Perfecto para compartir tu modpack con tu comunidad de forma profesional.

### Para servidores privados
Distribuye fácilmente la configuración exacta de mods que usa tu servidor.

### Para amigos
Crea un instalador de un clic para que tus amigos jueguen contigo sin complicaciones.

---

**¿Preguntas?** Revisa [INSTRUCCIONES.txt](INSTRUCCIONES.txt) para una guía visual paso a paso.

**Hecho con ❤️ para la comunidad de Minecraft**
