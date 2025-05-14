local command = vim.api.nvim_create_user_command

local status, harpoon = pcall(require, "harpoon")
if not status then
  return
end


harpoon.setup({})

local conf = require("telescope.config").values

local function toggle_telescope(harpoon_files)
   local file_paths = {}
   for _, item in ipairs(harpoon_files.items) do
       table.insert(file_paths, item.value)
   end

   require("telescope.pickers").new({}, {
       prompt_title = "Harpoon",
       finder = require("telescope.finders").new_table({
           results = file_paths,
       }),
       previewer = conf.file_previewer({}),
       sorter = conf.generic_sorter({}),
   }):find()
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

