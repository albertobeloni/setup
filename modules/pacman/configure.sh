function post() {
	command local packages

	packages="${XDG_CACHE_HOME:-${HOME}/.local/cache}/packages"

	distribution arch && command sudo systemctl enable --now paccache.timer
	distribution arch && command mkdir -p "${packages}"
	distribution arch && command paccache -rk2 -c "${packages}"
}
