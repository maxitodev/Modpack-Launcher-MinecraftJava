# 🎮 Instalador de Modpack Minecraft - NeoForge

Instalador automático personalizado para distribuir modpacks de Minecraft con NeoForge, mods, resource packs y shaders.

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
   ```

2. **Crear el ejecutable** (3 opciones):

   **Opción A - Usando PS2EXE** (Recomendado para distribución):
   ```powershell
   # Abrir PowerShell como Administrador
   Install-Module -Name ps2exe -Scope CurrentUser
   
   # Navegar a la carpeta
   cd "C:\Users\maxsa\Downloads\mcpack"
   
   # Crear el .exe
   Invoke-PS2EXE -inputFile ".\Installer.ps1" -outputFile ".\InstaladorModpack.exe" -title "Instalador Modpack" -version "1.0.0.0"
   ```

   **Opción B - Usar el archivo .BAT** (Más simple):
   - Doble clic en `Ejecutar_Instalador.bat`

   **Opción C - Ejecutar directamente**:
   - Clic derecho en `Installer.ps1` → **Ejecutar con PowerShell**

3. **Distribuir tu modpack**:
   - Comprime toda la carpeta en un .zip
   - Comparte con tus usuarios

### Para Usuarios que instalan el Modpack

1. Descomprime el archivo .zip que recibiste
2. Ejecuta `InstaladorModpack.exe` o `Ejecutar_Instalador.bat`
3. Sigue las instrucciones en pantalla
4. ¡Abre Minecraft Launcher y juega!

## 📁 Estructura del Proyecto

```
mcpack/
│
├── 📄 Installer.ps1              # Script principal de instalación
├── 🚀 Ejecutar_Instalador.bat    # Lanzador del instalador (alternativa al .exe)
├── 📄 INSTRUCCIONES.txt          # Guía rápida
├── 📖 README.md                  # Este archivo
│
├── 📁 installer/                 # Coloca aquí el instalador de NeoForge
│   └── ⚠️ neoforge-X.X.X-installer.jar
│
├── 📁 mods/                      # Coloca aquí todos los mods (.jar)
│   ├── ejemplo-mod-1.jar
│   ├── ejemplo-mod-2.jar
│   └── ...
│
├── 📁 resourcepacks/             # Coloca aquí los resource packs (.zip)
│   ├── ejemplo-resourcepack.zip
│   └── ...
│
├── 📁 shaderpacks/               # Coloca aquí los shader packs (.zip)
│   ├── ejemplo-shaders.zip
│   └── ...
│
└── 📁 config/                    # Configuraciones personalizadas (opcional)
    └── ...
```

## ✨ Características

El instalador automáticamente:

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

O ejecuta el script con parámetros:

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
- El nombre debe comenzar con `neoforge-`

### "No se pueden ejecutar scripts"
- Abre PowerShell como Administrador y ejecuta:
  ```powershell
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
