-- local futil = require("formatter.util")
local formatter = require("formatter")

formatter.setup {
	logging = true,
	log_levels = vim.log.levels.DEBUG,
	filetype = {
		go = {
			function ()
				return {
					exe = "goimports",
					stdin = true,
			}
			end,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("__formatter__", { clear = true })
autocmd("BufWritePost", { group = "__formatter__", command = ":FormatWrite" })
