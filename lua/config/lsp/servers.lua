-- Server settings live here; installation is configured in plugins/lsp.lua.
local nvim_config = vim.uv.fs_realpath(vim.fn.stdpath("config")) or vim.fn.stdpath("config")

-- Neovide may not inherit GHCup's directory from the shell PATH.
local ghcup_bin = vim.fn.expand("~/.ghcup/bin")
local hls_path = ghcup_bin
if vim.env.PATH and vim.env.PATH ~= "" then
  hls_path = hls_path .. ":" .. vim.env.PATH
end

return {
  basedpyright = {},
  clangd = {},
  marksman = {},
  lua_ls = {
    root_dir = function(bufnr, on_dir)
      local filename = vim.api.nvim_buf_get_name(bufnr)
      filename = vim.uv.fs_realpath(filename) or filename
      if vim.startswith(filename, nvim_config .. "/") then
        on_dir(nvim_config)
        return
      end
      local root = vim.fs.root(filename, {
        ".luarc.json", ".luarc.jsonc", ".emmyrc.json", ".luacheckrc",
        ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git",
      })
      on_dir(root or vim.fs.dirname(filename))
    end,
    settings = {
      Lua = { telemetry = { enable = false } },
    },
  },
  texlab = {
    settings = {
      texlab = {
        build = {
          executable = "latexmk",
          args = { "-xelatex", "-interaction=nonstopmode", "-synctex=1", "%f" },
          onSave = false,
        },
        chktex = { onOpenAndSave = true, onEdit = true },
      },
    },
  },
  rust_analyzer = {
    cmd = { "/usr/lib/rustup/bin/rust-analyzer" },
    settings = {
      ["rust-analyzer"] = {
        check = { command = "clippy" },
      },
    },
  },
  hls = {
    cmd = { ghcup_bin .. "/haskell-language-server-wrapper", "--lsp" },
    cmd_env = { PATH = hls_path },
  },
}
