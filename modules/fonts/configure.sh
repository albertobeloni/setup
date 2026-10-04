post()
{
	command gsettings set org.gnome.desktop.interface font-name "Adwaita Sans 10"
	command gsettings set org.gnome.desktop.interface document-font-name "Adwaita Sans 10"
	command gsettings set org.gnome.desktop.interface monospace-font-name "Adwaita Mono 10"
	command gsettings set org.gnome.desktop.interface font-antialiasing "rgba"
	command gsettings set org.gnome.desktop.interface font-hinting "slight"
	command gsettings set org.gnome.desktop.interface font-rendering "manual"
	command gsettings set org.gnome.desktop.interface font-rgba-order "rgb"

	command fc-cache -f
}
