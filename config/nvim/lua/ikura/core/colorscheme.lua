-- Helper function to read theme from file
local function get_theme_mode()
  local theme_file = io.open(vim.fn.expand("~/.config/themes/theme"))
  if theme_file then
    local theme = theme_file:read("*a"):gsub("%s+", "")
    theme_file:close()
    if theme == "light" then
      return "light"
    end
  end
  return "dark"
end

-- Setup for kanagawa colorscheme
require("kanagawa").setup({
  compile = false,
  undercurl = true,
  commentStyle = { italic = true },
  functionStyle = {},
  keywordStyle = { italic = true },
  statementStyle = { bold = true },
  typeStyle = {},
  transparent = true,
  dimInactive = false,
  terminalColors = true,
  colors = {
    palette = {},
    theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
  },
  overrides = function(colors)
    return {}
  end,
  background = {
    dark = "wave",
    light = "lotus",
  },
  background_clear = {
    "toggleterm",
    "telescope",
    "which-key",
    "renamer",
  },
})

-- Apply theme function
local function apply_theme()
  local mode = get_theme_mode()
  vim.o.background = mode
  local ok, _ = pcall(vim.cmd, "colorscheme kanagawa")
  if not ok then
    vim.notify("Kanagawa not found!", vim.log.levels.ERROR)
  end
end

-- Apply theme immediately when config loads
apply_theme()

-- Manual update command
vim.api.nvim_create_user_command("ThemeReload", function()
  apply_theme()
end, {})

-- Auto-reload using OS filesystem events
local uv = vim.uv or vim.loop
local theme_file_path = vim.fn.expand("~/.config/themes/theme")
local last_theme = get_theme_mode()
local watcher = nil

-- Function to start/stop auto-reload
local function start_theme_watcher()
  if watcher then return end
  watcher = uv.new_fs_event()
  watcher:start(theme_file_path, {}, vim.schedule_wrap(function(err)
    if err then
      vim.notify("Theme watcher error: " .. err, vim.log.levels.ERROR)
      return
    end

    local current_theme = get_theme_mode()
    if current_theme ~= last_theme then
      last_theme = current_theme
      apply_theme()
      vim.notify("Theme auto-switched to " .. current_theme, vim.log.levels.INFO)
    end
  end))
end

local function stop_theme_watcher()
  if watcher then
    watcher:stop()
    watcher:close()
    watcher = nil
    vim.notify("Theme auto-reload disabled", vim.log.levels.INFO)
  end
end

-- Start by default (set to false to disable)
local auto_reload_enabled = true
if auto_reload_enabled then
  start_theme_watcher()
end

-- Commands to toggle
vim.api.nvim_create_user_command("ThemeWatchStart", start_theme_watcher, {})
vim.api.nvim_create_user_command("ThemeWatchStop", stop_theme_watcher, {})

-- Clean up watcher on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if watcher then
      watcher:stop()
      watcher:close()
    end
  end,
})
