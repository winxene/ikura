-- import presence safely
local setup, presence = pcall(require, "presence")
if not setup then
	return
end

-- configure presence
presence.setup({
	-- General settings
	auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
	blacklist = {
		"/tmp/",
		"/private/tmp/",
		"/var/folders/",
		-- "/Users/ikura/Development/",
		-- "/Users/ikura/",
	}, -- A list of strings that will disable Presence if the current file path matches
	-- client_id = "793271441293967371",
	buttons = false,
	neovim_image_text = "average vim editor", -- Text displayed when hovered over the Neovim image
	main_image = "neovim", -- Main image display (either "neovim" or "file")
	log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
	debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
	enable_line_number = false, -- Displays the current line number instead of the current project
	file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
	show_time = true, -- Show the timer

	-- Rich Presence text options
	editing_text = function(filename)
		local filetype = vim.bo.filetype:gsub("^%l", string.upper)
		return string.format("Editing %s", filetype)
	end,
	file_explorer_text = "Browsing work stuffs", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
	git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
	plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
	reading_text = "", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
	workspace_text = "", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
	line_number_text = "Line %s out of %s",
})
