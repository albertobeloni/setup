post()
{
	# Bundle the shell into a single executable

	command local source

	source="${XDG_CONFIG_HOME}/desktop"

	command ags bundle --gtk 4 --root "${source}" "${source}/desktop.tsx" "${HOME}/.local/bin/desktop"

	# Start the shell, or restart it so it runs the new bundle

	command local units

	units="${XDG_CONFIG_HOME}/systemd/user"

	command mkdir -p "${units}/graphical-session.target.wants"
	command ln -sf "${units}/desktop.service" "${units}/graphical-session.target.wants"

	if command systemctl --user is-active --quiet desktop.service
	then
		command systemctl --user restart desktop.service
	else
		command systemctl --user enable --now desktop.service
	fi
}
