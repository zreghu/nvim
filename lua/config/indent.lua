-- Filetype indentation; project .editorconfig files can override these defaults.
local indent_width = {
  c = 4,
  cpp = 4,
  haskell = 2,
  lua = 2,
  markdown = 2,
  python = 4,
  rust = 4,
  vim = 2,
  tex = 2,
  plaintex = 2,
}

local indent = vim.api.nvim_create_augroup("FiletypeIndent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = indent,
  callback = function(args)
    local width = indent_width[args.match]
    if width then
      vim.bo[args.buf].expandtab = true
      vim.bo[args.buf].shiftwidth = width
      vim.bo[args.buf].tabstop = width
      vim.bo[args.buf].softtabstop = width
    end
  end,
})
