local treesitter = require("nvim-treesitter.configs")

treesitter.setup {
	ensure_installed = {
		"go",
		"vimdoc"
	},
	highlight = {
		enable = true,
	},
}
