post()
{
	# Bundle AGS application

	command local source

	source="${XDG_CONFIG_HOME}/desktop"

	command ags bundle --gtk 4 --root "${source}" "${source}/desktop.tsx" "${HOME}/.local/bin/desktop"

	# Enable application services

	command local units

	units="${XDG_CONFIG_HOME}/systemd/user"

	command mkdir -p "${units}/graphical-session.target.wants"
	command ln -sf "${units}/desktop.service" "${units}/graphical-session.target.wants"

	command systemctl --user enable --now desktop.service
}
