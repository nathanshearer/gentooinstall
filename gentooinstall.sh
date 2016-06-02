#!/bin/bash

# \brief Displays the help and exits the program
function gentooinstall_help
{
	echo "$DISPLAYNAME $VERSION"
	echo "This script automates most of the steps in the Gentoo Handbook."
	echo "Usage:"
	echo "  gentooinstall [options]"
	echo "Options:"
	echo "  -a, --architecture amd64"
	echo "    Which architecture to install."
	echo "  -b, --block-device /tmp/none"
	echo "    Which block device to partition."
	echo "  --chroot false"
	echo "    Chroot into the destination directory for the current phase."
	echo "  -d, --destination"
	echo "    Where to install."
	echo "  -h, --help"
	echo "    Display this help message and exit."
	echo "  -p, --phase phase1,phase2,..."
	echo "    A comma-separated list of which phases to run."
	echo "  -t, --timezone \"UTC\""
	echo "    Which timezone to configure."
	echo "Examples:"
	echo "  gentooinstall.sh -a amd64 -d /mnt/gentoo -t \"Canada/Mountain\""
	exit
}

# \brief The main function of this script
function gentooinstall_main
{
	#iterate through each phase
	local CURRENT_PHASE=$(echo -n "$PHASES" | sed -r -e 's/([^,]+),?.*?/\1/')
	local REMAINING_PHASES=$(echo -n "$PHASES" | sed -r -e 's/[^,]+,?(.*?)/\1/')
	while [ "$CURRENT_PHASE" != "" ]; do
		case "$CURRENT_PHASE" in
			"partition")    gentooinstall_phase_partition;;
			"mount")        gentooinstall_phase_mount;;
			"download")     gentooinstall_phase_download;;
			"verifydigest") gentooinstall_phase_verifydigest;;
			"verifyhash")   gentooinstall_phase_verifyhash;;
			"extract")      gentooinstall_phase_extract;;
			"deletestage3") gentooinstall_phase_deletestage3;;
			"resolvconf")   gentooinstall_phase_resolvconf;;
			"makeconf")     gentooinstall_phase_makeconf;;
			"mountchroot")  gentooinstall_phase_mountchroot;;
			"portage")      gentooinstall_phase_portage;;
			"timezone")     gentooinstall_phase_timezone;;
			"locale")       gentooinstall_phase_locale;;
			"update")       gentooinstall_phase_update;;
			"vim")          gentooinstall_phase_vim;;
			"syslogng")     gentooinstall_phase_syslogng;;
			"packages")     gentooinstall_phase_packages;;
			"plasma")       gentooinstall_phase_plasma;;
			*)
				echo "error: unknown phase: \"$CURRENT_PHASE\""
				break
				;;
		esac
		CURRENT_PHASE=$(echo -n "$REMAINING_PHASES" | sed -r -e 's/([^,]+),?.*?/\1/')
		REMAINING_PHASES=$(echo -n "$REMAINING_PHASES" | sed -r -e 's/[^,]+,?(.*?)/\1/')
	done
}

function gentooinstall_phase_deletestage3
{
	rm "$DESTINATION"/stage3-*.tar.bz2*
}

