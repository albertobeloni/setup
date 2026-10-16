post()
{
	if changed && command test ! -f "${XDG_CONFIG_HOME}/git/local"
	then
		message "run \"ssh-keygen -t ed25519\""
		message "add \"cat ~/.ssh/id_ed25519.pub\" to GitHub"
		message "run \"ssh -T git@github.com\""
		message "run \"git config --file \"\${XDG_CONFIG_HOME:-${HOME}/.config}/git/local\" user.name 'Your Name'\""
		message "run \"git config --file \"\${XDG_CONFIG_HOME:-${HOME}/.config}/git/local\" user.email 'your@email.com'\""
	fi
}
