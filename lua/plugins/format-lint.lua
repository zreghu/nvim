return {
  {
    "stevearc/conform.nvim",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
        python = { "ruff_format" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        markdown = { "rumdl" },
        haskell = { lsp_format = "fallback" },
      },
      format_on_save = false,
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "ruff" },
        c = { "clangtidy" },
        cpp = { "clangtidy" },
        markdown = { "rumdl" },
      }

      -- Recent clang-tidy builds need explicit analysis checks. Respect each
      -- project's .clang-tidy and supply a default only when none is present.
      local clangtidy = lint.linters.clangtidy
      lint.linters.clangtidy = function()
        local linter = vim.deepcopy(clangtidy)
        local filename = vim.api.nvim_buf_get_name(0)
        local directory = vim.fs.dirname(filename) or vim.fn.getcwd()
        local config = vim.fs.find(".clang-tidy", { path = directory, upward = true })[1]
        if not config then
          table.insert(linter.args, "--checks=clang-analyzer-*")
        end
        return linter
      end

      local group = vim.api.nvim_create_augroup("user-lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = group,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
