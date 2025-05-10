#!/usr/bin/env bash

BUILD_ROOT="$PWD"

QSSI_DIR="${BUILD_ROOT}/LA.QSSI.14.0/LINUX/android"
VENDOR_DIR="${BUILD_ROOT}/LA.VENDOR.14.3.0/LINUX/android"
KERNEL_PLATFORM="${VENDOR_DIR}/kernel_platform"

function build_target {   #2
    cd "$VENDOR_DIR"
    source build/envsetup.sh
    lunch pineapple-userdebug
    RECOMPILE_KERNEL=1 kernel_platform/build/android/prepare_vendor.sh pineapple gki
    ./build.sh dist --target_only -j "$(nproc --all)"
}

function build_qssi {  #1
    cd "$QSSI_DIR"
    source build/envsetup.sh
    lunch qssi-userdebug
    ./build.sh dist --qssi_only -j "$(nproc --all)"
}

function build_super {  #3
    cd "$VENDOR_DIR"

    python vendor/qcom/opensource/core-utils/build/build_image_standalone.py \
        --image super \
        --qssi_build_path "$QSSI_DIR" \
        --target_build_path "$VENDOR_DIR" \
        --merged_build_path "$VENDOR_DIR" \
        --target_lunch pineapple \
        --no_tmp \
        --output_ota \
        --skip_qiifa
}

build_qssi
build_target
build_super
