post()
{
	command sudo systemctl enable --now iwd.service
	command sudo systemctl enable --now NetworkManager.service
}
