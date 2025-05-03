#!/usr/bin/env bash

BUILD_ROOT="$PWD"

QSSI_DIR="${BUILD_ROOT}/qssi"
VENDOR_DIR="${BUILD_ROOT}/vendor"
KERNEL_PLATFORM="${VENDOR_DIR}/kernel_platform"

function build_target {
    cd "$VENDOR_DIR"
    source build/envsetup.sh
    lunch pineapple-userdebug
    RECOMPILE_KERNEL=1 kernel_platform/build/android/prepare_vendor.sh pineapple gki
    ./build.sh dist --target_only -j "$(nproc --all)"
}

function build_qssi {
    cd "$QSSI_DIR"
    source build/envsetup.sh
    lunch qssi-userdebug
    ./build.sh dist --qssi_only -j "$(nproc --all)"
}

function build_super {
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
