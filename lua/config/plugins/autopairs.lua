return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    "saghen/blink.cmp", -- Đảm bảo plugin blink.cmp được tải trước
  },
  config = function()
    -- import nvim-autopairs
    local autopairs = require("nvim-autopairs")

    -- configure autopairs
    autopairs.setup({
      check_ts = true, -- enable treesitter
      ts_config = {
        lua = { "string" }, -- don't add pairs in lua string treesitter nodes
        javascript = { "template_string" }, -- don't add pairs in javascript template_string treesitter nodes
        java = false, -- don't check treesitter on java
      },
    })

    -- import nvim-autopairs completion functionality
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    -- import blink.cmp plugin
    local blink_cmp = require("blink.cmp")

    -- make autopairs and blink.cmp work together
    blink_cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