# \brief Download the latest stage3 tarball
function gentooinstall_phase_download
{
	echo "Downloading the latest stage 3 tarball..."
	mkdir -p "$DESTINATION"
	case "$ARCHITECTURE" in
		"i486")
			LATEST=$(wget --quiet http://distfiles.gentoo.org/releases/x86/autobuilds/latest-stage3-i486.txt -O-| tail -n 1 | cut -d " " -f 1)
			BASENAME=$(basename "$LATEST")
			wget -q --show-progress "http://distfiles.gentoo.org/releases/x86/autobuilds/$LATEST" -O "$DESTINATION/$BASENAME"
			wget -q --show-progress "http://distfiles.gentoo.org/releases/x86/autobuilds/$LATEST.DIGESTS.asc" -O "$DESTINATION/$BASENAME.DIGESTS.asc"
			;;
		"i686")
			LATEST=$(wget --quiet http://distfiles.gentoo.org/releases/x86/autobuilds/latest-stage3-i686.txt -O-| tail -n 1 | cut -d " " -f 1)
			BASENAME=$(basename "$LATEST")
			wget -q --show-progress "http://distfiles.gentoo.org/releases/x86/autobuilds/$LATEST" -O "$DESTINATION/$BASENAME"
			wget -q --show-progress "http://distfiles.gentoo.org/releases/x86/autobuilds/$LATEST.DIGESTS.asc" -O "$DESTINATION/$BASENAME.DIGESTS.asc"
			;;
		"amd64")
			LATEST=$(wget --quiet http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64.txt -O-| tail -n 1 | cut -d " " -f 1)
			BASENAME=$(basename "$LATEST")
			wget -q --show-progress "http://distfiles.gentoo.org/releases/amd64/autobuilds/$LATEST" -O "$DESTINATION/$BASENAME"
			wget -q --show-progress "http://distfiles.gentoo.org/releases/amd64/autobuilds/$LATEST.DIGESTS.asc" -O "$DESTINATION/$BASENAME.DIGESTS.asc"
			;;
		"armv4tl")
			LATEST=$(wget --quiet http://distfiles.gentoo.org/releases/arm/autobuilds/latest-stage3-armv4tl.txt -O-| tail -n 1 | cut -d " " -f 1)
			BASENAME=$(basename "$LATEST")
			wget -q --show-progress "http://distfiles.gentoo.org/releases/arm/autobuilds/$LATEST" -O "$DESTINATION/$BASENAME"
			wget -q --show-progress "http://distfiles.gentoo.org/releases/arm/autobuilds/$LATEST.DIGESTS.asc" -O "$DESTINATION/$BASENAME.DIGESTS.asc"
			;;
		"armv5tel")
			LATEST=$(wget --quiet http://distfiles.gentoo.org/releases/arm/autobuilds/latest-stage3-armv5tel.txt -O-| tail -n 1 | cut -d " " -f 1)
			BASENAME=$(basename "$LATEST")
			wget -q --show-progress "http://distfiles.gentoo.org/releases/arm/autobuilds/$LATEST" -O "$DESTINATION/$BASENAME"
			wget -q --show-progress "http://distfiles.gentoo.org/releases/arm/autobuilds/$LATEST.DIGESTS.asc" -O "$DESTINATION/$BASENAME.DIGESTS.asc"
			;;
		"armv6j")
			LATEST=$(wget --quiet http://distfiles.gentoo.org/releases/arm/autobuilds/latest-stage3-armv6j.txt -O-| tail -n 1 | cut -d " " -f 1)
			BASENAME=$(basename "$LATEST")
			wget -q --show-progress "http://distfiles.gentoo.org/releases/arm/autobuilds/$LATEST" -O "$DESTINATION/$BASENAME"
			wget -q --show-progress "http://distfiles.gentoo.org/releases/arm/autobuilds/$LATEST.DIGESTS.asc" -O "$DESTINATION/$BASENAME.DIGESTS.asc"
			;;
		"armv6j_hardfp")
			LATEST=$(wget --quiet http://distfiles.gentoo.org/releases/arm/autobuilds/latest-stage3-armv6j_hardfp.txt -O-| tail -n 1 | cut -d " " -f 1)
			BASENAME=$(basename "$LATEST")
			wget -q --show-progress "http://distfiles.gentoo.org/releases/arm/autobuilds/$LATEST" -O "$DESTINATION/$BASENAME"
			wget -q --show-progress "http://distfiles.gentoo.org/releases/arm/autobuilds/$LATEST.DIGESTS.asc" -O "$DESTINATION/$BASENAME.DIGESTS.asc"
			;;
		"armv7a")
			LATEST=$(wget --quiet http://distfiles.gentoo.org/releases/arm/autobuilds/latest-stage3-armv7a.txt -O-| tail -n 1 | cut -d " " -f 1)
			BASENAME=$(basename "$LATEST")
			wget -q --show-progress "http://distfiles.gentoo.org/releases/arm/autobuilds/$LATEST" -O "$DESTINATION/$BASENAME"
			wget -q --show-progress "http://distfiles.gentoo.org/releases/arm/autobuilds/$LATEST.DIGESTS.asc" -O "$DESTINATION/$BASENAME.DIGESTS.asc"
			;;
		"armv7a_hardfp")
			LATEST=$(wget --quiet http://distfiles.gentoo.org/releases/arm/autobuilds/latest-stage3-armv7a_hardfp.txt -O-| tail -n 1 | cut -d " " -f 1)
			BASENAME=$(basename "$LATEST")
			wget -q --show-progress "http://distfiles.gentoo.org/releases/arm/autobuilds/$LATEST" -O "$DESTINATION/$BASENAME"
			wget -q --show-progress "http://distfiles.gentoo.org/releases/arm/autobuilds/$LATEST.DIGESTS.asc" -O "$DESTINATION/$BASENAME.DIGESTS.asc"
			;;
		*) exit 1;;
	esac
}

