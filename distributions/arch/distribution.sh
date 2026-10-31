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

	command paru -S --cleanafter --skipreview --removemake=yes --noconfirm --needed "${@}"
}
