vim.g.mapleader = ";"
local keymap = vim.keymap

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                            WINDOW MANAGEMENT                             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "make split windows equal width & height" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "close current window" })

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              TAB MANAGEMENT                              ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "open new tab" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "close current tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "go to next tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "go to previous tab" })

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                               PLUGIN KEYMAPS                             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- ─────────────────────────────────── NvimTree ─────────────────────────────────────

keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "toggle file explorer" })

-- ──────────────────────────────── Copilot Chat ──────────────────────────────────

keymap.set("n", "<leader>cc", ":Codeium Chat<CR>", { desc = "open copilot chat" })

-- ──────────────────────────────── Telescope (Files) ───────────────────────────────

keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "find files within current working directory" })
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "find string in current working directory as you type" })
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "find string under cursor in current working directory" })
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "list open buffers in current nvim instance" })
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "list available help tags" })

-- ──────────────────────────────── Telescope (Git) ────────────────────────────────

keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "list all git commits (use <cr> to checkout)" })
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>", { desc = "list git commits for current file/buffer" })
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "list git branches (use <cr> to checkout)" })
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "list current changes per file with diff preview" })

-- ───────────────────────────────────── Trouble ────────────────────────────────────

keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "toggle diagnostics" })
keymap.set("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "toggle todo list" })
keymap.set("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics toggle<cr>", { desc = "toggle workspace diagnostics" })
keymap.set("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics toggle<cr>", { desc = "toggle document diagnostics" })
keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "toggle quickfix list" })
keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "toggle location list" })
keymap.set("n", "<leader>gR", "<cmd>Trouble lsp_references toggle<cr>", { desc = "toggle lsp references" })

-- ────────────────────────────────────── Flash ─────────────────────────────────────

keymap.set({ "n", "x", "o" }, "zk", function()
	require("flash").jump()
end, { desc = "flash jump" })

keymap.set({ "n", "x", "o" }, "Zk", function()
	require("flash").treesitter()
end, { desc = "flash treesitter" })

keymap.set("o", "r", function()
	require("flash").remote()
end, { desc = "remote flash" })

keymap.set({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end, { desc = "treesitter search" })

keymap.set("c", "<c-s>", function()
	require("flash").toggle()
end, { desc = "toggle flash search" })

-- ──────────────────────────────── Render Markdown ────────────────────────────────

keymap.set("n", "<leader>md", ":RenderMarkdown toggle<CR>", { desc = "toggle markdown preview" })

-- ─────────────────────────────────── Harpoon ──────────────────────────────────────

keymap.set("n", "<leader>hh", ":HarpoonListToggle<CR>", { desc = "toggle harpoon list" })
keymap.set("n", "<leader>ha", ":HarpoonListAdd<CR>", { desc = "add current file to harpoon" })
keymap.set("n", "<leader>hx", ":HarpoonListRemove<CR>", { desc = "remove current file from harpoon" })
keymap.set("n", "<leader>hp", ":HarpoonListPrev<CR>", { desc = "go to previous file in harpoon" })
keymap.set("n", "<leader>hn", ":HarpoonListNext<CR>", { desc = "go to next file in harpoon" })

for i = 1, 9 do
    keymap.set("n", "<leader>h" .. i, ":HarpoonSelect " .. i .. "<CR>", {
        desc = "go to file " .. i .. " in harpoon"
    })
end

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                           LSP & DEVELOPMENT TOOLS                        ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "restart lsp server" })

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                                  UTILITIES                               ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

keymap.set("n", "<leader>sk", ":Shortcuts<CR>", { desc = "show keyboard shortcuts reference" })


local M = {}

function M.get_keymaps()
  local file = debug.getinfo(1, "S").source:sub(2)
  local lines = {}
  for line in io.lines(file) do
    table.insert(lines, line)
  end

  local categories = {}
  local current_category = "Uncategorized"

  for _, line in ipairs(lines) do
    -- Detect category headers
    local header = line:match("%-%-%s*[║%-─]+%s*(.-)%s*[║%-─]*$")
      or line:match("%-%-%s*(.-)%s*$")
    if header and header:match("%a") then
      current_category = header:gsub("^%s*(.-)%s*$", "%1")
      if not categories[current_category] then
        categories[current_category] = {}
      end
    end

    -- Detect keymap.set lines
    local mode, key, rhs, desc =
      line:match('keymap%.set%(([^,]+),%s*([^,]+),%s*([^,]+),%s*{(.-)}')
    if mode and key then
      local d = desc and desc:match('desc%s*=%s*"(.-)"')
      table.insert(categories[current_category], {
        mode = mode:gsub("[\"{}'%s]", ""),
        key = key:gsub("[\"'%s]", ""),
        desc = d or "",
      })
    end
  end

  -- Sort alphabetically by key
  for _, maps in pairs(categories) do
    table.sort(maps, function(a, b)
      return a.key < b.key
    end)
  end

  return categories
end

return M
