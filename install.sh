#!/bin/bash
#
# Written by hobn, 2014
#

# DIY:
# Connect to internet (wifi-menu)
# Make partitions and format (cgdisk, mkfs)
# Mount partitions (mount)



#Install base system and generate fstab, then chroot into install
pacstrap /mnt base
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt


# Config locale
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

# Set timezone
ln -s /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc --utc

# Set hostname and root password
echo hobn > /etc/hostname
passwd

# Install bootloader
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg
cp /boot/grub/grub.cfg.new /boot/grub/grub.cfg

# Add user
useradd -m -g users -G wheel min
passwd min

# Install additional utilites
pacman -S dialog wpa_supplicant #wpa_actiond iw  #network
pacman -S xorg-server xorg-server-utils xorg-xinit xterm #X
pacman -S xf86-video-vesa xf86-video-ati xf86-video-intel #display
pacman -S xf86-input-synaptics awesome alsa-utils mesa sudo #misc
pacman -S transmission-gtk vlc gimp libreoffice git thunar
# From AUR: iron-git (libpdf, pepper)

# Add vgaswitcheroo
echo none            /sys/kernel/debug debugfs defaults 0 0 >> /etc/fstab
# To shutdown discrete GPU automatically: open /etc/mkinitcpio.conf and add MODULES="radeon i915" to the MODULES line and do below
mkinitcpio -p linux
echo w /sys/kernel/debug/vgaswitcheroo/switch - - - - OFF > /etc/tmpfiles.d/vgaswitcheroo.conf


# Reboot sequence
exit
umount -R /mnt
reboot

# After reboot:
# Log in as user
# echo exec awesome > ~/.xinitrc
# Add sudo privileges
# EDITOR=nano visudo
# Add two-finger scrolling
# nano /etc/X11/xorg.conf.d/50-synaptics.conf
# Apply awesome theme
