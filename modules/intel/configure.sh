post()
{
	command sudo udevadm control --reload
	command sudo udevadm trigger --subsystem-match=drm
}
