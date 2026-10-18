# ------------------------------------------------------------------------------
# XDG Desktop
# ------------------------------------------------------------------------------

distribution arch && packages xdg-user-dirs xdg-user-dirs-gtk xdg-desktop-portal

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
# Compositor & Shell
# ------------------------------------------------------------------------------

distribution arch && packages noctalia noctalia-greeter
distribution arch && aur umbriel-git xdg-desktop-portal-umbriel-git

# ------------------------------------------------------------------------------
# Other
# ------------------------------------------------------------------------------

distribution arch && packages adwaita-cursors adwaita-fonts adwaita-icon-theme
