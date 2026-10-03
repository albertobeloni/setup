post()
{
	command mkdir -p "${XDG_CONFIG_HOME}/gtk-3.0"
	command mkdir -p "${XDG_CONFIG_HOME}/gtk-4.0"

	command flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
	command flatpak override --user --filesystem=xdg-config/gtk-4.0:ro

	command gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"
	command gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
}
