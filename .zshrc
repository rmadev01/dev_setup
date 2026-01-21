# environment
export EDITOR="nvim"
export VISUAL="nvim"
export TERM="xterm-256color"
export ZDOTDIR="$HOME"

# path
path=(
  "$HOME/.local/bin"
  $path
)
export PATH

# plugins
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# autosuggest
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="100"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt APPEND_HISTORY

# behavior
unsetopt BEEP
setopt CORRECT

# aliases
alias ll="ls -lah"
alias v="nvim"
alias ..="cd .."
alias ...="cd ../.."

# keymaps
bindkey -s "^f" "~/.local/bin/tmux-sessionizer\n"
bindkey '^I' autosuggest-accept

# nvm
export NVM_DIR="$HOME/.nvm"
function nvm {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm "$@"
}
function node { nvm; node "$@"; }
function npm { nvm; npm "$@"; }
function npx { nvm; npx "$@"; }

# custom prompt
setopt PROMPT_SUBST
git_info() {
  local branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  local dirty=$([[ -n $(git status --porcelain 2>/dev/null) ]] && echo "*")
  echo " %F{${dirty:+#d699b6}${dirty:-#8bb8a5}}${branch}${dirty}%f"
}
PROMPT='%F{#8cadc6}%~%f$(git_info) %F{#c7c6c6}➜%f '

printf '\033]11;#141415\007'
