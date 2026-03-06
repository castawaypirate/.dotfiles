return {
  -- 1. Treesitter Setup (Syntax Highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "gdscript", "gdshader", "godot_resource" })
    end,
  },

  -- 2. Mason Setup (Installs gdtoolkit for formatting/linting)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "gdtoolkit" })
    end,
  },

  -- 3. Conform Setup (Auto-formatting via gdformat)
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.gdscript = { "gdformat" }
    end,
  },

  -- 4. Nvim-Lint Setup (Linting via gdlint)
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.gdscript = { "gdlint" }
    end,
  },

  -- 5. LSP Setup (Connects to Godot's built-in LSP on port 6005)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gdscript = {},
      },
    },
  },

  -- 6. DAP Setup (Connects to Godot's built-in Debugger on port 6006)
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      dap.adapters.godot = {
        type = "server",
        host = "127.0.0.1",
        port = 6006,
      }
      dap.configurations.gdscript = {
        {
          type = "godot",
          request = "launch",
          name = "Launch Scene",
          project = "${workspaceFolder}",
          launch_scene = true,
        },
      }
    end,
  },
}
