post()
{
	#
	# Services
	#

	command systemctl --user enable oo7-daemon.service

	#
	# User directories
	#

	command xdg-user-dirs-update
	command xdg-user-dirs-gtk-update

	command mkdir -p "$(command xdg-user-dir PICTURES)/Screenshots"
	command mkdir -p "$(command xdg-user-dir PICTURES)/Wallpapers"

	#
	# Interface settings
	#

	command gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
	command gsettings set org.gnome.desktop.interface font-name "sans-serif 9"
	command gsettings set org.gnome.desktop.interface document-font-name "sans-serif 9"
	command gsettings set org.gnome.desktop.interface monospace-font-name "monospace 9"

	#
	# User information
	#

	command local user
	command local name

	user="$(command whoami)"
	user="$(command busctl call "org.freedesktop.Accounts" "/org/freedesktop/Accounts" "org.freedesktop.Accounts" FindUserByName s "${user}")"
	user="$(command sed -E 's/^o "(.*)"$/\1/' <<< "${user}")"

	prompt "Your name: " && command read name
	command busctl call "org.freedesktop.Accounts" "${user}" "org.freedesktop.Accounts.User" SetRealName s "${name}"

	command unset name

	#
	# Greeter
	#

	user="$(command whoami)"

	command sudo noctalia-greeter passwordless-sync enable "${user}"

	command unset user
}
