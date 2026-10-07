# Ask which terminal multiplexer to start in a fresh terminal, like .bashrc.
#
# Only installed multiplexers are offered, and the prompt is skipped entirely
# when none is installed, when already inside tmux/herdr, in IDE terminals
# (VS Code and forks, JetBrains), without a TTY, or with NO_MUX=1.
#
# zshrc sources this file halfway through, before the rest of PATH is set up,
# so the question is asked from a one-shot precmd hook at the first prompt.

_dotfiles_mux_prompt() {
  add-zsh-hook -d precmd _dotfiles_mux_prompt

  [[ -o interactive && -t 0 && -t 1 ]] || return
  [[ -z $TMUX && -z $HERDR_ENV && -z $NO_MUX ]] || return
  [[ $TERM_PROGRAM == vscode || $TERMINAL_EMULATOR == JetBrains* ]] && return

  local choices="" key
  (( $+commands[tmux] ))  && choices+="[t]mux / "
  (( $+commands[herdr] )) && choices+="[h]erdr / "
  [[ -n $choices ]] || return

  read -s -k 1 "key?Multiplexer? ${choices}[Enter] none: "
  print
  case $key in
    [tT]) (( $+commands[tmux] ))  && tmux ;;
    [hH]) (( $+commands[herdr] )) && herdr ;;
  esac
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _dotfiles_mux_prompt
