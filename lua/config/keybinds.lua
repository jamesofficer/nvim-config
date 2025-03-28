vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<leader>w", "<CMD>:w<CR>", { desc = "Save file" })

vim.keymap.set("n", "<S-Up>", "6k", { desc = "Move up 6 lines" })
vim.keymap.set("n", "<S-Down>", "6j", { desc = "Move down 6 lines" })
vim.keymap.set("n", "K", "6k", { desc = "Move up 6 lines" })
vim.keymap.set("n", "J", "6j", { desc = "Move down 6 lines" })

vim.keymap.set("n", "<leader>tv", "<CMD>:vsplit<CR>", { desc = "Split [V]ertically" })
vim.keymap.set("n", "<leader>th", "<CMD>:split<CR>", { desc = "Split [V]ertically" })
vim.keymap.set("n", "<leader>tt", "<CMD>:wincmd w<CR>", { desc = "Cycle Splits" })

vim.keymap.set("n", "<leader>t<Up>", "<CMD>:wincmd k<CR>", { desc = "Go to Top Split" })
vim.keymap.set("n", "<leader>t<Down>", "<CMD>:wincmd j<CR>", { desc = "Go to Bottom Split" })
vim.keymap.set("n", "<leader>t<Left>", "<CMD>:wincmd h<CR>", { desc = "Go to Left Split" })
vim.keymap.set("n", "<leader>t<Right>", "<CMD>:wincmd l<CR>", { desc = "Go to Bottom Split" })

vim.keymap.set("n", "<leader>uy", ":%y+<CR>", { desc = "Yank entire buffer to clipboard" })

vim.keymap.set("n", "<leader>bd", "<CMD>:bd<CR>", { desc = "[D]elete Buffer" })

vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[R]ename Symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })

vim.keymap.set("n", "<leader>cu", function()
	vim.lsp.buf.code_action({
		apply = true,
		context = {
			only = { "source.removeUnusedImports.ts" },
			diagnostics = {},
		},
	})
end, { desc = "Remove unused TypeScript/JavaScript imports" })
