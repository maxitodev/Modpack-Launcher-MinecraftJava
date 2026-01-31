# 🎮 MaxitoDev Modpack Installer - Java Edition

Instalador profesional con interfaz gráfica moderna para Minecraft 1.21.11

## 🚀 Inicio Rápido

### Para Compilar el Instalador:

1. **Compilar:**
   ```bash
   build.bat
   ```
   Esto genera: `build/MaxitoDev-Modpack-Installer.jar`

2. **Probar:**
   ```bash
   run.bat
   ```
   Ejecuta el instalador en modo de prueba

3. **Empaquetar para distribución:**
   ```bash
   package.bat
   ```
   Crea un ZIP con todo listo para distribuir

## 📁 Estructura del Proyecto

```
java-installer/
├── src/
│   └── com/maxitodev/installer/
│       ├── Main.java              # Punto de entrada
│       ├── InstallerGUI.java      # Interfaz gráfica
│       └── InstallProcess.java    # Lógica de instalación
├── build/
│   └── MaxitoDev-Modpack-Installer.jar  # JAR compilado
├── dist/
│   └── MaxitoDev-Modpack-vXXXX.zip      # Paquete de distribución
├── build.bat                      # Compilar
├── run.bat                        # Ejecutar (prueba)
├── package.bat                    # Empaquetar
└── README.md                      # Este archivo
```

## ✨ Características

- ✅ **Interfaz Gráfica Moderna** - Tema oscuro con gradientes
- ✅ **Barra de Progreso** - Animada en tiempo real
- ✅ **Selector de Carpeta** - Visual y fácil de usar
- ✅ **Logs en Tiempo Real** - Monitoreo completo del proceso
- ✅ **Detección Automática** - Java y carpeta .minecraft
- ✅ **Instalación Completa** - Mod loader, mods, configs, shaders
- ✅ **Multiplataforma** - Windows, Mac, Linux

## 🛠️ Requisitos de Desarrollo

- Java JDK 17 o superior
- JavaFX (incluido en JDK moderno)

## 📦 Distribución

El archivo final para distribuir será:

```
MaxitoDev-Modpack-vXXXX.zip
├── MaxitoDev-Modpack-Installer.jar  (5-10 MB)
├── GameFiles/
│   ├── mods/
│   ├── config/
│   ├── installer/
│   ├── resourcepacks/
│   ├── shaderpacks/
│   └── options.txt
└── LEEME.txt
```

Los usuarios solo necesitan:
1. Extraer el ZIP
2. Doble clic en el .jar
3. ¡Listo!

## 🎨 Personalización

### Cambiar colores del tema:

Edita `InstallerGUI.java`:

```java
private static final String BG_COLOR = "#0d1117";      // Fondo principal
private static final String CARD_COLOR = "#161b22";    // Tarjetas
private static final String ACCENT_COLOR = "#58a6ff";  // Color de acento
private static final String SUCCESS_COLOR = "#3fb950"; // Color de éxito
```

### Cambiar versiones:

Edita `Main.java`:

```java
public static final String VERSION = "1.0.0";
public static final String MC_VERSION = "1.21.11";
public static final String MODLOADER = "NeoForge 21.11.37-beta";
```

## 🐛 Solución de Problemas

### "javac no se reconoce como comando"
**Solución:** Instala Java JDK y agrega a PATH

### "Error: JavaFX runtime components are missing"
**Solución:** 
- Usa Java 11+ que incluye JavaFX
- O descarga JavaFX SDK separadamente

### El instalador no encuentra GameFiles
**Solución:** Asegúrate de que la carpeta `GameFiles/` esté en la raíz del proyecto

## 👤 Autor

**MaxitoDev**

---

**¡Disfruta tu instalador profesional!** 🎮✨
