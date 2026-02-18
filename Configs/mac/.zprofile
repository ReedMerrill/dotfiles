# Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

source <(fzf --zsh)

# pnpm
export PNPM_HOME="/Users/reed/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/reed/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/reed/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/reed/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/reed/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Automatically activate venv if in project directory
function cd() {
  builtin cd "$@" || return 1

  if [ -d "venv" ]; then
    if [ -z "$VIRTUAL_ENV" ]; then
      # Activate virtual environment if not already active
      source venv/bin/activate
    fi
  else
    # Deactivate venv if it was activated and we're leaving the project directory
    if [ -n "$VIRTUAL_ENV" ]; then
      deactivate
    fi
  fi
}

# Created by `pipx` on 2025-05-08 02:56:54
export PATH="$PATH:/Users/reed/.local/bin"

export ucpw=$(security find-generic-password -a "$USER" -s ucalgarypw -w)
export GPG_TTY=$(tty)
