# dotfiles

My dotfiles for **macOS** (zsh + oh-my-zsh) and **Ubuntu** (bash + Bash-It),
based on [holman's dotfiles](https://github.com/holman/dotfiles).

The same checkout works on both systems and on machines where some tools are
missing: every tool hook is guarded, so a machine without `herdr`, `nvm`,
`rbenv`, `pyenv`, Bash-It, oh-my-zsh, … simply skips that part instead of
printing errors on every new shell.

## install

```sh
git clone git@github.com:andi1984/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
script/bootstrap
```

`script/bootstrap`

1. fetches the Bash-It submodule (`.bash_it`), if possible,
2. symlinks the dotfiles into `$HOME` and `~/.config`, asking what to do with
   files that already exist (skip, overwrite or back up),
3. runs `bin/dot`: macOS defaults and Homebrew (macOS only), then every
   `topic/install.sh`.

Options: `--yes` backs up existing files without asking (the default when
there is no terminal), `--no-install` only creates the links. Running it again
is safe; links that are already correct are left alone.

Run `dot` from time to time to update Homebrew and re-run the installers.

## layout

Everything is organized by topic (`git/`, `node/`, `zsh/`, `herdr/`, …):

- **bin/**: added to `$PATH` by both shells.
- **topic/\*.symlink**: linked to `~/.<name>` by `script/bootstrap`, e.g.
  `zsh/zshrc.symlink` → `~/.zshrc`, `fzf/fzf.bash.symlink` → `~/.fzf.bash`.
- **topic/\*.zsh**: loaded by zsh (`git/`, `node/` and `zsh/` only, so vim
  plugin files are never sourced). `path.zsh` loads first, `completion.zsh` last.
- **topic/install.sh**: run by `script/install`. Only one level deep, so the
  installers that ship with Bash-It and vim plugins are never picked up.
- Files outside that convention are linked explicitly in `script/bootstrap`:

  | repo | linked to |
  | --- | --- |
  | `.bashrc` | `~/.bashrc` |
  | `.bash_it` | `~/.bash_it` |
  | `vim/` | `~/.config/nvim` |
  | `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
  | `herdr/config.toml` | `~/.config/herdr/config.toml` (by `herdr/install.sh`) |

## conventions for cross-OS changes

- **Guard every tool.** `command -v tool >/dev/null && …` for commands,
  `[ -r file ] && source file` for init scripts, `[ -d dir ]` before adding to
  `$PATH`. `.bashrc` has `has`, `path_prepend` and `source_if` helpers for this.
- **No absolute home paths.** Use `$HOME`; the user name differs between
  machines (`/Users/andreassander` vs. `/home/andreas`).
- **Branch on the OS, not the machine.** `[ "$(uname -s)" = Darwin ]` for
  macOS-only steps such as `macos/set-defaults.sh` or Homebrew.
- **Machine-specific settings and secrets go in `~/.localrc`**, which both
  shells source and which is never committed.
- **POSIX `sh` for installers**, `bash` for `script/*`. macOS ships bash 3.2,
  so avoid bash 4+ features in anything that might run under `/bin/bash`.

## herdr

[herdr](https://herdr.dev) uses the default keybindings (prefix `ctrl+b`,
`prefix+?` lists them). `herdr/install.sh` links the config, removes leftovers
of the `tmurdr` plugin (its `apply` action rewrites `config.toml` and is not
undone by `herdr plugin uninstall`), validates the config and reloads a running
server. On a machine without herdr it only links the config.

New terminals in bash ask which multiplexer to start, offering only the ones
that are installed. Set `NO_MUX=1` to skip the question.

## testing

```sh
script/test
```

Bootstraps into a throwaway `$HOME`, checks the links and that a second run
changes nothing, then starts bash and zsh with a bare `PATH` (a fresh machine
without any tools) and with the current one. Any startup error fails the test.
Shell scripts are linted with shellcheck (or `uvx shellcheck-py` when only
`uv` is installed).

GitHub Actions runs the same test on `ubuntu-latest` and `macos-latest` for
every push. The Bash-It fork isn't publicly fetchable, so CI covers the "no Bash-It" path.

## thanks

[Zach Holman](https://github.com/holman/dotfiles) for the original structure,
and [Ryan Bates](http://github.com/ryanb), whose
[dotfiles](http://github.com/ryanb/dotfiles) inspired it.
