# ✅ INSTALADOR COMPLETADO - Guía de Uso

## 🎉 ¡Felicidades! Tu instalador está listo

Has creado exitosamente un **instalador profesional con interfaz gráfica** para tu modpack de Minecraft.

---

## 📦 ¿Qué se creó?

### **Archivos Principales:**

```
Client/java-installer/
├── src/                                    # Código fuente Java
│   └── com/maxitodev/installer/
│       ├── Main.java                       # Punto de entrada
│       ├── InstallerGUI.java              # Interfaz gráfica (Swing)
│       └── InstallProcess.java            # Lógica de instalación
│
├── build/
│   └── MaxitoDev-Modpack-Installer.jar    # ⭐ TU INSTALADOR (11 KB)
│
├── build.ps1                              # Script de compilación
├── run.bat                                # Script para probar
├── package.bat                            # Script para empaquetar
└── README.md                              # Documentación
```

---

## 🚀 Cómo Usar

### **1. Compilar el Instalador**

```powershell
.\build.ps1
```

Esto genera: `build/MaxitoDev-Modpack-Installer.jar`

### **2. Probar el Instalador**

```powershell
.\run.bat
```

O directamente:
```powershell
java -jar build\MaxitoDev-Modpack-Installer.jar
```

### **3. Empaquetar para Distribución**

```powershell
.\package.bat
```

Esto crea un ZIP con:
- `MaxitoDev-Modpack-Installer.jar`
- `GameFiles/` (mods, configs, shaders, etc.)
- `LEEME.txt`

---

## 🎨 Características del Instalador

✅ **Interfaz Gráfica Moderna**
- Tema oscuro profesional
- Diseño inspirado en GitHub Dark
- Colores personalizados

✅ **Funcionalidades Completas**
- Detección automática de Java
- Selector visual de carpeta .minecraft
- Barra de progreso en tiempo real
- Logs de instalación con colores
- Manejo de errores visual

✅ **Proceso de Instalación**
1. Verifica Java
2. Busca archivos del modpack
3. Instala NeoForge/Fabric
4. Copia mods
5. Copia configuraciones
6. Copia resource packs
7. Copia shaders
8. Configura options.txt
9. ¡Listo!

---

## 📋 Para tus Usuarios

### **Requisitos:**
- Java 17 o superior
- Minecraft Java Edition
- 8GB RAM mínimo

### **Instrucciones:**
1. Descargar el ZIP del modpack
2. Extraer todo el contenido
3. Doble clic en `MaxitoDev-Modpack-Installer.jar`
4. Seleccionar carpeta .minecraft (o dejar la por defecto)
5. Click en "Instalar"
6. Abrir Minecraft Launcher
7. Seleccionar perfil "MaxitoDev Modpack"
8. ¡Jugar!

---

## 🔧 Personalización

### **Cambiar Colores**

Edita `src/com/maxitodev/installer/InstallerGUI.java`:

```java
private static final Color BG_COLOR = new Color(13, 17, 23);      // Fondo
private static final Color ACCENT_COLOR = new Color(88, 166, 255); // Azul
private static final Color SUCCESS_COLOR = new Color(63, 185, 80); // Verde
```

### **Cambiar Versiones**

Edita `src/com/maxitodev/installer/Main.java`:

```java
public static final String VERSION = "1.0.0";
public static final String MC_VERSION = "1.21.11";
public static final String MODLOADER = "NeoForge 21.11.37-beta";
```

Después de cualquier cambio, ejecuta `.\build.ps1` para recompilar.

---

## 📊 Comparación: Antes vs Ahora

### **Antes (PowerShell):**
- ❌ Solo línea de comandos
- ❌ No visual
- ❌ Difícil de usar
- ❌ 180+ MB (si usabas Electron)

### **Ahora (Java Swing):**
- ✅ Interfaz gráfica moderna
- ✅ Muy visual e intuitiva
- ✅ Fácil de usar
- ✅ Solo 11 KB (+ GameFiles)
- ✅ Multiplataforma (Windows, Mac, Linux)
- ✅ Tus usuarios ya tienen Java

---

## 🎯 Próximos Pasos

### **1. Agregar tus archivos del modpack:**

Coloca tus archivos en:
```
../../GameFiles/
├── mods/              # Tus mods .jar
├── config/            # Configuraciones
├── installer/         # neoforge-installer.jar
├── resourcepacks/     # Resource packs
├── shaderpacks/       # Shaders
└── options.txt        # Opciones de Minecraft
```

### **2. Probar la instalación completa:**

```powershell
.\run.bat
```

Verifica que:
- Detecta Java correctamente
- Encuentra los archivos de GameFiles
- La barra de progreso funciona
- Los logs se muestran correctamente

### **3. Crear el paquete de distribución:**

```powershell
.\package.bat
```

Esto crea: `dist/MaxitoDev-Modpack-vXXXX.zip`

### **4. Distribuir:**

Sube el ZIP a:
- Google Drive
- Dropbox
- GitHub Releases
- Tu sitio web

---

## 💡 Tips Profesionales

### **Agregar un Icono**

1. Crea un icono `.ico` de 256x256
2. Usa una herramienta como `launch4j` para crear un .exe con icono
3. El .exe ejecutará tu .jar automáticamente

### **Firmar el JAR**

Para que Windows no muestre advertencias:

```powershell
jarsigner -keystore tu-keystore.jks build\MaxitoDev-Modpack-Installer.jar tu-alias
```

### **Crear Instalador .exe**

Usa herramientas como:
- **launch4j** - Convierte JAR a EXE
- **Inno Setup** - Crea instalador profesional
- **NSIS** - Instalador personalizable

---

## 🐛 Solución de Problemas

### **"Error: Invalid or corrupt jarfile"**
**Solución:** Recompila con `.\build.ps1`

### **"jar no se reconoce como comando"**
**Solución:** El JDK ya está instalado, el script lo encuentra automáticamente

### **La interfaz no se ve**
**Solución:** Asegúrate de tener Java 17+ instalado

### **No encuentra GameFiles**
**Solución:** Coloca la carpeta `GameFiles` en la raíz del proyecto

---

## 📚 Recursos Adicionales

- **README.md** - Documentación completa del proyecto
- **INSTALACION_JDK.md** - Guía de instalación del JDK
- **GUIA_ARCHIVOS.md** - Qué archivos van en cada carpeta

---

## 🎮 Ejemplo de Uso Final

Tu usuario descarga: `MaxitoDev-Modpack-v20260131.zip` (500 MB)

Contiene:
```
MaxitoDev-Modpack/
├── MaxitoDev-Modpack-Installer.jar  (11 KB)
├── GameFiles/                       (500 MB)
│   ├── mods/
│   ├── config/
│   └── ...
└── LEEME.txt
```

Usuario:
1. Extrae el ZIP
2. Doble clic en el .jar
3. Ve una interfaz gráfica moderna
4. Click en "Instalar"
5. ¡Listo en 2 minutos!

---

## ✨ ¡Felicidades!

Has creado un instalador profesional que:
- ✅ Se ve increíble
- ✅ Es fácil de usar
- ✅ Es ligero y rápido
- ✅ Funciona en todas las plataformas
- ✅ Tus usuarios lo amarán

**¡Ahora solo falta agregar tus mods y distribuir!** 🚀

---

**¿Necesitas ayuda?** Revisa los archivos README en el proyecto.

**¿Quieres mejorar algo?** El código está bien documentado y es fácil de modificar.

**¡Disfruta tu instalador profesional!** 🎉
