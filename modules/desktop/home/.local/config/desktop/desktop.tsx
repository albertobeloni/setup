import app from "ags/gtk4/app"
import { Gtk } from "ags/gtk4"

import style from "./style.scss"

app.start({
	instanceName: "desktop",
	css: style,
	main() {
	},
})