function gentooinstall_phase_extract
{
	local STAGE3=$(ls "$DESTINATION"/stage3-*.tar.bz2)
	echo -n "Extracting \"$STAGE3\" to \"$DESTINATION\"... "
	tar xjpf "$DESTINATION"/stage3-*.tar.bz2 -C "$DESTINATION" --xattrs
	echo "Done."
}

function gentooinstall_phase_locale
{
	if $CHROOT; then
		env-update
		source /etc/profile
		echo "en_US ISO-8859-1" >>/etc/locale.gen
		echo "en_US.UTF-8 UTF-8" >>/etc/locale.gen
		locale-gen
		eselect locale set en_US.utf8
	else
		cp -f "$THIS" "$DESTINATION/tmp"
		chroot "$DESTINATION" /tmp/gentooinstall.sh --chroot --phase locale
	fi
}

function gentooinstall_phase_makeconf
{
	echo "Patching /etc/portage/make.conf"
	echo "CiMgaGFyZHdhcmUKI0NQVV9GTEFHU19YODY9IiRVU0UgM2Rub3cgM2Rub3dleHQgYXZ4IG1teCBtbXhleHQgc3NlIHNzZTIgc3NzZTMiCiNVU0U9IiRVU0UgYWNwaSBhcG0gYmx1ZXRvb3RoIGNwdWRldGVjdGlvbiBoZGR0ZW1wIGllZWUxMzk0IGxtX3NlbnNvcnMgc21wIHVzYiB3aWZpIgojIHNlcnZlcgojVVNFPSIkVVNFIGFjbCBjcnlwdCBjdXBzIGljdSBpZG4gaW1hcCBpcHY2IGt2bSBsYXJnZWZpbGUgbGRhcCBsem1hIGx6byBtbWFwIG11bHRpbGliIG5ldHdvcmsgcG9zaXggc2FtYmEgc2hhcmVkbWVtIHNvY2tldHMgc3NsIHN5c2xvZyB0aHJlYWRzIHVkZXYgdW5pY29kZSB2bmMgeGF0dHIiCiMgZGVza3RvcAojVVNFPSIkVVNFIHB1bHNlYXVkaW8iCgojQUNDRVBUX0xJQ0VOU0U9IioiCiNJTlBVVF9ERVZJQ0VTPSJldmRldiBrZXlib2FyZCBtb3VzZSBzeW5hcHRpY3MiCiNMSU5HVUFTPSJlbiBlbl9VUyIK" \
		| base64 --decode >>"$DESTINATION"/etc/portage/make.conf
}

