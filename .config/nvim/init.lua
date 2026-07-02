-- Disable unused remote plugin providers.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

require("ikura.plugins-setup")
require("ikura.core.options")
require("ikura.core.keymaps")
require("ikura.core.colorscheme")
require("ikura.core.shortcuts")
