-- ------------------------------------------------------------------------------
-- Borders
-- ------------------------------------------------------------------------------

require("full-border"):setup {
	set = "plain",
}

local function frame(area)
	local border = ui.Border(ui.Edge.ALL):area(area):style(th.mgr.border_style)

	if th.input.border_set then
		border:set("plain")
	else
		border:type(ui.Border.PLAIN)
	end

	return border:merge()
end

-- ------------------------------------------------------------------------------
-- Layout
-- ------------------------------------------------------------------------------

function Root:layout()
	self._chunks = ui.Layout()
		:direction(ui.Layout.VERTICAL)
		:constraints({
			ui.Constraint.Length(Tabs.height() > 0 and 3 or 2),
			ui.Constraint.Length(Tabs.height()),
			ui.Constraint.Fill(1),
			ui.Constraint.Length(2),
		})
		:split(self._area)
end

local root_build = Root.build

function Root:build()
	root_build(self)

	local children = self._children
	for index, child in ipairs(children) do
		if child._id == "header" then
			table.remove(children, index)
			break
		end
	end
	for index, child in ipairs(children) do
		if child._id == "status" then
			table.insert(children, index, Header:new(self._chunks[1], cx.active))
			break
		end
	end
end

-- ------------------------------------------------------------------------------
-- File List
-- ------------------------------------------------------------------------------

function Entity:icon()
	local icon = th.icon:match(self._file, { hovered = self._file.is_hovered })
	return icon and ui.Line(icon.text .. " "):style(icon.style) or ""
end

-- ------------------------------------------------------------------------------
-- Path Bar
-- ------------------------------------------------------------------------------

function Header:cwd()
	local max = self._area.w - self._right_width
	if max <= 0 then
		return ""
	end

	local path = tostring(self._current.cwd) .. self:flags()
	return ui.Span(ui.truncate(path, { max = max, rtl = true })):style(th.mgr.cwd)
end

local header_redraw = Header.redraw

function Header:redraw()
	local area = self._area

	self._area = ui.Rect { x = area.x + 2, y = area.y + 1, w = math.max(0, area.w - 4), h = 1 }
	local elements = header_redraw(self)
	self._area = area

	return {
		frame(ui.Rect { x = area.x, y = area.y, w = area.w, h = 3 }),
		table.unpack(elements),
	}
end

-- ------------------------------------------------------------------------------
-- Status Bar
-- ------------------------------------------------------------------------------

local kinds = {
	-- Documents
	md = "Markdown",
	markdown = "Markdown",
	rst = "reStructuredText",
	org = "Org Document",
	txt = "Text",
	log = "Log",
	pdf = "PDF Document",
	djvu = "DjVu Document",
	epub = "EPUB Book",
	mobi = "Mobi Book",
	azw3 = "Kindle Book",
	odt = "Document",
	ods = "Spreadsheet",
	odp = "Presentation",
	odg = "Drawing",
	doc = "Document",
	docx = "Document",
	xls = "Spreadsheet",
	xlsx = "Spreadsheet",
	ppt = "Presentation",
	pptx = "Presentation",
	csv = "CSV",
	tsv = "TSV",
	rtf = "Rich Text",
	ipynb = "Jupyter Notebook",
	-- Images
	png = "PNG Image",
	jpg = "JPEG Image",
	jpeg = "JPEG Image",
	jxl = "JPEG XL Image",
	gif = "GIF Image",
	webp = "WebP Image",
	avif = "AVIF Image",
	heic = "HEIC Image",
	heif = "HEIF Image",
	bmp = "BMP Image",
	tif = "TIFF Image",
	tiff = "TIFF Image",
	ico = "Icon",
	svg = "SVG Image",
	raw = "Raw Image",
	dng = "Raw Image",
	cr2 = "Raw Image",
	cr3 = "Raw Image",
	nef = "Raw Image",
	arw = "Raw Image",
	psd = "Photoshop Document",
	xcf = "GIMP Image",
	kra = "Krita Document",
	blend = "Blender File",
	-- Video
	mp4 = "MP4 Video",
	m4v = "MP4 Video",
	mkv = "Matroska Video",
	webm = "WebM Video",
	mov = "QuickTime Video",
	avi = "AVI Video",
	wmv = "WMV Video",
	flv = "Flash Video",
	mpg = "MPEG Video",
	mpeg = "MPEG Video",
	ogv = "Ogg Video",
	["3gp"] = "3GP Video",
	-- Audio
	mp3 = "MP3 Audio",
	flac = "FLAC Audio",
	wav = "WAV Audio",
	ogg = "Ogg Audio",
	oga = "Ogg Audio",
	opus = "Opus Audio",
	m4a = "M4A Audio",
	aac = "AAC Audio",
	wma = "WMA Audio",
	aif = "AIFF Audio",
	aiff = "AIFF Audio",
	mid = "MIDI",
	midi = "MIDI",
	-- Subtitles
	srt = "Subtitles",
	ass = "Subtitles",
	vtt = "Subtitles",
	-- Code
	sh = "Shell Script",
	bash = "Shell Script",
	zsh = "Zsh Script",
	fish = "Fish Script",
	ps1 = "PowerShell Script",
	bat = "Batch File",
	lua = "Lua",
	py = "Python",
	rb = "Ruby",
	pl = "Perl",
	php = "PHP",
	rs = "Rust",
	c = "C",
	h = "C Header",
	cpp = "C++",
	cc = "C++",
	cxx = "C++",
	hpp = "C++ Header",
	hh = "C++ Header",
	cs = "C#",
	go = "Go",
	java = "Java",
	kt = "Kotlin",
	scala = "Scala",
	swift = "Swift",
	dart = "Dart",
	zig = "Zig",
	hs = "Haskell",
	ex = "Elixir",
	exs = "Elixir",
	erl = "Erlang",
	r = "R",
	js = "JavaScript",
	mjs = "JavaScript",
	cjs = "JavaScript",
	jsx = "JSX",
	ts = "TypeScript",
	mts = "TypeScript",
	cts = "TypeScript",
	tsx = "TSX",
	lisp = "Common Lisp",
	cl = "Common Lisp",
	el = "Emacs Lisp",
	scm = "Scheme",
	ss = "Scheme",
	rkt = "Racket",
	clj = "Clojure",
	cljs = "ClojureScript",
	edn = "EDN",
	fnl = "Fennel",
	sql = "SQL",
	vim = "Vim Script",
	-- Markup and styles
	html = "HTML",
	htm = "HTML",
	xhtml = "XHTML",
	hbs = "Handlebars",
	handlebars = "Handlebars",
	css = "CSS",
	scss = "SCSS",
	sass = "Sass",
	less = "Less",
	xml = "XML",
	xsd = "XML Schema",
	dtd = "DTD",
	tex = "TeX",
	sty = "LaTeX Package",
	bib = "BibTeX",
	-- Configuration and data
	json = "JSON",
	json5 = "JSON5",
	jsonc = "JSON",
	toml = "TOML",
	yaml = "YAML",
	yml = "YAML",
	ini = "INI",
	conf = "Configuration",
	cfg = "Configuration",
	properties = "Properties",
	desktop = "Desktop Entry",
	service = "Systemd Unit",
	timer = "Systemd Timer",
	socket = "Systemd Socket",
	mount = "Systemd Mount",
	mk = "Makefile",
	cmake = "CMake",
	diff = "Diff",
	patch = "Patch",
	lock = "Lock File",
	db = "Database",
	sqlite = "SQLite Database",
	sqlite3 = "SQLite Database",
	-- Archives
	zip = "ZIP Archive",
	["7z"] = "7-Zip Archive",
	rar = "RAR Archive",
	tar = "Tar Archive",
	tgz = "Gzip Archive",
	gz = "Gzip Archive",
	xz = "XZ Archive",
	zst = "Zstandard Archive",
	bz2 = "Bzip2 Archive",
	lz4 = "LZ4 Archive",
	jar = "Java Archive",
	-- Disk images and packages
	iso = "Disc Image",
	img = "Disk Image",
	qcow2 = "Disk Image",
	dmg = "Disk Image",
	appimage = "AppImage",
	deb = "Debian Package",
	rpm = "RPM Package",
	apk = "Android Package",
	flatpakref = "Flatpak Reference",
	-- Binaries
	exe = "Windows Executable",
	msi = "Windows Installer",
	dll = "Windows Library",
	so = "Shared Library",
	a = "Static Library",
	o = "Object File",
	-- Fonts
	ttf = "TrueType Font",
	otf = "OpenType Font",
	ttc = "Font Collection",
	woff = "Web Font",
	woff2 = "Web Font",
	-- Security
	gpg = "PGP File",
	asc = "PGP File",
	pem = "Certificate",
	crt = "Certificate",
	kdbx = "KeePass Database",
	-- Other
	ics = "Calendar",
	vcf = "Contact",
	eml = "Email",
	torrent = "Torrent",
}

