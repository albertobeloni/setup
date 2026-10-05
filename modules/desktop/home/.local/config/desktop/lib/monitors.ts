// Per-monitor windows that follow monitors being connected and disconnected.

import app from "ags/gtk4/app"
import { Gdk, Gtk } from "ags/gtk4"
import { For, This, createBinding, onCleanup } from "ags"

// Renders the given windows once for each monitor. When a monitor goes away,
// its windows are destroyed; GTK doesn't do that for top-level windows.
export function ForMonitors({ children }: { children: (monitor: Gdk.Monitor) => JSX.Element | JSX.Element[] }) {
	const monitors = createBinding(app, "monitors")

	return (
		<For each={monitors}>
			{(monitor) => {
				const windows = [children(monitor)].flat()

				onCleanup(() => {
					for (const window of windows) {
						if (window instanceof Gtk.Window) window.destroy()
					}
				})

				return <This this={app}>{windows}</This>
			}}
		</For>
	)
}
