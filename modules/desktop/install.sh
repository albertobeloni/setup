# ------------------------------------------------------------------------------
# XDG Desktop
# ------------------------------------------------------------------------------

distribution arch && packages xdg-user-dirs xdg-user-dirs-gtk
distribution arch && packages xdg-desktop-portal-gtk xdg-desktop-portal-gnome

# ------------------------------------------------------------------------------
# System Control
# ------------------------------------------------------------------------------

distribution arch && packages brightnessctl playerctl accountsservice

# ------------------------------------------------------------------------------
# Clipboard
# ------------------------------------------------------------------------------

distribution arch && packages wl-clipboard

# ------------------------------------------------------------------------------
# Screenshot & Screencast
# ------------------------------------------------------------------------------

distribution arch && packages grim slurp

# ------------------------------------------------------------------------------
# Compositor
# ------------------------------------------------------------------------------

distribution arch && packages niri
distribution arch && aur libastal-niri-git

# ------------------------------------------------------------------------------
# Other
# ------------------------------------------------------------------------------

distribution arch && packages adwaita-cursors adwaita-fonts adwaita-icon-theme
distribution arch && packages papirus-icon-theme
