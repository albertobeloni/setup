post()
{
	command sudo systemctl enable iwd.service
	command sudo systemctl enable NetworkManager.service

	if changed
	then
		command sudo systemctl restart iwd.service
		command sudo systemctl restart NetworkManager.service
	fi
}
