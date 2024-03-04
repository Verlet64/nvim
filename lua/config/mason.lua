local present, mason = pcall(require, "mason")

if not present then
  return
end

local options = {
	ensure_installed = {
		"delve",
		"codelldb",
		"gopls",
		"lua-language-server",
	}
}

vim.api.nvim_create_user_command("MasonInstallAll", function()
	local i = options.ensure_installed
	vim.cmd("MasonInstall " .. table.concat(i, " "))
end, {})

mason.setup(options)
