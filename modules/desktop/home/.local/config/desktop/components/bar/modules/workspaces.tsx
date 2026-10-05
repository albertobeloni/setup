// Workspace indicators for one monitor: its configured workspaces (from the
// workspace rules) plus any other workspace currently on it. Up to five are
// visible; with more, the strip scrolls to keep the current one in view.
//
// Each indicator is styled by state: "empty", "occupied" or "current". The
// widgets stay the same as the state changes, so CSS transitions animate it.

import { Gdk, Gtk } from "ags/gtk4"
import { With, createComputed, createConnection, createState, onCleanup } from "ags"

import { focusWorkspace, hyprland, workspaceRules } from "../../../compositor/hyprland"

// How many indicators are visible at once.
const VISIBLE = 5

interface Snapshot {
	// Workspaces on the monitor right now.
	existing: number[]
	// Workspaces with at least one window, on any monitor.
	occupied: Set<number>
	// The workspace shown on the monitor.
	current: number | null
}

function snapshot(connector: string): Snapshot {
	const h = hyprland()

	return {
		existing: h
			.get_workspaces()
			.filter((workspace) => workspace.id > 0 && workspace.monitor?.name === connector)
			.map((workspace) => workspace.id),
		occupied: new Set(h.get_clients().flatMap((client) => (client.workspace ? [client.workspace.id] : []))),
		current: h.get_monitor_by_name(connector)?.activeWorkspace?.id ?? null,
	}
}

export default function Workspaces({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
	const connector = gdkmonitor.connector
	const h = hyprland()

	// Refreshed on every Hyprland event, after AstalHyprland has updated.
	const state = createConnection(snapshot(connector), [h, "event", () => snapshot(connector)])

	// Workspaces the rules assign to this monitor, reloaded with the config.
	const [configured, setConfigured] = createState<number[]>([])

	async function loadRules() {
		const rules = await workspaceRules()

		setConfigured(
			rules
				.filter((rule) => rule.monitor === connector)
				.map((rule) => Number(rule.workspace))
				.filter((id) => Number.isInteger(id) && id > 0),
		)
	}

	loadRules()

	const reloaded = h.connect("config-reloaded", loadRules)
	onCleanup(() => h.disconnect(reloaded))

	const ids = createComputed(() => [...new Set([...configured(), ...state().existing])].sort((a, b) => a - b))

	// The first visible indicator. It only moves when the current workspace
	// would fall outside the visible ones.
	let offset = 0

	const start = createComputed(() => {
		const list = ids()
		const index = list.indexOf(state().current ?? -1)

		if (index >= 0 && index < offset) offset = index
		if (index >= offset + VISIBLE) offset = index - VISIBLE + 1

		offset = Math.max(0, Math.min(offset, list.length - VISIBLE))

		return offset
	})

	const classes = (id: number) =>
		state((s) => `workspace ${s.current === id ? "current" : s.occupied.has(id) ? "occupied" : "empty"}`)

	return (
		<box class="module workspaces">
			{/* Rebuilt only when the set of workspaces changes. */}
			<With value={ids((list) => list.join(","))}>
				{(key: string) => (
					<box class="indicators">
						{(key === "" ? [] : key.split(",").map(Number)).map((id, index) => (
							<button
								class={classes(id)}
								valign={Gtk.Align.CENTER}
								visible={start((first) => index >= first && index < first + VISIBLE)}
								tooltipText={`Workspace ${id}`}
								onClicked={() => focusWorkspace(id)}
							/>
						))}
					</box>
				)}
			</With>
		</box>
	)
}
