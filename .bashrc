# ~/.bashrc — interactive bash setup, shared between Ubuntu and macOS.
#
# Every tool hook below is guarded, so a machine without the tool simply skips
# it instead of printing errors. Machine-specific settings and secrets belong
# in ~/.localrc, which is never committed.

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# --- helpers -----------------------------------------------------------------

has() { command -v "$1" >/dev/null 2>&1; }

# Prepend a directory to PATH if it exists and isn't on PATH yet.
path_prepend() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1${PATH:+:$PATH}" ;;
  esac
}

source_if() {
  if [ -r "$1" ]; then
    # shellcheck source=/dev/null
    . "$1"
  fi
}

# Resolve the dotfiles checkout from the ~/.bashrc symlink, wherever it lives.
__dotfiles_dir() {
  local src="${BASH_SOURCE[0]}" dir
  while [ -L "$src" ]; do
    dir="$(cd -P "$(dirname "$src")" && pwd)"
    src="$(readlink "$src")"
    case "$src" in /*) ;; *) src="$dir/$src" ;; esac
  done
  cd -P "$(dirname "$src")" && pwd
}
DOTFILES="$(__dotfiles_dir 2>/dev/null || echo "$HOME/dev/dotfiles")"
export DOTFILES
unset -f __dotfiles_dir

# Stash your environment variables in ~/.localrc. This means they'll stay out
# of your main dotfiles repository (which may be public, like this one), but
# you'll have access to them in your scripts.
source_if "$HOME/.localrc"

# --- PATH and toolchains -----------------------------------------------------
# Later entries take precedence, matching the previous prepend order.

path_prepend "$HOME/bin"
path_prepend "$HOME/.local/bin"

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source_if "$NVM_DIR/nvm.sh"                 # This loads nvm
  source_if "$NVM_DIR/bash_completion"        # This loads nvm bash_completion
else
  for _nvm in /opt/homebrew/opt/nvm /usr/local/opt/nvm; do
    if [ -s "$_nvm/nvm.sh" ]; then
      source_if "$_nvm/nvm.sh"
      source_if "$_nvm/etc/bash_completion.d/nvm"
      break
    fi
  done
  unset _nvm
fi

# Rust: rustup's env file, or the toolchain of the rustup snap on Ubuntu.
if [ -r "$HOME/.cargo/env" ]; then
  source_if "$HOME/.cargo/env"
else
  for _tc in "$HOME"/snap/rustup/common/rustup/toolchains/stable-*/bin; do
    path_prepend "$_tc"
  done
  unset _tc
fi

source_if "$HOME/.deno/env"
path_prepend "$HOME/.deno/bin"
path_prepend "$DOTFILES/bin"

# Perl local::lib
if [ -d "$HOME/perl5" ]; then
  path_prepend "$HOME/perl5/bin"
  PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
  PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
  # shellcheck disable=SC2089,SC2090 # literal quotes, as written by local::lib
  export PERL_MB_OPT="--install_base \"$HOME/perl5\""
  PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;
fi

# bun
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  path_prepend "$BUN_INSTALL/bin"
fi

# Android SDK/NDK — Ferrico mobile build (ticket #61)
if [ -z "${ANDROID_HOME:-}" ]; then
  for _sdk in "$HOME/Android/Sdk" "$HOME/Library/Android/sdk"; do
    if [ -d "$_sdk" ]; then
      export ANDROID_HOME="$_sdk"
      break
    fi
  done
  unset _sdk
fi
if [ -n "${ANDROID_HOME:-}" ]; then
  [ -d "$ANDROID_HOME/ndk/30.0.15729638" ] && export NDK_HOME="$ANDROID_HOME/ndk/30.0.15729638"
  path_prepend "$ANDROID_HOME/emulator"
  path_prepend "$ANDROID_HOME/platform-tools"
  path_prepend "$ANDROID_HOME/cmdline-tools/latest/bin"
fi

# Java 21: Debian/Ubuntu package path, or macOS java_home.
for _jdk in /usr/lib/jvm/java-21-openjdk-*; do
  if [ -d "$_jdk" ]; then
    export JAVA_HOME="$_jdk"
    break
  fi
done
unset _jdk
if [ -z "${JAVA_HOME:-}" ] && [ -x /usr/libexec/java_home ] && /usr/libexec/java_home -v 21 >/dev/null 2>&1; then
  JAVA_HOME="$(/usr/libexec/java_home -v 21)"
  export JAVA_HOME
fi

export PATH

# --- bash-it -----------------------------------------------------------------

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# Some themes can show whether `sudo` has a current token or not.
# Set `$THEME_CHECK_SUDO` to `true` to check every prompt:
#THEME_CHECK_SUDO='true'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# (Advanced): Change this to the name of the main development branch if
# you renamed it or if it was changed for some reason
# export BASH_IT_DEVELOPMENT_BRANCH='master'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to the location of your work or project folders
#BASH_IT_PROJECT_PATHS="${HOME}/Projects:/Volumes/work/src"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true
# Set to actual location of gitstatus directory if installed
#export SCM_GIT_GITSTATUS_DIR="$HOME/gitstatus"
# per default gitstatus uses 2 times as many threads as CPU cores, you can change this here if you must
#export GITSTATUS_NUM_THREADS=8

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8}

# If your theme use command duration, uncomment this to
# enable display of last command duration.
#export BASH_IT_COMMAND_DURATION=true
# You can choose the minimum time in seconds before
# command duration is displayed.
#export COMMAND_DURATION_MIN_SECONDS=1

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# Load Bash It
source_if "$BASH_IT/bash_it.sh"

# --- interactive extras ------------------------------------------------------

# Switch node versions automatically when entering a directory with .nvmrc.
enter_directory() {
  has nvm || return 0

  if [[ $PWD == "$PREV_PWD" ]]; then
    return
  fi

  # shellcheck disable=SC2076 # quoted on purpose: literal prefix match, not a regex
  if [[ "$PWD" =~ "$PREV_PWD" && ! -f ".nvmrc" ]]; then
    return
  fi

  PREV_PWD=$PWD
  if [[ -f ".nvmrc" ]]; then
    nvm use
    NVM_DIRTY=true
  elif [[ $NVM_DIRTY = true ]]; then
    nvm use default
    NVM_DIRTY=false
  fi
}

export PROMPT_COMMAND="enter_directory; ${PROMPT_COMMAND}"

# fzf key bindings and completion. bash-it's fzf plugin may already have
# loaded the same file through ~/.fzf.bash; it only initializes once.
source_if "$DOTFILES/fzf/fzf.bash.symlink"

# Ask which terminal multiplexer to start in a fresh terminal. Only installed
# multiplexers are offered, and the prompt is skipped entirely when none is
# installed, when already inside tmux/herdr, without a TTY, or with NO_MUX=1.
if [ -z "$TMUX" ] && [ -z "$HERDR_ENV" ] && [ -z "$NO_MUX" ] && [ -t 0 ] && [ -t 1 ]; then
  _mux_choices=""
  has tmux && _mux_choices="${_mux_choices}[t]mux / "
  has herdr && _mux_choices="${_mux_choices}[h]erdr / "
  if [ -n "$_mux_choices" ]; then
    read -r -n 1 -p "Multiplexer? ${_mux_choices}[Enter] none: " _mux
    echo
    case "$_mux" in
      t|T) has tmux && tmux ;;
      h|H) has herdr && herdr ;;
    esac
  fi
  unset _mux _mux_choices
fi
