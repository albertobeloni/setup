home()
{
	command cd "${HOME}" > "/dev/null"
}

to()
{
	command local target

	target="${1}"

	if command test -z "${target}"
	then
		command cd "${HOME}" > "/dev/null"
		command unset -v target
		command return
	fi

	if command test -d "${target}"
	then
		command cd "${target}" > "/dev/null"
		command unset -v target
		command return
	fi

	command unset -v target
	command return 1
}

up()
{
	command local levels

	levels="${1}"

	if command test -z "${levels}"
	then
		command cd .. > "/dev/null"
		command unset -v levels
		command return
	fi

	if [[ "${levels}" == +([0-9]) ]]
	then
		command local level

		for level in $(command seq "${levels}")
		do
			command cd .. > "/dev/null"
		done

		command unset -v level
		command unset -v levels
		command return
	fi

	command unset -v levels
	command return 1
}
