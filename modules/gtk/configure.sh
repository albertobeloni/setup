post()
{
	command flatpak override --user --filesystem=xdg-data/setup/modules/gtk/home/.local/config/gtk-3.0:ro
	command flatpak override --user --filesystem=xdg-data/setup/modules/gtk/home/.local/config/gtk-4.0:ro
	command flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
	command flatpak override --user --filesystem=xdg-config/gtk-4.0:ro

	command gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"
	command gsettings set org.gnome.desktop.interface icon-theme "Adwaita"
	command gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"
	command gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
	command gsettings set org.gnome.desktop.wm.preferences button-layout ":"
}
