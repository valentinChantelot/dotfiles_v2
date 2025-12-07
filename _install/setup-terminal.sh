#!/bin/bash

set -e

# get OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/arch-release ]; then
        OS="arch"
    elif [ -f /etc/debian_version ]; then
        OS="debian"
    else
        echo "Error: Unsupported Linux distribution"
        exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    echo "Error: Unsupported OS"
    exit 1
fi

# install wget
if ! command -v wget &> /dev/null; then
    case $OS in
        arch) sudo pacman -S --needed --noconfirm wget ;;
        debian) sudo apt update -qq && sudo apt install -y -qq wget ;;
        macos)
            if ! command -v brew &> /dev/null; then
                echo "Error: Homebrew required on macOS"
                exit 1
            fi
            brew install wget -q
            ;;
    esac
fi

# install ZSH
if ! command -v zsh &> /dev/null; then
    case $OS in
        arch) sudo pacman -S --needed --noconfirm zsh ;;
        debian) sudo apt install -y -qq zsh ;;
        macos) brew install zsh -q ;;
    esac
fi

# set ZSH as default shell
if [[ "$SHELL" != *"zsh"* ]]; then
    chsh -s $(which zsh)
fi

# install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1
fi

# install plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone -q https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone -q https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# install poke-fetch if requested if --with-poke-fetch flag
WITH_POKE_FETCH=false
while [[ $# -gt 0 ]]; do
    case $1 in
        --with-poke-fetch)
            WITH_POKE_FETCH=true
            shift
            ;;
        *)
            echo "Error: Unknown argument $1"
            exit 1
            ;;
    esac
done

if [ "$WITH_POKE_FETCH" = true ]; then
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"
    git clone -q https://github.com/valentinChantelot/poke-fetch.git
    cd poke-fetch
    bash install.sh > /dev/null 2>&1
    cd ~
    rm -rf "$TMP_DIR"
fi

echo "Installation complete. Restart your terminal to use ZSH."