-- in case it isn't installed
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
	theme = "wave",
	-- background = {
	-- 	dark = "wave",
	-- 	light = "lotus",
	-- },
	background_clear = {
		"toggleterm",
		"telescope",
		"which-key",
		"renamer",
	},
})

-- Set initial colorscheme
local status, _ = pcall(vim.cmd, "colorscheme kanagawa")
if not status then
	print("kanagawa not found!")
end
