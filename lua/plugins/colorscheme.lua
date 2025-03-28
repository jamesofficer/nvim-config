return {
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			vim.cmd.colorscheme("tokyonight-moon")
			vim.cmd.hi("Comment gui=none")
		end,
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
			require("bamboo").load()
		end,
	},
}
