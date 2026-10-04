post()
{
	command sed "s/YOURUSER/${USER}/" "${path}/data/config.toml" | command sudo tee "/etc/greetd/config.toml" > "/dev/null"
	command sudo systemctl enable greetd.service
}
