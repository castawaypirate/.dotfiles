-- TypeScript / Ionic Development Setup
return {
  -- Configure TypeScript LSP
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.ts_ls = opts.servers.ts_ls or {}

      -- Merge settings with any existing ts_ls config
      opts.servers.ts_ls.settings = vim.tbl_deep_extend("force", opts.servers.ts_ls.settings or {}, {
        typescript = {
          preferences = {
            -- Prevent auto-importing from Ionic paths (Ionic-specific TS setting)
            autoImportFileExcludePatterns = {
              "@ionic/angular/common",
              "@ionic/angular",
            },
          },
        },
        javascript = {
          preferences = {
            -- Same exclusion for JavaScript files
            autoImportFileExcludePatterns = {
              "@ionic/angular/common",
              "@ionic/angular",
            },
          },
        },
      })

      return opts
    end,
  },
}
