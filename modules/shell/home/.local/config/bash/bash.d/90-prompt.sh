command declare symbol

if [[ "$(command tty)" == "/dev/tty"[1-9]* ]]
then
	symbol=">"
else
	symbol="󰅂"
fi

PS1=""
PS1+="$(prompt "$(background reset)")"
PS1+="$(prompt "$(foreground white)")"
PS1+="${symbol} "
PS1+="$(prompt "$(format reset)")"

PS2=""
PS2+="$(prompt "$(background reset)")"
PS2+="$(prompt "$(foreground yellow)")"
PS2+="${symbol} "
PS2+="$(prompt "$(format reset)")"

PS3="? "

command unset -v symbol
