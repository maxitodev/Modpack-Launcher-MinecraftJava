package com.maxitodev.installer;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.border.LineBorder;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;

/**
 * Interfaz gráfica del instalador usando Swing
 * Diseño Minimalista Premium con Fondo de Minecraft
 */
public class InstallerGUI extends JFrame {
    
    // Componentes de la UI
    private JProgressBar progressBar;
    private JLabel statusLabel;
    private JLabel detailLabel;
    private JTextArea logArea;
    private JTextField installPathField;
    private JButton installButton;
    private JButton browseButton;
    private JButton cancelButton;
    private InstallProcess installProcess;
    private BufferedImage backgroundImage;
    
    // Paleta (Ajustada para fondo)
    // Fondo base transparente para sub-paneles y color negro semitransparente para inputs
    private static final Color SURFACE_COLOR = new Color(0, 0, 0, 150);   // Negro semitransparente para inputs
    private static final Color TEXT_PRIMARY = new Color(255, 255, 255); 
    private static final Color TEXT_SECONDARY = new Color(200, 200, 200);
    private static final Color BORDER_COLOR = new Color(255, 255, 255, 50); // Borde sutil blanco
    
    // Fuentes
    private final Font TITLE_FONT = new Font("Segoe UI", Font.BOLD, 24);
    private final Font TEXT_FONT = new Font("Segoe UI", Font.PLAIN, 12);
    private final Font MONO_FONT = new Font("Consolas", Font.PLAIN, 11);
    
    public InstallerGUI() {
        // Cargar imagen de fondo de manera robusta
        try {
            // Intentar cargar desde el classpath (dentro del JAR)
            java.io.InputStream is = getClass().getResourceAsStream("/resources/bg.png");
            if (is == null) {
                // Intento alternativo sin slash inicial
                is = getClass().getClassLoader().getResourceAsStream("resources/bg.png");
            }
            
            if (is != null) {
                backgroundImage = ImageIO.read(is);
            } else {
                System.err.println("⚠ No se encontró la imagen de fondo en resources/bg.png");
            }
        } catch (Exception e) {
            System.err.println("Error cargando fondo: " + e.getMessage());
            e.printStackTrace();
        }
        
        this.installProcess = new InstallProcess(this);
        initializeUI();
    }
    
    private void initializeUI() {
        setTitle("Modpack Installer");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(550, 500); 
        setLocationRelativeTo(null);
        setResizable(false);
        
        // Usar Panel con Fondo
        setContentPane(new BackgroundPanel());
        setLayout(new BorderLayout(0, 20));
        
        // Layout principal
        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new BorderLayout(0, 20));
        mainPanel.setOpaque(false); // Transparente
        mainPanel.setBorder(new EmptyBorder(25, 30, 25, 30)); 
        
        mainPanel.add(createHeader(), BorderLayout.NORTH);
        mainPanel.add(createCenterPanel(), BorderLayout.CENTER);
        mainPanel.add(createButtons(), BorderLayout.SOUTH);
        
