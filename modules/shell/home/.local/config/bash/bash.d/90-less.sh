command declare symbol

if [[ "$(tty)" == "/dev/tty"[1-9]* ]]
then
	symbol=">"
else
	symbol="⟩"
fi

command export LESS="-FKR --use-color --color=P -Ps${symbol} $ -Pm${symbol} $ -PM${symbol} $ -P=${symbol} $"

command unset -v symbol
