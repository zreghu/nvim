# Neovim setup

This config is for Neovim and Neovide. Neovide uses the same configuration as
the terminal application. Kanagawa Wave is the normal theme; Zen Mode uses
Rosé Pine Dawn and restores the previous theme when it closes.

## Install the applications

On this Arch Linux machine, install the editor, GUI client, and search support:

```sh
sudo pacman -S --needed neovim neovide ripgrep
```

`make`, `gcc`, `git`, `curl`, `tar`, and `unzip` are already available here.

## First launch

Start `nvim` or `neovide`. The first launch downloads the plugin manager and
plugins. Mason installs the configured Python, C/C++, Lua, and Tree-sitter build tools. Markdown uses
Marksman and rumdl from the system PATH; LaTeX uses TexLab and chktex. Rust
Analyzer and the Rust formatter/linter use the existing Rust toolchain. Haskell
uses the HLS wrapper installed by GHCup.

## Shortcuts

This uses Doom Emacs's leader layout with Neovim/Telescope equivalents,
with your preferred overrides for references and diagnostic popups. Press
Space and pause to browse the groups. Normal Vim motions, surround keys, and
completion keys keep their usual behavior.

| Keys | Action |
| --- | --- |
| `Space s s` / `Space s b` | Search lines in the current buffer with Telescope |
| `Space s S` | Search buffer with the symbol under the cursor prefilled |
| `Space s p` / `Space /` | Search project text |
| `Space s d` | Search text in the current file's directory |
| `Space *` | Search project for the word under the cursor |
| `Space f f` / `Space .` | Find files in the current file's directory |
| `Space p f` / `Space Space` | Find project files |
| `Space f r` | Search symbol references in Telescope |
| `Space f s` | Save file |
| `Space b b` / `Space ,` | Switch buffers |
| `Space b n` / `Space b p` | Next / previous buffer |
| `Space b l` / `Space backtick` | Return to the last buffer |
| `Space b d` / `Space b k` | Delete the current buffer; refuses unsaved changes |
| `Space b N` | New empty buffer |
| `Space b s` / `Space b S` | Save this buffer / all buffers |
| `Space o p` / `Space o P` | Toggle sidebar / reveal current file |
| `Space o t` | Toggle terminal |
| `Space s i` | Search symbols in the current file (LSP required) |
| `Space c j` | Search workspace symbols (LSP required) |
| `Space s j` / `Space s r` | Telescope jump list / marks |
| `gd` | Go to definition (LSP) |
| `Space c i` / `Space c t` | Go to implementation / type definition |
| `Space c k` | Hover documentation |
| `Space c a` / `Space c r` | Code action / rename symbol |
| `Space c f` | Format buffer |
| `Space c x` / `Space c X` | List errors and warnings globally / in this buffer |
| `Space c d` / `Ctrl-w d` | Show line diagnostics; repeat to focus the popup |
| `Space g g` | Telescope Git status |
| `Space g s` / `Space g r` | Stage / reset hunk (reset discards edits) |
| `Space g [` / `Space g ]` | Previous / next Git change |
| `Space g B` | Git blame |
| `Space g h d` | Toggle the Git comparison (Neovim extension) |
| `Space w s` / `Space w v` | Split below / right |
| `Space w h/j/k/l` | Move between windows |
| `Space w d` / `Space w =` | Close window / balance windows |
| `Space t z` | Toggle zen mode |
| `Space t w` | Toggle soft wrap in the current window |
| `Space '` | Resume the last Telescope picker |
| `Space :` | Telescope command picker |

In terminal mode, Escape returns to Normal mode; `Ctrl-h/j/k/l` moves between
windows. These Control shortcuts also work from ordinary buffers. Tab /
Shift-Tab selects completion or snippet entries, and Enter confirms completion.

Project pickers find the Git root for the current file, then fall back to an
attached language server's root or the working directory. The file picker and
current-directory search use the current file's containing directory.

`Space f r` searches references and `Space c d` opens line diagnostics.
These are your preferred overrides; `Space c D` is unassigned. Use
`:Telescope oldfiles` for recent files.
Project text search moved from `Space f g` to `Space s p`. Diagnostic pickers
moved from `Space f d`/`Space f D` to `Space c x`/`Space c X`. `gd`
goes to definition; use `Space c d` for the diagnostic popup. The terminal moved
from `Space t t` to `Space o t`.

Telescope Git status substitutes for Doom's Magit status. The `Space g h` hunk
menu and VimTeX's extra `Space m` actions are documented Neovim extensions.
Formatting is manual; saving does not rewrite the buffer. Markdown and LaTeX
PDFs rebuild after their source files are saved. Linters report issues during
editing and after saving.

