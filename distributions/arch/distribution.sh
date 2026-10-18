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
	if ! command -v "yay" > "/dev/null"
	then
		modules "yay"
	fi

	command yay -S --noconfirm --needed --answerclean None --answerdiff None --removemake "${@}"
}
