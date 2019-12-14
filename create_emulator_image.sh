#!/bin/sh

if [ -z $ANDROID_BUILD_TOP ]; then
    echo $ANDROID_BUILD_TOP undefined
    exit 1
fi

if [ -z $ANDROID_PRODUCT_OUT ]; then
    echo $ANDROID_PRODUCT_OUT undefined
    exit 1
fi

if [ ! -f $ANDROID_PRODUCT_OUT/system.img ]; then
    echo "Please build before running this"
    exit 1
fi

# creates image zip in $ANDROID_PRODUCT_OUT
cd $ANDROID_PRODUCT_OUT/..
DIGEST=`grep "# " generic_x86/VerifiedBootParams.textproto| sed -e 's/# //'`

cd $ANDROID_BUILD_TOP
cp -r device/generic/emulator/skins $ANDROID_PRODUCT_OUT
cat device/generic/emulator/start_emulator_image.sh | sed -e "s/vbmeta/$DIGEST/" > $ANDROID_PRODUCT_OUT/start_emulator_image.sh
chmod 755 $ANDROID_PRODUCT_OUT/start_emulator_image.sh
cp -r device/generic/emulator/advancedFeatures.ini $ANDROID_PRODUCT_OUT

cd $ANDROID_PRODUCT_OUT/..
if [ -e $ANDROID_PRODUCT_OUT/du_emulator.zip ]; then
    rm $ANDROID_PRODUCT_OUT/du_emulator.zip
fi
zip -r $ANDROID_PRODUCT_OUT/du_emulator.zip generic_x86/skins generic_x86/system-qemu.img generic_x86/system/build.prop generic_x86/cache.img generic_x86/userdata.img generic_x86/start_emulator_image.sh generic_x86/advancedFeatures.ini generic_x86/encryptionkey.img generic_x86/kernel-ranchu-64 generic_x86/ramdisk.img generic_x86/vendor-qemu.img
