export SKIP_ABI_CHECKS=true
export SELINUX_IGNORE_NEVERALLOWS=true
export TEMPORARY_DISABLE_PATH_RESTRICTIONS=true

# Clone HALs from AOSP-11 to fix wfd
rm -rf hardware/qcom-caf/msm8998/display
rm -rf hardware/qcom-caf/msm8998/media
rm -rf hardware/qcom-caf/msm8998/audio

git clone -b 11 https://github.com/zaidkhan0997/hardware_qcom-caf_display_msm8998.git hardware/qcom-caf/msm8998/display
git clone -b 11 https://github.com/zaidkhan0997/hardware_qcom-caf_media_msm8998.git hardware/qcom-caf/msm8998/media
git clone -b 11 https://github.com/zaidkhan0997/hardware_qcom-caf_audio_msm8998.git hardware/qcom-caf/msm8998/audio
