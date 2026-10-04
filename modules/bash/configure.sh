pre()
{
	command mkdir -p "${XDG_STATE_HOME}/bash"

	backup "${HOME}/.bashrc" "${XDG_STATE_HOME}/bash"
	backup "${HOME}/.bash_profile" "${XDG_STATE_HOME}/bash"
	backup "${HOME}/.bash_logout" "${XDG_STATE_HOME}/bash"

	backup "/etc/bash.bashrc"
}
