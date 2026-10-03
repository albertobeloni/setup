post()
{
	command sudo sed -i "s/YOURUSER/${USER}/" "/etc/greetd/config.toml"
	command sudo systemctl enable greetd.service

	command mkdir -p "${XDG_CONFIG_HOME}/systemd/user/graphical-session.target.wants"
	command ln -sf "/usr/lib/systemd/user/hyprpaper.service" "${XDG_CONFIG_HOME}/systemd/user/graphical-session.target.wants/"
	command ln -sf "/usr/lib/systemd/user/hypridle.service" "${XDG_CONFIG_HOME}/systemd/user/graphical-session.target.wants/"

	command sudo mkinitcpio -P
}
