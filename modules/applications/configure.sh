function post() {
	command systemctl --user --root=/ add-wants graphical-session.target gnome-software.service
	command systemctl --user --root=/ add-wants graphical-session.target localsearch-3.service

	# command sudo systemctl enable --now cups.socket
}
