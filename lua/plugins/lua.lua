return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      -- Preserve our explicit workspace root and per-project LuaLS settings.
      integrations = { lspconfig = false },
      -- Keep Neovim libraries specific to this config workspace.
      enabled = function(root)
        local config = vim.fn.stdpath("config")
        return (vim.uv.fs_realpath(root) or root) == (vim.uv.fs_realpath(config) or config)
      end,
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
