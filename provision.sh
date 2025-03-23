#!/bin/bash

is_command_installed() {
    if ! command -v "$1" &>/dev/null; then
        return 1
    else
        return 0
    fi
}

brew_install() {
    if ! /opt/homebrew/bin/brew install "$@"; then
        echo "Error installing $1" >&2
        return 1
    fi
}

brew_conditional_install() {
    if ! is_command_installed "$1"; then
        if [ -z "$2" ]; then
            brew_install "$1"
        else
            echo "Installing $2 to provide missing command $1..."
            brew_install "$2"
        fi
    fi
}

is_app_installed() {
    if [ -d "/Applications/$1.app" ]; then
        return 0
    else
        return 1
    fi
}

brew_install_cask() {
    if ! /opt/homebrew/bin/brew install --cask "$@"; then
        echo "Error installing $1" >&2
        return 1
    fi
}

brew_conditional_install_cask() {
    if ! is_app_installed "$1"; then
        if [ -z "$2" ]; then
            brew_install_cask "$(echo "$1" | tr '[:upper:]' '[:lower:]')"
        else
            echo "Installing $2 to provide missing application $1..."
            brew_install_cask "$2"
        fi
    fi
}

git_config() {
    echo "Setting git global configuration option $1 to $2..."
    git config --global "$1" "$2"
}

git_conditional_clone() {
    if [ ! -d "$2" ]; then
        git clone "$1" "$2"
    fi
}

install_file() {
    local src="$1"
    local dest="$2"

    if [ -z "$src" ] || [ -z "$dest" ]; then
        echo "Usage: install_file source_file destination_path" >&2
        return 1
    fi

    if [ ! -f "$src" ]; then
        echo "Error: Source file '$src' does not exist" >&2
        return 1
    fi

    if ! install -D -b -m 0644 -g staff "$src" "$dest"; then
        echo "Error installing file" >&2
        return 1
    fi

    return 0
}

if ! is_command_installed "brew"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

set -e

for cmd in kitty go uv node; do
    brew_conditional_install $cmd
done
brew_conditional_install http httpie
brew_conditional_install rg ripgrep
for cask in Obsidian Firefox Rectangle Zed; do
    brew_conditional_install_cask $cask
done
brew_conditional_install_cask "Affinity Photo 2" affinity-photo
brew_install \
    vim \
    git \
    font-inconsolata \
    font-inconsolata-for-powerline \
    font-powerline-symbols \
    python-setuptools \
    zsh-completions

git_config init.defaultBranch main
git_config pull.rebase true
git_conditional_clone https://github.com/dharmab/ck-base16-shell.git ~/.config/base16-shell

install_file kitty.conf ~/.config/kitty/kitty.conf
install_file vimrc ~/.vimrc
install_file zed.json ~/.config/zed/config.json
install_file zshrc ~/.zshrc
vim +PlugInstall +qall!
