# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="bureau"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias creategi="gi osx,bower,node,sass >> .gitignore"
alias pip-sync="pip freeze | grep -v -f requirements.txt - | xargs pip uninstall -y"
# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git git-flow gitignore gulp npm terminalapp grunt github osx brew python)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Path for homebrew (/usr/local/[s]bin)

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Set up rbenv for Homebrew. Make sure path is BEFORE Homebrew's /usr/local/[s]bin
#To enable shims and autocompletion add to your profile:
eval "$(rbenv init -)"

# Change gem path
export GEM_PATH=/Users/andreassander/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# The next line updates PATH for the Google Cloud SDK.
source '/Users/andreassander/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/Users/andreassander/google-cloud-sdk/completion.zsh.inc'

# added by travis gem
[ -f /Users/andreassander/.travis/travis.sh ] && source /Users/andreassander/.travis/travis.sh

export PATH="$HOME/.yarn/bin:$PATH"

###-tns-completion-start-###
if [ -f /Users/andreassander/.tnsrc ]; then
    source /Users/andreassander/.tnsrc
fi
###-tns-completion-end-###
export PATH="/usr/local/opt/postgresql@9.5/bin:$PATH"
export PATH="/usr/local/opt/php@7.1/bin:$PATH"
export PATH="/usr/local/opt/php@7.1/sbin:$PATH"
export PATH="$(pyenv root)/shims:$PATH"
