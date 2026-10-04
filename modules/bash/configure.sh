pre()
{
	command mkdir -p "${XDG_STATE_HOME}/bash"

	backup "${HOME}/.bashrc"
	backup "${HOME}/.bash_profile"
	backup "${HOME}/.bash_logout"

	command rm -f "${HOME}/.bashrc"
	command rm -f "${HOME}/.bash_profile"
	command rm -f "${HOME}/.bash_logout"
}
