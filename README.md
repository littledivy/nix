# nix

This repo contains confugrations for:

- (nix-darwin) M1 Macbook Pro
- (nix-darwin) M1 Mac mini
- (nixos 25.11) MSI Modern MS-15HK
- (nixos 25.11) NixOS Live installer

## Building the Live installer

Build the ISO:

```
$ ./build-iso.sh
```

Flash to a USB drive:

```
$ sudo dd bs=4M conv=fsync oflag=direct status=progress \
    if=result/out/*.iso \
    of=/dev/sda
```

## Install

Build your own (see above) or grab a live ISO from releases. Use wpa_cli to
connect to WiFI.

Partition:

```
$ parted /dev/nvme0n1
(parted) mklabel gpt
(parted) mkpart root ext4 512MB -8GB
(parted) mkpart swap linux-swap -8GB 100%
(parted) mkpart ESP fat32 1MB 512MB
(parted) set 3 esp on
```

Format:

```
$ mkfs.ext4 -L nixos /dev/nvme0n1p1

$ mkswap -L swap /dev/nvme0n1p2

$ mkfs.fat -F 32 -n boot /dev/nvme0n1p3
```

Mount it:

```
$ mount /dev/disk/by-label/nixos /mnt

$ mkdir -p /mnt/boot
$ mount /dev/disk/by-label/boot /mnt/boot
```

Generate or bring your config:

```
$ nixos-generate-config --root /mnt
```

```
$ nixos-install

$ nixos-enter --root /mnt -c 'passwd divy'
```
