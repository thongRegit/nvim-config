return {
	"folke/trouble.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	opts = {
		focus = true, -- Focus Trouble when opened
	},
	config = function()
		-- Configure diagnostic signs globally
		vim.diagnostic.config({
			signs = {
				values = {
					DiagnosticSignError = { text = "✗", texthl = "DiagnosticError" },
					DiagnosticSignWarn = { text = "⚠", texthl = "DiagnosticWarn" },
					DiagnosticSignInfo = { text = "ℹ", texthl = "DiagnosticInfo" },
					DiagnosticSignHint = { text = "➤", texthl = "DiagnosticHint" },
				},
			},
		})

		-- Additional Trouble.nvim setup
		require("trouble").setup({
			use_diagnostic_signs = true, -- Use diagnostic signs defined above
		})
	end,
	cmd = "Trouble",
	keys = {
		{ "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
		{
			"<leader>xd",
			"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
			desc = "Open trouble document diagnostics",
		},
		{ "<leader>xq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
		{ "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
	},
}
