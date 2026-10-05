post()
{
	command local device

	for device in $(command upower -e | command grep "battery_")
	do
		if [[ "$(command upower -i ${device} | command grep 'charge-threshold-supported:')" == *"yes"* ]]
		then
			command sudo busctl call org.freedesktop.UPower "${device}" org.freedesktop.UPower.Device EnableChargeThreshold b true
		fi
	done

	command sudo systemctl enable power-profiles-daemon.service
}
