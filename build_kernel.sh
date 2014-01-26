#!/bin/bash
kdir=`readlink -f .`
cd $kdir
cd ..
home=`readlink -f .`
ramdisk=$home/ramdisk_ics/ug28 # UG28
toolchain=$home/toolchain/linaro_4.8/bin/arm-linux-gnueabihf-
version=minah
defconfig_name=minah_defconfig

export ARCH=arm
export USE_SEC_FIPS_MODE=true
export CROSS_COMPILE=$toolchain
cd $kdir
mkdir out
rm -rf out/*
rm -rf ./pack/stock/boot/zImage
mv .git git
make $defconfig_name
make mrproper
make $defconfig_name
rm -rf $ramdisk/lib/modules/*
make -j16 CONFIG_INITRAMFS_SOURCE="$ramdisk"
find . -name "*.ko" -exec mv {} $ramdisk/lib/modules/ \;
make clean
make -j16 CONFIG_INITRAMFS_SOURCE="$ramdisk"
cp ./arch/arm/boot/zImage ./pack/stock/boot/
cd $kdir/pack/stock
zip -r [$version].$(date -u +%m)-$(date -u +%d)-$(date -u +%s).zip ./
mv ./*.zip $kdir/out/
cd $kdir
make mrproper
mv git .git
