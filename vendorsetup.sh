#
# OrangeFox build configuration for "even"
# (Realme C25 RMX3191/RMX3193 | Realme C25s RMX3195/RMX3197 | Realme Narzo 50A RMX3430)
# MediaTek MT6768 (Helio G70/G80/G85), 720x1600 panel, dynamic partitions, non-A/B
#
# This file is sourced automatically by the OrangeFox build system when you
# lunch twrp_even-eng. Values below tune OrangeFox for this device.
#

FDEVICE="even"

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep -w $FDEVICE)
   if [ -n "$chkdev" ]; then
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep -w $FDEVICE)
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device || true
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
	export FOX_BUILD_DEVICE="$FDEVICE"
	export ALLOW_MISSING_DEPENDENCIES=true
	export LC_ALL="C"
	export TARGET_DEVICE_ALT="RMX3191, RMX3193, RMX3195, RMX3197, RMX3430, C25, C25s, Narzo 50A"

	# -------- Identity (shown in OrangeFox "About") --------
	export FOX_BUILD_TYPE="Unofficial"
	export FOX_VARIANT="even-RUI4-A13"
	export OF_MAINTAINER="Rocker14427c"
	export TW_DEFAULT_LANGUAGE="en"

	# -------- Display: 720x1600 teardrop notch panel --------
	export OF_SCREEN_H=1600
	export OF_STATUS_H=80
	export OF_STATUS_INDENT_LEFT=48
	export OF_STATUS_INDENT_RIGHT=48
	export OF_HIDE_NOTCH=1
	export OF_CLOCK_POS=1
	export OF_ALLOW_DISABLE_NAVBAR=1

	# -------- magiskboot is mandatory here: used to patch the vbmeta AVB flags --------
	export OF_USE_MAGISKBOOT=1
	export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
	export FOX_PATCH_VBMETA_FLAG=1

	# -------- Behaviour / sanity --------
	export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
	export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
	export OF_NO_RELOAD_AFTER_DECRYPTION=1
	export OF_USE_GREEN_LED=0
	export OF_FLASHLIGHT_ENABLE=0
	export OF_ENABLE_LPTOOLS=1
	# MTK devices: health-HAL battery reading is broken (shows >100%); use legacy battery services
	export OF_USE_LEGACY_BATTERY_SERVICES=1

	# -------- OTA handling (Realme UI incremental/full OTAs) --------
	export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1
	export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES=1

	# -------- Bundled Unix tools --------
	export FOX_USE_BASH_SHELL=1
	export FOX_ASH_IS_BASH=1
	export FOX_USE_TAR_BINARY=1
	export FOX_USE_SED_BINARY=1
	export FOX_USE_XZ_UTILS=1
	export FOX_USE_NANO_EDITOR=1
	export FOX_USE_ZIP_BINARY=1
	export FOX_REPLACE_BUSYBOX_PS=1
	export FOX_REPLACE_TOOLBOX_GETPROP=1
	export FOX_USE_UNZIP_BINARY=1

	# -------- One-tap backup list --------
	export OF_QUICK_BACKUP_LIST="/boot;/dtbo;/data;"

	# -------- Mountpoints for advanced file ops (dynamic partitions) --------
	export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
	export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"

	# Build date/timezone sanity (some OrangeFox UIs are timezone sensitive)
	export FOX_MAINTAINER_PATCH_VERSION="4"

	# ------- Optional extras (uncomment to enable) -------
	# export OF_ADVANCED_SECURITY=1              # extra password options
	# export OF_OPTIONS_LIST_NUM=9              # how many toggles per settings page (default 6)
	# export FOX_DELETE_AROMAFM=1               # drop AromaFM to save space
	# export OF_USE_LOCKSCREEN_BUTTON=1         # lock button on the gesture bar
fi

# never let this script exit non-zero when sourced by build/envsetup.sh (which runs under set -e)
true
