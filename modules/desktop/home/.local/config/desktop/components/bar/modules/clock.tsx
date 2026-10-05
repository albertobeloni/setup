// The current time (HH:MM), updated at the start of every minute.

import GLib from "gi://GLib?version=2.0"
import { createState, onCleanup } from "ags"

const now = () => GLib.DateTime.new_now_local().format("%H:%M") ?? ""

export default function Clock() {
	const [time, setTime] = createState(now())

	let timer: ReturnType<typeof setTimeout>

	// Waits for the next minute to start, then updates and waits again.
	function schedule() {
		timer = setTimeout(
			() => {
				setTime(now())
				schedule()
			},
			60_000 - (Date.now() % 60_000) + 50,
		)
	}

	schedule()
	onCleanup(() => clearTimeout(timer))

	return (
		<box class="module clock">
			<label label={time} />
		</box>
	)
}
