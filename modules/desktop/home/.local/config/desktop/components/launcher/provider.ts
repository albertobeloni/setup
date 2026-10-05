// What every launcher provider implements.
//
// A provider with a prefix answers when the search starts with it, e.g. ">"
// for the terminal; the provider without one answers everything else.

export interface Result {
	title: string
	subtitle?: string
	// An icon name or a path to an image.
	icon?: string
	activate(): void
}

export interface Provider {
	name: string
	// A symbolic icon name, shown in the search box while this provider answers.
	icon: string
	prefix?: string
	// Called each time the launcher opens, to pick up changes.
	refresh?(): void
	// Results for the search text, best first. The prefix is already removed.
	search(query: string): Result[]
}
