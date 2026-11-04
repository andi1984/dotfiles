#!/bin/sh
#
# Neovim: install the release pinned in vim/nvim-release (sha256-checked)
# into ~/.local/opt/nvim-<version> and link it as ~/.local/bin/nvim, then
# restore plugins to lazy-lock.json and install the tools and parsers listed
# in lua/config/tools.lua.

set -e
cd "$(dirname "$0")"

version="$(awk '$1 == "version" { print $2 }' nvim-release)"

case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) asset="nvim-linux-x86_64.tar.gz" ;;
  Linux-aarch64 | Linux-arm64) asset="nvim-linux-arm64.tar.gz" ;;
  Darwin-arm64) asset="nvim-macos-arm64.tar.gz" ;;
  Darwin-x86_64) asset="nvim-macos-x86_64.tar.gz" ;;
  *) echo "nvim: unsupported platform $(uname -s)-$(uname -m)" >&2; exit 1 ;;
esac
expected="$(awk -v a="$asset" '$1 == a { print $2 }' nvim-release)"

prefix="$HOME/.local/opt/nvim-$version"
if [ ! -x "$prefix/bin/nvim" ]
then
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  echo "  downloading Neovim $version ($asset)"
  curl -fsSL -o "$tmp/$asset" "https://github.com/neovim/neovim/releases/download/v$version/$asset"

  if command -v sha256sum >/dev/null 2>&1
  then
    actual="$(sha256sum "$tmp/$asset" | cut -d' ' -f1)"
  else
    actual="$(shasum -a 256 "$tmp/$asset" | cut -d' ' -f1)"
  fi
  if [ "$actual" != "$expected" ]
  then
    echo "nvim: checksum mismatch for $asset (got $actual)" >&2
    exit 1
  fi

  mkdir -p "$prefix"
  tar -xzf "$tmp/$asset" -C "$prefix" --strip-components=1
fi

mkdir -p "$HOME/.local/bin"
ln -sfn "$prefix/bin/nvim" "$HOME/.local/bin/nvim"
echo "  nvim -> $("$HOME/.local/bin/nvim" --version | head -1)"

nvim="$HOME/.local/bin/nvim"
if [ ! -e "$HOME/.config/nvim/init.lua" ]
then
  echo "  ~/.config/nvim is not linked yet (run script/bootstrap), skipping plugins and tools"
  exit 0
fi

echo "  restoring plugins (lazy-lock.json)"
"$nvim" --headless "+Lazy! restore" +qa >/dev/null 2>&1 || { echo "nvim: plugin restore failed" >&2; exit 1; }

echo "  installing tools and parsers (lua/config/tools.lua)"
"$nvim" --headless -c 'lua local ok, err = pcall(require("config.tools").install_sync)
  if not ok then io.stderr:write(tostring(err) .. "\n") vim.cmd("cquit 1") end'
