#!/usr/bin/env bash
# Install Neovim, this config, and the toolchains it expects on Arch Linux or macOS.
#
# Run it from a checkout to link the config to that checkout:
#   ./install.sh
# Or run it on its own to clone the config (bash <(...) keeps prompts on the terminal):
#   bash <(curl -fsSL https://raw.githubusercontent.com/zreghu/nvim/main/install.sh)
set -euo pipefail

REPO_URL="https://github.com/zreghu/nvim.git"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

WITH_RUST=1
WITH_HASKELL=1
WITH_TEX=1

usage() {
  cat <<EOF
Usage: install.sh [options]

Installs Neovim, the config in $CONFIG_DIR, and the toolchains it uses.
Mason installs the language servers, formatters, and linters.

Options:
  --no-rust     Skip rustup, rust-analyzer, clippy, and rustfmt
  --no-haskell  Skip GHCup, GHC, and haskell-language-server
  --no-tex      Skip TeX Live (latexmk, xelatex, chktex)
  -h, --help    Show this help
EOF
}

log() {
  printf '\n==> %s\n' "$*"
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

have() {
  command -v "$1" >/dev/null 2>&1
}

while [ $# -gt 0 ]; do
  case "$1" in
    --no-rust) WITH_RUST=0 ;;
    --no-haskell) WITH_HASKELL=0 ;;
    --no-tex) WITH_TEX=0 ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      die "unknown option: $1"
      ;;
  esac
  shift
done

if [ "$(id -u)" -eq 0 ]; then
  die "run this as your user; it calls sudo where needed"
fi

case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux)
    have pacman || die "only Arch Linux (pacman) and macOS are supported"
    OS=arch
    ;;
  *) die "only Arch Linux and macOS are supported" ;;
esac

# A checkout contains init.lua next to this script. Piped runs have no script file.
SCRIPT_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  candidate="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  if [ -f "$candidate/init.lua" ]; then
    SCRIPT_DIR="$candidate"
  fi
fi

install_arch_packages() {
  local packages=(
    neovim git base-devel curl unzip tar gzip python
    ripgrep fd tree-sitter-cli xdg-utils wl-clipboard xclip
  )
  if [ "$WITH_RUST" -eq 1 ] && ! have rustup; then
    packages+=(rustup)
  fi
  if [ "$WITH_HASKELL" -eq 1 ]; then
    # GHCup's prebuilt GHC links against these.
    packages+=(gmp ncurses xz)
  fi
  if [ "$WITH_TEX" -eq 1 ]; then
    packages+=(texlive)
  fi
  log "Installing packages with pacman"
  # Arch does not support partial upgrades, so sync and upgrade together.
  sudo pacman -Syu --needed "${packages[@]}"
}

load_homebrew() {
  local brew
  for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$brew" ]; then
      eval "$("$brew" shellenv)"
      return 0
    fi
  done
  return 1
}

install_macos_packages() {
  if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install || true
    die "finish installing the Xcode Command Line Tools, then rerun this script"
  fi

  if ! have brew && ! load_homebrew; then
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    load_homebrew || die "Homebrew installed, but brew is not on PATH"
  fi

  log "Installing packages with Homebrew"
  brew install neovim git ripgrep fd tree-sitter-cli

  if [ "$WITH_RUST" -eq 1 ] && ! have rustup && [ ! -x "$HOME/.cargo/bin/rustup" ]; then
    log "Installing rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi

  if [ "$WITH_TEX" -eq 1 ]; then
    if ! have latexmk && [ ! -x /Library/TeX/texbin/latexmk ]; then
      log "Installing MacTeX (about 5 GB)"
      brew install --cask mactex-no-gui
    fi
    # The MacTeX installer adds this to /etc/paths.d, which only new shells read.
    export PATH="/Library/TeX/texbin:$PATH"
  fi
}

setup_rust() {
  local rustup
  rustup="$(command -v rustup || echo "$HOME/.cargo/bin/rustup")"
  [ -x "$rustup" ] || die "rustup is not installed"
  log "Installing the Rust toolchain and components"
  if ! "$rustup" default >/dev/null 2>&1; then
    "$rustup" default stable
  fi
  "$rustup" component add rust-analyzer clippy rustfmt
}

