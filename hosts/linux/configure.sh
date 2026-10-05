post()
{
	command sudo timedatectl set-ntp true
	command sudo systemctl enable --now fstrim.timer

	if changed
	then
		command sudo mkinitcpio -P
	fi
}
