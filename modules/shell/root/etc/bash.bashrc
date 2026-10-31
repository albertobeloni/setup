if [[ "${-}" != *"i"* ]]
then
	command return
fi

if command test -r "${XDG_CONFIG_HOME:-${HOME}/.config}/bash/bashrc"
then
	command source "${XDG_CONFIG_HOME:-${HOME}/.config}/bash/bashrc"
fi

if [[ "${TERM}" == "screen"* ]]
then
	PROMPT_COMMAND+=('command printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#"${HOME}"/\~}"')
else
	PROMPT_COMMAND+=('command printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#"${HOME}"/\~}"')
fi
