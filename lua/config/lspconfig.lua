local lspconfig = require("lspconfig")

local on_attach_lspconfig = require("plugins.lspconfig").on_attach
local capabilities_lspconfig = require("cmp_nvim_lsp").capabilities


local wk = require('which-key')

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
		gopls_opts.settings.gopls.buildFlags = { "-tags", table.concat(args, ",") }
		lspconfig.gopls.setup(gopls_opts)
	end,
	{ nargs = '+' }
)

lspconfig.lua_ls.setup {
	  on_init = function(client)
		local path = client.workspace_folders[1].name
		if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
		client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
			Lua = {
				  runtime = {
					    version = 'LuaJIT'
				  },
				  workspace = {
					    checkThirdParty = false,
					    library = {
					      vim.env.VIMRUNTIME
					    },
				  },
			},
		})
		client.capabilities = capabilities_lspconfig
		client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
		return true
	end,
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function (ev)
	local opts = { buffer = ev.buf }
	wk.register({
		g = {
			d = { function () vim.lsp.buf.definition(opts) end, [[Go to definition]] },
			D = { function () vim.lsp.buf.declaration(opts) end, [[Go to declaration]] },
			i = { function () vim.lsp.buf.implementation(opts) end, [[Go to implementation]] }
		}
	})
  end
})

local luasnip = require("luasnip")
local cmp = require ("cmp")

cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
	    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
	    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
	    -- C-b (back) C-f (forward) for snippet placeholder navigation.
	    ['<C-Space>'] = cmp.mapping.complete(),
	    ['<CR>'] = cmp.mapping.confirm {
	      behavior = cmp.ConfirmBehavior.Replace,
	      select = true,
	    },
	    ['<Tab>'] = cmp.mapping(function(fallback)
	      if cmp.visible() then
		cmp.select_next_item()
	      elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	      else
		fallback()
	      end
	    end, { 'i', 's' }),
	    ['<S-Tab>'] = cmp.mapping(function(fallback)
	      if cmp.visible() then
		cmp.select_prev_item()
	      elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	      else
		fallback()
	      end
	    end, { 'i', 's' }),
	}),
	sources = {
	    { name = 'nvim_lsp' },
	    { name = 'luasnip' },
	},
}
