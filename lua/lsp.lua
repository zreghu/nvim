-- LSP Config Setup
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

lspconfig.pyright.setup({
  capabilities = capabilities,
})

lspconfig.lua_ls.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
  settings = { Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the globals
        globals = {'vim', 'on_attach', 'lsp_flags'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

lspconfig.clangd.setup {
  capabilities = capabilities
}

lspconfig.marksman.setup{
  capabilities = capabilities
}

lspconfig.ocamllsp.setup{
  capabilities = capabilities
}

require('lspconfig')['hls'].setup{
  filetypes = {'haskell', 'lhaskell', 'cabal'},
  capabilities = capabilities,
}

vim.cmd[[let g:opamshare = substitute(system('opam var share'),'\n$','','''')]]
vim.cmd[[execute "set rtp+=" . g:opamshare . "/merlin/vim"]]

-- TODO: add more lsp servers
