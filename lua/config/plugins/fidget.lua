return {
  "j-hui/fidget.nvim",
  opts = {
    notification = {
      window = {
        winblend = 0,
        border = "none",
      },
      text = {
        spinner = "dots", -- Kiểu spinner (dạng chấm động)
        done = "✔", -- Ký hiệu hiển thị khi hoàn thành
      },
    },
    timer = {
      spinner_rate = 125, -- Tốc độ chuyển động của spinner (ms) ]]
      fidget_decay = 2000, -- Thời gian hiển thị spinner sau khi task hoàn thành (ms) ]]
      task_decay = 1000, -- Thời gian task được giữ lại sau khi hoàn thành (ms) ]]
    },
  },
}
