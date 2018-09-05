KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
CCACHEDIR=../CCACHE/xiaomi-8996
TOOLCHAINDIR=~/toolchain/aarch64-linux-android-4.9
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Pepsy-Kernel"
DEVICE="-xiaomi-8996-"
VER="-v0.1"
TYPE="-O-MR1-MIUI"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$TYPE""$VER".zip

rm $ANYKERNEL_DIR/xiaomi-8996/Image.gz-dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb

export ARCH=arm64
export KBUILD_BUILD_USER="Psy_Man"
export KBUILD_BUILD_HOST="PsyBuntu"
export CROSS_COMPILE=$TOOLCHAINDIR/bin/aarch64-linux-android-
export LD_LIBRARY_PATH=$TOOLCHAINDIR/lib/
export USE_CCACHE=1
export CCACHE_DIR=$CCACHEDIR/.ccache

make clean && make mrproper
make gemini_user_defconfig
make -j$( nproc --all )

cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/xiaomi-8996
find $KERNEL_DIR -name '*.ko' -exec cp '{}' "$ANYKERNEL_DIR/xiaomi-8996" \;
for module in $(find $ANYKERNEL_DIR/xiaomi-8996 -name "*.ko"); do
    $KERNEL_DIR/scripts/sign-file sha512 $KERNEL_DIR/signing_key.priv $KERNEL_DIR/signing_key.x509 $module;
done;
cd $ANYKERNEL_DIR/xiaomi-8996
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP

