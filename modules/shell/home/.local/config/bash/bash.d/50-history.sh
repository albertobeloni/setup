HISTCONTROL="ignoredups:erasedups"
HISTFILE="${XDG_STATE_HOME:-${HOME}/.local/state}/bash/history"
HISTFILESIZE=2000
HISTSIZE=1000
PROMPT_COMMAND+=("history -a")
