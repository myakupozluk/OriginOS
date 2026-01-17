cd rootfs
find . | cpio -o -H newc | gzip > ../initramfs.cpio.gz
cd ..
