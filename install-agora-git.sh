#!/bin/sh

# Terminate script on error
set -e

CWD=$(pwd)
DEV_HOME=${DEV_HOME:-$HOME/Development}
AGORA_HOME=$DEV_HOME/Agora

# Verify that sudo is installed
[ -x "$(which sudo)" ] || (echo "This script requires sudo to be installed." && exit 1)

cd $HOME

mkdir -p $AGORA_HOME
mkdir -p $HOME/Documents
mkdir -p $HOME/Library/Wallpaper
mkdir -p $HOME/Library/Icons
sudo mkdir -p /Library/Wallpaper
sudo mkdir -p /Library/Icons

cd $AGORA_HOME

# install prerequisites
sudo pkg install bash gmake cmake libffcall libxml2 libxslt openssl \
    libiconv giflib aspell cups libaudiofile portaudio libart_lgpl \
    windowmaker cairo libsvg-cairo harfbuzz-cairo libdispatch

# install gnustep-make
[ -d "tools-make" ] || git clone https://github.com/AgoraDesktop/tools-make.git
cd tools-make
git pull --rebase --autostash
./configure \
	--with-layout=agora \
	--with-library-combo=ng-gnu-gnu \
	--enable-objc-arc
gmake
sudo gmake install && sudo gmake clean
cd $AGORA_HOME
# Load the shell environment for gnustep-make
. /System/Library/Makefiles/GNUstep.sh

# install libobjc2
[ -d "libobjc2" ] || git clone https://github.com/AgoraDesktop/libobjc2.git
cd libobjc2
git pull --rebase --autostash
git submodule update --init
mkdir Build
cd Build 
cmake -DGNUSTEP_INSTALL_TYPE=SYSTEM -DOLDABI_COMPAT=OFF ..
gmake
sudo gmake install
cd ..
rm -rf Build
cd $AGORA_HOME

sudo -E ldconfig

# install gnustep-base
[ -d "libs-base" ] || git clone https://github.com/AgoraDesktop/libs-base.git
cd libs-base
git pull --rebase --autostash
./configure
gmake -j8
sudo gmake install
gmake clean
cd $AGORA_HOME

# install gnustep-gui
[ -d "libs-gui" ] || git clone https://github.com/AgoraDesktop/libs-gui.git
cd libs-gui
git pull --rebase --autostash
./configure
gmake -j8
sudo gmake install
gmake clean
cd $AGORA_HOME

# install gnustep-back
[ -d "libs-back" ] || git clone https://github.com/AgoraDesktop/libs-back.git
cd libs-back
git pull --rebase --autostash
./configure --enable-server=x11 --enable-graphics=cairo
gmake -j8
sudo gmake install
gmake clean
cd $AGORA_HOME

# install GWorkspace
[ -d "apps-gworkspace" ] || git clone https://github.com/AgoraDesktop/apps-gworkspace.git
cd apps-gworkspace
git pull --rebase --autostash
./configure
gmake -j8
sudo gmake install
gmake clean
cd $AGORA_HOME

# install libs-corebase
[ -d "libs-corebase" ] || git clone https://github.com/AgoraDesktop/libs-corebase.git
cd libs-corebase
git pull --rebase --autostash
CFLAGS=-I/Library/Headers LDFLAGS=-L/Library/Libraries ./configure
gmake -j8
sudo gmake install
gmake clean
cd $AGORA_HOME

#install Terminal.app
[ -d "apps-terminal" ] || git clone https://github.com/AgoraDesktop/apps-terminal.git
cd apps-terminal
git pull --rebase --autostash
gmake -j8
sudo gmake install
gmake clean

cd $PWD

# Set up user defaults
defaults write NSGlobalDomain GSFirstControlKey Control_L 
defaults write NSGlobalDomain GSSecondControlKey Control_R
defaults write NSGlobalDomain GSFirstCommandKey Super_L
defaults write NSGlobalDomain GSSecondCommandKey Super_R
defaults write NSGlobalDomain GSFirstAlternateKey Alt_L
defaults write NSGlobalDomain GSSecondAlternateKey Alt_R

defaults write NSGlobalDomain UseWindowMakerIcons YES

defaults write NSGlobalDomain GSControlKeyString "^"
defaults write NSGlobalDomain GSAlternateKeyString "⌥"
defaults write NSGlobalDomain GSShiftKeyString "⇧"
defaults write NSGlobalDomain GSCommandKeyString "⌘"

defaults write NSGlobalDomain NSInterfaceStyleDefault NSMacintoshInterfaceStyle
defaults write NSGlobalDomain NSMenuInterfaceStyle NSMacintoshInterfaceStyle

defaults write NSGlobalDomain GSFileBrowserHideDotFiles YES
defaults write GWorkspace GSSuppressAppIcon YES

cat > /tmp/agora.root.hidden <<EOF
bin
boot
dev
etc
lib
libexec
media
mnt
net
nvraid
proc
rescue
root
sbin
tmp
usr
var
zroot
COPYRIGHT
entropy
sys
EOF

sudo mv /tmp/agora.root.hidden /.hidden

cat > $HOME/.xinitrc <<EOF
wmaker &
exec GWorkspace
EOF

cat > $HOME/.hidden <<EOF
nohup.out
GNUstep
EOF

echo "The Agora Desktop is now installed. You will find the source code under $HOME/Development/Agora."
