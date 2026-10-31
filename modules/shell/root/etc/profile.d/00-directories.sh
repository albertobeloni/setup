if command test -r "/etc/environment.d/00-directories.conf"
then
	command . "/etc/environment.d/00-directories.conf"
else
	XDG_CACHE_HOME="${HOME}/.local/cache"
	XDG_CONFIG_HOME="${HOME}/.local/config"
	XDG_DATA_HOME="${HOME}/.local/data"
	XDG_STATE_HOME="${HOME}/.local/state"
fi

command export XDG_CACHE_HOME
command export XDG_CONFIG_HOME
command export XDG_DATA_HOME
command export XDG_STATE_HOME
