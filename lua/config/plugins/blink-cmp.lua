return {
  "saghen/blink.cmp",
  event = { "LspAttach" },
  dependencies = "rafamadriz/friendly-snippets",
  version = "v0.*",

  opts = {
    keymap = {
      ["<C-j>"] = { "select_prev", "fallback" },
      ["<C-k>"] = { "select_next", "fallback" },
      ["<CR>"] = { "select_and_accept" },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    signature = { enabled = true },
  },
}
