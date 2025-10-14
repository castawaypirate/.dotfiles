return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>fp",
      function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.getcwd(),
          find_command = { "fd", "-t", "f", "-e", "csproj", "-x", "dirname" },
          prompt_title = "C# Projects",
        })
      end,
      desc = "Find C# Projects",
    },
  },
}
