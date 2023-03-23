vim.g.mapleader = ";"
local keymap = vim.keymap -- for conciseness

-- general keymaps
-- will add more soon

--[[

the pattern:
keymap.set("n for normal mode", "shortcuts you want to create", "the running command")

- <CR> == return button/ enter button
- <C-something> == control + something

]]--

keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current window

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- go to previous tab

keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
