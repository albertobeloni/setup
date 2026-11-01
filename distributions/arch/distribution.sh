function packages() {
	command sudo pacman -S --noconfirm --needed "${@}"
}

function prepare() {
	command sudo pacman -Syu --noconfirm
}

function flathub() {
	if ! command -v "flatpak" > "/dev/null"
	then
		modules "flatpak"
	fi

	command sudo flatpak install --noninteractive flathub "${@}"
}

function aur() {
	if ! command -v "paru" > "/dev/null"
	then
		modules "paru"
	fi

	command local package
	command local -a missing

	missing=()

	for package in "${@}"
	do
		if ! command pacman -Q "${package}" > "/dev/null" 2>&1
		then
			missing+=("${package}")
		fi
	done

	if command test "${#missing[@]}" -eq 0
	then
		command return 0
	fi

	command paru -S --cleanafter --skipreview --removemake=yes --noconfirm --needed "${missing[@]}"
}
