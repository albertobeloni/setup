function explore()
{
	command local current
	command local directory

	current="$(command mktemp -t "directory.XXXXXX")"

	command yazi "${@}" --cwd-file="${current}"

	IFS= read -r -d "" directory < "${current}"

	if command test -n "${directory}" && command test "${directory}" != "${PWD}" && command test -d "${directory}"
	then
		builtin cd -- "${directory}"
	fi

	command rm -f -- "${current}"
}
