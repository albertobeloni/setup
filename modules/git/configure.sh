post()
{
	if command test ! -f "${XDG_CONFIG_HOME:-${HOME}/.config}/git/local"
	then
		command local name
		command local email

		prompt "Your name: " && command read name
		prompt "Your e-mail: " && command read email

		command git config --file "${XDG_CONFIG_HOME:-${HOME}/.config}/git/local" user.name "${name}"
		command git config --file "${XDG_CONFIG_HOME:-${HOME}/.config}/git/local" user.email "${email}"

		command unset name
		command unset email
	fi
}
