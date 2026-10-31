post()
{
	command local directory

	directory="/etc/fonts/conf.d"

	command sudo mkdir -p "${directory}"
	command sudo ln -sf "/usr/share/fontconfig/conf.avail/10-yes-antialias.conf" "${directory}/"
	command sudo ln -sf "/usr/share/fontconfig/conf.avail/10-hinting-slight.conf" "${directory}/"
	command sudo ln -sf "/usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf" "${directory}/"
	command sudo ln -sf "/usr/share/fontconfig/conf.avail/11-lcdfilter-default.conf" "${directory}/"

	directory="${XDG_CONFIG_HOME:-${HOME}/.local/config}/fontconfig/conf.d"

	command mkdir -p "${directory}"
	command ln -sf "/usr/share/fontconfig/conf.avail/10-yes-antialias.conf" "${directory}/10-antialias.conf"
	command ln -sf "/usr/share/fontconfig/conf.avail/10-hinting-slight.conf" "${directory}/10-hinting.conf"
	command ln -sf "/usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf" "${directory}/10-sub-pixel.conf"
	command ln -sf "/usr/share/fontconfig/conf.avail/11-lcdfilter-default.conf" "${directory}/11-lcdfilter.conf"

	command unset -v directory

	#
	# GTK rendering settings
	#

	command gsettings set org.gnome.desktop.interface font-antialiasing "rgba"
	command gsettings set org.gnome.desktop.interface font-hinting "slight"
	command gsettings set org.gnome.desktop.interface font-rgba-order "rgb"

	command gsettings set org.gnome.desktop.interface font-name "sans-serif 9"
	command gsettings set org.gnome.desktop.interface document-font-name "sans-serif 9"
	command gsettings set org.gnome.desktop.interface monospace-font-name "monospace 9"

	command fc-cache -fv
}
