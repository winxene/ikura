-- in case it isn't installed

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

-- Setup for monokai-pro colorscheme
require("monokai-pro").setup({
	transparent_background = true,
	terminal_colors = false,
	devicons = true,
	styles = {
		comment = { italic = true },
		keyword = { italic = true },
		type = { italic = true },
		storageclass = { italic = true },
		structure = { italic = true },
		parameter = { italic = true },
		annotation = { italic = true },
		tag_attribute = { italic = true },
	},
	filter = "ristretto",
	day_night = {
		enable = true,
		day_filter = "pro",
		night_filter = "spectrum",
	},
	inc_search = "background",
	background_clear = {
		"toggleterm",
		"telescope",
		"which-key",
		"renamer",
	},
	plugins = {
		bufferline = {
			underline_selected = false,
			underline_visible = false,
		},
		indent_blankline = {
			context_highlight = "default",
			context_start_underline = false,
		},
	},
	override = function(c) end,
})

-- Function to toggle between colorschemes
local current_colorscheme = "kanagawa"

local function toggle_colorscheme()
	if current_colorscheme == "monokai-pro" then
		local status, _ = pcall(vim.cmd, "colorscheme kanagawa")
		if status then
			current_colorscheme = "kanagawa"
		else
			print("kanagawa not found!")
		end
	else
		local status, _ = pcall(vim.cmd, "colorscheme monokai-pro")
		if status then
			current_colorscheme = "monokai-pro"
		else
			print("monokai-pro not found!")
		end
	end
end

-- Set initial colorscheme
local status, _ = pcall(vim.cmd, "colorscheme " .. current_colorscheme)
if not status then
	print(current_colorscheme .. " not found!")
end