function gentooinstall_phase_mount
{
	mkdir -p "$DESTINATION"
	mount "$DEVICE"*2 "$DESTINATION"
	mkdir -p "$DESTINATION"/boot
	mount "$DEVICE"*1 "$DESTINATION"/boot
}

function gentooinstall_phase_mountchroot
{
	mount -t proc none "$DESTINATION/proc"
	mount --rbind /sys "$DESTINATION/sys"
	mount --make-rslave "$DESTINATION/sys"
	mount --rbind /dev "$DESTINATION/dev"
	mount --make-rslave "$DESTINATION/dev"
}

function gentooinstall_phase_packages
{
	if $CHROOT; then
		env-update
		source /etc/profile
		
		CONFIG_PROTECT_MASK="$CONFIG_PROTECT_MASK /etc/portage/package.use/zzzz-autounmask-write /etc/portage/package.accept_keywords"

		emerge --quiet --autounmask-write net-misc/ntp || emerge --resume
		if [ $? -eq 0 ]; then
			rc-update add ntpd default
		fi
		
		emerge --quiet --autounmask-write sys-power/acpid || emerge --resume
		if [ $? -eq 0 ]; then
			rc-update add acpid default
		fi
		
		emerge --quiet --autounmask-write sys-process/vixie-cron || emerge --resume
		if [ $? -eq 0 ]; then
			rc-update add vixie-cron default
		fi
		
		emerge --quiet --autounmask-write app-admin/sudo || emerge --resume
		if [ $? -eq 0 ]; then
			# update /etc/sudoers to allow members of the wheel group to run any command via sudo
			echo "LS0tIC9ldGMvc3Vkb2VycwkyMDE2LTA0LTI4IDE5OjU5OjU3LjYzMzE5NTE5NSAtMDYwMAorKysgL2V0Yy9zdWRvZXJzLnBhdGNoZWQJMjAxNi0wNC0yOSAxMzo1NDoyNy4yNzk5NjMzMjQgLTA2MDAKQEAgLTc5LDcgKzc5LDcgQEAKIHJvb3QgQUxMPShBTEwpIEFMTAogCiAjIyBVbmNvbW1lbnQgdG8gYWxsb3cgbWVtYmVycyBvZiBncm91cCB3aGVlbCB0byBleGVjdXRlIGFueSBjb21tYW5kCi0jICV3aGVlbCBBTEw9KEFMTCkgQUxMCisld2hlZWwgQUxMPShBTEwpIEFMTAogCiAjIyBTYW1lIHRoaW5nIHdpdGhvdXQgYSBwYXNzd29yZAogIyAld2hlZWwgQUxMPShBTEwpIE5PUEFTU1dEOiBBTEwK" \
				| base64 --decode | patch -p0
		fi
		
		emerge --quiet app-portage/gentoolkit
		
		emerge --quiet --autounmask-write \
			app-editors/nano \
			app-misc/screen \
			net-analyzer/arping \
			net-analyzer/bmon \
			net-analyzer/tcpdump \
			net-analyzer/traceroute \
			net-dns/bind-tools \
			net-dns/openresolv \
			net-firewall/iptables \
			net-fs/nfs-utils \
			net-misc/bridge-utils \
			net-misc/dhcpcd \
			net-misc/whois \
			sys-apps/hdparm \
			sys-apps/iproute2 \
			sys-apps/lm_sensors \
			sys-apps/pciutils \
			sys-apps/smartmontools \
			sys-apps/usb_modeswitch \
			sys-apps/usbutils \
			sys-block/parted \
			sys-fs/btrfs-progs \
			sys-fs/ddrescue \
			sys-fs/dosfstools \
			sys-fs/exfat-utils \
			sys-fs/fuse-exfat \
			sys-fs/lvm2 \
			sys-fs/mdadm \
			sys-kernel/linux-firmware \
			sys-process/atop \
			sys-process/iotop \
			sys-process/lsof \
			|| emerge --resume
	else
		cp -f "$THIS" "$DESTINATION/tmp"
		chroot "$DESTINATION" /tmp/gentooinstall.sh --chroot --phase packages
	fi
}

