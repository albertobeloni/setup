post()
{
	command local source

	source="${XDG_CONFIG_HOME}/desktop"

	command ags bundle --gtk 4 --root "${source}" "${source}/desktop.ts" "${HOME}/.local/bin/desktop"
}
