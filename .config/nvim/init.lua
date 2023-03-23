require("ikura.plugins-setup")
require("ikura.core.options")
require("ikura.core.keymaps")
require("ikura.core.colorscheme")
require("ikura.plugins.comment")
require("ikura.plugins.nvim-tree")
require("ikura.plugins.lualine")
require("ikura.plugins.telescope")

if vim.g.vscode then
    -- VSCode extension
    require("ikura.plugins-setup")
    require("ikura.core.options")
    require("ikura.core.keymaps")
    require("ikura.core.colorscheme")
    require("ikura.plugins.comment")
    require("ikura.plugins.nvim-tree")
    require("ikura.plugins.lualine")
else
    -- ordinary Neovim
end
