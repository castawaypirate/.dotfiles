-- C# / .NET Development Setup
return {
  -- Add NuGet package manager
  {
    "d7omdev/nuget.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("nuget").setup()
    end,
  },

  -- Add omnisharp-extended keymaps for better C# navigation
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       omnisharp = {
  --         keys = {
  --           {
  --             "gd",
  --             function()
  --               require("omnisharp_extended").telescope_lsp_definitions()
  --             end,
  --             desc = "Goto Definition",
  --           },
  --           {
  --             "gI",
  --             function()
  --               require("omnisharp_extended").telescope_lsp_implementation()
  --             end,
  --             desc = "Goto Implementation",
  --           },
  --           {
  --             "gr",
  --             function()
  --               require("omnisharp_extended").telescope_lsp_references()
  --             end,
  --             desc = "References",
  --           },
  --           {
  --             "gy",
  --             function()
  --               require("omnisharp_extended").telescope_lsp_type_definition()
  --             end,
  --             desc = "Goto Type Definition",
  --           },
  --         },
  --         -- Enable decompilation support globally
  --         settings = {
  --           RoslynExtensionsOptions = {
  --             enableDecompilationSupport = true,
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}
