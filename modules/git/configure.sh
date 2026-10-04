post()
{
	if command test ! -f "${HOME}/.local/config/git/local"
	then
		message "run \"git config --file ~/.local/config/git/local user.name 'Your Name'\""
		message "run \"git config --file ~/.local/config/git/local user.email 'your@email.com'\""
	fi
}
