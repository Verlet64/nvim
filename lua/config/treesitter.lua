local treesitter = require("nvim-treesitter.configs")

treesitter.setup {
	ensure_installed = {
		"go",
	},
	highlight = {
		enable = true,
	},
}
