function post() {
	if command test ! -f "${XDG_CONFIG_HOME:-${HOME}/.local/config}/git/local"
	then
		command local name
		command local email

		prompt "Your name: " && command read -r name
		prompt "Your e-mail: " && command read -r email

		command git config --file "${XDG_CONFIG_HOME:-${HOME}/.local/config}/git/local" user.name "${name}"
		command git config --file "${XDG_CONFIG_HOME:-${HOME}/.local/config}/git/local" user.email "${email}"

		command unset -v name
		command unset -v email
	fi
}
