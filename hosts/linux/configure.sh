post()
{
	if changed
	then
		command sudo timedatectl set-ntp true
		# command sudo systemctl enable fstrim.timer
		command sudo mkinitcpio -P
	fi
}
