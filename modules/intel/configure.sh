post()
{
	if changed
	then
		command sudo udevadm control --reload
		command sudo udevadm trigger --subsystem-match=drm
	fi
}
