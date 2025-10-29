return {
	"neovim/nvim-lspconfig",
	dependencies = { "saghen/blink.cmp" },

	-- example using `opts` for defining servers
	opts = {
		servers = {
			-- 	lua_ls = {},
			-- 	ts_ls = {},
			biome = {
				root_dir = function(fname)
					return vim.fs.root(fname, { "biome.json", "biome.jsonc" })
				end,
				on_attach = function(client, bufnr)
					-- Disable formatting, let conform.nvim handle it
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
			},
		},
	},
}
