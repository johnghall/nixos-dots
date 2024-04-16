local lua = require("utils.mappings").lua

return {
	{
		"kylechui/nvim-surround",
		keys = {
			{ "cs", mode = { "n" } },
			{ "ds", mode = { "n" } },
			{ "ys", mode = { "n" } },
			{ "S", mode = { "v" } },
		},
		opts = {},
	},
	{
		"fedepujol/move.nvim",
		cmd = {
			"MoveLine",
			"MoveHChar",
			"MoveBlock",
			"MoveHBlock",
		},
	},
	{
		"folke/flash.nvim",
		keys = {
			{ "f", mode = { "n", "v" } },
			{ "F", mode = { "n", "v" } },
			{ "t", mode = { "n", "v" } },
			{ "T", mode = { "n", "v" } },
			{ "s", mode = { "n", "v" }, lua('require("flash").jump()') },
			{ "ß", mode = "n", lua("require('flash').jump({ pattern = vim.fn.expand('<cword>') })") },
			{ "S", mode = "n", lua("require('flash').treesitter()") },
			{ "o", mode = "o", lua("require('flash').jump()"), desc = "Search jump" },
			{ "O", mode = "o", lua("require('flash').treesitter()"), desc = "Tresitter jump" },
		},
		opts = {},
	},
}
