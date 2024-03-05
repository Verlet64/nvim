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

vim.api.nvim_create_user_command([[GoGet]], function (command)
	local packages = command.fargs

	for _, package in ipairs(packages) do
		vim.fn.jobstart(
			{ "go", "get", package },
			{
				on_stdout = function (j, d, e)
					print(vim.inspect(j), vim.inspect(d), vim.inspect(e))
				end,
				stderr_buffered = true,
				on_stderr = function (j, d, e)
					print(vim.inspect(j), vim.inspect(d), vim.inspect(e))
				end,
				on_exit = function (j, d, e)
					print(vim.inspect(j), vim.inspect(d), vim.inspect(e))
				end
			}
		)
	end
end, {
	desc = "install go package(s) into the current go project",
	nargs = "+",
	complete = function ()
		print("download complete")
	end
})

local build_flags = {}

vim.api.nvim_create_user_command("GoTest", function ()
	local path = vim.api.nvim_buf_get_name(0)

	vim.fn.jobstart(
		{ "go", "test", path},
		{
			on_stdout = function (j, d, e)
				print(vim.inspect(j), vim.inspect(d), vim.inspect(e))
			end,
			stdout_buffered = true,
			on_stderr = function (j, d, e)
				print(vim.inspect(j), vim.inspect(d), vim.inspect(e))
			end,
			stderr_buffered = true,
			on_exit = function (j, d, e)
				print(vim.inspect(j), vim.inspect(d), vim.inspect(e))
			end
		}
	)
end, {})

vim.api.nvim_create_user_command("GoTestAll", function ()
	vim.fn.jobstart(
		{ "go", "test", "./..."},
		{
			on_stdout = function (j, d, e)
				print(vim.inspect(j), vim.inspect(d), vim.inspect(e))
			end,
			stdout_buffered = true,
			on_stderr = function (j, d, e)
				print(vim.inspect(j), vim.inspect(d), vim.inspect(e))
			end,
			stderr_buffered = true,
			on_exit = function (j, d, e)
				print(vim.inspect(j), vim.inspect(d), vim.inspect(e))
			end
		}
	)
end, {})

local lspconfig = require("lspconfig")
local on_attach_lspconfig = require("plugins.lspconfig").on_attach
local capabilities_lspconfig = require("cmp_nvim_lsp").capabilities

local gopls_opts = {
	on_attach = on_attach_lspconfig,
	capabilities = capabilities_lspconfig,
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
		}
	}
}

lspconfig.gopls.setup(gopls_opts)
vim.api.nvim_create_user_command(
	'GoBuildTags',
	function (command)
		local args = command.fargs
		build_flags = { "-tags", table.concat(args, ",") }
		gopls_opts.settings.gopls.buildFlags = build_flags
		lspconfig.gopls.setup(gopls_opts)
	end,
	{ nargs = '+' }
)

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
