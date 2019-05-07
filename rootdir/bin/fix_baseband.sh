#! /vendor/bin/sh

VER_INFO=/vendor/firmware_mnt/verinfo/ver_info.txt

if [ -f $VER_INFO ]; then
    BB_VER=$(grep '"modem":' $VER_INFO | cut -d '"' -f4)
    setprop gsm.version.baseband $BB_VER
fi

