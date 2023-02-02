Description:
  Install Gentoo Linux by automating most of the steps in the Gentoo Handbook.

Usage:
  gentooinstall [options]

Options:
  --assimilate
    Convert the destination into Gentoo Linux.
  -a, --architecture x86_64
    Which guest architecture to install. Default is the host architecture.
    Supported architectures are:
      i486, i686, x86_64,
      armv4, armv5, armv6, armv6hf, armv7, armv7hf, aarch64,
      riscv,
      ppc, ppc64,
      alpha
  --bootloader BOOTLOADER
    Which bootloader to install on the boot device:
      bios-lilo    default when bios is detected
      uefi-refind  default when uefi is detected
      uefi-stub
  -d, --destination /mnt/gentoo
    Install into this destination. If a directory is provided, then install into
    that directory. If an empty block device is provided, then it will be
    partitioned and mounted. Default destination is "/mnt/gentoo".
  --destination-root-partuuid 00000000-0000-0000-0000-000000000000
    Specify the destination root partuuid instead of automatically detecting it.
  -h, --help
    Display this help message and exit.
  --no-news
    Do not display unread news items.
  --no-warning
    Do not display or wait for the 10-second pre-install warning.
  -m, --mountpoint /mnt/gentoo
    Where to mount the destination block devices. Default is "/mnt/gentoo"
  --mirror http://distfiles.gentoo.org
    Download the stage3 files from a different mirror.
  --password password
    Set the root password. The root password is randomized by default.
  --partition-type gpt
    The type of a partition table to create: gpt or msdos.
  --partition-alignment 1048576
    The block size used for partition alignment.
  -p, --phase phase1,phase2,...
    A comma-separated list of which phases to run:
      partition           conditional  Partition an empty block device
      mount               conditional  Mount the destination block device
      stage3download      default      Download the stage 3 tarball
      stage3signature     default      Verify the cryptographic signature
      stage3hash          default      Verify the hash
      stage3extract       default      Extract the stage 3 tarball
      stage3delete        default      Delete the stage 3 tarball
      dynamictranslation  default      Enable dynamic translation if required
      resolvconf          default      Add default nameservers
      procsysdev          automatic    Mount proc, sys, and dev
      portage             default      Install Portage
      timezone            default      Set the timezone
      locale              default      Set the locale
      fstab                            Add boot, root, and swap entries
      kernel                           Compile and install the kernel
      initrd                           Create an initrd
      bootloader                       Configure and install a bootloader
      update              default      Update the world
      password            default      Set the root password
  --portage latest
    Install the latest portage snapshot or provide a URL to a different version.
  --stage3 latest
    Install the latest stage3 tarball or provide a URL to a different version.
  -t, --timezone "UTC"
    Which timezone to configure.

Examples:
  gentooinstall -d /dev/sdzz -t Canada/Mountain
  gentooinstall -p kernel,fstab,bootloader

Version:
  Gentoo Install 2.4.1.1
  Copyright (C) 2016 Nathan Shearer
  Licensed under GNU General Public License 2.0
