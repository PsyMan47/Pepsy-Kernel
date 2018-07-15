KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
CCACHEDIR=../CCACHE/lithium
TOOLCHAINDIR=~/toolchain/aarch64-linux-android-4.9
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Pepsy-Kernel"
DEVICE="-lithium-"
VER="-v0.7.1"
TYPE="-O-MR1-MIUI"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$TYPE""$VER".zip

rm $ANYKERNEL_DIR/lithium/Image.gz-dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb

export ARCH=arm64
export KBUILD_BUILD_USER="Psy_Man"
export KBUILD_BUILD_HOST="PsyBuntu"
export CROSS_COMPILE=$TOOLCHAINDIR/bin/aarch64-linux-android-
export LD_LIBRARY_PATH=$TOOLCHAINDIR/lib/
export USE_CCACHE=1
export CCACHE_DIR=$CCACHEDIR/.ccache

make clean && make mrproper
make lithium_defconfig
make -j$( nproc --all )

cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/lithium
find $KERNEL_DIR -name '*.ko' -exec cp '{}' "$ANYKERNEL_DIR/lithium" \;
cd $ANYKERNEL_DIR/lithium/
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
