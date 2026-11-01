function post() {
	command sudo flatpak remote-add --system --if-not-exists flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
	command sudo flatpak update --noninteractive
	command sudo flatpak uninstall --unused --noninteractive
}
