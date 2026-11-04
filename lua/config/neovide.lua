-- Scale font in Neovide
vim.g.neovide_scale_factor = 1.1

vim.keymap.set("n", "<C-=>", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1
end, { desc = "Increase Neovide scale" })

vim.keymap.set("n", "<C-->", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor / 1.1
end, { desc = "Decrease Neovide scale" })
