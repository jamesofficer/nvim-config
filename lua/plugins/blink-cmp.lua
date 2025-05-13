return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	-- dependencies = { "rafamadriz/friendly-snippets" },
	version = "*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		fuzzy = { implementation = "prefer_rust_with_warning" },

		-- keymap = { preset = "default" },

		keymap = {
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },

			["<Tab>"] = {
				function(cmp)
					return cmp.select_next()
				end,
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = {
				function(cmp)
					return cmp.select_prev()
				end,
				"snippet_backward",
				"fallback",
			},

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-up>"] = { "scroll_documentation_up", "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		sources = {
			-- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
			-- default = { "lsp", "path", "snippets", "buffer" },
			default = { "lsp", "path", "snippets" },
		},

		signature = { enabled = true },

		completion = {
			trigger = {
				show_on_keyword = true,
			},

			keyword = { range = "full" },

			accept = { auto_brackets = { enabled = false } },

			documentation = { auto_show = true },

			-- Use mini.icons
			menu = {
				auto_show = true,

				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
								return kind_icon
							end,
							-- (optional) use highlights from mini.icons
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
						kind = {
							-- (optional) use highlights from mini.icons
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
					},
				},
			},
		},
	},
}
