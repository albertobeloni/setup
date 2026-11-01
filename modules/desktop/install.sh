# ------------------------------------------------------------------------------
# Desktop
# ------------------------------------------------------------------------------

#
# Boot
#

distribution arch && packages plymouth

#
# Wayland Compositor
#

distribution arch && aur umbriel-git
distribution arch && aur xdg-desktop-portal-umbriel-git
distribution arch && packages xdg-desktop-portal-gnome

#
# Shell and Greeter
#

distribution arch && packages noctalia
distribution arch && packages noctalia-greeter

#
# XDG Directories
#

distribution arch && packages xdg-user-dirs
distribution arch && packages xdg-user-dirs-gtk

#
# Support
#

distribution arch && packages brightnessctl
distribution arch && packages ddcutil
distribution arch && packages ffmpeg
distribution arch && packages pipewire-alsa
distribution arch && packages pipewire-pulse
distribution arch && packages playerctl
distribution arch && packages rtkit
distribution arch && packages wireplumber
distribution arch && packages wl-clipboard

#
# Themes
#

distribution arch && packages papirus-icon-theme
distribution arch && packages sound-theme-freedesktop
