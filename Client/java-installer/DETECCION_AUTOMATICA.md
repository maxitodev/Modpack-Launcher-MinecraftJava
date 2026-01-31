# 🔄 Actualización: Detección Automática de Mod Loader

## ✨ Nuevas Características

El instalador ahora **detecta automáticamente** el tipo de mod loader (NeoForge, Forge, Fabric, Quilt) según el archivo instalador que encuentre en la carpeta `GameFiles/installer/`.

---

## 🎯 ¿Qué cambió?

### **Antes:**
- El mod loader estaba hardcodeado: `"NeoForge 21.11.37-beta"`
- Si usabas Fabric, mostraba información incorrecta

### **Ahora:**
- ✅ **Detecta automáticamente** NeoForge, Forge, Fabric o Quilt
- ✅ **Extrae la versión** del nombre del archivo
- ✅ **Actualiza la interfaz** dinámicamente
- ✅ **Muestra el nombre correcto** en el subtítulo y logs

---

## 🔍 Cómo Funciona

El instalador analiza el nombre del archivo `.jar` en `GameFiles/installer/`:

### **Ejemplos de Detección:**

| Archivo Instalador | Detectado Como |
|-------------------|----------------|
| `neoforge-21.11.37-beta-installer.jar` | **NeoForge 21.11.37-beta** |
| `fabric-installer-0.18.4.jar` | **Fabric 0.18.4** |
| `forge-1.21.11-51.0.33-installer.jar` | **Forge 1.21.11-51.0.33** |
| `quilt-installer-0.9.0.jar` | **Quilt** |

---

## 📝 Patrones de Detección

El código busca palabras clave en el nombre del archivo:

```java
// Prioridad de detección:
1. "neoforge" → NeoForge
2. "forge" → Forge  
3. "fabric" → Fabric
4. "quilt" → Quilt
```

### **Extracción de Versión:**

- **NeoForge**: `neoforge-[VERSION]-installer.jar`
  - Ejemplo: `neoforge-21.11.37-beta-installer.jar` → `21.11.37-beta`

- **Forge**: `forge-[VERSION]-installer.jar`
  - Ejemplo: `forge-1.21.11-51.0.33-installer.jar` → `1.21.11-51.0.33`

- **Fabric**: `fabric-installer-[VERSION].jar`
  - Ejemplo: `fabric-installer-0.18.4.jar` → `0.18.4`

---

## 🎨 Actualización de Interfaz

### **Subtítulo Dinámico:**

Antes:
```
Minecraft 1.21.11 • NeoForge 21.11.37-beta
```

Ahora (detecta automáticamente):
```
Minecraft 1.21.11 • Fabric 0.18.4
```

### **Logs de Instalación:**

```
=== Iniciando instalación ===
Ruta de instalación: C:\Users\...\AppData\Roaming\.minecraft
Verificando versión de Java...
Java detectado: 24.0.2
Buscando carpeta GameFiles...
GameFiles encontrado: C:\...\GameFiles
Buscando instalador de mod loader...
Mod loader detectado: Fabric 0.18.4
Instalador encontrado: fabric-installer-0.18.4.jar
Ejecutando instalador...
[Instalador] Installing Fabric...
✓ Fabric instalado correctamente
```

---

## 🔧 Cambios Técnicos

### **Archivos Modificados:**

1. **`Main.java`**
   - Eliminada constante `MODLOADER` (ya no es necesaria)
   - Ahora se detecta dinámicamente

2. **`InstallerGUI.java`**
   - Agregado campo `modLoaderName` (dinámico)
   - Agregado `subtitleLabel` (actualizable)
   - Nuevo método `updateModLoader(String)` para actualizar la UI

3. **`InstallProcess.java`**
   - Lógica de detección automática de mod loader
   - Extracción de versión mediante regex
   - Actualización dinámica de la interfaz

---

## 🚀 Uso

### **Para NeoForge:**

Coloca en `GameFiles/installer/`:
```
neoforge-21.11.37-beta-installer.jar
```

El instalador mostrará:
```
Minecraft 1.21.11 • NeoForge 21.11.37-beta
```

### **Para Fabric:**

Coloca en `GameFiles/installer/`:
```
fabric-installer-0.18.4.jar
```

El instalador mostrará:
```
Minecraft 1.21.11 • Fabric 0.18.4
```

### **Para Forge:**

Coloca en `GameFiles/installer/`:
```
forge-1.21.11-51.0.33-installer.jar
```

El instalador mostrará:
```
Minecraft 1.21.11 • Forge 1.21.11-51.0.33
```

---

## ✅ Ventajas

1. **Flexibilidad Total**
   - Cambia de NeoForge a Fabric sin modificar código
   - Solo reemplaza el archivo instalador

2. **Información Precisa**
   - Siempre muestra el mod loader correcto
   - Incluye la versión exacta

3. **Experiencia de Usuario**
   - El usuario sabe exactamente qué se está instalando
   - Logs claros y precisos

4. **Mantenimiento Fácil**
   - No necesitas recompilar para cambiar de mod loader
   - Un solo instalador para todos los mod loaders

---

## 🎯 Ejemplo Completo

### **Escenario: Cambiar de NeoForge a Fabric**

**Antes (necesitabas):**
1. Editar `Main.java`
2. Cambiar `MODLOADER = "NeoForge..."` a `MODLOADER = "Fabric..."`
3. Recompilar el instalador
4. Reemplazar archivos

**Ahora (solo necesitas):**
1. Reemplazar `neoforge-installer.jar` por `fabric-installer.jar` en `GameFiles/installer/`
2. ¡Listo! El instalador detecta automáticamente

---

## 📦 Compilar

```powershell
.\build.ps1
```

El nuevo instalador con detección automática está listo en:
```
build/MaxitoDev-Modpack-Installer.jar
```

---

## 🎉 Resultado

Ahora tienes un instalador **verdaderamente universal** que se adapta automáticamente a cualquier mod loader que uses, sin necesidad de modificar código ni recompilar.

**¡Perfecto para modpacks que cambian de mod loader o para crear múltiples versiones!** 🚀
