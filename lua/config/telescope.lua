local telescope = require('telescope')
local project = require("telescope._extensions.project.actions")

telescope.setup {
	  pickers = {
		  buffers = {
			  initial_mode = 'normal'
		  }
	  },
	  extensions = {
	        project = {
			on_project_selected = function(prompt_bufnr)
				project.browse_project_files(prompt_bufnr)
			end
		}
	}
}

telescope.load_extension('project')

local wk = require('which-key')

wk.register({
	f = {
		f = { "<cmd>Telescope find_files<cr>", "File Browser" },
		d = { [[<cmd>Telescope file_browser<cr>]], "File Browser"},
		b = { "<cmd>Telescope buffers<cr>", "List buffers" },
		r = { "<cmd>Telescope oldfiles<cr>", "List Recent Files" },
		p = { function () telescope.extensions.project.project{} end, "List Projects"},
		n = { "Create File or Directory" },
		g = { "<cmd>Telescope live_grep<cr>", "Grep files" } ,
		h = { "<cmd>Telescope help_tags<cr>", "Show Telescope Help"},

	}
}, { prefix = "<leader>"} )