local function kind(file)
	if file.cha.is_orphan then
		return "Broken Link"
	elseif file.cha.is_dir then
		return "Directory"
	end

	local extension = file.url.ext and file.url.ext:lower()
	if extension and kinds[extension] then
		return kinds[extension]
	end

	local mime = file:mime() or ""
	local category = mime:match("^([%w-]+)/")
	if mime == "inode/empty" then
		return "Empty File"
	elseif category == "image" then
		return (extension and extension:upper() .. " " or "") .. "Image"
	elseif category == "video" then
		return (extension and extension:upper() .. " " or "") .. "Video"
	elseif category == "audio" then
		return (extension and extension:upper() .. " " or "") .. "Audio"
	elseif category == "text" then
		return "Text"
	elseif file.cha.is_exec then
		return "Executable"
	end

	return extension and extension:upper() .. " File" or "File"
end

local function size(file)
	local bytes = file:size()
	if bytes then
		return ya.readable_size(bytes)
	elseif file.cha.is_dir then
		local folder = cx.active:history(file.url)
		if folder then
			local count = #folder.files
			return count == 1 and "1 item" or string.format("%d items", count)
		end
	end

	return ""
end

local calculation = nil

ps.sub("hover", function()
	if calculation then
		calculation:abort()
		calculation = nil
	end

	local file = cx.active.current.hovered
	if not file or not file.cha.is_dir or file:size() then
		return
	end

	local url = file.url

	calculation = ya.async(function()
		local iterator = fs.calc_size(url)
		if not iterator then
			return
		end

		local bytes = 0
		while true do
			local chunk = iterator:recv()
			if not chunk then
				break
			end
			bytes = bytes + chunk
		end

		ya.emit("update_files", { op = fs.op("size", { url = url.trail, sizes = { [url.key] = bytes } }) })
	end)
end)

function Status:redraw()
	local area = self._area
	local inner = ui.Rect { x = area.x + 2, y = area.y, w = math.max(0, area.w - 4), h = 1 }

	local file = self._current.hovered
	local left = file and kind(file) or ""
	local right = file and size(file) or ""

	return {
		frame(ui.Rect { x = area.x, y = area.y - 1, w = area.w, h = 3 }),
		ui.Line(left):area(inner),
		ui.Line(right):area(inner):align(ui.Align.RIGHT),
		table.unpack(ui.redraw(Progress:new(inner, ui.width(right)))),
	}
end

-- ------------------------------------------------------------------------------
-- Clipboard
-- ------------------------------------------------------------------------------

require("system-clipboard"):setup()
