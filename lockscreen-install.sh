# ImageMagick
cd ~/Tmp
git clone https://github.com/ImageMagick/ImageMagick.git ImageMagick-7.1.1
cd ImageMagick-7.1.1
./configure --prefix ~/
make
sudo make install
make check
# symlink to /usr/local/bin? Might need to make it system-wide

# i3lock-color
# dependencies
sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev -y
cd ~/Tmp
git clone https://github.com/Raymo111/i3lock-color.git
cd i3lock-color
./build.sh
./install-i3lock-color.sh
