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

-- open nvim-tree on setup
local function open_nvim_tree(data)
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
	local directory = vim.fn.isdirectory(data.file) == 1
	if not no_name and not directory then
		return
	end
	if directory then
		vim.cmd.cd(data.file)
	end
	require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
