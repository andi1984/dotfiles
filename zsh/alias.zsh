source $(dirname $0)/../git/alias.zsh

alias cdWork='cd ~/dev/web'
alias nfix='nvm use'

# Integration deploy
alias use_integration="export KUBECONFIG=$HOME/Documents/integration2.yaml"
alias use_development="export KUBECONFIG=$HOME/Documents/development.yaml"
# Kube aliases
alias k="kubectl --insecure-skip-tls-verify"
alias kns="kubectl --insecure-skip-tls-verify get namespaces"
alias kc="kubectl --insecure-skip-tls-verify config set-context --current --namespace "
alias kcc="kubectl --insecure-skip-tls-verify config get-contexts"
alias kd="kubectl --insecure-skip-tls-verify describe "
alias ka="kubectl --insecure-skip-tls-verify get all"
alias kl="kubectl --insecure-skip-tls-verify logs "
alias kin="kubectl --insecure-skip-tls-verify get ingress"
alias kn="kubectl --insecure-skip-tls-verify get nodes --show-labels"
