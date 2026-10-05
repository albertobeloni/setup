// The launcher: a search box that drops down from the top of the focused
// monitor. The search goes to a provider (see provider.ts); arrow keys pick a
// result, Enter or a click runs it, and Escape or focusing anything else
// closes it.

import app from "ags/gtk4/app"
import Gio from "gi://Gio?version=2.0"
import Pango from "gi://Pango?version=1.0"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import { For, createComputed, createState } from "ags"

import { hyprland } from "../../compositor/hyprland"
import { command } from "../../lib/commands"
import type { Provider, Result } from "./provider"
import applications from "./providers/applications"

// How many results to show at most.
const LIMIT = 8

const providers: Provider[] = [applications]

// The provider for the search text and the query it should see: the one whose
// prefix the text starts with, or else the one without a prefix.
function route(text: string): [Provider, string] {
	for (const provider of providers) {
		if (provider.prefix && text.startsWith(provider.prefix)) {
			return [provider, text.slice(provider.prefix.length).trimStart()]
		}
	}

	return [providers.find((provider) => !provider.prefix)!, text]
}

export default function Launcher() {
	const [results, setResults] = createState<Result[]>([])
	const [selected, setSelected] = createState(0)

	let window: Astal.Window
	let entry: Gtk.Entry

	function search(text: string) {
		const [provider, query] = route(text)

		setResults(provider.search(query).slice(0, LIMIT))
		setSelected(0)
	}

	function close() {
		window.visible = false
	}

	function activate(result: Result | undefined) {
		if (result === undefined) return

		close()
		result.activate()
	}

	// Moves the selection, wrapping around at either end.
	function step(by: number) {
		const count = results.peek().length

		if (count > 0) setSelected((selected.peek() + by + count) % count)
	}

	// Opens on the focused monitor, with the given text already typed.
	function open(text: string) {
		for (const provider of providers) provider.refresh?.()

		const name = hyprland().focusedMonitor?.name
		const monitor = app.get_monitors().find((monitor) => monitor.connector === name)

		if (monitor !== undefined) window.gdkmonitor = monitor

		entry.text = text
		search(text)

		window.visible = true
		entry.grab_focus()
		entry.set_position(-1)
	}

	command("launcher", "Show or hide the launcher, optionally with text typed in: launcher [text]", (args) => {
		if (window.visible && args.length === 0) close()
		else open(args.join(" "))
	})

	// Handled before the entry sees them, so arrows and Enter don't edit text.
	function onKeyPressed(_: Gtk.EventControllerKey, keyval: number) {
		switch (keyval) {
			case Gdk.KEY_Escape:
				close()
				return true
			case Gdk.KEY_Down:
				step(1)
				return true
			case Gdk.KEY_Up:
				step(-1)
				return true
			case Gdk.KEY_Return:
			case Gdk.KEY_KP_Enter:
				activate(results.peek()[selected.peek()])
				return true
		}

		return false
	}

	return (
		<window
			$={(self) => (window = self)}
			name="launcher"
			namespace="launcher"
			class="launcher"
			application={app}
			layer={Astal.Layer.OVERLAY}
			anchor={Astal.WindowAnchor.TOP}
			exclusivity={Astal.Exclusivity.IGNORE}
			keymode={Astal.Keymode.ON_DEMAND}
			onNotifyIsActive={(self) => {
				if (!self.isActive) close()
			}}
		>
			<Gtk.EventControllerKey propagationPhase={Gtk.PropagationPhase.CAPTURE} onKeyPressed={onKeyPressed} />
			<box class="panel" orientation={Gtk.Orientation.VERTICAL}>
				<entry
					$={(self) => (entry = self)}
					placeholderText="Search"
					onNotifyText={({ text }) => search(text)}
				/>
				<box class="results" orientation={Gtk.Orientation.VERTICAL} visible={results((list) => list.length > 0)}>
					<For each={results}>
						{(result, index) => (
							<button
								class={createComputed(() => (index() === selected() ? "result selected" : "result"))}
								focusOnClick={false}
								onClicked={() => activate(result)}
							>
								<box spacing={12}>
									<image
										gicon={Gio.Icon.new_for_string(result.icon ?? "application-x-executable")}
										pixelSize={32}
									/>
									<box orientation={Gtk.Orientation.VERTICAL} valign={Gtk.Align.CENTER}>
										<label class="title" label={result.title} xalign={0} ellipsize={Pango.EllipsizeMode.END} />
										<label
											class="subtitle"
											label={result.subtitle ?? ""}
											visible={result.subtitle !== undefined}
											xalign={0}
											ellipsize={Pango.EllipsizeMode.END}
										/>
									</box>
								</box>
							</button>
						)}
					</For>
				</box>
			</box>
		</window>
	)
}
