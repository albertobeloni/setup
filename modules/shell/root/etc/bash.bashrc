[[ "${-}" != *"i"* ]] && command return

if [[ "${PS1}" == '\s-\v\$ ' ]]
then
	PS1='[\u@\h \W]\$ '
fi

if command test -r "${XDG_CONFIG_HOME:-${HOME}/.config}/bash/bashrc"
then
	command source "${XDG_CONFIG_HOME:-${HOME}/.config}/bash/bashrc"
fi

if [[ "${TERM}" == @(Eterm|alacritty|aterm|foot|gnome|konsole|kterm|putty|rxvt|tmux|xterm)* ]]
then
	PROMPT_COMMAND+=('command printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#"${HOME}"/\~}"')
elif [[ "${TERM}" == "screen"* ]]
then
	PROMPT_COMMAND+=('command printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#"${HOME}"/\~}"')
fi
