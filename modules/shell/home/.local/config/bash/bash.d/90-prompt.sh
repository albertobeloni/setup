if [[ "$(tty)" == "/dev/tty"[1-9]* ]]
then
	symbol="> "
else
	symbol="⟩ "
fi

PS1=""
PS1+="$(prompt_background reset)"
PS1+="$(prompt_foreground white)"
PS1+="${symbol}"
PS1+="$(prompt_format reset)"

PS2=""
PS2+="$(prompt_background reset)"
PS2+="$(prompt_foreground yellow)"
PS2+="${symbol}"
PS2+="$(prompt_format reset)"

PS3="? "

command unset -v symbol
