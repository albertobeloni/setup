post()
{
	if changed
	then
		command sudo sudo timedatectl set-ntp true
		command sudo systemctl enable --now fstrim.timer
		command sudo mkinitcpio -P
	fi
}
