local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Doom's file and buffer actions, using native Neovim commands.
map("n", "<leader>fs", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>bs", "<cmd>write<CR>", { desc = "Save buffer" })
map("n", "<leader>bS", "<cmd>wall<CR>", { desc = "Save all buffers" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bl", "<cmd>buffer #<CR>", { desc = "Switch to last buffer" })
map("n", "<leader>`", "<cmd>buffer #<CR>", { desc = "Switch to last buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bk", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bN", "<cmd>enew<CR>", { desc = "New empty buffer" })

map("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split window below" })
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split window right" })
map("n", "<leader>wd", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<leader>ww", "<C-w>w", { desc = "Next window" })
map("n", "<leader>w=", "<C-w>=", { desc = "Balance windows" })

local directions = { h = "left", j = "below", k = "above", l = "right" }
for key, direction in pairs(directions) do
  local desc = "Move to window " .. direction
  map("n", "<leader>w" .. key, "<C-w>" .. key, { desc = desc })
  map("n", "<C-" .. key .. ">", "<C-w>" .. key, { desc = desc })
  map("t", "<C-" .. key .. ">", [[<C-\><C-n><C-w>]] .. key, { desc = desc })
end

map("n", "<leader>tw", function()
  local enabled = not vim.wo.wrap
  vim.wo.wrap = enabled
  vim.wo.linebreak = enabled
  vim.wo.breakindent = enabled
end, { desc = "Toggle soft wrap" })
