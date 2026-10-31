if command test -r "${XDG_CONFIG_HOME}/shell/profile"
then
	command . "${XDG_CONFIG_HOME}/shell/profile"
fi
