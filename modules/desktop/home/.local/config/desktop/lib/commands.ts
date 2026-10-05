// Commands the shell answers when it receives a request, from the bundle
// itself (`desktop <command> [arguments]`) or `ags request -i desktop`.
// Components register their own commands with command().

type Action = (args: string[]) => string | void | Promise<string | void>

interface Command {
	description: string
	action: Action
}

const commands = new Map<string, Command>()

// Registers a command. A command that returns nothing answers "ok"; one that
// throws answers with the error.
export function command(name: string, description: string, action: Action) {
	commands.set(name, { description, action })
}

function help() {
	const width = Math.max(...[...commands.keys()].map((name) => name.length))

	return [...commands]
		.sort(([a], [b]) => a.localeCompare(b))
		.map(([name, { description }]) => `${name.padEnd(width)}  ${description}`)
		.join("\n")
}

// The request handler for app.start(). Each request gets exactly one answer.
export async function handle(argv: string[], respond: (response: string) => void) {
	const [name, ...args] = argv

	if (!name || name === "help") {
		respond(help())
		return
	}

	const found = commands.get(name)

	if (!found) {
		respond(`unknown command "${name}"; try "help"`)
		return
	}

	try {
		respond((await found.action(args)) ?? "ok")
	} catch (error) {
		respond(`${name}: ${error instanceof Error ? error.message : error}`)
	}
}
