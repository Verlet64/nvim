return {
	"williamboman/mason.nvim",
	opts = {
		ensure_installed = {
			"delve",
			"codelldb",
			"gopls",
			"lua-language-server",
		},
	},
}
