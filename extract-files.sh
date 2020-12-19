#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=X00T
VENDOR=asus

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true
KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in

    lib64/libwfdnative.so)
        patchelf --remove-needed "android.hidl.base@1.0.so" "${2}"
        ;;

    lib64/libfm-hci.so)
        patchelf --remove-needed "android.hidl.base@1.0.so" "${2}"
        ;;

    product/etc/permissions/vendor.qti.hardware.data.connection-V1.0-java.xml)
        sed -i 's/version="2.0"/version="1.0"/' "${2}"
        ;;

    product/etc/permissions/vendor.qti.hardware.data.connection-V1.1-java.xml)
        sed -i 's/version="2.0"/version="1.0"/' "${2}"
        ;;

    product/lib64/libdpmframework.so)
        patchelf --add-needed "libshim_dpmframework.so" "${2}"
        ;;

    vendor/lib/hw/camera.sdm660.so)
        patchelf --remove-needed "android.hidl.base@1.0.so" "${2}"
        ;;

    vendor/lib64/libril-qc-hal-qmi.so)
        patchelf --replace-needed "libprotobuf-cpp-full.so" "libprotobuf-cpp-full-v29.so" "${2}"
        ;;

    vendor/lib64/libsettings.so)
        patchelf --replace-needed "libprotobuf-cpp-full.so" "libprotobuf-cpp-full-v29.so" "${2}"
        ;;

    vendor/lib64/libvendor.goodix.hardware.fingerprint@1.0-service.so)
        patchelf --replace-needed "libprotobuf-cpp-lite.so" "libprotobuf-cpp-lite-v29.so" "${2}"
        ;;

    vendor/lib64/libwvhidl.so)
        patchelf --replace-needed "libprotobuf-cpp-lite.so" "libprotobuf-cpp-lite-v29.so" "${2}"
        ;;

    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" ${KANG} --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
