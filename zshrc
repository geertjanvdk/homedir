autoload -U +X compinit && compinit

#
# Homebrew
#
if test -x /opt/homebrew/bin/brew >/dev/null 2>&1; then
  # macOS
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
elif test -d /home/linuxbrew/.linuxbrew >/dev/null 2>&1; then
  # Linux
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

#
# 1Password
#
if command -v -- "op" >/dev/null 2>&1; then
  eval "$(op completion zsh)"; compdef _op op
fi

#
# local
#
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

if command -v -- "starship" >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