function gentooinstall_phase_partition
{
	if [ ! -b "$DEVICE" ]; then
		echo "error: \"$DEVICE\" is not a block device"
		return 1
	fi
	if mount | grep "$DEVICE"; then
		echo "error: \"$DEVICE\" is currently mounted"
		return 2
	fi
	
	local DEVICE_MODEL=$(hdparm -I "$DEVICE" 2>/dev/null | grep --text 'Model Number' | cut -d ':' -f 2 | sed -r -e 's/ *(.*?) */\1/')
	local DEVICE_SERIAL=$(hdparm -I "$DEVICE" 2>/dev/null | grep --text 'Serial Number' | cut -d ':' -f 2 | sed -r -e 's/ *(.*?) */\1/')
	local DEVICE_SIZE=$(blockdev --getsize64 "$DEVICE")
	
	echo "Formatting with a UEFI partition table and filesystems:"
	echo "  Device: $DEVICE"
	if [ "$DEVICE_MODEL" != "" ]; then
		echo "  Model Number: $DEVICE_MODEL"
	fi
	if [ "$DEVICE_SERIAL" != "" ]; then
		echo "  Serial Number: $DEVICE_SERIAL"
	fi
	echo "  Size: $DEVICE_SIZE Bytes"
	echo "Press CTRL+C to cancel"
	for SECONDS in `seq 10 -1 1`; do
		printf "\r${SECONDS} ... "
		sleep 1
	done
	printf "\r0 ... \n"
	
	parted --script "$DEVICE" mklabel gpt
	parted --script "$DEVICE" mkpart primary $((1*1024*1024))b $((129*1024*1024-1))b
	parted --script "$DEVICE" set 1 boot on
	parted --script "$DEVICE" mkpart primary $((129*1024*1024))b $(( ($DEVICE_SIZE/(1024*1024) - 1) * 1024*1024 - 1 ))b
	mkfs.vfat -F 32 "$DEVICE"*1
	mkfs.ext4 -b 4096 -F "$DEVICE"*2
}

function gentooinstall_phase_plasma
{
	if $CHROOT; then
		env-update
		source /etc/profile
		
		eselect profile set "default/linux/amd64/13.0/desktop/plasma"
		env-update
		source /etc/profile
		emerge -uDN --with-bdeps=y world
		
		emerge kde-plasma/plasma-meta
		
		emerge \
			kde-apps/keditfiletype \
			kde-apps/kwrite \
			kde-apps/dolphin \
			kde-apps/gwenview \
			kde-apps/kcalc \
			kde-apps/konsole
		
		# update /etc/conf.d/xdm so the display manager is sddm instead of xdm
		echo "LS0tIC9ldGMvY29uZi5kL3hkbQkyMDE2LTA1LTE3IDE0OjM2OjM5Ljc1NjQ0NDU4NCAtMDYwMAorKysgL2V0Yy9jb25mLmQveGRtLnBhdGNoZWQJMjAxNi0wNS0xNyAxNTowNTozNS45NTk2NTY1MzQgLTA2MDAKQEAgLTcsNCArNyw0IEBACiAKICMgV2hhdCBkaXNwbGF5IG1hbmFnZXIgZG8geW91IHVzZSA/ICBbIHhkbSB8IGdkbSB8IGtkbSB8IGdwZSB8IGVudHJhbmNlIF0KICMgTk9URTogSWYgdGhpcyBpcyBzZXQgaW4gL2V0Yy9yYy5jb25mLCB0aGF0IHNldHRpbmcgd2lsbCBvdmVycmlkZSB0aGlzIG9uZS4KLURJU1BMQVlNQU5BR0VSPSJ4ZG0iCitESVNQTEFZTUFOQUdFUj0ic2RkbSIK" \
			| base64 --decode | patch -p0
		
		rc-update add dbus default
		rc-update add xdm default
	else
		cp -f "$THIS" "$DESTINATION/tmp"
		chroot "$DESTINATION" /tmp/gentooinstall.sh --chroot --phase plasma
	fi
}

