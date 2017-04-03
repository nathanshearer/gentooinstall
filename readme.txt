Description:
  Install Gentoo Linux by automating most of the steps in the Gentoo Handbook.

Usage:
  gentooinstall [options]

Options:
  -a, --architecture x86_64
    Which architecture to install. Default is the current architecture. Supported
    architectures are: i486, i686, x86_64, armv4, armv5, armv6, armv6hf, armv7,
    armv7hf.
  -b, --block-device /tmp/none
    Which block device to partition.
  --block-device-block-size 1048576
    What block size to align the partitions to.
  --block-device-partition-type gpt
    What type of a partition table to create: gpt or msdos.
  --chroot false
    Chroot into the destination directory for the current phase.
  -d, --destination /mnt/gentoo
    Where to install.
  -h, --help
    Display this help message and exit.
  -p, --phase phase1,phase2,...
    A comma-separated list of which phases to run:
      partition
      mount
      stage3              default    Download the stage 3 tarball
      stage3digest        default    Verify the cryptographic signature
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
      fstab                          Add boot, root, and swap entries
      update              default    Update the world
      password            default    Set the root password
  --portage latest
    Which portage snapshot to install, latest or a URL to a specific file to download.
  --stage3 latest
    Which stage3 tarball to install, latest or a URL to a specific file to download.
  -t, --timezone "UTC"
    Which timezone to configure.

Examples:
  gentooinstall -a x86_64 -d /mnt/gentoo -t "Canada/Mountain"
  gentooinstall -a x86_64 -d /mnt/gentoo --portage "https://www.example.com/portage-20160320.tar.bz2"

Version:
  Gentoo Install 0.0.0.0
  Copyright (C) 2016 Nathan Shearer
  Licensed under GNU General Public License 2.0