For C/C++, clang-tidy uses the project’s `.clang-tidy` settings when present.
If none exists, the editor enables `clang-analyzer-*` checks so newer builds
perform analysis instead of exiting with “no checks enabled”.

## Configuration layout

`init.lua` loads general options, indentation, keymaps, and then lazy.nvim.
The plugin manager imports every Lua file in `lua/plugins/` automatically.

| File or directory | Edit here for |
| --- | --- |
| `lua/config/options.lua` | General editor settings and fallback indentation |
| `lua/config/diagnostics.lua` | Diagnostic gutter icons and severity ordering |
| `lua/config/indent.lua` | Filetype indentation defaults |
| `lua/config/git.lua` | Git diff comparison toggle and window handling |
| `lua/config/project.lua` | Project-root detection for Telescope |
| `lua/config/keymaps.lua` | Global editor and window shortcuts |
| `lua/config/lazy.lua` | Plugin manager bootstrap and settings |
| `lua/config/lsp/init.lua` | Shared LSP capabilities and server activation |
| `lua/config/lsp/servers.lua` | Language server settings and executable paths |
| `lua/config/lsp/keymaps.lua` | Shortcuts attached to LSP buffers |
| `lua/plugins/ui.lua` | Theme, statusline, key hints, and zen mode |
| `lua/plugins/navigation.lua` | Telescope and file tree |
| `lua/plugins/treesitter.lua` | Syntax parsing, highlighting, and indentation |
| `lua/plugins/completion.lua` | Completion sources, snippets, and their shortcuts |
| `lua/plugins/lsp.lua` | LSP dependencies and Mason tool installation |
| `lua/plugins/format-lint.lua` | Formatters and linters by filetype |
| `lua/plugins/git.lua` | Git signs and hunk shortcuts |
| `lua/plugins/editing.lua` | Surround editing and automatic bracket pairs |
| `lua/plugins/lua.lua` | LazyDev and Neovim Lua libraries |
| `lua/plugins/latex.lua` | VimTeX compiler and PDF viewer |
| `lua/plugins/terminal.lua` | Terminal behavior and shortcut |
| `.editorconfig` | Consistent whitespace when editing this config |
| `lazy-lock.json` | Pinned plugin versions; managed by lazy.nvim |

Plugin shortcuts live alongside their plugin; global shortcuts live in
`config/keymaps.lua`. Language servers are configured and enabled from one
server table, avoiding duplicate activation through Mason.

## Indentation

All configured filetypes use spaces. C, C++, Python, and Rust use four columns;
Haskell, Lua, Markdown, Vimscript, and TeX use two. Other filetypes fall back to
four columns. These are editing conventions, not universal language requirements.
A project's `.editorconfig` can override them, and manual formatting follows the
formatter's own project settings.

## Lua and Neovim configuration

LuaLS treats this directory as a workspace. LazyDev supplies Neovim's runtime
and loads plugin Lua libraries as they are used, including completion for
`require(...)`. The config remains workspace code so its diagnostics are enabled.
LazyDev is enabled only for this config workspace; other Lua projects retain
their own LuaLS settings.

## Maintenance

Restart Neovim after changing startup or plugin configuration. Use `:Lazy` for
plugins, `:Mason` for managed tools, and `:checkhealth vim.lsp` for language server
diagnostics. `:lua print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))` shows the
clients attached to the current buffer.


## Using the new plugins

Press the keys in sequence in Normal mode unless specified otherwise. `<leader>`
is Space. Language-specific actions use `Space m`. Escape returns to Normal mode.

### Git changes: gitsigns

Inside a Git repository, gutter markers identify added, modified, and deleted
lines. A hunk is a nearby group of changed lines.

| Keys | Action |
| --- | --- |
| `]c` / `[c` | Jump to the next / previous change |
| `Space g h p` | Preview the change under the cursor |
| `Space g h s` | Stage or unstage the current change |
| `Space g h r` | Reset the change, discarding those edits |
| `Space g h b` | Show who last committed the current line |
| `Space g h d` | Toggle the Git comparison; press again in either pane to close it |
| `Space g g` | Open the existing Telescope Git status picker |

Start by editing a tracked file, pressing Escape, jumping with `]c`, and
previewing with `Space g h p`. Stage only the change you want with `Space g h s`;
this prepares it for a commit. Gitsigns does not commit it. In Visual mode,
`Space g h s` and `Space g h r` act on the selected lines.

### Surrounding text: nvim-surround

Use `ys` plus a motion and a delimiter to add a surround, `ds` plus a delimiter
to delete one, and `cs` plus the old and new delimiters to change one.

