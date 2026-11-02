if ! command -v "git" > "/dev/null"
then
	modules "git"
fi

if ! command -v "npm" > "/dev/null"
then
	modules "node"
fi

command local target

target="${XDG_DATA_HOME:-${HOME}/.local/data}/lumen"

if command test -d "${target}/.git"
then
	command git -C "${target}" pull --ff-only
else
	command git clone "https://github.com/albertobeloni/lumen.git" "${target}"
fi

command npm --prefix "${target}" install --omit=dev
command npm install --global "${target}"
