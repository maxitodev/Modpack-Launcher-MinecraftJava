# 🎮 Modpack Minecraft 1.21.11 - NeoForge

**Autor:** MaxitoDev

Instalador automático profesional para distribuir modpacks de Minecraft con NeoForge, mods, resource packs y shaders.

## 📋 Requisitos

- **Windows** (7 o superior)
- **Java 17 o superior** - [Descargar aquí](https://adoptium.net/)
- **Minecraft Java Edition** instalado

## 🚀 Inicio Rápido

### Para Creadores de Modpacks

1. **Coloca tus archivos** en las carpetas correspondientes:
   ```
   mcpack/
   ├── installer/        → Archivo .jar de NeoForge
   ├── mods/            → Archivos .jar de los mods
   ├── resourcepacks/   → Archivos .zip de resource packs
   ├── shaderpacks/     → Archivos .zip de shader packs
   └── config/          → Configuraciones personalizadas (opcional)
   ```:

   **Opción A - Usar los scripts automatizados** (Recomendado):
   - Ejecuta `3_Build_Completo.bat` para compilar el instalador y crear el ZIP automáticamente
   - O ejecuta `1_Compilar_Instalador.bat` solo para compilar el .exe

   **Opción B - Compilar manualmente con PS2EXE**:
   ```powershell
   # Abrir PowerShell como Administrador
   Install-Module -Name ps2exe -Scope CurrentUser
   
   # Navegar a la carpeta
   cd "C:\Users\maxsa\Downloads\mcpack"
   
   # Crear el .exe
   Invoke-PS2EXE -inputFile ".\Installer.ps1" -outputFile ".\Modpack.exe" -title "Modpack" -version "1.0.4.0" -company "MaxitoDev"
   ```

   **Opción C - Usar el archivo .BAT** (Para pruebas):
   - Doble clic en `Ejecutar_Instalador.bat`
   **Opción C - Ejecutar directamente**:
   - Clic derecho en `Installer.ps1` → **Ejecutar con PowerShell**

3. **Ejecuta `2_Crear_ZIP.bat` para crear el archivo de distribución
   - Comparte el archivo .zip con tus usuarios
   - O sube el .zip a Google Drive, Mega, MediaFire, etc.en un .zip
   - Comparte con tus usuarios

### Para Usuarios que instalan el Modpack

1. DescompriModpack.exe` (o `Ejecutar_Instalador.bat`)
3. Sigue las instrucciones en pantalla
4. Abre Minecraft Launcher y selecciona el perfil **"Modpack - by MaxitoDev - Minecraft 1.21.11"**
5. ¡A jugar! Los resource packs y shaders ya están activados automáticamentela
4. ¡Abre Minecraft Launcher y juega!

## 📁 Estructura del Proyecto

```
mcpack/
│🎮 Modpack.exe                # Instalador compilado
├── 🚀 Ejecutar_Instalador.bat    # Lanzador alternativo
│
├── 🔧 1_Compilar_Instalador.bat  # Compila el .exe
├── 📦 2_Crear_ZIP.bat            # Crea el archivo de distribución
├── ⚡ 3_Build_Completo.bat       # Build automático completo
│
├── 📄 INSTRUCCIONES.txt          # Guía rápida
├── 📖 README.md                  # Este archivo
├── 🚫 .gitignore                 # Configuración de Git
│
├── 📁 installer/                 # Coloca aquí el instalador de NeoForge
│   └── neoforge-21.11.37-beta-installer.jar
│
├── 📁 mods/                      # Coloca aquí todos los mods (.jar)
│   └── (82 mods incluidos)
│
├── 📁 resourcepacks/             # Resource packs (.zip)
│   ├── Alacrity.zip
│   └── FreshAnimations_v1.10.3.zip
│
├── 📁 shaderpacks/               # Shader packs (.zip)
│   ├── Bliss_v2.1.2.zip
│   ├── ComplementaryReimagined_r5.6.1.zip
│   └── ComplementaryUnbound_r5.6.1.zip
│
└── 📁 config/                    # Configuraciones personalizadas
│
└── 📁 config/                    # Configuraciones personalizadas (opcional)
    └── ...
```

## ✨ Características

El instalador automáticamente:
**Activa automáticamente los resource packs** en el juego
- ✅ **Activa automáticamente el shader** en el juego
- ✅ **Renombra el perfil del launcher** a un nombre personalizado
- ✅ **Cambia el icono** del perfil en el launcher
- ✅ 
- ✅ Verifica que Java esté instalado
- ✅ Instala NeoForge ejecutando su instalador oficial
- ✅ Copia todos los mods a `.minecraft/mods`
- ✅ Copia los resource packs a `.minecraft/resourcepacks`
- ✅ Copia los shader packs a `.minecraft/shaderpacks`
- ✅ Copia configuraciones personalizadas a `.minecraft/config`
- ✅ Muestra mensajes informativos y coloridos
- ✅ Detecta y reporta errores

## 🔧 Personalización

### Cambiar la ruta de instalación de Minecraft

Edita [Installer.ps1](Installer.ps1) y modifica el parámetro `$MinecraftPath`:

```powershell
param(
    [string]$MinecraftPath = "C:\TuRutaPersonalizada\.minecraft"
)
```

O ejecuta el script con parámetros:Modpack.exe" -iconFile ".\icon.ico"
   ```

### Cambiar el nombre del perfil en el launcher

Edita [Installer.ps1](Installer.ps1) y busca esta línea:
```powershell
$customName = "Modpack - by MaxitoDev - Minecraft 1.21.11"
```
Cámbiala por el nombre que prefieras.
```powershell
.\Installer.ps1 -MinecraftPath "C:\MiMinecraft"
```

### Añadir un icono al ejecutable

1. Coloca un archivo `icon.ico` en la carpeta raíz
2. Al crear el .exe con PS2EXE, añade el parámetro:
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
