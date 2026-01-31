package com.maxitodev.installer;

import javax.swing.SwingUtilities;
import javax.swing.UIManager;

/**
 * MaxitoDev Modpack Installer
 * Instalador profesional para Minecraft 1.21.11
 * 
 * @author MaxitoDev
 * @version 1.0.0
 */
public class Main {
    
    public static final String VERSION = "1.0.0";
    
    // ==========================================
    // CONFIGURACIÓN DE VERSIONES (EDITAR AQUÍ)
    // ==========================================
    public static final String MC_VERSION = "1.21.11";     // Versión de Minecraft
    public static final String LOADER_VERSION = "0.18.4"; // Versión de Fabric
    
    public static void main(String[] args) {
        // Configurar Look and Feel del sistema
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Iniciar interfaz gráfica en el hilo de eventos de Swing
        SwingUtilities.invokeLater(() -> {
            InstallerGUI gui = new InstallerGUI();
            gui.setVisible(true);
        });
    }
}
