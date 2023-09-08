#!/usr/local/bin/bash

pushd $(HOME)
mkdir -p Development/Agora
cd Development/Agora

# install prerequisites
pkg install bash gmake cmake libffcall libxml2 libxslt openssl libiconv giflib aspell cups libaudiofile portaudio libart_lgpl windowmaker 

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

