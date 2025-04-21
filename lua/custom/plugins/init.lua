-- Helper to detect the virtualenv (supports .venv/venv/env and VIRTUAL_ENV)
local function find_virtualenv()
  local venv = os.getenv('VIRTUAL_ENV')
  if venv then
    return venv
  end

  local candidates = {
    '.venv',
    'venv',
    'env',
    os.getenv('HOME') .. '/.virtualenvs/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
  }

  for _, dir in ipairs(candidates) do
    local python_path = dir .. '/bin/python'
    if vim.fn.filereadable(python_path) == 1 then
      return dir
    end
  end
  return nil
end

return {
  -- LSP + Mason Setup
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    init = function()
      vim.lsp.set_log_level('warn')
    end,
    opts = {
      servers = {
        pyright = {
          before_init = function(_, config)
            local venv = find_virtualenv()
            if venv then
              config.settings.python.pythonPath = venv .. '/bin/python'
            end
          end,
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                },
                diagnosticMode = "workspace",
              },
            },
          },
        },
        ruff = {
          before_init = function(_, config)
            local venv = find_virtualenv()
            config.cmd = { (venv and venv .. '/bin/ruff' or 'ruff'), 'server' }
          end,
          init_options = {
            settings = {
              configuration = vim.fn.findfile('ruff.toml', '.;'),
              logLevel = 'warn',
              organizeImports = { enabled = true },
            },
          },
        },
      },
    },
  },

  -- Mason for installing language servers
  {
    'williamboman/mason.nvim',
    opts = {
      ensure_installed = { 'pyright', 'ruff' },
    },
  },

  {
    'williamboman/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'pyright' },
    },
  },

  -- Conform.nvim for format-on-save with Ruff
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters = {
        ruff_fix = {
          command = function()
            local venv = find_virtualenv()
            return venv and (venv .. "/bin/ruff") or "ruff"
          end,
          args = { "check", "--fix", "--select", "I", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },
        ruff_format = {
          command = function()
            local venv = find_virtualenv()
            return venv and (venv .. "/bin/ruff") or "ruff"
          end,
          args = { "format", "-" },
          stdin = true,
        },
      },
    },
  },
}

