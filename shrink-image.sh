#!/bin/bash

function gentooinstall_detect_root_device
{
	if [ "$DESTINATION_ROOT_DEVICE" = "" -a -b "$DESTINATION" ]; then
		for PARTITION in $(lsblk -f -n -o PATH "$DESTINATION" | tail -n +2); do
			local FSTYPE=$(lsblk -f -n -o FSTYPE "$PARTITION")
			if [ "$FSTYPE" = "swap" ]; then continue; fi
			if [ "$FSTYPE" = "vfat" ]; then continue; fi
			DESTINATION_ROOT_DEVICE="$PARTITION"
		done
		if [ ! -b "$DESTINATION_ROOT_DEVICE" ]; then
			echo "error: detect_root_device: Unable to detect the root device. \"$DESTINATION_ROOT_DEVICE\" is not a block device."
			return 1
		fi
		echo "Detected Root Device: \"$DESTINATION_ROOT_DEVICE\""
	fi
}

if [ $# -ne 3 ]; then
	echo "Usage:"
	echo "shrink-image.sh FILE PARTITION_NUMBER PARTITION_START"
	exit 1
fi

DESTINATION_FILE="$1"
ROOT_PARTITION_NUMBER="$2"
ROOT_PARTITION_START="$3"

# setup loop device and detect root partition
losetup --partscan -f "$DESTINATION_FILE"
DESTINATION=$(losetup -j "$DESTINATION_FILE" | cut -d ':' -f 1)
DESTINATION_ROOT_DEVICE=""
gentooinstall_detect_root_device

echo "Shrinking the root filesystem..."
e2fsck -f -y "$DESTINATION_ROOT_DEVICE"
resize2fs -M -p "$DESTINATION_ROOT_DEVICE"
ROOT_FILESYSTEM_BLOCK_COUNT=$(tune2fs -l "$DESTINATION_ROOT_DEVICE" | grep "Block count:" | cut -d ':' -f 2)
ROOT_FILESYSTEM_BLOCK_SIZE=$(tune2fs -l "$DESTINATION_ROOT_DEVICE" | grep "Block size:" | cut -d ':' -f 2)
ROOT_FILESYSTEM_SIZE=$(( $ROOT_FILESYSTEM_BLOCK_COUNT * $ROOT_FILESYSTEM_BLOCK_SIZE ))

echo "Shrinking the partition..."
losetup -d "$DESTINATION"
parted -s "$DESTINATION_FILE" rm $ROOT_PARTITION_NUMBER
parted -s "$DESTINATION_FILE" mkpart primary ext4 ${ROOT_PARTITION_START}b $(( $ROOT_PARTITION_START + $ROOT_FILESYSTEM_SIZE - 1 ))b
# shrink the image
truncate -s $(( $ROOT_PARTITION_START + $ROOT_FILESYSTEM_SIZE )) "$DESTINATION_FILE"
