# OriginOS

OriginOS is a custom Linux-based operating system project focused on learning and experimenting with kernel boot, init systems, root filesystems, and basic package management.

This repository contains **source code and build scripts only**. Build artifacts such as disk images are intentionally not included.

---

## Requirements

You need a Linux host system.

### Required tools

* git
* make
* gcc / clang
* binutils
* qemu-system-x86_64
* grub-mkrescue (or grub tools)
* util-linux (for losetup, mount)
* sudo

On Arch Linux:

```bash
sudo pacman -S git base-devel qemu grub xorriso util-linux
```

On Debian / Ubuntu:

```bash
sudo apt install git build-essential qemu-system-x86 grub-pc-bin xorriso util-linux
```

---

## Repository Structure

```
OriginOS/
├── linux/              # Linux kernel source (submodule)
├── rootfs/             # Root filesystem template
│   ├── bin/
│   ├── sbin/
│   ├── etc/
│   │   ├── inittab
│   │   └── init.d/rcS
│   ├── lib/
│   └── usr/
├── scripts/            # Build and disk creation scripts
├── Makefile
└── README.md
```

---

## Building the Linux Kernel

Enter the kernel directory:

```bash
cd linux
```

Configure the kernel:

```bash
make defconfig
```

Build the kernel:

```bash
make -j$(nproc)
```

The kernel image will be generated at:

```
linux/arch/x86/boot/bzImage
```

---

## Creating the Root Filesystem

The `rootfs/` directory is copied directly into the disk image.

Make sure the following files exist and are executable:

```bash
chmod +x rootfs/etc/init.d/rcS
```

If you add binaries, ensure all required shared libraries are present inside `rootfs/lib` or `rootfs/lib64`.

---

## Creating the Disk Image

The disk image is **not stored in the repository**. Each user creates it locally.

### Step 1: Create an empty disk image

```bash
dd if=/dev/zero of=origin_disk.img bs=1M count=512
```

### Step 2: Create a filesystem

```bash
mkfs.ext4 origin_disk.img
```

### Step 3: Mount the image

```bash
sudo mkdir -p /mnt/originos
sudo mount origin_disk.img /mnt/originos
```

### Step 4: Copy root filesystem

```bash
sudo cp -r rootfs/* /mnt/originos/
```

### Step 5: Unmount

```bash
sudo umount /mnt/originos
```

---

## Booting with QEMU

From the repository root:

```bash
qemu-system-x86_64 \
  -kernel linux/arch/x86/boot/bzImage \
  -append "root=/dev/sda rw init=/sbin/init" \
  -drive file=origin_disk.img,format=raw \
  -netdev user,id=net0 \
  -device e1000,netdev=net0 \
  -nographic
```

---

## Networking

Inside the system, networking is configured manually in `rcS`:

```sh
ifconfig eth0 10.0.2.15 up
route add default gw 10.0.2.2
```

This matches QEMU user networking.

---

## Package Management (opm)

OriginOS includes a simple package manager (`opm`). Packages are installed into:

```
/mnt/storage
```

Make sure:

* `/mnt/storage/bin` is in `PATH`
* Required shared libraries exist in `/mnt/storage/lib` or `/lib64`

---

## Important Notes

* Do not commit `.img`, `.iso`, or other large binary files
* Disk images are local build artifacts
* Kernel sources are tracked separately (submodule)
* This project is for educational purposes

---

## License

MIT License
