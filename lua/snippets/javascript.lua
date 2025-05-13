local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("javascript", {
	s("loggy", {
		t("console.log("),
		i(1),
		t(");"),
		i(0),
	}),
})
