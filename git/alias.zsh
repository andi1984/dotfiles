alias gbpurge="git branch --merged | grep -v \"*\" | grep -Ev \"(\*|master|develop|staging)\" | xargs -n 1 git branch -d"
alias gbclean="git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -d"
alias gpo='git push origin "$(git symbolic-ref --short HEAD)"'