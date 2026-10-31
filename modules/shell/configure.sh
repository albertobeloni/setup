post()
{
	command mkdir -p "${XDG_STATE_HOME:-${HOME}/.local/state}/bash"

	backup "${HOME}/.bash_logout"
	backup "${HOME}/.bash_profile"
	backup "${HOME}/.bashrc"

	if command test -f "${HOME}/.bash_history" && ! command test -e "${XDG_STATE_HOME:-${HOME}/.local/state}/bash/history"
	then
		command mv "${HOME}/.bash_history" "${XDG_STATE_HOME:-${HOME}/.local/state}/bash/history"
	fi

	command rm -f "${HOME}/.bash_logout"
	command rm -f "${HOME}/.bash_profile"
	command rm -f "${HOME}/.bashrc"
}
