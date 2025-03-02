local M = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
}

function M.config()
  require("harpoon"):setup()
end

vim.keymap.set("n", "<leader>a", function()
  require("harpoon"):list():add()
end)
vim.keymap.set("n", "<C-e>", function()
  require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end)

--vim.keymap.set("n", "<C-h>", function()
-- require("harpoon"):list():select(1)
--end)
vim.keymap.set("n", "<C-t>", function()
  require("harpoon"):list():select(2)
end)
vim.keymap.set("n", "<C-n>", function()
  require("harpoon"):list():select(3)
end)
vim.keymap.set("n", "<C-s>", function()
  require("harpoon"):list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function()
  require("harpoon"):list():prev()
end)
vim.keymap.set("n", "<C-S-N>", function()
  require("harpoon"):list():next()
end)

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

vim.keymap.set("n", "<C-e>", function()
  local harpoon = require "harpoon"
  toggle_telescope(require("harpoon"):list())
end, { desc = "Open harpoon window" })

return M
