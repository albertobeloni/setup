post()
{
	if changed
	then
		command sudo systemctl enable nvidia-resume.service
		command sudo systemctl enable nvidia-suspend.service
		command sudo systemctl enable nvidia-hibernate.service
		command sudo udevadm control --reload
		command sudo udevadm trigger --subsystem-match=drm
	fi
}
