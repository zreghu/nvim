local colorscheme_before_zen_mode
local background_before_zen_mode
local guifont_before_zen_mode
local wrap_options_before_zen_mode

return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme("habamax")
    end,
    opts = {
      theme = "wave",
      background = { dark = "wave", light = "lotus" },
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 900,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 350,
      spec = {
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "Git changes" },
        { "<leader>m", group = "language" },
        { "<leader>o", group = "open" },
        { "<leader>p", group = "project" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "toggle" },
        { "<leader>w", group = "windows" },
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>tz", "<cmd>ZenMode<CR>", desc = "Toggle zen mode" },
    },
    opts = {
      window = { width = 120 },
      on_open = function()
        wrap_options_before_zen_mode = {
          wrap = vim.wo.wrap,
          linebreak = vim.wo.linebreak,
          breakindent = vim.wo.breakindent,
        }
        vim.wo.wrap = true
        vim.wo.linebreak = true
        vim.wo.breakindent = true

        if not colorscheme_before_zen_mode then
          colorscheme_before_zen_mode = vim.g.colors_name or "kanagawa"
          background_before_zen_mode = vim.o.background
        end
        vim.cmd.colorscheme("rose-pine-dawn")

        if vim.g.neovide then
          guifont_before_zen_mode = vim.o.guifont
          vim.o.guifont = "Inconsolata"
        end
      end,
      on_close = function()
        if wrap_options_before_zen_mode then
          vim.wo.wrap = wrap_options_before_zen_mode.wrap
          vim.wo.linebreak = wrap_options_before_zen_mode.linebreak
          vim.wo.breakindent = wrap_options_before_zen_mode.breakindent
          wrap_options_before_zen_mode = nil
        end

        if colorscheme_before_zen_mode then
          if background_before_zen_mode then
            vim.o.background = background_before_zen_mode
          end
          vim.cmd.colorscheme(colorscheme_before_zen_mode)
          colorscheme_before_zen_mode = nil
          background_before_zen_mode = nil
        end

        if vim.g.neovide and guifont_before_zen_mode ~= nil then
          vim.o.guifont = guifont_before_zen_mode
          guifont_before_zen_mode = nil
        end
      end,
      plugins = {
        options = { enabled = true, ruler = false, showcmd = false },
        twilight = { enabled = false },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "quickfix", "toggleterm" },
    },
  },
}