function gentooinstall_phase_portage
{
	if $CHROOT; then
		env-update
		source /etc/profile
		emerge-webrsync --quiet >/dev/null 2>/dev/null
		emerge --sync --quiet
		mkdir /etc/portage/package.use
		touch /etc/portage/package.use/zzzz-autounmask-write
	else
		cp -f "$THIS" "$DESTINATION/tmp"
		chroot "$DESTINATION" /tmp/gentooinstall.sh --chroot --phase portage
	fi
}

function gentooinstall_phase_resolvconf
{
	if [ ! -f "$DESTINATION/etc/resolv.conf" ]; then
		echo "Patching /etc/resolv.conf"
		echo "nameserver 8.8.8.8" >>"$DESTINATION/etc/resolv.conf"
		echo "nameserver 8.8.4.4" >>"$DESTINATION/etc/resolv.conf"
	fi
}

function gentooinstall_phase_syslogng
{
	if $CHROOT; then
		env-update
		source /etc/profile
		
		emerge --quiet app-admin/syslog-ng
		if [ $? -eq 0 ]; then
			rc-update add syslog-ng default
		fi

		emerge --quiet app-admin/ccze
		if [ $? -eq 0 ]; then
			# Update /etc/syslog-ng/syslog-ng.conf to use ccze for color output on TTY12
			echo "LS0tIC9ldGMvc3lzbG9nLW5nL3N5c2xvZy1uZy5jb25mCTIwMTYtMDQtMjkgMTE6NTg6MDkuNzkzNzA2MjE3IC0wNjAwCisrKyAvZXRjL3N5c2xvZy1uZy9zeXNsb2ctbmcuY29uZi5uZXcJMjAxNi0wNC0yOSAxMjowMDo0Ni4yMjY1Njg5OTAgLTA2MDAKQEAgLTI3LDcgKzI3LDcgQEAKIGRlc3RpbmF0aW9uIG1lc3NhZ2VzIHsgZmlsZSgiL3Zhci9sb2cvbWVzc2FnZXMiKTsgfTsKIAogIyBCeSBkZWZhdWx0IG1lc3NhZ2VzIGFyZSBsb2dnZWQgdG8gdHR5MTIuLi4KLWRlc3RpbmF0aW9uIGNvbnNvbGVfYWxsIHsgZmlsZSgiL2Rldi90dHkxMiIpOyB9OworZGVzdGluYXRpb24gY29uc29sZV9hbGwgeyBwcm9ncmFtKCJjY3plIC1yID4+IC9kZXYvdHR5MTIiKTsgfTsKICMgLi4uaWYgeW91IGludGVuZCB0byB1c2UgL2Rldi9jb25zb2xlIGZvciBwcm9ncmFtcyBsaWtlIHhjb25zb2xlCiAjIHlvdSBjYW4gY29tbWVudCBvdXQgdGhlIGRlc3RpbmF0aW9uIGxpbmUgYWJvdmUgdGhhdCByZWZlcmVuY2VzIC9kZXYvdHR5MTIKICMgYW5kIHVuY29tbWVudCB0aGUgbGluZSBiZWxvdy4K" \
				| base64 --decode | patch -p0
		fi
	else
		cp -f "$THIS" "$DESTINATION/tmp"
		chroot "$DESTINATION" /tmp/gentooinstall.sh --chroot --phase packages
	fi
}

function gentooinstall_phase_timezone
{
	if $CHROOT; then
		env-update
		source /etc/profile
		echo "$TIMEZONE" >/etc/timezone
		emerge --config sys-libs/timezone-data
	else
		cp -f "$THIS" "$DESTINATION/tmp"
		chroot "$DESTINATION" /tmp/gentooinstall.sh --chroot --phase timezone -t "$TIMEZONE"
	fi
}

