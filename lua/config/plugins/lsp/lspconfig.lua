return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "Saghen/blink.cmp",
    -- Auto update reference when change name file, name variable
    { "antosha417/nvim-lsp-file-operations", config = true },
    -- Enhance LSP for lua
    { "folke/neodev.nvim", opts = {} },
  },
  config = function(_, opts)
    local lspconfig = require("lspconfig")

    -- Configure Blink CMP capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
    capabilities = vim.tbl_deep_extend("force", capabilities, {
      workspace = {
        didChangeWatchedFiles = {
          relativePatternSupport = true,
        },
      },
    })

    -- Example using opts for defining servers
    local servers = {
      phpactor = {
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern("composer.json", ".git") or vim.loop.cwd(),
      },
      intelephense = {
        capabilities = capabilities,
        settings = {
          intelephense = {
            files = { maxSize = 5000000 },
          },
        },
      },
      ts_ls = {
        capabilities = capabilities,
        on_attach = function(client, _)
          client.server_capabilities.documentFormattingProvider = false -- Prettier formatting
        end,
      },
      volar = {
        capabilities = capabilities,
        filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
      },
      emmet_ls = {
        capabilities = capabilities,
        filetypes = { "html", "css", "typescriptreact", "javascriptreact", "vue" },
      },
      lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      },
    }

    -- Setup LSP servers using the updated capabilities from Blink CMP
    for server, config in pairs(servers) do
      lspconfig[server].setup(config)
    end

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
  end,
}
