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
		"/Users/ikura/Development/",
		"/Users/ikura/",
	}, -- A list of strings that will disable Presence if the current file path matches
	buttons = false,
})
