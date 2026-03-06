return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      configuration = {
        contrast = "medium", -- 'hard', 'medium', 'soft'
      },
      overrides = {
        -- Noice popup borders - link to Gruvbox highlights
        NoiceCmdlinePopupBorder = { link = "GruvboxYellow" },
        NoiceCmdlinePopupTitle = { link = "GruvboxYellow" },
        NoiceCmdlinePopupBorderSearch = { link = "GruvboxYellow" },
        NoiceCmdlinePopupTitleSearch = { link = "GruvboxYellow" },
        NoicePopupBorder = { link = "GruvboxBg4" },
      },
    },
  },

  -- Configure LazyVim to use gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
