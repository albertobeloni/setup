post()
{
	if command test ! -f "${XDG_CONFIG_HOME}/git/local"
	then
		message "run \"git config --file \"\${XDG_CONFIG_HOME}/git/local\" user.name 'Your Name'\""
		message "run \"git config --file \"\${XDG_CONFIG_HOME}/git/local\" user.email 'your@email.com'\""
	fi
}
