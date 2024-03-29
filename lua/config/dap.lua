local dap = require("dap")
local mason_registry = require("mason-registry")

local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension"
local codelldb_path = codelldb_root .. "/adapter/codelldb"
local liblldb_path = codelldb_root .. "/lldb/lib/liblldb.so"

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = codelldb_path,
		args = { "--port", "${port}" },
	},
}

local codelldb = {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
}

dap.configurations.rust = {
	codelldb
}

local dapui = require('dapui')

dapui.setup()
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

local wk = require("which-key")

wk.register({
	name = "debug",
	d = {
		s = {
			name = "step",
			k = { "<cmd>DapStepOut<cr>", "step out"},
			j = { "<cmd>DapStepInto<cr>", "step into"},
			l = { "<cmd>DapStepOver<cr>", "step over"},
		},
		b = { "<cmd>DapToggleBreakpoint<cr>", "toggle breakpoint" }
	}
}, { prefix = "<leader>" })