function gentooinstall_phase_update
{
	if $CHROOT; then
		env-update
		source /etc/profile
		
		# list the news to help the user debug any unexpected failures
		eselect news list
		emerge -1u --backtrack=1024 sys-apps/portage
		emerge -uDN --with-bdeps=y --backtrack=1024 --quiet world
	else
		cp -f "$THIS" "$DESTINATION/tmp"
		chroot "$DESTINATION" /tmp/gentooinstall.sh --chroot --phase update
	fi
}

function gentooinstall_phase_verifydigest
{
	echo -n "Verifying the cryptographic signature of the stage3 hashes... "
	gpg --keyserver hkps.pool.sks-keyservers.net --recv-keys 0xBB572E0E2D182910 >/dev/null 2>/dev/null
	gpg --verify "$DESTINATION/stage3-"*".tar.bz2.DIGESTS.asc" >/dev/null 2>/dev/null
	if [ $? -ne 0 ]; then
		echo "Failed."
		echo "error: the cryptographic signature of \"$DESTINATION/stage3-"*".tar.bz2.DIGESTS.asc\" could not be verified!"
		exit 1
	fi
	echo "Success."
}

function gentooinstall_phase_verifyhash
{
	echo -n "Verifying the hash of the stage3 tarball... "
	grep $(sha512sum "$DESTINATION/stage3-"*".tar.bz2") "$DESTINATION/stage3-"*".tar.bz2.DIGESTS.asc" >/dev/null
	if [ $? -ne 0 ]; then
		echo "Failed."
		echo "error: the downloaded file \"$DESTINATION/stage3-"*".tar.bz2\" does not match the sha512sum hash in \"$DESTINATION/stage3-"*".tar.bz2.DIGESTS.asc\""
		exit 1
	fi
	echo "Success."
}

function gentooinstall_phase_vim
{
	if $CHROOT; then
		env-update
		source /etc/profile
		
		emerge --quiet app-editors/vim
		if [ $? -eq 0 ]; then
			eselect editor set vi
		fi
	else
		cp -f "$THIS" "$DESTINATION/tmp"
		chroot "$DESTINATION" /tmp/gentooinstall.sh --chroot --phase packages
	fi
}

#------------------------------------------------------------------------------
# hard coded variables

CODENAME=gentooinstall
DISPLAYNAME="Gentoo Install"
VERSION="1.0.0.0"
DEBUG=false
TMP="/tmp"

#------------------------------------------------------------------------------
# default configuration

EMAIL=""
NICE=0
VERBOSITY=0
ARCHITECTURE=amd64
CHROOT=false
DEVICE=/tmp/none
DESTINATION=/mnt/gentoo
PHASES="download,verifydigest,verifyhash,extract,deletestage3,resolvconf,makeconf,mountchroot,portage,timezone,locale,update,vim,syslogng,packages"
TIMEZONE="UTC"

#------------------------------------------------------------------------------
# command line arguments
#

if [ $# -eq 0 ]; then
	gentooinstall_help
	exit 1
fi

THIS="$0"
while [ $# -ne 0 ]; do
	case "$1" in
		"-a"|"--architecture")
			ARCHITECTURE="$2"
			shift 2
			;;
		"-b"|"--block-device")
			DEVICE="$2"
			shift 2
			;;
		"--chroot")
			CHROOT=true
			shift
			;;
		"-d"|"--destination")
			DESTINATION="$2"
			shift 2
			;;
		"-h"|"--help")
			gentooinstall_help
			exit
			;;
		"-p"|"--phase")
			PHASES="$2"
			shift 2
			;;
		"-t"|"--timezone")
			TIMEZONE="$2"
			shift 2
			;;
		*) break;;
	esac
done

#------------------------------------------------------------------------------
# begin execution
#

gentooinstall_main
