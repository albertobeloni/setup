post()
{
	if changed && command test ! -f "${XDG_CONFIG_HOME:-${HOME}/.config}/git/local"
	then
		message "run \"git config --file \"\${XDG_CONFIG_HOME:-${HOME}/.config}/git/local\" user.name 'Your Name'\""
		message "run \"git config --file \"\${XDG_CONFIG_HOME:-${HOME}/.config}/git/local\" user.email 'your@email.com'\""
	fi
}
