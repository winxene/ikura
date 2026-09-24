-- import nvim-tree plugin safely
local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

-- recommended settings from nvim-tree documentation
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local devicons_loaded, _ = pcall(require, "nvim-web-devicons")
if not devicons_loaded then
	print("Warning: nvim-web-devicons not loaded. Icons may not display correctly.")
end

nvimtree.setup({
	renderer = {
		highlight_modified = "all",
		icons = {
			show = {
				file = true,
				folder = true,
        folder_arrow = false,
				git = true,
			},
			glyphs = {
				default = "", -- Default file icon
				symlink = "",
				git = {
					unstaged = "✗",
					staged = "✓",
					unmerged = "",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	-- disable window_picker for
	-- explorer to work well with
	-- window splits
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
		},
	},
	git = {
		enable = true,
		ignore = false,
	},
})

