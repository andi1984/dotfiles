#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew. Homebrew itself gets installed on macOS; on Linux the
# Brewfile is only applied when Homebrew is already set up there.

# Pick up an existing Homebrew that isn't on PATH yet (fresh shells on Apple
# Silicon, Linuxbrew).
if ! command -v brew >/dev/null 2>&1
then
  for prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew "$HOME/.linuxbrew"
  do
    if [ -x "$prefix/bin/brew" ]
    then
      eval "$("$prefix/bin/brew" shellenv)"
      break
    fi
  done
fi

# Check for Homebrew
if ! command -v brew >/dev/null 2>&1
then
  if [ "$(uname -s)" = "Darwin" ]
  then
    echo "  Installing Homebrew for you."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    for prefix in /opt/homebrew /usr/local
    do
      if [ -x "$prefix/bin/brew" ]
      then
        eval "$("$prefix/bin/brew" shellenv)"
        break
      fi
    done
  else
    echo "  Homebrew not installed, skipping the Brewfile."
    exit 0
  fi
fi

# Install what is inside the Brewfile. Entries Homebrew has since removed fail
# on their own without aborting the rest of the setup.
if ! brew bundle --file="$(dirname "$0")/Brewfile"
then
  echo "  brew bundle reported failures (see above), continuing."
fi

exit 0
