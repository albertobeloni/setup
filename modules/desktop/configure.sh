post()
{
	#
	# Services
	#

	command systemctl --user enable umbriel-events.service

	#
	# XDG User Directories
	#

	command xdg-user-dirs-update

	#
	# Screenshot and Wallpaper Directories
	#

	command mkdir -p "$(command xdg-user-dir PICTURES)/Screenshots"
	command mkdir -p "$(command xdg-user-dir PICTURES)/Wallpapers"

	#
	# User Information
	#

	command local user
	command local name

	user="$(command whoami)"

	prompt "Your name: " && command read name
	command sudo usermod -c "${name}" "${user}"

	#
	# Greeter
	#

	command sudo noctalia-greeter passwordless-sync enable "${user}"
	command sudo systemctl enable greetd.service

	command unset user
	command unset name

	if changed
	then
		command sudo mkinitcpio -P
	fi
}
