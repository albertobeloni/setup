post()
{
	if changed
	then
		#
		# Enable clock synchronization
		#

		command sudo timedatectl set-ntp true

		#
		# Enable SSD auto-trim
		#

		command sudo systemctl enable fstrim.timer

		#
		# Rebuild kernel hooks
		#

		command sudo mkinitcpio -P
	fi
}
