return {
  { "williamboman/mason.nvim", build = ":MasonUpdate", lazy = false, opts = {} },
  { "neovim/nvim-lspconfig",
    lazy = false,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  },
  { "nvim-treesitter/nvim-treesitter",
    lazy = false,
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = { "c", "lua", "vim", "query", "javascript", "python" },
      auto_install = true,
      highlight = { enable = true }
    }
  },
  { "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim", "nvim-lua/plenary.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
          nls.builtins.diagnostics.eslint,
          nls.builtins.diagnostics.cpplint,
          nls.builtins.diagnostics.flake8,
        },
      }
    end
  },
  { "folke/neodev.nvim", opts = {} },
}
