-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
  return
end


-- set up lualine
require("lualine").setup({
  options = {
    theme = 'kanagawa',
    icons_enabled = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      { "filename", path = 1 },
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
