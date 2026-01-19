return {
  {
    "sainnhe/gruvbox-material",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- 1. Configuration: Must be set BEFORE loading the colorscheme
      vim.g.gruvbox_material_background = "medium" -- 'hard', 'medium', 'soft'
      vim.g.gruvbox_material_better_performance = 1

      -- 2. Load the colorscheme
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
    },
  },
}
