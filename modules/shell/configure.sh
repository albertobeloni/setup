post()
{
	command mkdir -p "${XDG_STATE_HOME:-${HOME}/.local/state}/bash"

	backup "${HOME}/.bash_logout"
	backup "${HOME}/.bash_profile"
	backup "${HOME}/.bashrc"

	command rm -f "${HOME}/.bash_history"
	command rm -f "${HOME}/.bash_logout"
	command rm -f "${HOME}/.bash_profile"
	command rm -f "${HOME}/.bashrc"
}
