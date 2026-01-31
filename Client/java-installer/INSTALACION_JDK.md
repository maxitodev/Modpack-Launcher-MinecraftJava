# 🚀 Guía Rápida de Instalación del JDK

## ¿Qué es el JDK?

**JDK (Java Development Kit)** es el kit de desarrollo de Java que incluye:
- ✅ **JRE** (Java Runtime Environment) - Para ejecutar programas Java
- ✅ **javac** - Compilador de Java
- ✅ **jar** - Herramienta para crear archivos JAR
- ✅ Otras herramientas de desarrollo

## Instalación Automática (Recomendado)

Ya se está instalando automáticamente con winget. Espera a que termine.

## Instalación Manual (Si falla la automática)

### Opción 1: Oracle JDK (Oficial)

1. Ve a: https://www.oracle.com/java/technologies/downloads/
2. Descarga: **Java 24** o **Java 21 LTS**
3. Ejecuta el instalador
4. Sigue las instrucciones

### Opción 2: Eclipse Temurin (OpenJDK - Gratis)

1. Ve a: https://adoptium.net/
2. Descarga: **JDK 21 LTS** (recomendado)
3. Ejecuta el instalador
4. **IMPORTANTE**: Marca la opción "Add to PATH"

### Opción 3: Usando winget (Línea de comandos)

```powershell
# Oracle JDK 24
winget install Oracle.JDK.24

# O Eclipse Temurin (OpenJDK)
winget install EclipseAdoptium.Temurin.21.JDK
```

## Verificar Instalación

Después de instalar, abre una **nueva** terminal PowerShell y ejecuta:

```powershell
java -version
javac -version
```

Deberías ver algo como:
```
java version "24.0.2" 2025-04-15
javac 24.0.2
```

## Compilar el Instalador

Una vez instalado el JDK:

```powershell
# Opción 1: Usar el script PowerShell (recomendado)
.\build.ps1

# Opción 2: Usar el script BAT
.\build.bat
```

## Solución de Problemas

### "javac no se reconoce como comando"

**Solución**: Cierra y abre una nueva terminal después de instalar el JDK.

### "jar no se reconoce como comando"

**Solución**: Usa `build.ps1` en lugar de `build.bat` - no requiere la herramienta jar.

### El instalador no compila

1. Verifica que tienes el **JDK** (no solo JRE)
2. Cierra todas las terminales
3. Abre una nueva terminal PowerShell
4. Ejecuta: `.\build.ps1`

## ¿Qué sigue?

Una vez compilado:

1. **Probar**: `.\run.bat` - Ejecuta el instalador
2. **Empaquetar**: `.\package.bat` - Crea el ZIP para distribuir

---

**¿Necesitas ayuda?** Revisa el README.md principal.
