if [[ "$(tty)" == "/dev/tty"[1-9]* ]]
then
	PS1=""
	PS1+="\[$(background reset)\]"
	PS1+="\[$(foreground white)\]"
	PS1+="> "
	PS1+="\[$(background reset)\]"
	PS1+="\[$(foreground reset)\]"

	PS2=""
	PS2+="\[$(background reset)\]"
	PS2+="\[$(foreground yellow)\]"
	PS2+="> "
	PS2+="\[$(background reset)\]"
	PS2+="\[$(foreground reset)\]"

	PS3="? "
else
	PS1=""
	PS1+="\[$(background reset)\]"
	PS1+="\[$(foreground white)\]"
	PS1+="⟩ "
	PS1+="\[$(background reset)\]"
	PS1+="\[$(foreground reset)\]"

	PS2=""
	PS2+="\[$(background reset)\]"
	PS2+="\[$(foreground yellow)\]"
	PS2+="⟩ "
	PS2+="\[$(background reset)\]"
	PS2+="\[$(foreground reset)\]"

	PS3="? "
fi
