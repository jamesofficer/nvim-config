return {
	"s1n7ax/nvim-window-picker",
	name = "window-picker",
	event = "VeryLazy",
	version = "2.*",
	config = function()
		require("window-picker").setup({
			selection_chars = "nrtshaeigyfodw",
			hint = "floating-big-letter",
		})

		vim.keymap.set("n", "<leader>i", "<cmd>lua require('window-picker').pick_window()<CR>", {
			desc = "Pick Window",
		})
	end,
}
