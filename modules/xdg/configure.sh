post()
{
	command xdg-user-dirs-update --force
	command xdg-user-dirs-gtk-update --force

	command mkdir -p "$(xdg-user-dir PICTURES)/Screenshots"
}
