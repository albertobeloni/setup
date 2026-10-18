if [[ "${-}" == *"i"* ]]
then
	command alias cat="bat --paging=never --style=plain"
fi

command alias print="bat"

export LESSOPEN="| bat --color=always %s"
export MANPAGER="bat --language=man --style=plain --strip-ansi=always"
