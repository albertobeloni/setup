post()
{
	command sudo timedatectl set-ntp true
	# command sudo systemctl enable --now fstrim.timer

	changed && command sudo mkinitcpio -P
}
