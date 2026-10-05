// Status icons: network, Bluetooth, audio, microphone and battery. Each one
// shows only when there's something to show: the microphone while an app is
// recording, Bluetooth when there's an adapter, the battery when there is one.

import AstalBattery from "gi://AstalBattery"
import AstalBluetooth from "gi://AstalBluetooth"
import AstalNetwork from "gi://AstalNetwork"
import AstalWp from "gi://AstalWp"
import { createBinding, createComputed, createConnection } from "ags"

function Network() {
	const network = AstalNetwork.get_default()
	const primary = createBinding(network, "primary")
	const wifi = createBinding(network, "wifi", "iconName")
	const wired = createBinding(network, "wired", "iconName")

	const icon = createComputed(() => {
		if (primary() === AstalNetwork.Primary.WIRED) return wired() ?? "network-wired-symbolic"
		return wifi() ?? wired() ?? "network-offline-symbolic"
	})

	return <image class="network" iconName={icon} />
}

function Bluetooth() {
	const bluetooth = AstalBluetooth.get_default()
	const powered = createBinding(bluetooth, "isPowered")
	const connected = createBinding(bluetooth, "isConnected")

	const icon = createComputed(() => {
		if (!powered()) return "bluetooth-disabled-symbolic"
		return connected() ? "bluetooth-active-symbolic" : "bluetooth-symbolic"
	})

	return <image class="bluetooth" iconName={icon} visible={bluetooth.get_adapter() !== null} />
}

function Audio() {
	const icon = createBinding(AstalWp.get_default(), "defaultSpeaker", "volumeIcon")

	return <image class="audio" iconName={icon((name) => name ?? "")} visible={icon((name) => !!name)} />
}

function Microphone() {
	const wp = AstalWp.get_default()
	const icon = createBinding(wp, "defaultMicrophone", "volumeIcon")

	// How many streams are recording.
	const recording = createConnection(
		wp.audio.get_recorders().length,
		[wp.audio, "recorder-added", (_, count) => count + 1],
		[wp.audio, "recorder-removed", (_, count) => Math.max(0, count - 1)],
	)

	return (
		<image
			class="microphone"
			iconName={icon((name) => name ?? "microphone-sensitivity-high-symbolic")}
			visible={recording((count) => count > 0)}
		/>
	)
}

function Battery() {
	const battery = AstalBattery.get_default()

	return (
		<image
			class="battery"
			iconName={createBinding(battery, "batteryIconName")}
			visible={createBinding(battery, "isPresent")}
		/>
	)
}

export default function Status() {
	return (
		<box class="module status">
			<Network />
			<Bluetooth />
			<Audio />
			<Microphone />
			<Battery />
		</box>
	)
}
