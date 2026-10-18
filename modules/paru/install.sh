if distribution arch
then
	if ! command -v "paru" > "/dev/null"
	then
		packages git base-devel

		command local build

		build="$(mktemp -d)"

		command git clone "https://aur.archlinux.org/paru.git" "${build}/paru"

		(
			command cd "${build}/paru"
			command makepkg -rsi --clean --noconfirm
		)

		command rm -rf "${build}"
	fi
fi
