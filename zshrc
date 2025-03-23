PROMPT='%F{red}[%F{white}%n@%m %F{blue}%1d%F{red}]%F{white} '
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ] && source "$BASE16_SHELL/profile_helper.sh"

if type base16_default_dark &>/dev/null; then
    base16_default_dark
fi

eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export EDITOR=vim

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

alias ls='ls --color=auto'

bindkey -e
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line

ulimit -n 10240
