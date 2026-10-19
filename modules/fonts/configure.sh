post()
{
	if changes
	then
		command local directory

		directory="/etc/fonts/conf.d"

		command sudo mkdir -p "${directory}"
		command sudo ln -s "/usr/share/fontconfig/conf.avail/10-yes-antialias.conf" "${directory}/"
		command sudo ln -s "/usr/share/fontconfig/conf.avail/10-hinting-slight.conf" "${directory}/"
		command sudo ln -s "/usr/share/fontconfig/conf.avail/10-sub-pixel-none.conf" "${directory}/"
		command sudo ln -s "/usr/share/fontconfig/conf.avail/11-lcdfilter-none.conf" "${directory}/"

		directory="${XDG_CONFIG_HOME:-${HOME}/.local/config}/fontconfig/conf.d"

		command mkdir -p "${directory}"
		command ln -sf "/usr/share/fontconfig/conf.avail/10-yes-antialias.conf" "${directory}/10-antialias.conf"
		command ln -sf "/usr/share/fontconfig/conf.avail/10-hinting-slight.conf" "${directory}/10-hinting.conf"
		command ln -sf "/usr/share/fontconfig/conf.avail/10-sub-pixel-none.conf" "${directory}/10-sub-pixel.conf"
		command ln -sf "/usr/share/fontconfig/conf.avail/11-lcdfilter-none.conf" "${directory}/11-lcdfilter.conf"

		command unset -v directory

		command fc-cache -fv
	fi
}
