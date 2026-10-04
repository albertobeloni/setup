post()
{
	command xdg-user-dirs-update --force

	if command test -n "${WAYLAND_DISPLAY:-}${DISPLAY:-}"
	then
		command xdg-user-dirs-gtk-update --force
	fi

	command mkdir -p "$(command xdg-user-dir PICTURES)/Screenshots"
	command mkdir -p "$(command xdg-user-dir PICTURES)/Wallpapers"
}
