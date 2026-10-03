packages()
{
	command sudo pacman -S --noconfirm --needed "${@}"
}

aur()
{
	if ! command -v "yay" > "/dev/null" 2>&1
	then
		packages git base-devel

		command local build

		build="$(mktemp -d)"

		command git clone "https://aur.archlinux.org/yay.git" "${build}/yay"
		(command cd "${build}/yay" && command makepkg -si --clean --noconfirm)
		command rm -rf "${build}"
	fi

	command yay -S --noconfirm --needed --answerclean None --answerdiff None --removemake "${@}"
}
