// Entry point of the desktop shell.
//
// The bundle is also its own command line: while the shell runs, starting it
// again with arguments sends them as a request, so `desktop help` lists the
// available commands. Hyprland keybinds use the same route.

import app from "ags/gtk4/app"
import { Gtk } from "ags/gtk4"

import { command, handle } from "./lib/commands"
import Launcher from "./components/launcher/launcher"

import style from "./style.scss"

app.start({
	instanceName: "desktop",
	css: style,
	requestHandler: handle,
	main() {
		Launcher()

		command("inspect", "Open the GTK inspector", () => {
			Gtk.Window.set_interactive_debugging(true)
		})

		command("toggle", "Show or hide a window: toggle <name>", ([name]) => {
			if (!name) throw Error("missing window name")
			app.toggle_window(name)
		})

		command("quit", "Quit the shell", () => {
			// Quitting exits right away, so answer the request first.
			setTimeout(() => app.quit())
		})
	},
})
