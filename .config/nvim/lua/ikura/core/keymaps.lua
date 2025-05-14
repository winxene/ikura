vim.g.mapleader = ";"
local keymap = vim.keymap -- for conciseness

-- general keymaps
-- will add more soon

-----------------
-- the pattern:
-----------------
--[[

keymap.set("n for normal mode", "shortcuts you want to create", "the running command")

- <CR> == return button/ enter button
- <C-something> == control + something

]]
--

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current window

-- tab management
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- go to previous tab

---------------
-- Plugin
---------------
-- tree management
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- copilot chat
keymap.set("n", "<leader>cc", ":CopilotChat<CR>") -- connect to copilot chat

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- trouble
keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>") -- toggle trouble
keymap.set("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>") -- toggle trouble
keymap.set("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics toggle<cr>") -- toggle workspace diagnostics
keymap.set("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics toggle<cr>") -- toggle document diagnostics
keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>") -- toggle quickfix list
keymap.set("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>") -- toggle location list
keymap.set("n", "<leader>gR", "<cmd>Trouble lsp_references toggle<cr>") -- toggle lsp references

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

-- flash
keymap.set({ "n", "x", "o" }, "zk", function()
	require("flash").jump()
end, { desc = "Flash" })

keymap.set({ "n", "x", "o" }, "Zk", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter" })

keymap.set("o", "r", function()
	require("flash").remote()
end, { desc = "Remote Flash" })

keymap.set({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end, { desc = "Treesitter Search" })

keymap.set("c", "<c-s>", function()
	require("flash").toggle()
end, { desc = "Toggle Flash Search" })

-- Toggle render markdown
keymap.set("n", "<leader>md", ":RenderMarkdown toggle<CR>") -- toggle markdown preview

-- Harpoon (Buffer selector)
keymap.set("n", "<leader>hh", ":HarpoonListToggle<CR>") -- toggle harpoon
keymap.set("n", "<leader>ha", ":HarpoonListAdd<CR>") -- add current file to harpoon
keymap.set("n", "<leader>hx", ":HarpoonListRemove<CR>") -- remove current file from harpoon
keymap.set("n", "<leader>hp", ":HarpoonListPrev<CR>") -- go to previous file in harpoon
keymap.set("n", "<leader>hn", ":HarpoonListNext<CR>") -- go to next file in harpoon

-- Number keys for direct selection
for i = 1, 9 do
    keymap.set("n", "<leader>h" .. i, ":HarpoonSelect " .. i .. "<CR>", {
        desc = "Go to file " .. i .. " in harpoon"
    })
end

-- restart lsp server (not on youtube nvim video)
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary
