// The bar, one per monitor: workspaces on the left, the clock in the center
// and status icons on the right. Its edge, and whether it floats, come from
// the bar options in lib/options.ts.

import app from "ags/gtk4/app"
import { Astal, Gdk } from "ags/gtk4"

import { bar } from "../../lib/options"
import Clock from "./modules/clock"
import Status from "./modules/status"
import Workspaces from "./modules/workspaces"

export default function Bar({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
	const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor
	const top = bar.position === "top"
	const margin = bar.floating ? bar.margin : 0

	return (
		<window
			visible
			name={`bar-${gdkmonitor.connector}`}
			namespace="bar"
			class={`bar ${bar.position}${bar.floating ? " floating" : ""}`}
			application={app}
			gdkmonitor={gdkmonitor}
			layer={Astal.Layer.TOP}
			anchor={(top ? TOP : BOTTOM) | LEFT | RIGHT}
			exclusivity={Astal.Exclusivity.EXCLUSIVE}
			marginTop={top ? margin : 0}
			marginBottom={top ? 0 : margin}
			marginLeft={margin}
			marginRight={margin}
		>
			<centerbox class="content">
				<Workspaces $type="start" gdkmonitor={gdkmonitor} />
				<Clock $type="center" />
				<Status $type="end" />
			</centerbox>
		</window>
	)
}