| Starting text | Keys | Result |
| --- | --- | --- |
| `hello` with cursor on the word | `ysiw"` | `"hello"` |
| `hello` with cursor on the word | `ysiw)` | `(hello)` |
| `"hello"` with cursor inside | `cs"'` | `'hello'` |
| `"hello"` with cursor inside | `ds"` | `hello` |

For a more deliberate workflow, select the word with `viw`, then press `S"`
to surround the selection with quotes. You can pause after selecting the text.
For the normal-mode form, think of `ysiw"` as `ys` (surround), `iw` (inner word),
and `"` (quotes). The mapping timeout is one second: type `y` and `s` within
that interval so `y` does not become the normal yank command.

Here `iw` means "inner word". A closing delimiter such as `)` gives `(hello)`;
an opening delimiter such as `(` adds spaces: `( hello )`.

### Lua configuration: lazydev

Open a Lua file in this config and type `vim.api.` or start `require("...`.
Use `Ctrl-Space` to request completion, Tab / Shift-Tab to select, and Enter to
accept. Hover with `K`, jump to definitions with `gd`, and request a code action
with `Space c a`. LazyDev supplies the library information while LuaLS provides
language features. Run `:LazyDev` to inspect the workspace.

### Automatic pairs: nvim-autopairs

In Insert mode, type `(`, `{`, `[`, or a quote: the closing character appears
automatically and the cursor stays between the pair. Type the closing character
to move past an existing one. Backspace between an empty pair removes both.
Accepting function completions also adds parentheses when appropriate.

### Statusline: lualine

No shortcuts are needed. The bottom bar shows mode, Git branch and changes,
diagnostics, filename, filetype, progress, and cursor position. Its configuration
is alongside your theme in `lua/plugins/ui.lua`.

### LaTeX: VimTeX

Open the main `.tex` file; VimTeX starts continuous compilation with latexmk
and XeLaTeX, building immediately and rebuilding when the source is saved.
Press `Space m c` to ensure compilation is running, `Space m k` to stop it, or
`Space m v` to view the PDF. Your system PDF application is Firefox; this opens
the PDF but does not provide SyncTeX jumps between source and PDF.

| Keys | Action |
| --- | --- |
| `Space m c` | Start continuous compilation |
| `Space m v` | Open the output PDF |
| `Space m e` | Show compilation errors |
| `Space m t` | Toggle the table of contents |
| `Space m i` | Show VimTeX project information |
| `Space m k` | Stop compilation |
| `Space m o` | Show compiler output |
| `Space m C` | Clean auxiliary files |

Press `Space m` and pause to see the language menu in a LaTeX buffer.
The old backslash-prefixed VimTeX shortcuts are replaced by this prefix.

### Markdown: format and PDF

In a Markdown buffer, `Space m f` formats with rumdl. Saving the file rebuilds
its PDF: if a Makefile exists in the current directory or a parent directory,
Neovim runs `make` there; otherwise it runs Pandoc to create a same-name PDF
beside the Markdown file. `Space m c` saves and builds immediately, and
`Space m v` opens the PDF with the system PDF application. For example, in
`~/workplace/resume/resume.md`, the Makefile runs the project's Pandoc template
and filter to create `resume.pdf`.

Try a small `article` document first. Once comfortable, `cse` changes an
environment and `dse` removes its begin/end wrapper. See `:help vimtex` for more.

## Plugin help

Use `:help gitsigns`, `:help nvim-surround`, `:help lazydev`,
`:help nvim-autopairs`, `:help lualine`, and `:help vimtex` for full manuals.


## Word navigation and diagnostic icons

Underscores are removed from `iskeyword`: `foo_bar` contains the word `foo`,
the punctuation `_`, and the word `bar`. Motions such as `w`, `b`, and `e`,
text objects such as `iw`, and word searches such as `*` use these boundaries.
Uppercase `W`, `B`, and `E` still move by whitespace-separated chunks.

Diagnostic gutter signs use a cross for errors, a warning triangle for warnings,
an info circle for information, and a lightbulb for hints. The theme supplies
their colors. Two sign columns allow Git markers and diagnostics to coexist;
higher-severity diagnostics have priority. Use a Nerd Font to display the icons.
Use `]d` / `[d` to jump between diagnostics and `Space c d` to read the diagnostic message. `Space c x` lists errors and warnings in
Telescope.


## Tree-sitter compatibility

Neovim 0.12 uses the `main` branch of nvim-treesitter and Neovim's native
highlighting API. The frozen `master` branch targets older Neovim versions and
breaks Markdown language injections in hover popups on 0.12. Parser installation
uses Mason's `tree-sitter-cli`; `:TSUpdate` updates the parsers after plugin
updates. Parser files and queries are managed under the Neovim data directory's
`site/` folder. Restart Neovim after upgrading the plugin or its parsers.
