package com.maxitodev.installer;

import java.io.*;
import java.nio.file.*;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Proceso de instalación del modpack
 * Ejecuta el instalador de mod loader y copia archivos
 */
public class InstallProcess {
    
    private InstallerGUI gui;
    private AtomicBoolean installing = new AtomicBoolean(false);
    private AtomicBoolean cancelled = new AtomicBoolean(false);
    
    public InstallProcess(InstallerGUI gui) {
        this.gui = gui;
    }
    
    public void install(String installPath) {
        if (installing.get()) {
            return;
        }
        
        installing.set(true);
        cancelled.set(false);
        
        // Ejecutar en un hilo separado para no bloquear la UI
        new Thread(() -> {
            try {
                runInstallation(installPath);
            } catch (Exception e) {
                gui.appendLog("ERROR: " + e.getMessage());
                e.printStackTrace();
                gui.onInstallComplete(false);
            } finally {
                installing.set(false);
            }
        }).start();
    }
    
    private void runInstallation(String installPath) throws Exception {
        gui.updateProgress(0);
        gui.updateStatus("🔍 Verificando requisitos...");
        gui.appendLog("=== Iniciando instalación ===");
        gui.appendLog("Ruta de instalación: " + installPath);
        
        if (cancelled.get()) return;
        
        // Paso 1: Verificar Java
        gui.updateProgress(10);
        gui.updateStatus("☕ Verificando Java...");
        gui.appendLog("Verificando versión de Java...");
        
        String javaVersion = System.getProperty("java.version");
        gui.appendLog("Java detectado: " + javaVersion);
        
        Thread.sleep(500);
        
        if (cancelled.get()) return;
        
        // Paso 2: Buscar archivos del modpack
        gui.updateProgress(20);
        gui.updateStatus("📦 Buscando archivos del modpack...");
        gui.appendLog("Buscando carpeta GameFiles...");
        
        File gameFilesDir = findGameFilesDirectory();
        if (gameFilesDir == null || !gameFilesDir.exists()) {
            gui.appendLog("ERROR: No se encontró la carpeta GameFiles");
            gui.appendLog("Asegúrate de extraer todo el contenido del ZIP");
            gui.onInstallComplete(false);
            return;
        }
        
        gui.appendLog("GameFiles encontrado: " + gameFilesDir.getAbsolutePath());
        
        if (cancelled.get()) return;
        
        // Paso 3: Detectar e instalar mod loader
        gui.updateProgress(30);
        gui.updateStatus("🔧 Detectando mod loader...");
        gui.appendLog("Buscando instalador de mod loader...");
        
        File installerDir = new File(gameFilesDir, "installer");
        File[] installers = installerDir.listFiles((dir, name) -> name.endsWith(".jar"));
        
        String modLoaderName = "Desconocido";
        // String modLoaderVersion eliminada aquí, se define más abajo desde Main
        
        if (installers != null && installers.length > 0) {
            File installerJar = installers[0];
            String installerName = installerJar.getName().toLowerCase();
            
            // Detectar tipo de mod loader (solo tipo, la versión ya la tenemos en Main)
            if (installerName.contains("neoforge")) {
                modLoaderName = "NeoForge";
            } else if (installerName.contains("forge")) {
                modLoaderName = "Forge";
            } else if (installerName.contains("fabric")) {
                modLoaderName = "Fabric";
            } else if (installerName.contains("quilt")) {
                modLoaderName = "Quilt";
            }
            
            // Usar versiones definidas en Main.java
            String modLoaderVersion = Main.LOADER_VERSION;
            String fullModLoaderName = modLoaderName + " " + modLoaderVersion;
            
            gui.appendLog("mod loader detectado: " + modLoaderName);
            gui.appendLog("Instalador encontrado: " + installerJar.getName());
            gui.updateStatus("🔧 Instalando " + fullModLoaderName + "...");
            gui.appendLog("Ejecutando instalador en modo headless...");

            // Mostrar información explícita sobre las versiones QUE SE USARÁN
            gui.appendLog("--------------------------------------------------");
            gui.appendLog("🔎 CONFIGURACIÓN:");
            gui.appendLog("   • Minecraft: " + Main.MC_VERSION);
            gui.appendLog("   • Loader Objetivo: " + Main.LOADER_VERSION);
            gui.appendLog("   • Archivo Instalador: " + installerJar.getName());
            gui.appendLog("--------------------------------------------------");
            
            ProcessBuilder pb;
            
            // Configurar argumentos según el tipo de mod loader
            if (modLoaderName.equals("Fabric")) {
                // Fabric: modo headless con parámetros manuales
                pb = new ProcessBuilder(
                    "java", "-jar", installerJar.getAbsolutePath(),
                    "client",
                    "-dir", installPath,
                    "-mcversion", Main.MC_VERSION,
                    "-loader", Main.LOADER_VERSION // <--- Usar versión manual
                );
                gui.appendLog("🚀 Ejecutando Fabric (Manual Configuration)...");
            } else {
                // NeoForge/Forge: modo headless
                pb = new ProcessBuilder(
                    "java", "-jar", installerJar.getAbsolutePath(),
                    "--installClient", installPath
                );
                gui.appendLog("Modo: " + modLoaderName + " headless");
            }
            
            pb.redirectErrorStream(true);
            Process process = pb.start();
            
            // Leer output del instalador
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    gui.appendLog("[Instalador] " + line);
                }
            }
            
