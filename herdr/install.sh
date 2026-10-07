#!/bin/sh
#
# herdr
#
# Links config.toml into ~/.config/herdr (same path on Linux and macOS) and
# removes leftovers of the tmurdr plugin, whose "apply" action rewrites the
# [keys] section of config.toml and is not undone by uninstalling it.

set -e

src="$(cd "$(dirname "$0")" && pwd)/config.toml"
dir="$HOME/.config/herdr"
dst="$dir/config.toml"

mkdir -p "$dir"

if command -v herdr >/dev/null 2>&1 && herdr plugin list 2>/dev/null | grep -q tmurdr
then
  echo "› herdr plugin uninstall tmurdr"
  herdr plugin uninstall tmurdr
fi
rm -rf "$dir/plugins/config/tmurdr"

if [ "$(readlink "$dst" 2>/dev/null)" != "$src" ]
then
  if [ -e "$dst" ] || [ -L "$dst" ]
  then
    backup="$dst.backup-$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    echo "› moved existing $dst to $backup"
  fi
  ln -s "$src" "$dst"
  echo "› linked $src to $dst"
fi

if command -v herdr >/dev/null 2>&1
then
  herdr config check
  if herdr status server 2>/dev/null | grep -q 'status: running'
  then
    herdr server reload-config >/dev/null
    echo "› reloaded running herdr server"
  fi
fi
