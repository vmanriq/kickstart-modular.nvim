local function get_python_path()
  -- Retrieve the Python path from the active virtual environment
  local venv = os.getenv "VIRTUAL_ENV"
  if venv then
    return venv .. "/bin/python"
  end
  -- Fallback to system Python if no virtual environment is active
  return vim.fn.exepath "python3" or "python3"
end

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require "lint"

      lint.linters.pylint.cmd = get_python_path()
      lint.linters.pylint.args = { "-m", "pylint", "-f", "json" }

      lint.linters_by_ft = {
        python = { "pylint" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
