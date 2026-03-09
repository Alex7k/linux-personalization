#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

sudo apt update
sudo apt upgrade -y
mapfile -t apt_packages < <(grep -vE '^\s*(#|$)' "${REPO_ROOT}/packages.txt")
sudo apt install -y "${apt_packages[@]}"

git config --global user.name "Alex7k"
git config --global user.email "51133872+Alex7k@users.noreply.github.com"
git config --global init.defaultBranch main
git config --global core.editor "nvim"

curl -fsSL https://get.docker.com | sudo sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mkdir -p "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins"
if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/.git" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi
if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/.git" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi
if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use/.git" ]]; then
  git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use"
fi

cp "${REPO_ROOT}/.zshrc" ~/.zshrc -f
sudo chsh -s "$(which zsh)"

cat << 'EOM'
Manual shell theming steps (if you have a desktop environment):
- Install a Nerd Font (for example RobotoMono Nerd Font Mono).
- Put font files in ~/.local/share/fonts/.
- In terminal GUI preferences, use the Nerd Font monospace variant.
EOM
