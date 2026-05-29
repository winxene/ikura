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
		cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFile" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		init = function()
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function(data)
					if vim.fn.isdirectory(data.file) ~= 1 then
						return
					end
					vim.cmd.cd(data.file)
					require("lazy").load({ plugins = { "nvim-tree.lua" } })
					require("nvim-tree.api").tree.open()
				end,
			})
		end,
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
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("ikura.plugins.gitsigns")
		end,
	},

	-- LSP and completion
	{
		"williamboman/mason.nvim", -- Package manager for LSP servers, linters, formatters
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim", -- Bridge between mason and lspconfig
			"neovim/nvim-lspconfig", -- LSP config
			"hrsh7th/cmp-nvim-lsp", -- LSP completion capabilities
		},
		config = function()
			require("ikura.plugins.lsp.mason")
			require("ikura.plugins.lsp.lspconfig")
		end,
	},
	{
		"glepnir/lspsaga.nvim",
		cmd = "Lspsaga",
		config = function()
			require("ikura.plugins.lsp.lspsaga")
		end,
	},
	{
		"nvimtools/none-ls.nvim", -- Formatting, linting, etc.
		event = { "BufReadPre", "BufNewFile" },
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
		event = "InsertEnter",
		config = function()
			require("ikura.plugins.nvim-cmp")
		end,
		dependencies = {
			"hrsh7th/cmp-buffer", -- Buffer completions
			"hrsh7th/cmp-path", -- Path completions
			"hrsh7th/cmp-nvim-lsp", -- LSP completions
			"onsails/lspkind.nvim", -- Completion pictograms
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
		event = { "BufReadPost", "BufNewFile" },
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
		event = "InsertEnter",
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
		cmd = "Telescope",
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
		cmd = "Trouble",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("ikura.plugins.trouble")
		end,
	},

	-- PlatformIO support
	{
		"anurag3301/nvim-platformio.lua",
		cmd = {
			"Pioinit",
			"PioLSP",
			"Piorun",
			"Piocmdh",
			"Piocmdf",
			"Piomon",
			"Piolsserial",
			"Piolib",
			"Piodebug",
			"PioTermList",
		},
	},

	-- Navigations
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
	},

	-- Flutter/Dart support
	{ "dart-lang/dart-vim-plugin", ft = "dart" },
	{ "thosakwe/vim-flutter", ft = "dart" },

	-- Markdown preview
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		cmd = "RenderMarkdown",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
		config = function()
			require("render-markdown").setup()
		end,
	},

	-- codediff
	{
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
		config = function()
			require("codediff").setup({
				explorer = {
					view_mode = "tree",
				},
				history = {
					view_mode = "tree",
				},
			})
		end,
	},

	--Harpoon 2 (Simple buffer navigation)
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		cmd = {
			"HarpoonListToggle",
			"HarpoonListAdd",
			"HarpoonListRemove",
			"HarpoonListPrev",
			"HarpoonListNext",
			"HarpoonSelect",
		},
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			require("ikura.plugins.harpoon")
		end,
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
