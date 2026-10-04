pre()
{
	backup "/etc/locale.conf"
	backup "/etc/locale.gen"
}

post()
{
	command sudo cp -r --no-preserve=ownership "${path}/data/locale.conf" "/etc/locale.conf"
	command sudo sed -i -e "s/\#en_US\.UTF-8/en_US\.UTF-8/g" "/etc/locale.gen"
	command sudo sed -i -e "s/\#pt_BR\.UTF-8/pt_BR\.UTF-8/g" "/etc/locale.gen"
	command sudo locale-gen
}