            int exitCode = process.waitFor();
            if (exitCode == 0) {
                gui.appendLog("✓ " + modLoaderName + " instalado correctamente");
            } else {
                gui.appendLog("⚠ El instalador terminó con código: " + exitCode);
            }
        } else {
            gui.appendLog("⚠ No se encontró instalador de mod loader");
        }
        
        Thread.sleep(1000);
        
        if (cancelled.get()) return;
        
        // Paso 4: Copiar mods
        gui.updateProgress(50);
        gui.updateStatus("📦 Copiando mods...");
        copyDirectory(new File(gameFilesDir, "mods"), new File(installPath, "mods"), "mods");
        
        if (cancelled.get()) return;
        
        // Paso 5: Copiar configuraciones
        gui.updateProgress(60);
        gui.updateStatus("⚙️ Copiando configuraciones...");
        copyDirectory(new File(gameFilesDir, "config"), new File(installPath, "config"), "config");
        
        if (cancelled.get()) return;
        
        // Paso 6: Copiar resource packs
        gui.updateProgress(70);
        gui.updateStatus("🎨 Copiando resource packs...");
        copyDirectory(new File(gameFilesDir, "resourcepacks"), new File(installPath, "resourcepacks"), "resource packs");
        
        if (cancelled.get()) return;
        
        // Paso 7: Copiar shaders
        gui.updateProgress(80);
        gui.updateStatus("✨ Copiando shaders...");
        copyDirectory(new File(gameFilesDir, "shaderpacks"), new File(installPath, "shaderpacks"), "shaders");
        
        if (cancelled.get()) return;
        
        // Paso 8: Copiar options.txt
        gui.updateProgress(90);
        gui.updateStatus("📝 Configurando opciones...");
        File optionsFile = new File(gameFilesDir, "options.txt");
        if (optionsFile.exists()) {
            Files.copy(optionsFile.toPath(), 
                      new File(installPath, "options.txt").toPath(),
                      StandardCopyOption.REPLACE_EXISTING);
            gui.appendLog("✓ options.txt copiado");
        }
        
        if (cancelled.get()) return;
        
        // Paso 9: Finalizar
        gui.updateProgress(100);
        gui.updateStatus("✅ Instalación completada");
        gui.appendLog("=== Instalación completada exitosamente ===");
        gui.appendLog("¡Abre Minecraft Launcher y disfruta!");
        
        Thread.sleep(500);
        
        gui.onInstallComplete(true);
    }
    
    private File findGameFilesDirectory() {
        // Buscar GameFiles en varias ubicaciones posibles
        String[] possiblePaths = {
            "../../GameFiles",           // Relativo al jar
            "../../../GameFiles",        // Si está en build/
            "GameFiles",                 // Mismo directorio
            "../GameFiles"               // Un nivel arriba
        };
        
        for (String path : possiblePaths) {
            File dir = new File(path);
            if (dir.exists() && dir.isDirectory()) {
                return dir;
            }
        }
        
        return null;
    }
    
    private void copyDirectory(File source, File target, String name) throws IOException {
        if (!source.exists()) {
            gui.appendLog("⚠ Carpeta " + name + " no encontrada, omitiendo...");
            return;
        }
        
        if (!target.exists()) {
            target.mkdirs();
        }
        
        File[] files = source.listFiles();
        if (files == null) return;
        
        int total = files.length;
        int copied = 0;
        
        gui.appendLog("Copiando " + total + " archivos de " + name + "...");
        
        for (File file : files) {
            if (cancelled.get()) return;
            
            File targetFile = new File(target, file.getName());
            
            if (file.isDirectory()) {
                copyDirectory(file, targetFile, name);
            } else {
                Files.copy(file.toPath(), targetFile.toPath(), 
                          StandardCopyOption.REPLACE_EXISTING);
                copied++;
                
                if (copied % 10 == 0 || copied == total) {
                    gui.updateDetail(String.format("Copiando %s (%d/%d)", name, copied, total));
                }
            }
        }
        
        gui.appendLog("✓ " + copied + " archivos de " + name + " copiados");
    }
    
    public boolean isInstalling() {
        return installing.get();
    }
    
    public void cancel() {
        if (installing.get()) {
            cancelled.set(true);
            gui.appendLog("⚠ Instalación cancelada por el usuario");
            gui.updateStatus("❌ Instalación cancelada");
            gui.onInstallComplete(false);
        }
    }
}
