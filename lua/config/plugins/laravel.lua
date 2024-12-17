return {
  "adalessa/laravel.nvim",
  dependencies = {
    "tpope/vim-dotenv",
    "ibhagwan/fzf-lua",
    "MunifTanjim/nui.nvim",
    "kevinhwang91/promise-async",
  },
  cmd = { "Laravel" },
  keys = {
    { "<leader>la", ":Laravel artisan<cr>" },
    { "<leader>lr", ":FzfLua grep { search = 'GET\\|POST\\|PUT\\|DELETE', prompt = 'Routes❯ ' }<cr>" },
    { "<leader>lm", ":FzfLua grep_cword<cr>" },
  },
  event = { "VeryLazy" },
  config = function()
    require("laravel").setup({
      -- Tùy chỉnh options nếu cần
    })

    -- Tạo các chức năng FzfLua tùy chỉnh cho Laravel
    local fzf = require("fzf-lua")

    vim.api.nvim_create_user_command("LaravelRoutes", function()
      fzf.grep({
        search = "GET\\|POST\\|PUT\\|DELETE",
        prompt = "Laravel Routes❯ ",
        cwd = vim.loop.cwd(),
      })
    end, { desc = "Find Laravel routes using fzf-lua" })

    vim.api.nvim_create_user_command("LaravelRelated", function()
      fzf.grep_cword({
        prompt = "🔍 Laravel Related Files: ",
      })
    end, { desc = "Find related Laravel files using fzf-lua" })
  end,
}
