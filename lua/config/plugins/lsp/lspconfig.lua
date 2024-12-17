return {
  -- Config to nvim interaction with LSP
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

    -- Replace vim.fn.sign_define with vim.diagnostic.config
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●", -- Customize virtual text prefix
      },
      signs = {
        active = {
          { name = "DiagnosticSignError", text = "" },
          { name = "DiagnosticSignWarn", text = "" },
          { name = "DiagnosticSignHint", text = "󰠠" },
          { name = "DiagnosticSignInfo", text = "" },
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })
    -- Force type for php
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = "*.php",
      command = "LspStart phpactor",
    })

    -- Enhanced capabilities for autocompletion
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- LSP keymaps when a server attaches
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- Tìm references
        opts.desc = "Find references"
        keymap.set("n", "gR", "<cmd>FzfLua lsp_references<CR>", opts)

        -- Go to declaration
        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        -- Tìm definitions
        opts.desc = "Find definitions"
        keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", opts)

        -- Tìm implementations
        opts.desc = "Find implementations"
        keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts)

        -- Tìm type definitions
        opts.desc = "Find type definitions"
        keymap.set("n", "gt", "<cmd>FzfLua lsp_typedefs<CR>", opts)
        opts.desc = "Code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        -- After change name must excuted command ":wa" to update change for all buffer
        -- Because vim.lsp.buf.rename only apply for file is opened
        opts.desc = "Rename symbol"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, silent = true, noremap = true })

        opts.desc = "Buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        opts.desc = "Hover documentation"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

        opts.desc = "Format document"
        keymap.set("n", "<leader>fd", vim.lsp.buf.format, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- Autocommand to organize imports on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup("organize_imports", {}),
      pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue" }, -- Restrict to TypeScript files
      callback = function()
        local params = {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "Organize Imports",
        }
        vim.lsp.buf.execute_command(params)
      end,
    })

    -- Mason LSP setup handlers
    mason_lspconfig.setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({ capabilities = capabilities })
      end,
      ["phpactor"] = function()
        lspconfig["phpactor"].setup({
          capabilities = capabilities,
          root_dir = lspconfig.util.root_pattern("composer.json", ".git") or vim.loop.cwd(),
        })
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
      ["ts_ls"] = function()
        lspconfig["ts_ls"].setup({
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
