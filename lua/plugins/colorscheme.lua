return {
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{
		"pappasam/papercolor-theme-slim",
		priority = 1000,
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		-- init = function()
		-- 	vim.cmd.colorscheme("tokyonight-moon")
		-- 	vim.cmd.hi("Comment gui=none")
		-- end,
	},
	{
		"sainnhe/gruvbox-material",
		lazy = true,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			-- vim.g.gruvbox_material_enable_italic = true
			-- vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"ribru17/bamboo.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("bamboo").setup({
				-- optional configuration here
			})
			-- require("bamboo").load()
		end,
	},
	{
		"sainnhe/sonokai",
		lazy = false,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.sonokai_enable_italic = true
			vim.cmd.colorscheme("sonokai")
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.vscode_style = "dark"
			-- vim.cmd.colorscheme("vscode")
		end,
	},
	{
		"bluz71/vim-nightfly-colors",
		name = "nightfly",
		lazy = false,
		priority = 1000,
	},
}
