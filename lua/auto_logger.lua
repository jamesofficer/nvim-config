-- auto_logger.lua
-- Place this file in ~/.config/nvim/lua/auto_logger.lua

local M = {}

-- Language-specific configurations
local language_configs = {
	javascript = {
		extensions = { ".js", ".jsx", ".mjs" },
		log_template = 'console.log("%s:", %s);',
		variable_pattern = "([%w_]+)%s*=",
		comment = "//",
	},
	typescript = {
		extensions = { ".ts", ".tsx" },
		log_template = 'console.log("%s:", %s);',
		variable_pattern = "([%w_]+)%s*=",
		comment = "//",
	},
	javascriptreact = {
		extensions = { ".jsx" },
		log_template = 'console.log("%s:", %s);',
		variable_pattern = "([%w_]+)%s*=",
		comment = "//",
	},
	typescriptreact = {
		extensions = { ".tsx" },
		log_template = 'console.log("%s:", %s);',
		variable_pattern = "([%w_]+)%s*=",
		comment = "//",
	},
	python = {
		extensions = { ".py" },
		log_template = 'print(f"%s: {%s}")',
		variable_pattern = "([%w_]+)%s*=",
		comment = "#",
	},
	lua = {
		extensions = { ".lua" },
		log_template = 'print("%s:", %s)',
		variable_pattern = "([%w_]+)%s*=",
		comment = "--",
	},
	go = {
		extensions = { ".go" },
		log_template = 'fmt.Printf("%s: %%v\\n", %s)',
		variable_pattern = "([%w_]+)%s*:=",
		comment = "//",
	},
	rust = {
		extensions = { ".rs" },
		log_template = 'println!("%s: {:?}", %s);',
		variable_pattern = "let%s+mut%s+([%w_]+)|let%s+([%w_]+)",
		comment = "//",
	},
}

-- Function to detect the current language
local function get_language_config()
	local filetype = vim.bo.filetype
	return language_configs[filetype]
end

-- Function to extract variable name from a line
local function extract_variable(line, pattern)
	-- First try const/let/var for JS/TS
	local var_name = line:match("const%s+([%w_]+)%s*=")
		or line:match("let%s+([%w_]+)%s*=")
		or line:match("var%s+([%w_]+)%s*=")

	-- If not found, try the language-specific pattern
	if not var_name then
		var_name = line:match(pattern)
	end

	-- For destructuring in JS/TS, handle simple cases
	if not var_name then
		var_name = line:match("const%s+{%s*([%w_]+)[%s,}]")
			or line:match("let%s+{%s*([%w_]+)[%s,}]")
			or line:match("const%s+%[%s*([%w_]+)[%s,%]]")
			or line:match("let%s+%[%s*([%w_]+)[%s,%]]")
	end

	return var_name
end

-- Function to calculate proper indentation
local function get_indentation(line)
	return line:match("^(%s*)")
end

-- Main function to insert log statements
function M.insert_logs()
	local config = get_language_config()
	if not config then
		vim.notify("Auto-logger: Unsupported language", vim.log.levels.WARN)
		return
	end

	-- Get the visual selection range
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")

	-- Get all lines in the selection
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	-- Track variables to log and their line numbers
	local logs_to_insert = {}

	for i, line in ipairs(lines) do
		local var_name = extract_variable(line, config.variable_pattern)
		if var_name then
			local line_num = start_line + i - 1
			local indentation = get_indentation(line)
			local log_statement = indentation .. string.format(config.log_template, var_name, var_name)
			table.insert(logs_to_insert, { line = line_num, log = log_statement })
		end
	end

	-- Insert logs in reverse order to maintain line numbers
	for i = #logs_to_insert, 1, -1 do
		local item = logs_to_insert[i]
		vim.api.nvim_buf_set_lines(0, item.line, item.line, false, { item.log })
	end

	-- Exit visual mode
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

	-- Report what was done
	if #logs_to_insert > 0 then
		vim.notify(string.format("Auto-logger: Inserted %d log statement(s)", #logs_to_insert), vim.log.levels.INFO)
	else
		vim.notify("Auto-logger: No variables found to log", vim.log.levels.WARN)
	end
end

-- Function to remove log statements in selection
function M.remove_logs()
	local config = get_language_config()
	if not config then
		vim.notify("Auto-logger: Unsupported language", vim.log.levels.WARN)
		return
	end

	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")

	-- Extend the range to include potential log statements after the selection
	local extended_end = math.min(end_line + (end_line - start_line + 1), vim.api.nvim_buf_line_count(0))
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, extended_end, false)

	local lines_to_remove = {}

	for i, line in ipairs(lines) do
		-- Check if line contains console.log, print, fmt.Printf, etc.
		if
			line:match("console%.log%s*%(")
			or line:match("print%s*%(")
			or line:match("fmt%.Printf%s*%(")
			or line:match("println!%s*%(")
		then
			table.insert(lines_to_remove, start_line + i - 1)
		end
	end

	-- Remove lines in reverse order
	for i = #lines_to_remove, 1, -1 do
		vim.api.nvim_buf_set_lines(0, lines_to_remove[i] - 1, lines_to_remove[i], false, {})
	end

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

	if #lines_to_remove > 0 then
		vim.notify(string.format("Auto-logger: Removed %d log statement(s)", #lines_to_remove), vim.log.levels.INFO)
	else
		vim.notify("Auto-logger: No log statements found to remove", vim.log.levels.WARN)
	end
end

-- Setup function to create commands and keymaps
function M.setup(opts)
	opts = opts or {}

	-- Create commands
	vim.api.nvim_create_user_command("AutoLog", function()
		M.insert_logs()
	end, { range = true })

	vim.api.nvim_create_user_command("AutoLogRemove", function()
		M.remove_logs()
	end, { range = true })

	-- Set up default keymaps (can be overridden in opts)
	local keymaps = opts.keymaps or {
		insert = "<leader>al",
		remove = "<leader>ar",
	}

	-- Visual mode keymaps
	vim.keymap.set("v", keymaps.insert, ":AutoLog<CR>", { desc = "Auto insert log statements" })
	vim.keymap.set("v", keymaps.remove, ":AutoLogRemove<CR>", { desc = "Remove log statements" })
end

return M
