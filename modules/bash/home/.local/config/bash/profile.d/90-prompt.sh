if [[ "$(tty)" == "/dev/tty"[1-9]* ]]
then
	PS1=""
	PS1+="\[$(bash_background reset)\]"
	PS1+="\[$(bash_foreground white)\]"
	PS1+="> "
	PS1+="\[$(bash_background reset)\]"
	PS1+="\[$(bash_foreground reset)\]"

	PS2=""
	PS2+="\[$(bash_background reset)\]"
	PS2+="\[$(bash_foreground yellow)\]"
	PS2+="> "
	PS2+="\[$(bash_background reset)\]"
	PS2+="\[$(bash_foreground reset)\]"

	PS3="? "
else
	PS1=""
	PS1+="\[$(bash_background reset)\]"
	PS1+="\[$(bash_foreground white)\]"
	PS1+="⟩ "
	PS1+="\[$(bash_background reset)\]"
	PS1+="\[$(bash_foreground reset)\]"

	PS2=""
	PS2+="\[$(bash_background reset)\]"
	PS2+="\[$(bash_foreground yellow)\]"
	PS2+="⟩ "
	PS2+="\[$(bash_background reset)\]"
	PS2+="\[$(bash_foreground reset)\]"

	PS3="? "
fi
