function post() {
	if command -v "flatpak" > "/dev/null"
	then
		command flatpak override --user --filesystem="xdg-config/gtk-3.0:ro" --filesystem="xdg-config/gtk-4.0:ro"
	fi
}
