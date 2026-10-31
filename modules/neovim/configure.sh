post()
{
	command local plugin

	plugin="${XDG_DATA_HOME}/nvim/site/pack/setup/start/nvim-treesitter"

	if command test -d "${plugin}/.git"
	then
		command git -C "${plugin}" fetch --depth 1 origin main
		command git -C "${plugin}" reset --hard FETCH_HEAD
	else
		command git clone --depth 1 --branch main "https://github.com/nvim-treesitter/nvim-treesitter.git" "${plugin}"
	fi

	command nvim --headless -c "lua if not require('treesitter').install() then vim.cmd.cquit() end" -c "qall"
}
