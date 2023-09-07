#!/usr/local/bin/bash

cd $(HOME)
mkdir -p Development/Agora
cd Development/Agora
git clone https://github.com/AgoraDesktop/tools-make.git
cd tools-make
./configure --enable-objc-arc --with-layout=agora
sudo gmake install && sudo gmake clean
cd ..
. /System/Library/Makefiles/GNUstep.sh
git clone https://github.com/AgoraDesktop/libs-base.git
cd libs-base
