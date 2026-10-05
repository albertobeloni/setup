post()
{
	command sudo systemctl enable nvidia-hibernate.service
	command sudo systemctl enable nvidia-resume.service
	command sudo systemctl enable nvidia-suspend.service

	if changed
	then
		command sudo udevadm control --reload
		command sudo udevadm trigger --subsystem-match=drm
	fi
}
