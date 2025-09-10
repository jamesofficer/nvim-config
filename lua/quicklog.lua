-- quicklog.lua (Treesitter version)
-- Place this file in ~/.config/nvim/lua/quicklog.lua

local M = {}

-- Language-specific configurations
local language_configs = {
	javascript = {
		log_template = 'console.log("%s:", %s);',
		declaration_types = {
			"variable_declarator",
			"lexical_declaration",
			"variable_declaration",
		},
	},
	typescript = {
		log_template = 'console.log("%s:", %s);',
		declaration_types = {
			"variable_declarator",
			"lexical_declaration",
			"variable_declaration",
		},
	},
	tsx = {
		log_template = 'console.log("%s:", %s);',
		declaration_types = {
			"variable_declarator",
			"lexical_declaration",
			"variable_declaration",
		},
	},
	jsx = {
		log_template = 'console.log("%s:", %s);',
		declaration_types = {
			"variable_declarator",
			"lexical_declaration",
			"variable_declaration",
		},
	},
	python = {
		log_template = 'print(f"%s: {%s}")',
		declaration_types = {
			"assignment",
			"annotated_assignment",
		},
	},
	lua = {
		log_template = 'print("%s:", %s)',
		declaration_types = {
			"assignment_statement",
			"variable_declaration",
		},
	},
	go = {
		log_template = 'fmt.Printf("%s: %%v\\n", %s)',
		declaration_types = {
			"short_var_declaration",
			"var_declaration",
			"var_spec",
		},
	},
	rust = {
		log_template = 'println!("%s: {:?}", %s);',
		declaration_types = {
			"let_declaration",
		},
	},
}

-- Get Treesitter parser
local function get_parser()
	local ok, parser = pcall(vim.treesitter.get_parser)
	if not ok then
		return nil
	end
	return parser
end

