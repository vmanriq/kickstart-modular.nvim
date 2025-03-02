return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup {
      -- Configuration here, or leave empty to use defaults
    }
    vim.cmd.colorscheme "catppuccin"
  end,
}
