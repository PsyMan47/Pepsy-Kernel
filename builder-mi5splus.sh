#!/bin/bash

KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
CCACHEDIR=../CCACHE/natrium
TOOLCHAINDIR=/pipeline/build/root/toolchain/aarch64-linux-android-4.9
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Pepsy"
DEVICE="-natrium-"
VER="-v1.4"
TYPE="-O-MR1-EAS"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$TYPE""$VER".zip

rm $ANYKERNEL_DIR/natrium/Image.gz-dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb

export ARCH=arm64
export KBUILD_BUILD_USER="Psy_Man"
export KBUILD_BUILD_HOST="PsyBuntu"
export CC=/pipeline/build/root/toolchain/SnapDragonLLVM_6.0/prebuilt/linux-x86_64/bin/clang
export CXX=/pipeline/build/root/toolchain/SnapDragonLLVM_6.0/prebuilt/linux-x86_64/bin/clang++
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=$TOOLCHAINDIR/bin/aarch64-linux-android-
export LD_LIBRARY_PATH=$TOOLCHAINDIR/lib/
export USE_CCACHE=1
export CCACHE_DIR=$CCACHEDIR/.ccache

make clean && make mrproper
make natrium_defconfig
make -j$( nproc --all )

{
cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/natrium
} || {
  if [ $? != 0 ]; then
    curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="Build failed for natrium :c" -d chat_id=@pepsykernel;
    exit
  fi
}

cd $ANYKERNEL_DIR/natrium
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
curl -F chat_id="-1001152658251" -F document=@"$FINAL_ZIP" https://api.telegram.org/bot$BOT_API_KEY/sendDocument
mv $FINAL_ZIP /pipeline/output/$FINAL_ZIP
