return {
	"echasnovski/mini.files",
	version = "*",
	config = function()
		local minifiles = require("mini.files")

		vim.keymap.set("n", "<leader>e", function()
			local currentbuffer = vim.api.nvim_buf_get_name(0)
			minifiles.open(currentbuffer)
		end, { desc = "Fil[e] Browser" })

		minifiles.setup({
			mappings = {
				close = "q",
				go_in = "<Right>",
				go_in_plus = "L",
				go_out = "<Left>",
				go_out_plus = "H",
				reset = "<BS>",
				reveal_cwd = "@",
				show_help = "g?",
				synchronize = "=",
				trim_left = "<",
				trim_right = ">",
			},

			options = {
				use_as_default_explorer = true,
			},
		})
	end,
}
