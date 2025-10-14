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
	config = function(_, opts)
		for server, config in pairs(opts.servers) do
			-- passing config.capabilities to blink.cmp merges with the capabilities in your
			-- `opts[server].capabilities, if you've defined it
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end
	end,
}
