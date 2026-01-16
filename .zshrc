# environment
export EDITOR="nvim"
export ZDOTDIR="$HOME"

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="minimal"
ENABLE_CORRECTION="true"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# path
path=(
    "$HOME/.local/share/bob/nvim-bin"
    "$HOME/.local/bin"
    "$HOME/.local/share/cargo/bin"
    "$HOME/.opencode/bin"
    $path
)
export PATH

# prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ":vcs_info:git:*" formats "%F{#539bf5}(%b)%f "
zstyle ":vcs_info:*" enable git

setopt PROMPT_SUBST
PROMPT="%F{#c0c0c0}%1~%f %F{#539bf5}➜%f "

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt APPEND_HISTORY

# behavior
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
unsetopt BEEP

# aliases
alias ll="ls -lah"
alias v="nvim"
alias ..="cd .."
alias ...="cd ../.."

# keymaps
bindkey -s "^f" "~/.local/bin/tmux-sessionizer\n"

# nvm (lazy)
export NVM_DIR="$HOME/.nvm"
function nvm {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm "$@"
}
function node { nvm; node "$@"; }
function npm { nvm; npm "$@"; }
function npx { nvm; npx "$@"; }
