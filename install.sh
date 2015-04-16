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
#add encrypt lvm2 before filesystems at HOOKS in /etc/mkinitcpio.conf then mkinitcpio -p linux a nls_cp437 for codepage and ext4/$filesysofkeydevice tomodules 
dd bs=512 count=4 if=/dev/urandom of=$watev iflag=fullblock
cryptsetup lukAddKey /dv/$part /$keyfile
nano /etc/default/grub #and edit GRUB_CMDLINE_LINUX= "cryptdevice=/dev/mapper/sys-root:root root=/dev/mapper/root"cryptkey=/dev/sdxx:filesys:/dir/to/file

pacstrap /mnt base
genfstab -U -p /mnt >> /mnt/etc/fstab 
arch-chroot /mnt
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8
echo FONT=lat9w-16 > /etc/vconsole.conf
ln -s /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc --utc
echo hobn > /etc/hostname
useradd -m -g users -G wheel min
passwd min
passwd

# Install bootloader
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg
cp /boot/grub/grub.cfg.new /boot/grub/grub.cfg #no longer needed (?)
#password protect?
#shutdown and reboot entries?
#theming?

#HDD copy key to /etc/hdd first
echo hdd UUID=b51367ae-b23d-4999-9d7d-dcf1b0456c21 /etc/hdd luks >> /etc/crypttab
echo /dev/mapper/hdd-mnt /mnt ext4 defaults,errors=remount-ro 0 2

#enable multilib for wine and probably steam
echo [multilib] >> /etc/pacman.conf
echo Include = /etc/pacman.d/mirrorlist >> /etc/pacman.conf

# Install additional utilites
pacman -S dialog wpa_supplicant wireless_tools
          xorg-server xorg-server-utils xorg-xinit xorg-utils xorg-xkbcomp
          xf86-input-synaptics xf86-video-vesa xf86-video-intel xf86-video-ati mesa alsa-utils 
          acpi sudo base-devel multilib-devel wget git ntp rsync mlocate openssh
          unzip unrar p7zip gptfdisk dosfstools util-linux exfat-utils ntfs-3g parted coreutils davfs2
          zsh grml-zsh-config zsh-completions 
          gvim vim slock surf ranger 
          mpd ncmpcpp 
          steam wine lib32-alsa-lib lib32-alsa-plugins
          vlc libreoffice gimp darktable audacity 
          gcc gdb
          abs dmenu

abs community/dwm
cp -r /var/abs/community/dwm ~/dwm
makepkg -i
makepkg -efi --skipinteg //for recompiling with config.h modifications

echo exec dwm > ~/.xinitrc //as user

chsh -s /bin/zsh root
chsh -s /bin/zsh min

          #AUR: dwm st-git-zsh tor-browser-en google-chrome-unstable cower mars-mips gtk-evemon-git pyfa yaourt
          #Elsewhere: evernus (boost-libs libc++ libc++abi qt5-base qt5-multimedia qt5-script qt5-webkit)
#AUR: sup-git python2-epub-git exfat-git(?) rednotebook(?) tor(?) jfbview vlc-nogui
(instant messaging) (aggregator) (pastebin) (codecs?) (mp3tag) 
(p7zip/dar)? alsi? (clipman) (keyboardlayout) pacmatic(etc?)  (firewall) (netsec) 
(autobackup) (screenlocker:slock/xscreensaver) (hash) (encrypt) (steno) (passman) (calc?) (bootsplash) 
(loginman/displayman) (todo/calendar) 

#WTFNOTHINGSOWRSK

# Reboot sequence
exit
umount -R /mnt
reboot

# After reboot:
# Log in as user
# enable wpa_supplicant, dhcpcd
echo exec dwm > ~/.xinitrc
echo set ttyscroll=0 > ~/.vimrc
echo set guifont=liberationmono > ~/.vimrc
echo syntax enable > ~/.vimrc
echo set nu > ~/.vimrc
# mpd.conf and playlist/etc, enable mpd.service
# etc/systemd/logind.conf
# custom /usr/bin: steamd csgo eve eve-test update-eve update-eve-test evernus suspend
# Add sudo privileges
# EDITOR=vim visudo
# Add two-finger scrolling
# nano /etc/X11/xorg.conf.d/50-synaptics.conf
# Apply awesome theme
# Fix Windows time sync issue
#Auto wifi connect
#Password protect GRUB2 and BIOS
#TODO: screen lock and conky
#enable multilib /etc/pacman.conf
#Userman
#AUR helper
#Disable boot message clearing

#HYBRID GRAPHICS OMGWTFBBQ!?1!?!?!??!?!1/1/1?
xrandr --listproviders
xrandr --setprovideroffloadsink 0x55 0x7e
#Rerun on X reboot

#lvmetad error fix:
#change use_lvmetad = 1 to 0 in /etc/lvm/lvm.conf, install grub, change value back ?? PROFIT https://bbs.archlinux.org/viewtopic.php?id=169655

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

OpenGL direct render for Steam fix on desktop: remove libgcc/libstdc
possible laptop fix? glamor from git

fix:
media mounting and chmod and chown
auto-wifi
awesome & conky
hybrid graphics
steam shortcuts
hibernate to swap
login after suspend


ACTUAL HYBRID GRAPHICS SOLUTION!1!1!1!!!!!1!
Downgrade to xf86-video-intel-2.21.15 using Arch Rollback Machine

Possible other contributing factors:
Use compton
LD_PRELOAD libraries with Steam
Install glamor-egl-git from AUR

Fix small text in Valve games:
Install Verdana font?

Dwarf Fortress fix:
http://dwarffortresswiki.org/index.php/v0.34:Installation#.22Not_found:_.2Fdata.2Fart.2Fmouse.png.22_and_similar_errors

# systemctl enable netctl-auto@interface.service 
# systemctl enable netctl-ifplugd@interface.service  
# netctl enable $PROFILENAME (eg wlp2s0-NETGEAR)
 
 
 vimium
