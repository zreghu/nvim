return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    init = function()
      -- Parser builds run before the LSP plugin sets up Mason's PATH.
      local bin = vim.fn.stdpath("data") .. "/mason/bin"
      if vim.fn.executable(bin .. "/tree-sitter") == 1 then
        vim.env.PATH = bin .. ":" .. (vim.env.PATH or "")
      end
    end,
    opts = {
      -- install.sh reads this list to finish parser builds before first use.
      languages = {
        "c", "cpp", "haskell", "lua", "markdown", "markdown_inline", "python", "rust", "vim", "vimdoc",
      },
    },
    config = function(_, opts)
      local ts = require("nvim-treesitter")
      local languages = opts.languages
      ts.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
      -- This is a no-op for installed parsers. Mason supplies the CLI.
      if vim.fn.executable("tree-sitter") == 1 then
        ts.install(languages, { max_jobs = 2 })
      end

      local enabled = {}
      for _, language in ipairs(languages) do
        enabled[language] = true
      end
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
        callback = function(event)
          local language = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
          if not enabled[language] then
            return
          end
          -- Use built-in syntax until a parser finishes its first installation.
          local ok, available = pcall(vim.treesitter.language.add, language)
          if not ok or not available then
            return
          end
          vim.treesitter.start(event.buf, language)
          if vim.treesitter.query.get(language, "indents") then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
