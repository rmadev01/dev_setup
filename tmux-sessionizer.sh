#!/usr/bin/env bash

# Direct path: skip picker (e.g., tmux-sessionizer ~/.config)
if [[ $# -eq 1 ]]; then
    selected=$1
else
    # Get active tmux sessions
    declare -A active_sessions
    while IFS= read -r s; do
        [[ -n $s ]] && active_sessions["$s"]=1
    done < <(tmux list-sessions -F "#{session_name}" 2>/dev/null)

    # Collect directories (exclude hidden dirs, ~/.config)
    dirs=$({ find ~/workspace -mindepth 1 -maxdepth 1 -type d 2>/dev/null
             find ~/ -mindepth 1 -maxdepth 1 -type d ! -name '.*' 2>/dev/null
           } | grep -v -E '(scratch|\.config)$' | sort -u)

    # Build fzf list: inactive dirs first, active sessions at bottom (highlighted)
    inactive=""
    active=""
    while IFS= read -r dir; do
        [[ -z $dir ]] && continue
        name=$(basename "$dir" | tr . _)
        if [[ ${active_sessions[$name]} ]]; then
            # Blue highlight for active sessions (Vague theme)
            active+=$'\e[38;2;140;173;198m'"$name"$'\e[0m'"	$dir"$'\n'
        else
            inactive+="$name	$dir"$'\n'
        fi
    done <<< "$dirs"
    list="${active}${inactive}"

    # fzf: show only first column (name), return second column (path)
    selected=$(printf "%s" "$list" | fzf --ansi --delimiter='	' --with-nth=1 \
        --color=bg+:-1,fg+:#8cadc6,pointer:#8cadc6 | cut -f2)
fi

[[ -z $selected ]] && exit 0

# Resolve to session name
selected_name=$(basename "$selected" | tr . _)

# Switch to existing session
if tmux has-session -t="$selected_name" 2>/dev/null; then
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$selected_name"
    else
        tmux switch-client -t "$selected_name"
    fi
    exit 0
fi

# Create new session
if [[ -z $TMUX ]] && [[ -z $(pgrep tmux) ]]; then
    tmux new-session -s "$selected_name" -c "$selected"
else
    tmux new-session -ds "$selected_name" -c "$selected"
    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$selected_name"
    else
        tmux switch-client -t "$selected_name"
    fi
fi
