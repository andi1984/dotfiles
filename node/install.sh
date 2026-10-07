#!/bin/sh
#
# Global npm tools. Skipped when npm isn't installed.

if ! command -v spoof >/dev/null 2>&1 && command -v npm >/dev/null 2>&1
then
  # nvm and Homebrew installs are user-writable; only a system npm needs sudo.
  if [ -w "$(npm config get prefix)" ]
  then
    npm install spoof -g
  else
    sudo npm install spoof -g
  fi
fi
