__terminal_color()
{
	command local -i base
	command local code
	command local hex

	base="${2}"

	case "${1}" in
		black) code=0 ;;
		red) code=1 ;;
		green) code=2 ;;
		yellow) code=3 ;;
		blue) code=4 ;;
		magenta) code=5 ;;
		cyan) code=6 ;;
		white) code=7 ;;
		reset)
			reply=$(( ${base} + 9 ))
			return 0
			;;
		*)
			if [[ "${1}" =~ ^[0-9]{1,3}$ ]] && (( 10#$1 <= 255 ))
			then
				reply="$(( ${base} + 8 ));5;$(( 10#${1} ))"
				return 0
			elif [[ "${1}" =~ ^#([0-9A-Fa-f]{6})$ ]]
			then
				hex="${BASH_REMATCH[1]}"
				reply="$(( ${base} + 8 ));2;$(( 16#${hex:0:2} ));$(( 16#${hex:2:2} ));$(( 16#${hex:4:2} ))"
				return 0
			fi
			return 1
			;;
	esac

	[[ "${3}" == "true" ]] && base+=60

	reply="$(( ${base} + ${code} ))"
}

__terminal_format()
{
	command local format
	command local code
	command local codes

	codes=""

	for format in "${@}"
	do
		case "${format}" in
			reset) code=0 ;;
			bold) code=1 ;;
			dim) code=2 ;;
			italic) code=3 ;;
			underline) code=4 ;;
			blink) code=5 ;;
			reverse) code=7 ;;
			hidden) code=8 ;;
			strike) code=9 ;;
			no-bold) code=22 ;;
			no-dim) code=22 ;;
			no-italic) code=23 ;;
			no-underline) code=24 ;;
			no-blink) code=25 ;;
			no-reverse) code=27 ;;
			no-hidden) code=28 ;;
			no-strike) code=29 ;;
			*) return 1 ;;
		esac

		codes+=${codes:+;}${code}
	done

	reply="${codes}"
}

__terminal_escape()
{
	command local prompt

	prompt="${2:-false}"

	if [[ "${prompt}" == "false" ]]
	then
		printf '\033[%sm' "${1}"
	else
		printf '\001\033[%sm\002' "${1}"
	fi
}

bash_background()
{
	command local reply

	__terminal_color "${1}" 40 "${2:-false}" || return
	__terminal_escape "${reply}"
}

bash_foreground()
{
	command local reply

	__terminal_color "${1}" 30 "${2:-false}" || return
	__terminal_escape "${reply}"
}

bash_format()
{
	command local reply

	__terminal_format "${@}" || return
	__terminal_escape "${reply}"
}

prompt_background()
{
	command local reply

	__terminal_color "${1}" 40 "${2:-false}" || return
	__terminal_escape "${reply}" "true"
}

prompt_foreground()
{
	command local reply

	__terminal_color "${1}" 30 "${2:-false}" || return
	__terminal_escape "${reply}" "true"
}

prompt_format()
{
	command local reply

	__terminal_format "${@}" || return
	__terminal_escape "${reply}" "true"
}
