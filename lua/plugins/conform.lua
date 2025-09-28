return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = { c = true, cpp = true }

			-- Disable autoformat for files in a certain path
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if bufname:match("/node_modules/") then
				return
			end

			-- Organize imports before formatting
			require("utils").organize_imports(bufnr)

			return {
				timeout_ms = 500,
				lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			}
		end,
		formatters = {
			biome = {
				require_cwd = true,
			},
		},
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "biome", stop_after_first = true },
			javascriptreact = { "biome" },
			typescript = { "biome" },
			typescriptreact = { "biome" },
			json = { "biome" },
			jsonc = { "biome" },
			-- python = { "isort", "black" },
		},
	},
}
