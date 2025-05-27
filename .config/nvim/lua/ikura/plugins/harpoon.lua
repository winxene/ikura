local command = vim.api.nvim_create_user_command

local status, harpoon = pcall(require, "harpoon")
if not status then
	return
end


harpoon.setup({})

local function toggle_telescope(harpoon_files)
	local telescope_ok, telescope = pcall(require, "telescope")
	if not telescope_ok then
		vim.notify("Telescope not available", vim.log.levels.ERROR)
		return
	end

	local pickers_ok, pickers = pcall(require, "telescope.pickers")
	if not pickers_ok then
		vim.notify("Telescope pickers not available", vim.log.levels.ERROR)
		return
	end

	local finders_ok, finders = pcall(require, "telescope.finders")
	if not finders_ok then
		vim.notify("Telescope finders not available", vim.log.levels.ERROR)
		return
	end

	local conf_ok, conf = pcall(require, "telescope.config")
	if not conf_ok then
		vim.notify("Telescope config not available", vim.log.levels.ERROR)
		return
	end

	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	pickers
		.new({}, {
			prompt_title = "Harpoon",
			finder = finders.new_table({
				results = file_paths,
			}),
			previewer = conf.values.file_previewer({}),
			sorter = conf.values.generic_sorter({}),
		})
		:find()
end
local function select_file_by_index(index)
	if type(index) ~= "number" then
		vim.notify("Please provide a valid number. Usage: :HarpoonSelect 1", vim.log.levels.ERROR)
		return
	end
	harpoon:list():select(index)
end

command("HarpoonListToggle", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open Harpoon in Telescope" })

command("HarpoonListAdd", function()
	harpoon:list():add()
end, { desc = "Add current file to Harpoon list" })

command("HarpoonListRemove", function()
	harpoon:list():remove()
end, { desc = "Remove current file from Harpoon list" })

command("HarpoonListPrev", function()
	harpoon:list():prev()
end, { desc = "Go to previous file in Harpoon list" })

command("HarpoonListNext", function()
	harpoon:list():next()
end, { desc = "Go to next file in Harpoon list" })

command("HarpoonSelect", function(opts)
	local idx = tonumber(opts.args)
	select_file_by_index(idx)
end, {
	nargs = 1,
	complete = function(_, _, _)
		return { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
	end,
	desc = "Select a file from Harpoon list by index",
})
