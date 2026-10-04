pre()
{
	if ! command cmp -s "root/etc/cmdline.d/usb.conf" "/etc/cmdline.d/usb.conf"
	then
		rebuild="true"
	fi
}

post()
{
	if command test "${rebuild:-}" = "true"
	then
		command sudo mkinitcpio -P
	fi
}
