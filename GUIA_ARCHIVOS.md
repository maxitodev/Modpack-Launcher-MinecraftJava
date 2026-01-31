# 📋 GUÍA: Qué Archivos van en Cada Carpeta

Esta guía te explica exactamente qué archivos debes colocar en cada carpeta de `GameFiles/` antes de compilar el instalador.

---

## 📁 GameFiles/mods/

**Qué va aquí:** Archivos `.jar` de los mods

**Ejemplo:**
```
GameFiles/mods/
├── sodium-fabric-0.5.8.jar
├── iris-1.6.10.jar
├── create-1.21.11-0.5.1.jar
├── jei-1.21.11-17.0.0.jar
└── ... (todos tus mods)
```

**Dónde conseguirlos:**
- [CurseForge](https://www.curseforge.com/minecraft/mc-mods)
- [Modrinth](https://modrinth.com/mods)

**Importante:**
- ✅ Solo archivos `.jar`
- ✅ Asegúrate que sean compatibles con tu versión de Minecraft (1.21.11)
- ✅ Verifica que sean para NeoForge o Fabric (según tu mod loader)

---

## 📁 GameFiles/config/

**Qué va aquí:** Archivos de configuración de los mods

**Ejemplo:**
```
GameFiles/config/
├── sodium-options.json
├── iris.properties
├── create-common.toml
├── jei/
│   └── jei-client.ini
└── ... (todas las configuraciones)
```

**Cómo obtenerlos:**
1. Instala los mods en tu Minecraft
2. Configura todo como quieras (opciones, keybinds, etc.)
3. Copia la carpeta `.minecraft/config/` completa aquí

**Importante:**
- ✅ Incluye subcarpetas si las hay
- ✅ Archivos comunes: `.toml`, `.json`, `.cfg`, `.properties`

---

## 📁 GameFiles/defaultconfigs/

**Qué va aquí:** Configuraciones por defecto (si las hay)

**Ejemplo:**
```
GameFiles/defaultconfigs/
├── create-server.toml
└── ... (configuraciones de servidor)
```

**Cuándo usarlo:**
- Algunos mods generan esta carpeta automáticamente
- Si no tienes esta carpeta, déjala vacía (solo con .gitkeep)

---

## 📁 GameFiles/installer/

**Qué va aquí:** El instalador de NeoForge o Fabric

**Ejemplo:**
```
GameFiles/installer/
└── neoforge-21.11.37-beta-installer.jar
```

O para Fabric:
```
GameFiles/installer/
└── fabric-installer-1.0.1.jar
```

**Dónde conseguirlo:**
- **NeoForge:** [neoforged.net](https://neoforged.net/)
- **Fabric:** [fabricmc.net](https://fabricmc.net/use/installer/)

**Importante:**
- ✅ Solo UN archivo `.jar` (el instalador)
- ✅ Debe coincidir con la versión de Minecraft que usas

---

## 📁 GameFiles/resourcepacks/

**Qué va aquí:** Paquetes de recursos (Resource Packs) en formato `.zip`

**Ejemplo:**
```
GameFiles/resourcepacks/
├── Alacrity.zip
├── FreshAnimations_v1.10.3.zip
└── ... (tus resource packs)
```

**Dónde conseguirlos:**
- [Planet Minecraft](https://www.planetminecraft.com/resources/texture-packs/)
- [CurseForge](https://www.curseforge.com/minecraft/texture-packs)

**Importante:**
- ✅ Archivos `.zip` (NO descomprimir)
- ✅ Compatibles con tu versión de Minecraft

---

## 📁 GameFiles/shaderpacks/

**Qué va aquí:** Paquetes de shaders en formato `.zip`

**Ejemplo:**
```
GameFiles/shaderpacks/
├── Bliss_v2.1.2.zip
├── ComplementaryReimagined_r5.6.1.zip
├── ComplementaryUnbound_r5.6.1.zip
└── ... (tus shaders)
```

**Dónde conseguirlos:**
- [Shader Labs](https://shaders.fandom.com/)
- [CurseForge](https://www.curseforge.com/minecraft/shaders)

**Importante:**
- ✅ Archivos `.zip` (NO descomprimir)
- ✅ Requiere Iris o Optifine instalado

---

## 📄 GameFiles/options.txt

**Qué es:** Archivo de configuración de Minecraft (opciones del juego)

**Qué contiene:**
- Configuración de video (render distance, graphics, etc.)
- Controles (keybinds)
- Configuración de audio
- Idioma
- Resource packs y shaders activados

**Cómo obtenerlo:**
1. Abre Minecraft
2. Configura todo como quieras (video, controles, etc.)
3. **Activa los resource packs y shaders que quieras que vengan por defecto**
4. Cierra Minecraft
5. Copia el archivo `.minecraft/options.txt` aquí

**Importante:**
- ✅ Este archivo hace que el instalador active automáticamente los resource packs y shaders
- ✅ Los usuarios verán exactamente la misma configuración que tú

---

## ✅ Checklist Antes de Compilar

Antes de ejecutar `3_Build_Completo.bat`, verifica:

- [ ] `GameFiles/mods/` tiene todos los archivos `.jar` de los mods
- [ ] `GameFiles/config/` tiene todas las configuraciones personalizadas
- [ ] `GameFiles/installer/` tiene el instalador de NeoForge/Fabric
- [ ] `GameFiles/resourcepacks/` tiene los resource packs (opcional)
- [ ] `GameFiles/shaderpacks/` tiene los shaders (opcional)
- [ ] `GameFiles/options.txt` existe y tiene la configuración correcta
- [ ] Todos los mods son compatibles con la misma versión de Minecraft
- [ ] Has probado que todo funciona en tu Minecraft local

---

## 🎯 Ejemplo Completo

Así debería verse tu carpeta `GameFiles/` antes de compilar:

```
GameFiles/
├── mods/
│   ├── sodium-0.5.8.jar
│   ├── iris-1.6.10.jar
│   ├── create-0.5.1.jar
│   └── ... (82 mods más)
│
├── config/
│   ├── sodium-options.json
│   ├── iris.properties
│   ├── create-common.toml
│   └── ... (todas las configs)
│
├── defaultconfigs/
│   └── .gitkeep (puede estar vacía)
│
├── installer/
│   └── neoforge-21.11.37-beta-installer.jar
│
├── resourcepacks/
│   ├── Alacrity.zip
│   └── FreshAnimations_v1.10.3.zip
│
├── shaderpacks/
│   ├── Bliss_v2.1.2.zip
│   ├── ComplementaryReimagined_r5.6.1.zip
│   └── ComplementaryUnbound_r5.6.1.zip
│
└── options.txt
```

---

## 💡 Consejos

1. **Prueba primero:** Instala todo en tu Minecraft local y asegúrate que funciona antes de crear el instalador

2. **Documenta los mods:** Crea una lista de los mods incluidos para compartir con los usuarios

3. **Versiones:** Anota las versiones exactas de cada mod por si necesitas actualizar después

4. **Licencias:** Verifica que tienes permiso para redistribuir los mods (la mayoría permiten distribución en modpacks)

---

**¿Dudas?** Revisa el `README.md` principal o contacta al creador del proyecto.
