local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user-lsp-keymaps", { clear = true }),
    callback = function(event)
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
      end

      map("gd", vim.lsp.buf.definition, "Go to definition")
      map("gr", vim.lsp.buf.references, "Find references")
      map("K", vim.lsp.buf.hover, "Hover documentation")
      map("<leader>ca", vim.lsp.buf.code_action, "Code action")
      map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
      map("<leader>ci", vim.lsp.buf.implementation, "Find implementations")
      map("<leader>ct", vim.lsp.buf.type_definition, "Find type definition")
      map("<leader>ck", vim.lsp.buf.hover, "Documentation")
    end,
  })
end

return M
