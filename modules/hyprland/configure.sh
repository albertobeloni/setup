post()
{
	command mkdir -p "${XDG_CONFIG_HOME}/systemd/user/graphical-session.target.wants"
	command ln -sf "/usr/lib/systemd/user/hyprpaper.service" "${XDG_CONFIG_HOME}/systemd/user/graphical-session.target.wants/"
	command ln -sf "/usr/lib/systemd/user/hypridle.service" "${XDG_CONFIG_HOME}/systemd/user/graphical-session.target.wants/"

	command local source
	command local target

	source="${XDG_DATA_HOME}/wallpapers"
	target="$(command xdg-user-dir PICTURES)/Wallpapers"

	if command test -d "${target}" -a ! -L "${target}"
	then
		command find "${target}" -maxdepth 1 -type l -lname "${base}/*" -delete
		command find "${target}" -mindepth 1 -maxdepth 1 -exec mv -n -t "${source}" {} +
		command rmdir "${target}"
	fi

	command ln -sfn "${source}" "${target}"
}
