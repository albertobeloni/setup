config.load_autoconfig(True)

config.source("colors.py")
config.source("interface.py")

c.url.default_page = "about:blank"
c.url.searchengines = {
	"DEFAULT": "https://www.google.com/?q={}"
}
c.url.start_pages = [
	"about:blank"
]

c.content.blocking.adblock.lists = [
	"https://easylist.to/easylist/easylist.txt",
	"https://easylist.to/easylist/easyprivacy.txt"
]
c.content.blocking.enabled = True
c.content.blocking.hosts.block_subdomains = True
c.content.blocking.hosts.lists = [
	"https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
]
c.content.blocking.method = "auto"
c.content.blocking.whitelist = []

c.input.insert_mode.auto_load = True

c.auto_save.session = True
