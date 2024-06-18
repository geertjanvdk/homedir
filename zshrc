autoload -U +X compinit && compinit

#
# Powerlevel10k prompt (close to top)
#
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

#
# Powerlevel10k (at bottom)
#
if command -v -- "brew" >/dev/null 2>&1; then
  source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
fi
[[ ! -f ~/.homedir/p10k.zsh ]] || source ~/.homedir/p10k.zsh
