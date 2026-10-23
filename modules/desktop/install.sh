# ------------------------------------------------------------------------------
# XDG Desktop
# ------------------------------------------------------------------------------

distribution arch && packages xdg-user-dirs xdg-user-dirs-gtk
distribution arch && packages xdg-desktop-portal-gtk xdg-desktop-portal-gnome

# ------------------------------------------------------------------------------
# System Control
# ------------------------------------------------------------------------------

distribution arch && packages brightnessctl ddcutil playerctl accountsservice

# ------------------------------------------------------------------------------
# Clipboard
# ------------------------------------------------------------------------------

distribution arch && packages wl-clipboard

# ------------------------------------------------------------------------------
# Secret Service Provider
# ------------------------------------------------------------------------------

distribution arch && packages oo7

# ------------------------------------------------------------------------------
# Screenshot & Screencast
# ------------------------------------------------------------------------------

# distribution arch && packages grim slurp

# ------------------------------------------------------------------------------
# Compositor
# ------------------------------------------------------------------------------

distribution arch && packages noctalia noctalia-greeter
distribution arch && aur umbriel-git xdg-desktop-portal-umbriel-git

# ------------------------------------------------------------------------------
# Other
# ------------------------------------------------------------------------------

distribution arch && packages adwaita-cursors adwaita-fonts adwaita-icon-theme
distribution arch && packages papirus-icon-theme
distribution arch && packages sound-theme-freedesktop

# ------------------------------------------------------------------------------
# Software
# ------------------------------------------------------------------------------

distribution arch && packages nautilus gnome-software gnome-system-monitor

distribution arch && flathub org.gnome.Decibels
distribution arch && flathub org.gnome.Calculator
distribution arch && flathub org.gnome.Calendar
distribution arch && flathub org.gnome.Snapshot
distribution arch && flathub org.gnome.clocks
distribution arch && flathub org.gnome.Papers
distribution arch && flathub org.gnome.font-viewer
distribution arch && flathub org.gnome.Loupe
distribution arch && flathub org.gnome.Logs
distribution arch && flathub org.gnome.Maps
distribution arch && flathub org.gnome.Music
distribution arch && flathub org.gnome.TextEditor
distribution arch && flathub org.gnome.Showtime
distribution arch && flathub org.gnome.Weather
distribution arch && flathub org.gnome.SoundRecorder

# distribution arch && packages evolution-data-server
# distribution arch && flathub org.gnome.Contacts
