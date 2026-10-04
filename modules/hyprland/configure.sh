post()
{
	command mkdir -p "${XDG_CONFIG_HOME}/systemd/user/graphical-session.target.wants"
	command ln -sf "/usr/lib/systemd/user/hyprpaper.service" "${XDG_CONFIG_HOME}/systemd/user/graphical-session.target.wants/"
	command ln -sf "/usr/lib/systemd/user/hypridle.service" "${XDG_CONFIG_HOME}/systemd/user/graphical-session.target.wants/"
}
