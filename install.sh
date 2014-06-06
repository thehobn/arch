#!/bin/bash
#
# Written by hobn, 2014
#

# DIY:
# Connect to internet (wifi-menu)
# Make partitions and format (cgdisk, mkfs)
# Mount partitions (mount)
#pvcreate /dev/sdXn
#pvdisplay
#vgcreate $volumeGroupName $physicalVolumeName
#vgextend $volumeGroupName $anotherPhysicalVolumeName
#vgdisplay
#lvcreate -l +100%FREE $volumeGroupName -n $logicalVolumeName
#lvdisplay
#modprobe dm-mod
#vgscan
#vgchange -ay
#cryptsetup -y -v luksFormat /dev/mapper/sys-root
#cryptsetup open /dev/mapper/sys-root root
#mkfs.ext4 /dev/mapper/root
#TO CLOSE: cryptsetup close root
#mount -t ext4 /dev/mapper/root /mnt
#add encrypt lvm2 before filesystems at HOOKS in /etc/mkinitcpio.conf then mkinitcpio -p linux
nano /etc/default/grub #and edit GRUB_CMDLINE_LINUX= "cryptdevice=/dev/mapper/sys-root:root root=/dev/mapper/root"

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
cp /boot/grub/grub.cfg.new /boot/grub/grub.cfg #no longer needed (?)
#password protect?
#shutdown and reboot entries?
#theming?


# Add user
useradd -m -g users -G wheel min
passwd min

# Install additional utilites
pacman -S dialog wpa_supplicant #wpa_actiond iw  #network
pacman -S xorg-server xorg-server-utils xorg-xinit xterm #X
pacman -S xf86-video-vesa xf86-video-ati xf86-video-intel #display
pacman -S xf86-input-synaptics awesome alsa-utils mesa sudo #misc
pacman -S unzip wget base-devel transmission-gtk vlc gimp libreoffice git audacity darktable gvim conky dwarffortress rxvt-unicode zsh grml-zsh-config ntp acpi gptfdisk dosfstools
# From AUR: iron-git (libpdf, pepper)

# Add vgaswitcheroo
echo none            /sys/kernel/debug debugfs defaults 0 0 >> /etc/fstab #worko???
# To shutdown discrete GPU automatically: open /etc/mkinitcpio.conf and add MODULES="radeon i915" to the MODULES line and do below
nano /etc/mkinitcpio.conf
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
# Fix Windows time sync issue
# Fix full power fan after resume:
sudo nano /usr/lib/systemd/system-sleep/radeon.sh #make file first
Write below:
#!/bin/bash
case $1/$2 in
  pre/*)
    echo ON > /sys/kernel/debug/vgaswitcheroo/switch
    ;;
  post/*)
    echo OFF > /sys/kernel/debug/vgaswitcheroo/switch
    ;;                                                                       
esac
# Set executable and owned by root
chmod 755 /usr/lib/systemd/system-sleep/radeon.sh
chown root:root /usr/lib/systemd/system-sleep/radeon.sh

#Auto wifi connect

chromium pepper libpdf rednotebook exfat tor

#Password protect GRUB2 and BIOS

#TODO: screen lock and conky
#enable multilib /etc/pacman.conf

#Fix time
ntpd -qg
hwclock --systohc

#completely power down discrete
acpi-call-git
modprobe acpi_call
turn_off_gpu.sh
Add the kernel module to the array of modules to load at boot:
/etc/modules-load.d/acpi_call.conf
#Load 'acpi_call.ko' at boot.

acpi_call
To turn off the GPU at boot we could just run the above script but honestly that is not very elegant so instead lets make use of systemd's tmpfiles.
/etc/tmpfiles.d/acpi_call.conf

w /proc/acpi/call - - - - \_SB.PCI0.PEG0.PEGP._OFF
The above config will be loaded at boot by systemd. What it does is write the specific OFF signal to the /proc/acpi/call file. Obviously, replace the \_SB.PCI0.PEG0.PEGP._OFF with the one which works on your system.

TODO:
Wifi on resume/wifi-menu alternative
Occasional "Operating system not found"
Brightness widget/notification in awesomewm
Theming awesomewm
Battery drain in suspend
Login manager/screen locker
Complete CLI/GUI environment

IDEAS:
Clean under keyboard/touchpad
Integrate conky
Find wallpaper

DONE:
Boot Arch (format EFI partition as VFAT instead of FAT32)
Fix grub.cfg (manually replace .cfg with .cfg.new file)
Run X as non-root user (copy /root/.xinitrc file to /home/$USER)
Hybrid graphics (turn off discrete at boot, back on before suspend/hibernate and back off on resume; see install.sh)

WarGame
Europa Universalis
Crusader Kings
Witcher
Metro
Minecraft
Kerbal Space Program
FTL

STALKER
Fallout
X3

PS2


Buffy
Veronica Mars
