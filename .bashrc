# Disable Beep
bind "set bell-style none"

# History
export HISTSIZE=10000
export HISTFILESIZE=10000
shopt -s histappend

# Prompt: Directory (Blue) -> Arrow (Bold White) -> Reset
# Blue = \033[1;34m
# White = \033[1;37m
PS1="\[\033[1;34m\]\w \[\033[1;37m\]➜ \[\033[0m\]"

# Environment
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"
export EDITOR='nvim'
export TERM='xterm-256color'

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias ..='cd ..'
alias v='nvim'

# NVM (Standard Initialization)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Sessionizer Keybinding (Ctrl+f)
if [ -t 1 ]; then
    bind '"\C-f":"~/.local/bin/tmux-sessionizer\n"'
fi