        add(mainPanel);
    }
    
    // Panel personalizado para pintar el fondo
    private class BackgroundPanel extends JPanel {
        @Override
        protected void paintComponent(Graphics g) {
            super.paintComponent(g);
            if (backgroundImage != null) {
                // Pintar imagen escalada (cover)
                g.drawImage(backgroundImage, 0, 0, getWidth(), getHeight(), this);
                
                // Overlay oscuro (Dimming)
                g.setColor(new Color(0, 0, 0, 180)); // 70-80% opacidad negra
                g.fillRect(0, 0, getWidth(), getHeight());
            } else {
                g.setColor(new Color(18, 18, 18));
                g.fillRect(0, 0, getWidth(), getHeight());
            }
        }
    }
    
    private JPanel createHeader() {
        JPanel header = new JPanel(new BorderLayout());
        header.setOpaque(false);
        
        JLabel title = new JLabel("Modpack Installer", SwingConstants.CENTER); 
        title.setFont(TITLE_FONT);
        title.setForeground(TEXT_PRIMARY);
        
        JLabel subtitle = new JLabel("by MaxitoDev • v" + Main.VERSION, SwingConstants.CENTER); 
        subtitle.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        subtitle.setForeground(TEXT_SECONDARY);
        
        header.add(title, BorderLayout.CENTER);
        header.add(subtitle, BorderLayout.SOUTH);
        return header;
    }
    
    private JPanel createCenterPanel() {
        JPanel center = new JPanel();
        center.setLayout(new BoxLayout(center, BoxLayout.Y_AXIS));
        center.setOpaque(false);
        
        center.add(createPathSelector());
        center.add(Box.createVerticalStrut(20));
        center.add(createProgressSection());
        center.add(Box.createVerticalStrut(15));
        center.add(createLogSection());
        
        return center;
    }
    
    private JPanel createPathSelector() {
        JPanel panel = new JPanel(new BorderLayout(10, 5));
        panel.setOpaque(false);
        panel.setMaximumSize(new Dimension(Integer.MAX_VALUE, 50));
        
        JLabel label = new JLabel("Ubicación de instalación");
        label.setFont(TEXT_FONT);
        label.setForeground(TEXT_SECONDARY);
        
        installPathField = new JTextField();
        installPathField.setBackground(SURFACE_COLOR);
        installPathField.setForeground(TEXT_PRIMARY);
        installPathField.setCaretColor(TEXT_PRIMARY);
        installPathField.setBorder(BorderFactory.createCompoundBorder(
            new LineBorder(BORDER_COLOR, 1),
            new EmptyBorder(8, 8, 8, 8)
        ));
        installPathField.setFont(TEXT_FONT);
        installPathField.setText(System.getenv("APPDATA") + "\\.minecraft");
        
        browseButton = createSmallButton("...");
        browseButton.addActionListener(e -> browseFolder());
        
        JPanel inputPanel = new JPanel(new BorderLayout(10, 0));
        inputPanel.setOpaque(false);
        inputPanel.add(installPathField, BorderLayout.CENTER);
        inputPanel.add(browseButton, BorderLayout.EAST);
        
        panel.add(label, BorderLayout.NORTH);
        panel.add(inputPanel, BorderLayout.CENTER);
        
        return panel;
    }
    
    private JPanel createProgressSection() {
        JPanel panel = new JPanel(new BorderLayout(0, 5));
        panel.setOpaque(false);
        panel.setMaximumSize(new Dimension(Integer.MAX_VALUE, 40));
        
        progressBar = new JProgressBar(0, 100);
        progressBar.setValue(0);
        progressBar.setStringPainted(false); 
        progressBar.setBackground(new Color(255, 255, 255, 30)); // Fondo de barra sutil
        progressBar.setForeground(TEXT_PRIMARY); 
        progressBar.setBorderPainted(false);
        progressBar.setPreferredSize(new Dimension(100, 6)); 
        
        JPanel labels = new JPanel(new BorderLayout());
        labels.setOpaque(false);
        
        statusLabel = new JLabel("Listo");
        statusLabel.setFont(new Font("Segoe UI", Font.BOLD, 12));
        statusLabel.setForeground(TEXT_PRIMARY);
        
        detailLabel = new JLabel("0%");
        detailLabel.setFont(TEXT_FONT);
        detailLabel.setForeground(TEXT_SECONDARY);
        
        labels.add(statusLabel, BorderLayout.WEST);
        labels.add(detailLabel, BorderLayout.EAST);
        
        panel.add(labels, BorderLayout.NORTH);
        panel.add(progressBar, BorderLayout.CENTER);
        
        return panel;
    }
    
    private JPanel createLogSection() {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setOpaque(false);
        
        logArea = new JTextArea();
        logArea.setEditable(false);
        logArea.setBackground(SURFACE_COLOR);
        logArea.setForeground(new Color(220, 220, 220));
        logArea.setFont(MONO_FONT);
        logArea.setMargin(new Insets(5, 5, 5, 5));
        logArea.setBorder(null); // Sin borde interno
        
        JScrollPane scroll = new JScrollPane(logArea);
        scroll.setBorder(new LineBorder(BORDER_COLOR, 1));
        scroll.getVerticalScrollBar().setPreferredSize(new Dimension(8, 0)); 
        scroll.getViewport().setOpaque(false);
        scroll.setOpaque(false); // Transparente para que se vea el fondo oscuro de logArea
        
        panel.add(scroll, BorderLayout.CENTER);
        return panel;
    }
    
    private JPanel createButtons() {
        JPanel panel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 15, 0));
        panel.setOpaque(false);
        
        RoundedButton btnCancel = new RoundedButton("Salir", new Color(255, 255, 255, 20), TEXT_SECONDARY);
        btnCancel.setBorderColor(new Color(255, 255, 255, 100)); // Borde blanco sutil
        btnCancel.setPreferredSize(new Dimension(100, 40));
        btnCancel.addActionListener(e -> {
            if (installProcess.isInstalling()) installProcess.cancel();
            else System.exit(0);
        });
        cancelButton = btnCancel;
        
        RoundedButton btnInstall = new RoundedButton("INSTALAR", Color.WHITE, Color.BLACK);
        btnInstall.setFont(new Font("Segoe UI", Font.BOLD, 13));
        btnInstall.setPreferredSize(new Dimension(140, 40));
        btnInstall.setHoverColor(new Color(220, 220, 220)); 
        btnInstall.addActionListener(e -> startInstallation());
        installButton = btnInstall;
        
        panel.add(cancelButton);
        panel.add(installButton);
        return panel;
    }
    
    // Botón personalizado
    private static class RoundedButton extends JButton {
        private Color bgColor;
        private Color fgColor;
        private Color hoverColor;
        private Color borderColor;
        private int radius = 20; 
        
        public RoundedButton(String text, Color bg, Color fg) {
            super(text);
            this.bgColor = bg;
            this.fgColor = fg;
            this.hoverColor = new Color(Math.min(255, bg.getRed()+30), Math.min(255, bg.getGreen()+30), Math.min(255, bg.getBlue()+30), bg.getAlpha());
            if (bg.equals(Color.WHITE)) this.hoverColor = new Color(230, 230, 230);
            
            setBackground(bg);
            setContentAreaFilled(false);
            setFocusPainted(false);
            setBorderPainted(false);
            setOpaque(false);
            setForeground(fg);
            setFont(new Font("Segoe UI", Font.PLAIN, 12));
            setCursor(new Cursor(Cursor.HAND_CURSOR));
            
            addMouseListener(new java.awt.event.MouseAdapter() {
                public void mouseEntered(java.awt.event.MouseEvent evt) {
                    if (isEnabled()) {
                        setBackground(hoverColor);
                        repaint();
                    }
                }
                public void mouseExited(java.awt.event.MouseEvent evt) {
                    if (isEnabled()) {
                        setBackground(bgColor);
                        repaint();
                    }
                }
            });
        }
        
        public void setHoverColor(Color color) {
            this.hoverColor = color;
        }
        
        public void setBorderColor(Color color) {
            this.borderColor = color;
        }
        
        @Override
        protected void paintComponent(Graphics g) {
            Graphics2D g2 = (Graphics2D) g.create();
            g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            
            if (getModel().isPressed()) {
                g2.setColor(getBackground().darker());
            } else if (getModel().isRollover()) {
                g2.setColor(hoverColor != null ? hoverColor : getBackground());
            } else {
                g2.setColor(getBackground());
            }
            g2.fillRoundRect(0, 0, getWidth(), getHeight(), radius, radius);
            
            if (borderColor != null) {
                g2.setColor(borderColor);
                g2.setStroke(new BasicStroke(1.5f));
                g2.drawRoundRect(0, 0, getWidth()-1, getHeight()-1, radius, radius);
            }
            
            g2.dispose();
            super.paintComponent(g);
        }
    }
    
    private JButton createSmallButton(String text) {
        RoundedButton btn = new RoundedButton(text, SURFACE_COLOR, TEXT_PRIMARY);
        btn.radius = 10;
        btn.setPreferredSize(new Dimension(40, 35));
        btn.setBorderColor(BORDER_COLOR);
        return btn;
    }

    private void browseFolder() {
        JFileChooser chooser = new JFileChooser();
        chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
        
        File currentPath = new File(installPathField.getText());
        if (currentPath.exists()) chooser.setCurrentDirectory(currentPath);
        
        if (chooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
            installPathField.setText(chooser.getSelectedFile().getAbsolutePath());
        }
    }
    
    private void startInstallation() {
        File installDir = new File(installPathField.getText());
        if (!installDir.exists() && !installDir.mkdirs()) {
            JOptionPane.showMessageDialog(this, "Ruta inválida", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }
        
        installButton.setEnabled(false);
        installPathField.setEnabled(false);
        browseButton.setEnabled(false);
        cancelButton.setText("Cancelar");
        
        installProcess.install(installDir.getAbsolutePath());
    }
    
    public void updateProgress(int progress) {
        SwingUtilities.invokeLater(() -> {
            progressBar.setValue(progress);
            detailLabel.setText(progress + "%");
        });
    }
    
    public void updateStatus(String status) {
        SwingUtilities.invokeLater(() -> statusLabel.setText(status));
    }
    
    public void updateDetail(String detail) {
        appendLog("> " + detail);
    }
    
    public void appendLog(String message) {
        SwingUtilities.invokeLater(() -> {
            logArea.append(message + "\n");
            logArea.setCaretPosition(logArea.getDocument().getLength());
        });
    }
    
    public void onInstallComplete(boolean success) {
        SwingUtilities.invokeLater(() -> {
            installButton.setEnabled(false);
            cancelButton.setText("Cerrar");
            cancelButton.setEnabled(true);
            
            if (success) {
                updateStatus("Instalación Completada");
                progressBar.setForeground(new Color(63, 185, 80)); 
                JOptionPane.showMessageDialog(this, "Instalación completada exitosamente.", "Éxito", JOptionPane.INFORMATION_MESSAGE);
            } else {
                updateStatus("Error en la instalación");
                progressBar.setForeground(new Color(185, 63, 63)); 
            }
        });
    }
}
