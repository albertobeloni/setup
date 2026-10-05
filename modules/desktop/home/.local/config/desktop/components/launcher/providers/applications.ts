// Installed applications, matched by name, keywords and command. With an empty
// search, the most launched come first.

import AstalApps from "gi://AstalApps"
import GLib from "gi://GLib?version=2.0"

import { exec } from "../../../compositor/hyprland"
import type { Provider } from "../provider"

let apps: AstalApps.Apps | null = null

const applications: Provider = {
	name: "Applications",

	// Re-reads the desktop files, so newly installed apps show up.
	refresh() {
		if (apps === null) apps = new AstalApps.Apps()
		else apps.reload()
	},

	search(query) {
		return (apps?.fuzzy_query(query) ?? []).map((app) => ({
			title: app.name,
			subtitle: app.description ?? undefined,
			icon: app.iconName ?? undefined,
			activate() {
				// Started like the Hyprland keybinds do, in its own systemd scope.
				exec(`uwsm app -- ${GLib.shell_quote(app.entry)}`)

				// Counts the launch for the ordering; AstalApps saves it.
				app.frequency += 1
			},
		}))
	},
}

export default applications
