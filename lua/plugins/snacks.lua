return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = false },
		bufdelete = { enabled = true },
		dashboard = { enabled = false },
		dim = { enabled = true },
		indent = { enabled = true },
		input = { enabled = false },
		lazygit = { enabled = true },
		gitbrowse = { enabled = true },
		notifier = { enabled = false },
		picker = { enabled = true },
		quickfile = { enabled = false },
		scroll = { enabled = false },
		statuscolumn = { enabled = false },
		words = { enabled = true },
		zen = { enabled = true },
	},
	keys = {
		--------------
		-- Bufdelete
		--------------
		{
			"<leader>bD",
			function()
				Snacks.bufdelete()
			end,
			desc = "Bufdelete",
		},
		--------------
		-- Zen
		--------------
		{
			"<leader>uz",
			function()
				Snacks.zen()
			end,
			desc = "Zen",
		},
		--------------
		-- Words
		--------------
		{
			"<leader>uw",
			function()
				if Snacks.words.is_enabled() then
					Snacks.words.disable()
				else
					Snacks.words.enable()
				end
			end,
			desc = "Toggle Words",
		},
		--------------
		-- Dim
		--------------
		{
			"<leader>ud",
			function()
				if Snacks.dim.enabled then
					Snacks.dim.disable()
				else
					Snacks.dim.enable()
				end
			end,
			desc = "Toggle Dim",
		},
		--------------
		-- LazyGit
		--------------
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "LazyGit",
		},
		--------------
		-- GitBrowse
		--------------
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "GitBrowse",
		},
		{
			"<leader>pa",
			function()
				Snacks.picker()
			end,
			desc = "All Pickers",
		},
		--------------
		-- Pickers
		--------------
		{
			"<leader>sS",
			function()
				Snacks.picker.files()
			end,
			desc = "Files (all)",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Files (in Git)",
		},
		{
			"<leader><leader>",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent Files",
		},
		{
			"<leader>sR",
			function()
				Snacks.picker.registers()
			end,
			desc = "Registers",
		},
		{
			"<leader>sr",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			"<leader>sl",
			function()
				Snacks.picker.lines()
			end,
			desc = "Lines",
		},
		{
			"<leader>sm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>su",
			function()
				Snacks.picker.undo()
			end,
			desc = "Undo History",
		},
		{
			"<leader>sj",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumps",
		},
		{
			"<leader>ls",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "Lsp Symbols",
		},
		{
			"<leader>lS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "Lsp Symbols (Workspace)",
		},
		{
			"<leader>uc",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Colorschemes (UI)",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
		},
	},
}
