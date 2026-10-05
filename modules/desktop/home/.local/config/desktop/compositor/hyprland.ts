// The only place the shell talks to Hyprland.
//
// State and events come from AstalHyprland. Actions don't use its built-in
// methods (workspace.focus(), client.kill(), ...): they send Hyprland's old
// dispatcher syntax, which a Lua config rejects. They go through dispatch()
// here instead, as Lua expressions.

import Gio from "gi://Gio?version=2.0"
import AstalHyprland from "gi://AstalHyprland"
import { createBinding } from "ags"

Gio._promisify(AstalHyprland.Hyprland.prototype, "message_async", "message_finish")

// Created on first use, inside the running shell rather than at import time.
let instance: AstalHyprland.Hyprland | null = null

export function hyprland() {
	return (instance ??= AstalHyprland.get_default())
}

// State, as reactive values

export const workspaces = () => createBinding(hyprland(), "workspaces")
export const focusedWorkspace = () => createBinding(hyprland(), "focusedWorkspace")
export const clients = () => createBinding(hyprland(), "clients")
export const focusedClient = () => createBinding(hyprland(), "focusedClient")
export const monitors = () => createBinding(hyprland(), "monitors")

// Lua

// A Lua string literal for any text. Control characters become three-digit
// decimal escapes, so a following digit can't change them.
export function lua(text: string) {
	const escaped = text.replace(/[\\"\x00-\x1f]/g, (c) =>
		c === "\\" || c === '"' ? `\\${c}` : `\\${String(c.charCodeAt(0)).padStart(3, "0")}`,
	)

	return `"${escaped}"`
}

// Sends a request to Hyprland's socket and resolves to its reply.
async function request(message: string): Promise<string> {
	return (await hyprland().message_async(message)) as unknown as string
}

// Runs a dispatcher, written as a Lua expression such as
// `hl.dsp.focus({ workspace = 2 })`. Resolves to whether Hyprland accepted it;
// failures are logged.
export async function dispatch(expression: string) {
	const reply = (await request(`dispatch ${expression}`)).trim()

	if (reply !== "ok") console.error(`dispatch ${expression}: ${reply}`)

	return reply === "ok"
}

// Runs a Lua chunk in Hyprland's config state, so it can call the config's
// own helpers, e.g. `require("helpers.focus").towards("left")`.
export async function evaluate(code: string) {
	const reply = (await request(`eval ${code}`)).trim()

	if (reply !== "ok") console.error(`eval ${code}: ${reply}`)

	return reply === "ok"
}

// Workspace rules from the config: which workspace each rule names, and the
// monitor it assigns it to, if any.
export async function workspaceRules(): Promise<{ workspace: string; monitor?: string }[]> {
	const rules: { workspaceString: string; monitor?: string }[] = JSON.parse(await request("j/workspacerules"))

	return rules.map((rule) => ({ workspace: rule.workspaceString, monitor: rule.monitor }))
}

// Actions

// AstalHyprland drops the 0x from client addresses; selectors need it.
const selector = (client: AstalHyprland.Client) => lua(`address:0x${client.address}`)

export const focusWorkspace = (workspace: number | string) =>
	dispatch(`hl.dsp.focus({ workspace = ${lua(String(workspace))} })`)

export const focusClient = (client: AstalHyprland.Client) =>
	dispatch(`hl.dsp.focus({ window = ${selector(client)} })`)

export const closeClient = (client: AstalHyprland.Client) =>
	dispatch(`hl.dsp.window.close({ window = ${selector(client)} })`)

export const moveClient = (client: AstalHyprland.Client, workspace: number | string, follow = false) =>
	dispatch(`hl.dsp.window.move({ window = ${selector(client)}, workspace = ${lua(String(workspace))}, follow = ${follow} })`)

export const toggleSpecial = (name: string) =>
	dispatch(`hl.dsp.workspace.toggle_special(${lua(name)})`)

// Starts a program the way Hyprland's own keybinds do.
export const exec = (command: string) =>
	dispatch(`hl.dsp.exec_cmd(${lua(command)})`)
