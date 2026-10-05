post()
{
	command local units

	units="${XDG_CONFIG_HOME}/systemd/user"

	command mkdir -p "${units}/graphical-session.target.wants"
	command ln -sf "${units}/polkit-gnome.service" "${units}/graphical-session.target.wants/"
}
