Description:
  Install Gentoo Linux by automating most of the steps in the Gentoo Handbook.

Usage:
  gentooinstall [options]

Options:
  -a, --architecture x86_64
    Which guest architecture to install. Default is the host architecture.
    Supported architectures are:
      i486, i686, x86_64,
      armv4, armv5, armv6, armv6hf, armv7, armv7hf, aarch64,
      ppc, ppc64,
      alpha
  -b, --block-device /tmp/none
    The block device to partition.
  --block-device-block-size 1048576
    The block size used for alignment.
  --block-device-partition-type gpt
    The type of a partition table to create: gpt or msdos.
  --bootloader bios-lilo
    Which bootloader to install on the boot device:
      bios-lilo
      uefi-refind
  --chroot false
    Used internally to chroot into the destination directory for some phases.
  -d, --destination /mnt/gentoo
    Where to install.
  -h, --help
    Display this help message and exit.
  --no-warning
    Do not display or wait for the 10-second pre-install warning.
  --mirror http://distfiles.gentoo.org
    Download the stage3 files from a different mirror.
  -p, --phase phase1,phase2,...
    A comma-separated list of which phases to run:
      partition
      mount
      stage3download      default    Download the stage 3 tarball
      stage3signature     default    Verify the cryptographic signature
      stage3hash          default    Verify the hash
      extract             default    Extract the stage 3 tarball
      dynamictranslation  default    Enable dynamic translation if required
      deletestage3        default    Delete the stage 3 tarball
      resolvconf          default    Add default nameservers
      mountchroot         default    Mount the chroot environment
      portage             default    Install Portage
      timezone            default    Set the timezone
      locale              default    Set the locale
      kernel                         Install and compile the kernel
      bootloader                     Configure and install lilo
      fstab                          Add boot, root, and swap entries
      update              default    Update the world
      password            default    Set the root password
  --portage latest
    Install the latest portage snapshot or provide a URL to a different version.
  --stage3 latest
    Install the latest stage3 tarball or provide a URL to a different version.
  -t, --timezone "UTC"
    Which timezone to configure.

Examples:
  gentooinstall -b /dev/sdzz -p partition,mount
  gentooinstall -t "Canada/Mountain"
  gentooinstall -p bootloader,fstab

Version:
  Gentoo Install 1.2.0.0
  Copyright (C) 2016 Nathan Shearer
  Licensed under GNU General Public License 2.0
