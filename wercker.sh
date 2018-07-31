#!/bin/bash

dpkg --add-architecture i386 && apt-get update && apt-get install -y git ccache automake bc lzop bison gperf build-essential zip curl zlib1g-dev zlib1g-dev:i386 g++-multilib python-networkx libxml2-utils bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make optipng &&
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 /pipeline/build/root/toolchain/aarch64-linux-android-4.9

KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
TOOLCHAINDIR=/pipeline/build/root/toolchain/aarch64-linux-android-4.9
CCACHEDIR=../CCACHE/xiaomi-8996
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Pepsy-Kernel"
DEVICE="-Xiaomi-8996-"
VER="-v0.6"
TYPE="-O-MR1"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$TYPE""$VER".zip

rm $ANYKERNEL_DIR/xiaomi-8996/Image.gz-dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb

export ARCH=arm64
export KBUILD_BUILD_USER="Psy_Man"
export KBUILD_BUILD_HOST="PsyBuntu"
export CROSS_COMPILE=/pipeline/build/root/toolchain/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export LD_LIBRARY_PATH=/pipeline/build/root/toolchain/aarch64-linux-android-4.9/lib/
export USE_CCACHE=1
export CCACHE_DIR=$CCACHEDIR/.ccache
make clean && make mrproper
make msm8996_defconfig
curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="$KERNEL_NAME$VER build started!" -d chat_id=@pepsykernel;
make -j$( nproc --all )

{

  #try block

cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/xiaomi-8996

} || {

  #catch block

  if [ $? != 0 ]; then

    curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="Build failed :c" -d chat_id=@pepsykernel;
    exit

  fi

}
cd $ANYKERNEL_DIR/xiaomi-8996
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
message="Build completed with the latest commit -"
curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="$message $(git log --pretty=format:'%h : %s' -1)" -d chat_id=@pepsykernel
curl -F chat_id="-1001152658251" -F document=@"$FINAL_ZIP" https://api.telegram.org/bot$BOT_API_KEY/sendDocument
mv $FINAL_ZIP /pipeline/output/$FINAL_ZIP
