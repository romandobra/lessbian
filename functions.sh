function lreset(){
rm -rf iso; rm -rf edit; rm -rf mnt; mkdir -p iso; mkdir -p edit; mkdir -p mnt
mount buster-backports-10.8.0-amd64.hybrid.iso mnt
cp -r mnt/* iso; umount $PWD/mnt; rm -rf mnt; rm -rf iso/pool
unsquashfs -f -d edit iso/live/filesystem.squashfs; rm -rf iso/live/filesystem.squashfs;}

function lchroot(){
 if [ -d apt-cache ]; then mount -B apt-cache edit/var/cache/apt/archives; fi
 if [ -d log ]; then rm -rf log/*; mount -B log edit/var/log; fi
 cp /etc/resolv.conf edit/etc/resolv.conf
 mount -B /dev edit/dev; mount -B /sys edit/sys; mount -B /proc edit/proc; mount -B /run edit/run; sleep 1
 if [ -f my-apps.sh ]; then cp my-apps.sh edit/; fi
 cp inchroot.sh edit/; chroot edit bash inchroot.sh
 rm -rf edit/chroot-./script.sh; rm -rf edit/etc/resolv.conf; sleep 1
 umount $PWD/edit/dev; umount $PWD/edit/sys; umount $PWD/edit/proc; umount $PWD/edit/run; sleep 1
 umount $PWD/edit/var/log; umount $PWD/edit/var/cache/apt/archives;}

function ltoram(){
rm -rf edit/usr/share/doc/*; rm -rf edit/usr/share/help/*; rm -rf edit/usr/share/locale/*
rm -rf edit/var/lib/apt/lists/*; rm -rf edit/var/cache/apt/archives/*
cp grub.cfg iso/boot/grub/grub.cfg;}

function lpack(){
 chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' > iso/live/filesystem.manifest
 mksquashfs edit iso/live/filesystem.squashfs -comp xz
 stat --printf="%s" iso/live/filesystem.squashfs > iso/live/filesystem.size
 (cd iso; find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > md5sum.txt)
 rm -f iso/live/filesystem.squashfs.gpg
 grub-mkrescue -v -o lessbian.iso iso/ -- -volid lessbian; chown 1000 lessbian.iso;}
