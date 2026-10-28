local M = {}

function M.root()
  local cwd = vim.fn.getcwd()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or vim.bo.buftype ~= "" then
    path = cwd
  end
  local git_root = vim.fs.root(path, { ".git" })
  if git_root then
    return git_root
  end
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.root_dir then
      return client.root_dir
    end
  end
  return cwd
end

return M