setup_haskell() {
  local ghcup="$HOME/.ghcup/bin/ghcup"
  if [ ! -x "$ghcup" ]; then
    log "Installing GHCup, GHC, cabal, and haskell-language-server"
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org |
      BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
      BOOTSTRAP_HASKELL_INSTALL_HLS=1 \
      BOOTSTRAP_HASKELL_ADJUST_BASHRC=1 \
      sh
    return
  fi
  # The config runs HLS from ~/.ghcup/bin, so make sure GHCup installed it.
  if [ ! -x "$HOME/.ghcup/bin/ghc" ]; then
    log "Installing GHC with GHCup"
    "$ghcup" install ghc --set recommended
  fi
  if [ ! -x "$HOME/.ghcup/bin/haskell-language-server-wrapper" ]; then
    log "Installing haskell-language-server with GHCup"
    "$ghcup" install hls --set recommended
  fi
}

backup_existing() {
  local stamp dir
  stamp="$(date +%Y%m%d-%H%M%S)"
  # Move plugin data too, so plugins install fresh from this config's lockfile.
  for dir in "$CONFIG_DIR" "$DATA_DIR" "$STATE_DIR" "$CACHE_DIR"; do
    if [ -e "$dir" ] || [ -L "$dir" ]; then
      mv "$dir" "$dir.bak-$stamp"
      echo "Moved $dir to $dir.bak-$stamp"
    fi
  done
}

install_config() {
  mkdir -p "$(dirname "$CONFIG_DIR")"

  if [ -n "$SCRIPT_DIR" ]; then
    if [ -d "$CONFIG_DIR" ] && [ "$(cd "$CONFIG_DIR" && pwd -P)" = "$SCRIPT_DIR" ]; then
      log "Config already points to $SCRIPT_DIR"
      return
    fi
    log "Linking $CONFIG_DIR to $SCRIPT_DIR"
    backup_existing
    ln -s "$SCRIPT_DIR" "$CONFIG_DIR"
    return
  fi

  if [ -d "$CONFIG_DIR/.git" ]; then
    case "$(git -C "$CONFIG_DIR" remote get-url origin 2>/dev/null || true)" in
      *github.com[:/]zreghu/nvim | *github.com[:/]zreghu/nvim.git)
        log "Config already cloned in $CONFIG_DIR"
        return
        ;;
    esac
  fi
  log "Cloning $REPO_URL into $CONFIG_DIR"
  backup_existing
  git clone "$REPO_URL" "$CONFIG_DIR"
}

bootstrap_neovim() {
  # vim.lsp.config and vim.lsp.enable need Neovim 0.11.
  nvim --headless -c 'if !has("nvim-0.11") | cquit | endif' -c 'quit' ||
    die "Neovim 0.11 or newer is required; found $(nvim --version | head -n 1)"

  log "Installing plugins at the versions in lazy-lock.json"
  nvim --headless "+Lazy! restore" +qa

  log "Installing language servers, formatters, and linters with Mason"
  # MasonToolsInstallSync can wait forever after a failed download, so bound the wait.
  local mason="local done = false"
  mason+="; vim.api.nvim_create_autocmd('User', { pattern = 'MasonToolsUpdateCompleted', callback = function() done = true end })"
  mason+="; vim.cmd('MasonToolsInstall')"
  mason+="; if not vim.wait(1800000, function() return done end, 1000) then vim.cmd('cquit') end"
  nvim --headless "+Lazy! load nvim-lspconfig" "+lua $mason" +qa ||
    die "Mason did not finish; open Neovim and run :Mason to see what failed"

  log "Building treesitter parsers"
  # The plugin starts these installs on launch; this waits for them to finish.
  local parsers="local plugin = require('lazy.core.config').plugins['nvim-treesitter']"
  parsers+="; local opts = require('lazy.core.plugin').values(plugin, 'opts', false)"
  parsers+="; require('nvim-treesitter').install(opts.languages):wait(600000)"
  nvim --headless "+lua $parsers" +qa
}

case "$OS" in
  arch) install_arch_packages ;;
  macos) install_macos_packages ;;
esac

if [ "$WITH_RUST" -eq 1 ]; then
  setup_rust
fi
if [ "$WITH_HASKELL" -eq 1 ]; then
  setup_haskell
fi

install_config
bootstrap_neovim

log "Done"
echo "Open a new shell so PATH changes from rustup, GHCup, and TeX take effect."
echo "Run :checkhealth in Neovim to confirm the setup."
