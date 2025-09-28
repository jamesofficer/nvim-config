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
			-- ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-i>"] = { "show", "show_documentation", "hide_documentation" },

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

			["<C-p>"] = { "select_prev", "fallback_to_mappings" },
			["<C-n>"] = { "select_next", "fallback_to_mappings" },

			["<C-a>"] = { "scroll_documentation_up", "fallback" },
			["<C-h>"] = { "scroll_documentation_down", "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		-- snippets = {
		-- 	preset = "mini_snippets",
		-- },

		sources = {
			-- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
			-- default = { "lsp", "path", "snippets", "buffer" },
			default = { "snippets", "lsp", "path", "buffer" },
		},

		signature = { enabled = true },

		completion = {
			trigger = {
				show_on_keyword = true,
			},

			keyword = { range = "full" },

			accept = { auto_brackets = { enabled = false } },

			list = { selection = { preselect = false, auto_insert = false } },

			documentation = { auto_show = true },

			ghost_text = { enabled = false },

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
