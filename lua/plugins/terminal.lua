return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 15,
      open_mapping = [[<leader>ot]],
      direction = "horizontal",
      shade_terminals = true,
      persist_size = true,
      close_on_exit = true,
      start_in_insert = true,
      insert_mappings = false,
      terminal_mappings = true,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {
        desc = "Leave terminal mode",
      })
    end,
  },
}
