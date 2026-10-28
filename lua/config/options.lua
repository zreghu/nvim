local opt = vim.opt

opt.number = true
opt.relativenumber = true
-- Leave room for Git markers and diagnostic icons together.
opt.signcolumn = "yes:2"
opt.mouse = "a"
opt.termguicolors = true
opt.showmode = false
opt.clipboard = "unnamedplus"

-- Fallback indentation for filetypes without an explicit rule.
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = -1
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Treat snake_case components as separate words for motions and text objects.
opt.iskeyword:remove("_")

opt.splitright = true
opt.splitbelow = true
opt.updatetime = 300
-- Allow time to complete mappings such as ys and leader shortcuts.
opt.timeoutlen = 1000
opt.undofile = true
opt.confirm = true
