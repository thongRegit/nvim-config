return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- LSP autocompletion
		"hrsh7th/nvim-cmp", -- Completion plugin
		"hrsh7th/cmp-buffer", -- Buffer source for completion
		"hrsh7th/cmp-path", -- Path source for completion
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap
		local augroup = vim.api.nvim_create_augroup

		-- Set diagnostic signs in the sign column
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Enhanced capabilities for autocompletion
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- LSP keymaps when a server attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- References
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- Go to declaration
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- Definitions
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- Implementations
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- Type definitions
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- Code actions
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Rename
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- Buffer diagnostics
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- Line diagnostics
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- Previous diagnostic
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- Next diagnostic
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Hover documentation
				keymap.set("n", "<leader>fd", vim.lsp.buf.format, opts) -- Format the document
			end,
		})

		-- Autocommand to organize imports on save
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup("organize_imports", {}),
			pattern = { "*.php", "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue" },
			callback = function()
				vim.lsp.buf.code_action({
					apply = true,
					context = { only = { "source.organizeImports" }, diagnostics = {} },
				})
			end,
		})

		-- Mason LSP setup handlers
		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({ capabilities = capabilities })
			end,
			["intelephense"] = function()
				lspconfig["intelephense"].setup({
					capabilities = capabilities,
					settings = {
						intelephense = {
							files = { maxSize = 5000000 },
						},
					},
				})
			end,
			["tsserver"] = function()
				lspconfig["tsserver"].setup({
					capabilities = capabilities,
					on_attach = function(client, _)
						client.server_capabilities.documentFormattingProvider = false -- Prettier formatting
					end,
				})
			end,
			["volar"] = function()
				lspconfig["volar"].setup({
					capabilities = capabilities,
					filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
				})
			end,
			["emmet_ls"] = function()
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
					filetypes = { "html", "css", "typescriptreact", "javascriptreact", "vue" },
				})
			end,
			["lua_ls"] = function()
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				})
			end,
		})
	end,
}
