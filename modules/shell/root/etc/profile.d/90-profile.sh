if command test -r "${XDG_CONFIG_HOME:-${HOME}/.local/config}/shell/profile"
then
	command . "${XDG_CONFIG_HOME:-${HOME}/.local/config}/shell/profile"
fi
