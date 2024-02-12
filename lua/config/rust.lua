local mason_registry = require("mason-registry")
local cfg = require("rustaceanvim.config")

local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension"
local codelldb_path = codelldb_root .. "/adapter/codelldb"
local liblldb_path = codelldb_root .. "/lldb/lib/liblldb.so"

vim.g.rustaceanvim = {
	dap = {
		adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
	},
}
