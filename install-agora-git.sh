#!/usr/local/bin/bash

pushd $HOME
mkdir -p ~/Development/Agora
pushd ~/Development/Agora

# install prerequisites
pkg install bash gmake cmake libffcall libxml2 libxslt openssl libiconv giflib aspell cups libaudiofile portaudio libart_lgpl windowmaker cairo libsvg-cairo harfbuzz-cairo

# install gnustep-make
git clone https://github.com/AgoraDesktop/tools-make.git
pushd tools-make
./configure --with-layout=agora
gmake
sudo gmake install && sudo gmake clean
popd
# Load the shell environment for gnustep-make
. /System/Library/Makefiles/GNUstep.sh

# install libobjc2
git clone https://github.com/AgoraDesktop/libobjc2.git
pushd libobjc2
git submodule update --init
mkdir Build
cd Build 
cmake -DGNUSTEP_INSTALL_TYPE=SYSTEM -DOLDABI_COMPAT=OFF ..
gmake
sudo gmake install
cd ..
rm -rf Build
popd

# install gnustep-base
git clone https://github.com/AgoraDesktop/libs-base.git
pushd libs-base
./configure
gmake -j8
sudo gmake install
gmake clean
popd

# install gnustep-gui
git clone https://github.com/AgoraDesktop/libs-gui.git
pushd libs-gui
./configure
gmake -j8
sudo gmake install
gmake clean
popd

# install gnustep-back
git clone https://github.com/AgoraDesktop/libs-back.git
pushd libs-back
./configure --enable-server=x11 --enable-graphics=cairo
gmake -j8
sudo gmake install
gmake clean
popd

# install GWorkspace
git clone https://github.com/AgoraDesktop/apps-gworkspace.git
pushd apps-gworkspace
./configure
gmake -j8
sudo gmake install
gmake clean
popd

popd


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

echo "The Agora Desktop is now installed. You will find the source code under $HOME/Development/Agora."

