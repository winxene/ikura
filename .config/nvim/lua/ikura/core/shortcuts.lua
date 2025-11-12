
local keymaps = require("ikura.core.keymaps").get_keymaps()

-- Sort categories alphabetically
local categories = {}
for name in pairs(keymaps) do
  table.insert(categories, name)
end
table.sort(categories)

-- Compute neat alignment widths
local function pad_right(str, len)
  return str .. string.rep(" ", len - #str)
end

local function format_section(title, mappings)
  table.sort(mappings, function(a, b)
    return a.key < b.key
  end)

  local max_key = 0
  for _, m in ipairs(mappings) do
    if #m.key > max_key then max_key = #m.key end
  end

  local lines = {}
  table.insert(lines, "┌─ " .. title .. " " .. string.rep("─", 50 - #title) .. "┐")
  for _, m in ipairs(mappings) do
    local key = pad_right(m.key, max_key)
    local desc = m.desc or ""
    table.insert(lines, "│ " .. key .. " │ " .. desc)
  end
  table.insert(lines, "└" .. string.rep("─", 52) .. "┘")
  return lines
end

local function build_content()
  local lines = {}
  for _, cat in ipairs(categories) do
    vim.list_extend(lines, format_section(cat, keymaps[cat]))
    table.insert(lines, "")
  end
  return lines
end

local function open_shortcuts_window()
  local buf = vim.api.nvim_create_buf(false, true)
  local content = build_content()

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

  local width = 70
  local height = math.min(#content + 2, math.floor(vim.o.lines * 0.8))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>bd!<CR>", { noremap = true, silent = true })
end

vim.api.nvim_create_user_command("Shortcuts", open_shortcuts_window, {})
