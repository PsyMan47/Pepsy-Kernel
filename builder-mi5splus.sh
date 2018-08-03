KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
CCACHEDIR=../CCACHE/natrium
TOOLCHAINDIR=~/toolchain/aarch64-linux-android-4.9
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Pepsy-Kernel"
DEVICE="-natrium-"
VER="-v0.2"
TYPE="-O-MR1"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$TYPE""$VER".zip

rm $ANYKERNEL_DIR/natrium/Image.gz-dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb

export ARCH=arm64
export KBUILD_BUILD_USER="Psy_Man"
export KBUILD_BUILD_HOST="PsyBuntu"
export CROSS_COMPILE=$TOOLCHAINDIR/bin/aarch64-linux-android-
export LD_LIBRARY_PATH=$TOOLCHAINDIR/lib/
export USE_CCACHE=1
export CCACHE_DIR=$CCACHEDIR/.ccache

make clean && make mrproper
make natrium_defconfig
make -j$( nproc --all )

cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/natrium
cd $ANYKERNEL_DIR/natrium
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
