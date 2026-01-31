# 🛠️ GESTIÓN DEL MODPACK Y VERSIONES

Este instalador está configurado en **MODO MANUAL** para darte control total y evitar errores de detección. El instalador instalará EXACTAMENTE lo que tú definas en el código.

## 1. CÓMO CAMBIAR VERSIONES (Minecraft y Fabric)

Para actualizar el modpack a nuevas versiones, sigue obligatoriamente estos 3 pasos:

### 🅰️ PASO 1: Definir la versión en el Código
El instalador siempre obedecerá lo que diga este archivo.

1. Abre el archivo:
   `src/com/maxitodev/installer/Main.java`

2. Busca y edita estas variables al principio del archivo:
   ```java
   // ==========================================
   // CONFIGURACIÓN DE VERSIONES (EDITAR AQUÍ)
   // ==========================================
   public static final String MC_VERSION = "1.21.11";      // <--- Pon aquí tu versión de Minecraft
   public static final String LOADER_VERSION = "0.18.4";  // <--- Pon aquí tu versión de FabricLoader
   ```

### 🅱️ PASO 2: Actualizar el instalador base
Necesitas el archivo `.jar` oficial de Fabric para realizar la instalación.

1. Ve a la carpeta `GameFiles/installer/`.
2. Elimina el archivo `.jar` antiguo.
3. Descarga y pega el nuevo instalador de Fabric (ej: `fabric-installer-0.18.4.jar`).
   * *Descárgalo de https://fabricmc.net/use/installer/*

### 🅾️ PASO 3: Recompilar
Para aplicar los cambios y generar el nuevo `.jar` final:

1. Ejecuta el script:
   `.\build.ps1`

---

## 2. CÓMO ACTUALIZAR MODS

1. Ve a `GameFiles/mods/`.
2. Borra los mods viejos y pega los nuevos.
3. (Opcional) Haz lo mismo con `config`, `resourcepacks`, etc.
4. **No es necesario recompilar** si solo cambias mods; el instalador simplemente copia lo que haya en esas carpetas.

---

## ❓ SOLUCIÓN DE PROBLEMAS

- **El perfil no aparece en el Launcher:**
  Asegúrate de haber reiniciado el Launcher de Minecraft completamente después de instalar. El perfil suele llamarse "fabric-loader-1.21.11".

- **Error "No se encontró instalador":**
  Verifica que en la carpeta `GameFiles/installer/` exista un archivo `.jar` válido de Fabric.
