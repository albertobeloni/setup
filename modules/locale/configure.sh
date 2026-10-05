post()
{
	command sudo sed -i -e "s/\#en_US\.UTF-8/en_US\.UTF-8/g" "/etc/locale.gen"
	command sudo sed -i -e "s/\#pt_BR\.UTF-8/pt_BR\.UTF-8/g" "/etc/locale.gen"
	command sudo locale-gen

	if changed
	then
		command sudo mkinitcpio -P
	fi
}
