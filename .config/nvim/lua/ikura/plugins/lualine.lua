-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
  return
end

local lualine_monokai_pro = require("monokai-pro")

-- configure lualine with modified theme
lualine.setup({
  options = {
    theme = 'monokai-pro',
  },
})
