function post() {
	#
	# Services
	#

	command systemctl --user --root=/ enable umbriel-events.service

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

	if command test -z "$(command getent passwd "${user}" | command cut -d ":" -f 5)"
	then
		prompt "Your name: " && command read -r name
		command sudo usermod -c "${name}" "${user}"
	fi

	#
	# Greeter
	#

	command sudo noctalia-greeter passwordless-sync enable "${user}"
	command sudo systemctl enable greetd.service

	command unset -v user
	command unset -v name

	if changed
	then
		command sudo mkinitcpio -P
	fi
}
