-- import nvim-highlight-colors

local setup, highlight_colors = pcall(require, "nvim-highlight-colors")
if not setup then
	return
end

vim.opt.termguicolors = true

highlight_colors.setup({
	enable_hex = true,
	enable_short_hex = true,
	enable_rgb = true,
	enable_hsl = true,
	enable_ansi = true,
})
