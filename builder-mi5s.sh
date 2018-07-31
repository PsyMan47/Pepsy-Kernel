KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
CCACHEDIR=../CCACHE/capricorn
TOOLCHAINDIR=~/toolchain/aarch64-linux-android-4.9
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Pepsy-Kernel"
DEVICE="-capricorn-"
VER="-v0.6"
TYPE="-O-MR1"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$TYPE""$VER".zip

rm $ANYKERNEL_DIR/capricorn/Image.gz-dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb

export ARCH=arm64
export KBUILD_BUILD_USER="Psy_Man"
export KBUILD_BUILD_HOST="PsyBuntu"
export CROSS_COMPILE=$TOOLCHAINDIR/bin/aarch64-linux-android-
export LD_LIBRARY_PATH=$TOOLCHAINDIR/lib/
export USE_CCACHE=1
export CCACHE_DIR=$CCACHEDIR/.ccache

make clean && make mrproper
make capricorn_defconfig
make -j$( nproc --all )

cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/capricorn
cd $ANYKERNEL_DIR/capricorn
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
