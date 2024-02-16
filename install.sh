#! /usr/bin/bash

sudo apt update -y && sudo apt upgrade -y
# basics
sudo apt install fzf fd-find ripgrep zsh tmux ranger zathura xclip atool rofi feh
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
# i3
# dependencies
sudo apt install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool automake libxcb-shape0-dev meson asciidoc -y
cd ~/tmp
git clone https://github.com/Airblader/xcb-util-xrm
cd xcb-util-xrm
git submodule update --init
./autogen.sh --prefix=/usr
make
sudo make install
# i3-gaps
cd ~/tmp
mkdir build
cd build
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
git checkout gaps && git pull
meson -Ddocs=true -Dmans=true ../build
meson compile -C ../build
sudo meson install -C ../build
# picom
sudo apt install libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev libev-dev -y
cd Tmp
git clone git@github.com:yshui/picom.git
cd picom
meson setup --buildtype=release build
ninja -C build
ninja -C build install
# rofi theme
rm -rf ~/.config/rofi
git clone git@github.com:w8ste/Tokyonight-rofi-theme.git ~/.config/rofi
sudo mv ~/.config/rofi/tokyonight.rasi /usr/share/rofi/themes
sudo mv ~/.config/rofi/tokyonight_big1.rasi /usr/share/rofi/themes
sudo mv ~/.config/rofi/tokyonight_big2.rasi /usr/share/rofi/themes
rm ~/.config/rofi/README.md
