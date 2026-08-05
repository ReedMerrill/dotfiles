# disable ctrl-l clearing the screen
bindkey -r "^L"

# make arguments to cd that aren't directories assumed to be a variable who's
# value is a directory. Useful for "aliasing" directories
setopt cdablevars
# turn on dir switching without cd
setopt autocd

# hyphen-insensitive completion.
HYPHEN_INSENSITIVE="true"

COMPLETION_WAITING_DOTS="true"

plugins=(git)

# set editor
export EDITOR="$(which nvim)"

# Add scripts dir to path
export PATH="/Users/reed/Scripts:$PATH"

################################################################################
# ALIASES & HASHES (MacOS only)

# source main aliases script
source ~/.aliases

# stop using BSD sed, start using GNU sed
alias sed="gsed"

# listing (eza is an awesome ls replacement)
alias l="eza -l --icons --git --all --modified"
# list with 2-level tree
alias lt="eza --tree --level=2 --all --long --icons --git --modified"

################################################################################
# Pomodoro

function work() {
  local minutes="${1:-20}"
  local duration="${minutes}m"

  timer "$duration" && terminal-notifier \
    -title "Work Timer is up! Take a Break 😊" \
    -message "Pomodoro" \
    -appIcon "$HOME/Pictures/pumpkin.png" \
    -sound Crystal \
    -group pomodoro \
    -ignoreDnD
}

function rest() {
  local minutes="${1:-1.5}"
  local duration="${minutes}m"

  local duration="${minutes}m"
  timer "$duration" && terminal-notifier \
    -title "Break is over! Get back to work 😬" \
    -message "Pomodoro" \
    -appIcon "$HOME/Pictures/pumpkin.png" \
    -sound Crystal \
    -group pomodoro \
    -ignoreDnD

}

################################################################################
# yazi shell wrapper - allows for changing the cwd when exiting yazi

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

################################################################################
# Plugin initializations

eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$PATH"
