#!/bin/bash

if [ $# -ne 3 ]; then
	echo "Usage:"
	echo "grow-image.sh FILE PARTITION_NUMBER NEW_SIZE"
	echo "grow-image.sh FILE 1 64000000000"
	exit 1
fi

DESTINATION_FILE="$1"
ROOT_PARTITION_NUMBER="$2"
NEW_SIZE="$3"

echo "Increasing the size of the image file to $NEW_SIZE..."
dd status=none if=/dev/zero bs=1 count=0 seek="$NEW_SIZE" of="$DESTINATION_FILE" || exit

echo "Resizing the root file file system..."
parted -s "$DESTINATION_FILE" resizepart $ROOT_PARTITION_NUMBER $(( $NEW_SIZE - 1 ))b || exit
echo "Attaching loop device..."
losetup --partscan -f "$DESTINATION_FILE" || exit
DESTINATION=$(losetup -j "$DESTINATION_FILE" | cut -d ':' -f 1) || exit
echo "Checking filesystem..."
e2fsck -f "$DESTINATION"p"$ROOT_PARTITION_NUMBER" || exit
echo "Resizing filesystem..."
resize2fs "$DESTINATION"p"$ROOT_PARTITION_NUMBER" || exit
echo "Detaching loop device..."
losetup -d "$DESTINATION" || exit

echo "The image is now resized and all loop devices are detached."
