post()
{
	command sudo timedatectl set-ntp true
	command sudo systemctl enable vboxservice.service
}
