return {
  {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format { async = true, lsp_fallback = true }
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = true,
      log_level = vim.log.levels.DEBUG,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        --print the args to see what is being passed
        print(vim.inspect(bufnr))
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        python = {
          {
            "black",
            extra_args = { "--line-length=120" },
            format_on_save = true, -- Enable format on save for Python
            import_strategy = "fromEnvironment", -- Set import strategy for black
          },
          -- {
          --   "isort",
          --   extra_args = { "--profile", "black" }, -- Add black profile to isort
          --   import_strategy = "fromEnvironment", -- Set import strategy for isort
          -- },
        },
        javascript = { { "eslint", "prettierd" } },
        vue = { { "eslint" } },
      },
      formatters = {
        black = {
          append_args = { "--line-length=120" },
        },
      },
    },
  },
}
