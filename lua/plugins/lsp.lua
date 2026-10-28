return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "basedpyright",
          "clangd",
          "clang-format",
          "clang-tidy",
          "lua-language-server",
          "ruff",
          "tree-sitter-cli",
        },
        run_on_start = true,
      })
      -- Enable servers in config/lsp/init.lua, after applying their settings.
      require("mason-lspconfig").setup({ automatic_enable = false })
      require("config.lsp").setup()
    end,
  },
}
