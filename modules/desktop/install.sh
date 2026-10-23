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
distribution arch && flathub org.gnome.Decibels org.gnome.Calculator org.gnome.Calendar org.gnome.Snapshot org.gnome.clocks org.gnome.Papers org.gnome.font-viewer org.gnome.Loupe org.gnome.Logs org.gnome.Maps org.gnome.Music org.gnome.TextEditor org.gnome.Showtime org.gnome.Weather

# distribution arch && packages evolution-data-server
# distribution arch && flathub org.gnome.Contacts
