local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

lazy.setup({
	"nvim-lua/plenary.nvim", -- Lua functions library used by many plugins
	"antoinemadec/FixCursorHold.nvim", -- Fix CursorHold performance

	-- UI
	{
		"nvim-tree/nvim-web-devicons", -- Icons
		config = function()
			require("ikura.plugins.nvim-web-devicons")
		end,
	},
	{
		"nvim-lualine/lualine.nvim", -- Status line
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("ikura.plugins.lualine")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua", -- File explorer
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("ikura.plugins.nvim-tree")
		end,
	},
	-- Highlight colour
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("ikura.plugins.nvim-highlight-colors")
		end,
	},

	-- Colorschemes
	"rebelot/kanagawa.nvim",
	"loctvl842/monokai-pro.nvim",

	-- Git integration
	{
		"lewis6991/gitsigns.nvim", -- Git decorations
		config = function()
			require("ikura.plugins.gitsigns")
		end,
	},

	-- LSP and completion
	{
		"williamboman/mason.nvim", -- Package manager for LSP servers, linters, formatters
		dependencies = {
			"williamboman/mason-lspconfig.nvim", -- Bridge between mason and lspconfig
			"neovim/nvim-lspconfig", -- LSP config
		},
		config = function()
			require("ikura.plugins.lsp.mason")
			require("ikura.plugins.lsp.lspconfig")
		end,
	},
	{
		"glepnir/lspsaga.nvim",
		config = function()
			require("ikura.plugins.lsp.lspsaga")
		end,
	},
	"onsails/lspkind.nvim",
	{
		"nvimtools/none-ls.nvim", -- Formatting, linting, etc.
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvimtools/none-ls-extras.nvim",
			"jayp0521/mason-null-ls.nvim", -- Auto-install null-ls sources
		},
		config = function()
			require("ikura.plugins.lsp.null-ls")
		end,
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp", -- The completion plugin
		config = function()
			require("ikura.plugins.nvim-cmp")
		end,
		dependencies = {
			"hrsh7th/cmp-buffer", -- Buffer completions
			"hrsh7th/cmp-path", -- Path completions
			"hrsh7th/cmp-nvim-lsp", -- LSP completions
			"saadparwaiz1/cmp_luasnip", -- Snippet completions
			{
				"L3MON4D3/LuaSnip", -- Snippet engine
				dependencies = {
					"rafamadriz/friendly-snippets", -- Collection of snippets
				},
			},
		},
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter", -- Syntax highlighting
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag", -- Auto close/rename HTML tags
		},
		config = function()
			require("ikura.plugins.treesitter") -- Option 2: Load from a separate file
		end,
	},

	-- Autopairs
	{
		"windwp/nvim-autopairs", -- Auto pairs plugin
		config = function()
			require("ikura.plugins.autopairs")
		end,
	},

	-- Comments
	{
		"numToStr/Comment.nvim", -- Smart comments
		config = function()
			require("Comment").setup()
		end,
	},

	-- Telescope (fuzzy finder)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			require("ikura.plugins.telescope")
		end,
	},

	-- Terminal
	"akinsho/nvim-toggleterm.lua", -- Toggle terminal

	-- Trouble (diagnostics)
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("ikura.plugins.trouble")
		end,
	},

	-- PlatformIO support
	"anurag3301/nvim-platformio.lua",

	-- Discord presence
	{
		"andweeb/presence.nvim",
		config = function()
			require("ikura.plugins.presence")
		end,
	},

	-- Copilot
	"github/copilot.vim",
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"github/copilot.vim",
		},
		config = function()
			require("ikura.plugins.copilot-chat")
		end,
	},

	-- Flutter/Dart support
	"dart-lang/dart-vim-plugin",
	"thosakwe/vim-flutter",

	-- Markdown preview
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    config = function()
      require('render-markdown').setup()
    end
  },

	-- Vim plugins
	"inkarkat/vim-ReplaceWithRegister", -- Replace with register
	"tpope/vim-surround", -- Surround text objects
	"christoomey/vim-tmux-navigator", -- Navigate between tmux panes and vim splits
}, {
	install = {
		colorscheme = { "kanagawa" },
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
