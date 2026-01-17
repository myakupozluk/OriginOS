qemu-system-x86_64   -kernel linux/arch/x86/boot/bzImage   -initrd initramfs.cpio.gz   -m 512M   -nographic   -append "console=ttyS0 rdinit=/init"   -drive file=origin_disk.img,format=raw,if=ide
