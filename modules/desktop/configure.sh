post()
{
	command xdg-user-dirs-update
	command xdg-user-dirs-gtk-update

	command mkdir -p "$(command xdg-user-dir PICTURES)/Screenshots"
	command mkdir -p "$(command xdg-user-dir PICTURES)/Wallpapers"
}
