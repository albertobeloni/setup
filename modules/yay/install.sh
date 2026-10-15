if distribution arch
then
	if ! command -v "yay" > "/dev/null"
	then
		packages git base-devel

		command local build

		build="$(mktemp -d)"

		command git clone "https://aur.archlinux.org/yay-bin.git" "${build}/yay"

		(
			command cd "${build}/yay"
			command makepkg -rsi --clean --noconfirm
		)

		command rm -rf "${build}"
	fi
fi
