return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	config = function()
		require("nvim-treesitter.configs").setup({
			textobjects = {
				swap = {
					enable = true,
					swap_next = {
						["<leader>p"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>P"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
						["]t"] = "@tag.outer", -- Add this for HTML tags
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
						["]T"] = "@tag.outer", -- Add this for HTML tags
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
						["[t"] = "@tag.outer", -- Add this for HTML tags
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
						["[T"] = "@tag.outer", -- Add this for HTML tags
					},
				},
				lsp_interop = {
					enable = true,
					border = "none",
					floating_preview_opts = {},
					peek_definition_code = {
						["<leader>cp"] = "@function.outer",
						["<leader>cP"] = "@class.outer",
					},
				},
			},
		})
	end,
}
