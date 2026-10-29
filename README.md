# nvim

Neovim config for Arch Linux and macOS.

## Features

- lazy.nvim with a pinned lockfile
- Doom Emacs-style `<Space>` leader keymaps, with which-key
- LSP via Mason: C/C++ (clangd), Python (basedpyright), Lua, Markdown
  (marksman), LaTeX (texlab), Rust (rust-analyzer), Haskell (HLS)
- Formatting with conform.nvim and linting with nvim-lint: ruff,
  clang-format, clang-tidy, rustfmt, rumdl
- Treesitter highlighting and indentation
- Completion with nvim-cmp and LuaSnip
- LaTeX with VimTeX (latexmk, XeLaTeX)
- Telescope, Neo-tree, gitsigns, toggleterm, nvim-surround, nvim-autopairs
- Kanagawa theme, lualine, zen-mode

## Install

```sh
git clone https://github.com/zreghu/nvim.git ~/.config/nvim
~/.config/nvim/install.sh
```

Or without cloning first:

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/zreghu/nvim/main/install.sh)
```

The script installs Neovim, rustup, GHCup (recommended GHC, cabal, Stack,
HLS), TeX Live, Mason tools, plugins, and parsers. It backs up an existing
config first. Skip toolchains with `--no-rust`, `--no-haskell`, or `--no-tex`.
