local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true

opt.cmdheight = 1
opt.title = true

-- shell
opt.shell = "/bin/zsh"

-- line wrapping
opt.wrap = false
opt.backspace = "indent,eol,start"

-- search settings
opt.ignorecase = true
opt.smartcase = true
opt.path:append { "**" }
opt.wildignore:append(
	"*/tmp/*,*.so,*.swp,*.zip",
	"*/node_modules/*",
	"*/.git/*",
	"*/.cache/*",
	"*/.vscode/*",
	"*/.idea/*",
	"*/"
)

-- cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")
