return {
  {
    "lervag/vimtex",
    -- VimTeX uses filetype/autoload itself; keep its global commands available.
    lazy = false,
    init = function()
      vim.g.tex_flavor = "latex"
      -- Doom-style language actions use Space m. Reserve c for compile and C
      -- for auxiliary cleanup, instead of VimTeX's default clean bindings.
      vim.g.vimtex_mappings_prefix = "<leader>m"
      vim.g.vimtex_mappings_disable = {
        n = { "<leader>ml", "<leader>mc", "<leader>mC" },
      }
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
      vim.g.vimtex_compiler_latexmk = {
        continuous = 0,
        options = { "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
      }
      vim.g.vimtex_view_automatic = 0
      -- Use the system's default PDF application.
      vim.g.vimtex_view_method = "general"
      vim.g.vimtex_view_general_viewer = vim.fn.has("mac") == 1 and "open" or "xdg-open"
    end,
    config = function()
      local commands = {
        c = { "VimtexCompile", "Compile document" },
        v = { "VimtexView", "View PDF" },
        e = { "VimtexErrors", "Compilation errors" },
        t = { "VimtexTocToggle", "Table of contents" },
        k = { "VimtexStop", "Stop compilation" },
        i = { "VimtexInfo", "Project information" },
        o = { "VimtexCompileOutput", "Compiler output" },
        C = { "VimtexClean", "Clean auxiliary files" },
      }
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user-vimtex-keymaps", { clear = true }),
        pattern = "tex",
        callback = function(event)
          for key, action in pairs(commands) do
            vim.keymap.set("n", "<leader>m" .. key, "<cmd>" .. action[1] .. "<CR>", {
              buffer = event.buf,
              silent = true,
              desc = action[2],
            })
          end
        end,
      })
    end,
  },
}
