local dapgo = require('dap-go')
local mason_registry = require('mason-registry')

local delve_path = mason_registry.get_package("delve"):get_install_path() .. "/dlv"

dapgo.setup {
	  dap_configurations = {
		{
				type = "go",
				name = "Attach remote",
				mode = "remote",
				request = "attach",
		},
	  },
	  delve = {
		-- the path to the executable dlv which will be used for debugging.
		-- by default, this is the "dlv" executable on your PATH.
		path = delve_path,
		-- time to wait for delve to initialize the debug session.
		-- default to 20 seconds
		initialize_timeout_sec = 20,
		-- a string that defines the port to start delve debugger.
		-- default to string "${port}" which instructs nvim-dap
		-- to start the process in a random available port
		port = "${port}",
		-- additional args to pass to dlv
		args = {},
		build_flags = "",
	  },
}

local wk = require('which-key')

wk.register({
	g = {
		name = "go",
		d = {
			name="debug",
			t = { function ()
				require('dap-go').debug_test()
			end, "test"}
		}
	}
}, { prefix=[[<leader>]]})
