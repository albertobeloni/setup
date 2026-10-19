packages()
{
	command sudo pacman -S --noconfirm --needed "${@}"
}

prepare()
{
	command sudo pacman -Syu --noconfirm
}

flathub()
{
	if ! command -v "flatpak" > "/dev/null"
	then
		modules "flatpak"
	fi

	command sudo flatpak install --noninteractive flathub "${@}"
}

aur()
{
	if ! command -v "paru" > "/dev/null"
	then
		modules "paru"
	fi

	command paru -S --cleanafter --skipreview --removemake=yes --noconfirm --needed "${@}"
}
