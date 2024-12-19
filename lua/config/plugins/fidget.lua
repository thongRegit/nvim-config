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

    --[[ align = { ]]
    --[[   bottom = true, -- Đặt spinner ở dưới cùng ]]
    --[[   right = true, -- Đặt spinner ở bên phải ]]
    --[[ }, ]]
    --[[ window = { ]]
    --[[   relative = "win", -- Hiển thị dựa trên cửa sổ hiện tại ]]
    --[[   blend = 100, -- Độ trong suốt của cửa sổ (0: không trong suốt, 100: hoàn toàn trong suốt) ]]
    --[[   zindex = nil, -- Thứ tự lớp hiển thị (z-index) ]]
    --[[   border = "rounded", -- Viền bo tròn ]]
    --[[ }, ]]
    --[[ timer = { ]]
    --[[   spinner_rate = 125, -- Tốc độ chuyển động của spinner (ms) ]]
    --[[   fidget_decay = 2000, -- Thời gian hiển thị spinner sau khi task hoàn thành (ms) ]]
    --[[   task_decay = 1000, -- Thời gian task được giữ lại sau khi hoàn thành (ms) ]]
    --[[ }, ]]
    --[[ fmt = { ]]
    --[[   fidget = function(fidget_name, spinner) ]]
    --[[     return string.format("%s %s", spinner, fidget_name) ]]
    --[[   end, -- Định dạng hiển thị của fidget ]]
    --[[   task = function(task_name, message, percentage) ]]
    --[[     return string.format("%s%s [%s]", message, percentage and string.format(" (%s%%)", percentage) or "", task_name) ]]
    --[[   end, -- Định dạng hiển thị của task ]]
    --[[ }, ]]
    --[[ sources = { ]]
    --[[   ["*"] = { ]]
    --[[     ignore = false, -- Không bỏ qua nguồn nào ]]
    --[[   }, ]]
    --[[ }, ]]
    --[[ debug = { ]]
    --[[   logging = false, -- Tắt ghi log debug ]]
    --[[ }, ]]
  },
}