-- Get node text
local function get_node_text(node, bufnr)
	local start_row, start_col, end_row, end_col = node:range()
	local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)

	if #lines == 0 then
		return ""
	elseif #lines == 1 then
		return string.sub(lines[1], start_col + 1, end_col)
	else
		lines[1] = string.sub(lines[1], start_col + 1)
		lines[#lines] = string.sub(lines[#lines], 1, end_col)
		return table.concat(lines, "\n")
	end
end

-- Extract variable name from different node types
local function extract_variable_name(node, bufnr, lang)
	local node_type = node:type()

	-- JavaScript/TypeScript variable declarator
	if node_type == "variable_declarator" then
		local name_node = node:field("name")[1]
		if name_node then
			-- Handle destructuring
			if name_node:type() == "object_pattern" or name_node:type() == "array_pattern" then
				-- For destructuring, get the first identifier
				local identifier = name_node:descendant_for_range(name_node:range())
				while identifier do
					if identifier:type() == "identifier" or identifier:type() == "shorthand_property_identifier" then
						return get_node_text(identifier, bufnr)
					end
					identifier = identifier:next_sibling()
				end
			elseif name_node:type() == "identifier" then
				return get_node_text(name_node, bufnr)
			end
		end

	-- Python assignment
	elseif node_type == "assignment" or node_type == "annotated_assignment" then
		local left_node = node:field("left")[1]
		if left_node and left_node:type() == "identifier" then
			return get_node_text(left_node, bufnr)
		end

	-- Go short variable declaration
	elseif node_type == "short_var_declaration" then
		local left_node = node:field("left")[1]
		if left_node then
			-- Get first identifier in expression list
			for child in left_node:iter_children() do
				if child:type() == "identifier" then
					return get_node_text(child, bufnr)
				end
			end
		end

	-- Go var spec
	elseif node_type == "var_spec" then
		local name_node = node:field("name")[1]
		if name_node and name_node:type() == "identifier" then
			return get_node_text(name_node, bufnr)
		end

	-- Rust let declaration
	elseif node_type == "let_declaration" then
		local pattern_node = node:field("pattern")[1]
		if pattern_node then
			if pattern_node:type() == "identifier" then
				return get_node_text(pattern_node, bufnr)
			elseif pattern_node:type() == "mutable_specifier" then
				-- For 'let mut x', get the identifier after 'mut'
				for child in pattern_node:iter_children() do
					if child:type() == "identifier" then
						return get_node_text(child, bufnr)
					end
				end
			end
		end

	-- Lua assignment
	elseif node_type == "assignment_statement" then
		local var_list = node:field("variables")[1]
		if var_list then
			for child in var_list:iter_children() do
				if child:type() == "identifier" then
					return get_node_text(child, bufnr)
				end
			end
		end
	end

	-- Try to find an identifier child as fallback
	for child in node:iter_children() do
		if child:type() == "identifier" then
			return get_node_text(child, bufnr)
		end
	end

	return nil
end

-- Find declaration nodes in range
local function find_declarations_in_range(bufnr, start_line, end_line, lang_config)
	local parser = get_parser()
	if not parser then
		return {}
	end

	local tree = parser:parse()[1]
	if not tree then
		return {}
	end

	local root = tree:root()
	local declarations = {}

	-- Convert to 0-indexed
	start_line = start_line - 1
	end_line = end_line - 1

	-- Query for declarations
	local function visit_node(node)
		local start_row, _, end_row, _ = node:range()

		-- Check if node starts within our range
		if start_row >= start_line and start_row <= end_line then
			local node_type = node:type()

			-- Check if this is a declaration type we care about
			for _, decl_type in ipairs(lang_config.declaration_types) do
				if node_type == decl_type then
					local var_name = extract_variable_name(node, bufnr, vim.bo.filetype)
					if var_name then
						table.insert(declarations, {
							node = node,
							var_name = var_name,
							end_row = end_row,
						})
					end
					break
				end
			end
		end

		-- Recursively visit children if node overlaps with range
		if start_row <= end_line and end_row >= start_line then
			for child in node:iter_children() do
				visit_node(child)
			end
		end
	end

	visit_node(root)
	return declarations
end

-- Get indentation of a line
local function get_line_indent(bufnr, line_num)
	local line = vim.api.nvim_buf_get_lines(bufnr, line_num, line_num + 1, false)[1]
	if line then
		return line:match("^(%s*)")
	end
	return ""
end

-- Main function to insert log statements
function M.insert_logs()
	local bufnr = vim.api.nvim_get_current_buf()
	local lang = vim.bo.filetype

	-- Handle tsx/jsx as typescript/javascript
	if lang == "typescriptreact" then
		lang = "tsx"
	end
	if lang == "javascriptreact" then
		lang = "jsx"
	end

	local config = language_configs[lang]
	if not config then
		vim.notify("QuickLog: Unsupported language (" .. lang .. ")", vim.log.levels.WARN)
		return
	end

	-- Check if treesitter parser is available
	local ok, _ = pcall(vim.treesitter.get_parser)
	if not ok then
		vim.notify("QuickLog: Treesitter parser not available for " .. lang, vim.log.levels.ERROR)
		return
	end

	-- Get visual selection range
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")

	-- Find all declarations in range
	local declarations = find_declarations_in_range(bufnr, start_line, end_line, config)

	if #declarations == 0 then
		vim.notify("QuickLog: No variables found to log", vim.log.levels.WARN)
		return
	end

	-- Sort by end position (reverse) to insert from bottom to top
	table.sort(declarations, function(a, b)
		return a.end_row > b.end_row
	end)

	-- Insert log statements
	local inserted_count = 0
	for _, decl in ipairs(declarations) do
		local indent = get_line_indent(bufnr, decl.end_row)
		local log_statement = indent .. string.format(config.log_template, decl.var_name, decl.var_name)

		-- Insert after the declaration ends (end_row is 0-indexed)
		vim.api.nvim_buf_set_lines(bufnr, decl.end_row + 1, decl.end_row + 1, false, { log_statement })
		inserted_count = inserted_count + 1
	end

	-- Exit visual mode
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

	-- Report results
	vim.notify(string.format("QuickLog: Inserted %d log statement(s)", inserted_count), vim.log.levels.INFO)
end

-- Function to remove log statements
function M.remove_logs()
	local bufnr = vim.api.nvim_get_current_buf()
	local lang = vim.bo.filetype

	if lang == "typescriptreact" then
		lang = "tsx"
	end
	if lang == "javascriptreact" then
		lang = "jsx"
	end

	local config = language_configs[lang]
	if not config then
		vim.notify("QuickLog: Unsupported language", vim.log.levels.WARN)
		return
	end

	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")

	-- Extend range to catch logs after declarations
	local extended_end = math.min(end_line + (end_line - start_line + 1), vim.api.nvim_buf_line_count(0))
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, extended_end, false)

	local lines_to_remove = {}

	for i, line in ipairs(lines) do
		-- Check for common log patterns
		if
			line:match("console%.log%s*%(")
			or line:match("print%s*%(")
			or line:match("fmt%.Printf%s*%(")
			or line:match("println!%s*%(")
		then
			table.insert(lines_to_remove, start_line + i - 1)
		end
	end

	-- Remove in reverse order
	for i = #lines_to_remove, 1, -1 do
		vim.api.nvim_buf_set_lines(0, lines_to_remove[i] - 1, lines_to_remove[i], false, {})
	end

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

	if #lines_to_remove > 0 then
		vim.notify(string.format("QuickLog: Removed %d log statement(s)", #lines_to_remove), vim.log.levels.INFO)
	else
		vim.notify("QuickLog: No log statements found to remove", vim.log.levels.WARN)
	end
end

-- Setup function
function M.setup(opts)
	opts = opts or {}

	-- Check for nvim-treesitter
	local has_treesitter = pcall(require, "nvim-treesitter")
	if not has_treesitter then
		vim.notify("QuickLog: nvim-treesitter is required but not installed", vim.log.levels.ERROR)
		return
	end

	-- Create commands
	vim.api.nvim_create_user_command("QuickLog", function()
		M.insert_logs()
	end, { range = true })

	vim.api.nvim_create_user_command("QuickLogRemove", function()
		M.remove_logs()
	end, { range = true })

	-- Set up keymaps
	local keymaps = opts.keymaps or {
		insert = "<leader>ll",
		remove = "<leader>lr",
	}

	vim.keymap.set("v", keymaps.insert, ":QuickLog<CR>", { desc = "QuickLog: Insert log statements" })
	vim.keymap.set("v", keymaps.remove, ":QuickLogRemove<CR>", { desc = "QuickLog: Remove log statements" })
end

return M
