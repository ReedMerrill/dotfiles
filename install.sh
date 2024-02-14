#! /usr/bin/bash

sudo apt update -y && sudo apt upgrade -y
# basics
sudo apt install fzf fd-find ripgrep zsh tmux ranger zathura xclip atool
# set zsh to default
chsh
# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -r Lazygit*
# Conda
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init zsh
source ~/.zshrc
# Python base env
conda install python=3.11
# autoenv
curl -#fLo- 'https://raw.githubusercontent.com/hyperupcall/autoenv/master/scripts/install.sh' | sh
source ~/.zshrc
# neovim plugin dependencies
# fnm -- Node.js environment manager
curl -fsSL https://fnm.vercel.app/install | bash
source ~/.zshrc
fnm use 18
# npm stuff
npm install neovim # an integration -- not actual neovim
npm install tree-sitter-cli
# neovim
# install
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update -y
sudo apt install neovim -y
# set as default
sudo update-alternatives --config editor
