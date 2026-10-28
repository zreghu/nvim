local M = {}

function M.setup()
  require("config.lsp.keymaps").setup()
  vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  })

  local servers = require("config.lsp.servers")
  for name, settings in pairs(servers) do
    vim.lsp.config(name, settings)
  end
  vim.lsp.enable(vim.tbl_keys(servers))
end

return M
