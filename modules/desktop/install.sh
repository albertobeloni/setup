# ------------------------------------------------------------------------------
# Desktop
# ------------------------------------------------------------------------------

#
# Boot
#

distribution arch && packages plymouth

#
# Shell and Greeter
#

distribution arch && packages noctalia noctalia-greeter

#
# XDG Directories
#

distribution arch && packages xdg-user-dirs

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
# Wayland Compositor
#

distribution arch && aur umbriel-git xdg-desktop-portal-umbriel-git

#
# Themes
#

distribution arch && packages papirus-icon-theme
distribution arch && packages sound-theme-freedesktop
