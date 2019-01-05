#!/bin/bash

NAME="Pepsy-Kernel"
VERSION="-v1.6 EAS"

dpkg --add-architecture i386 && apt-get update && apt-get install -y git ccache automake bc lzop bison gperf build-essential zip curl zlib1g-dev zlib1g-dev:i386 g++-multilib python-networkx libxml2-utils bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make optipng &&
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 /pipeline/build/root/toolchain/aarch64-linux-android-4.9 &&
git clone https://github.com/PsyMan47/SnapDragonLLVM_6.0 /pipeline/build/root/toolchain/SnapDragonLLVM_6.0

curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="$NAME$VERSION build started!" -d chat_id=@pepsykernel;
curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="Changelog:" -d chat_id=@pepsykernel;
curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="$(git log --pretty=format:'%h : %s' -10)" -d chat_id=@pepsykernel;

bash builder-mi5.sh
bash builder-mi5s.sh
bash builder-mi5splus.sh
bash builder-mimix.sh
bash builder-minote2.sh

