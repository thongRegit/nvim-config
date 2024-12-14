local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local conf = require("telescope.config").values

local M = {}

local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.loop.cwd()

  -- Finder definition using async job
  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local pieces = vim.split(prompt, "  ")
      local args = { "rg", "-F" } -- ripgrep command

      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end

      -- Additional ripgrep arguments
      ---@diagnostic disable-next-line: deprecated
      return vim.tbl_flatten({
        args,
        {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      })
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })

  -- Picker configuration
  pickers
    .new(opts, {
      debounce = 100, -- Debouncing input for smooth searches
      prompt_title = "Multi Grep",
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(), -- Empty sorter for fast performance
    })
    :find()
end

M.setup = function()
  vim.keymap.set("n", "<leader>fm", function()
    live_multigrep()
  end, { desc = "Find multi grep" })
end

return M
--
--
--
--[[ local pickers = require("telescope.pickers") ]]
--[[ local finders = require("telescope.finders") ]]
--[[ local make_entry = require("telescope.make_entry") ]]
--[[ local conf = require("telescope.config").values ]]
--[[]]
--[[ local M = {} ]]
--[[]]
--[[ -- Định nghĩa hàm tìm kiếm ký tự đặc biệt ]]
--[[ M.live_specialgrep = function(opts) ]]
--[[   opts = opts or {} ]]
--[[   opts.cwd = opts.cwd or vim.loop.cwd() ]]
--[[]]
--[[   -- Finder sử dụng literal search ]]
--[[   local finder = finders.new_async_job({ ]]
--[[     command_generator = function(prompt) ]]
--[[       if not prompt or prompt == "" then ]]
--[[         return nil ]]
--[[       end ]]
--[[]]
--[[       local pieces = vim.split(prompt, "  ") -- Tách chuỗi tìm kiếm ]]
--[[       local args = { "rg", "-F" } -- "-F" để tìm kiếm literal ]]
--[[]]
--[[       if pieces[1] then ]]
--[[         table.insert(args, "-e") ]]
--[[         table.insert(args, pieces[1]) ]]
--[[       end ]]
--[[]]
--[[       if pieces[2] then ]]
--[[         table.insert(args, "-g") ]]
--[[         table.insert(args, pieces[2]) ]]
--[[       end ]]
--[[]]
--[[       return vim.tbl_flatten({ ]]
--[[         args, ]]
--[[         { ]]
--[[           "--color=never", ]]
--[[           "--no-heading", ]]
--[[           "--with-filename", ]]
--[[           "--line-number", ]]
--[[           "--column", ]]
--[[           "--smart-case", ]]
--[[         }, ]]
--[[       }) ]]
--[[     end, ]]
--[[     entry_maker = make_entry.gen_from_vimgrep(opts), ]]
--[[     cwd = opts.cwd, ]]
--[[   }) ]]
--[[]]
--[[   -- Cấu hình Picker ]]
--[[   pickers ]]
--[[     .new(opts, { ]]
--[[       prompt_title = "Special Grep (Literal Search)", ]]
--[[       finder = finder, ]]
--[[       previewer = conf.grep_previewer(opts), ]]
--[[       sorter = require("telescope.sorters").empty(), ]]
--[[     }) ]]
--[[     :find() ]]
--[[ end ]]
--[[]]
--[[ -- Thiết lập phím tắt cho chức năng này ]]
--[[ M.setup = function() ]]
--[[   vim.keymap.set("n", "<leader>fm", function() ]]
--[[     M.live_specialgrep({}) ]]
--[[   end, { desc = "Search for special characters (Literal Search)" }) ]]
--[[ end ]]
--[[]]
--[[ return M ]]
